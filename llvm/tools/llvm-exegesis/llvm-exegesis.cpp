//===-- llvm-exegesis.cpp ---------------------------------------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
///
/// \file
/// Measures execution properties (latencies/uops) of an instruction.
///
//===----------------------------------------------------------------------===//

#include "lib/Analysis.h"
#include "lib/BenchmarkResult.h"
#include "lib/BenchmarkRunner.h"
#include "lib/Clustering.h"
#include "lib/Latency.h"
#include "lib/LlvmState.h"
#include "lib/PerfHelper.h"
#include "lib/Uops.h"
#include "lib/X86.h"
#include "llvm/ADT/StringExtras.h"
#include "llvm/ADT/Twine.h"
#include "llvm/MC/MCInstBuilder.h"
#include "llvm/MC/MCRegisterInfo.h"
#include "llvm/MC/MCSubtargetInfo.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/Format.h"
#include "llvm/Support/Path.h"
#include "llvm/Support/TargetRegistry.h"
#include "llvm/Support/TargetSelect.h"
#include <algorithm>
#include <random>
#include <string>
#include <unordered_map>

static llvm::cl::opt<unsigned>
    OpcodeIndex("opcode-index", llvm::cl::desc("opcode to measure, by index"),
                llvm::cl::init(0));

static llvm::cl::opt<std::string>
    OpcodeName("opcode-name", llvm::cl::desc("opcode to measure, by name"),
               llvm::cl::init(""));

static llvm::cl::opt<std::string>
    BenchmarkFile("benchmarks-file", llvm::cl::desc(""), llvm::cl::init(""));

enum class BenchmarkModeE { Latency, Uops, Analysis };
static llvm::cl::opt<BenchmarkModeE> BenchmarkMode(
    "mode", llvm::cl::desc("the mode to run"),
    llvm::cl::values(
        clEnumValN(BenchmarkModeE::Latency, "latency", "Instruction Latency"),
        clEnumValN(BenchmarkModeE::Uops, "uops", "Uop Decomposition"),
        clEnumValN(BenchmarkModeE::Analysis, "analysis", "Analysis")));

static llvm::cl::opt<unsigned>
    NumRepetitions("num-repetitions",
                   llvm::cl::desc("number of time to repeat the asm snippet"),
                   llvm::cl::init(10000));

static llvm::cl::opt<unsigned> AnalysisNumPoints(
    "analysis-numpoints",
    llvm::cl::desc("minimum number of points in an analysis cluster"),
    llvm::cl::init(3));

static llvm::cl::opt<float>
    AnalysisEpsilon("analysis-epsilon",
                    llvm::cl::desc("dbscan epsilon for analysis clustering"),
                    llvm::cl::init(0.1));

static llvm::cl::opt<std::string>
    AnalysisClustersOutputFile("analysis-clusters-output-file",
                               llvm::cl::desc(""), llvm::cl::init("-"));
static llvm::cl::opt<std::string>
    AnalysisInconsistenciesOutputFile("analysis-inconsistencies-output-file",
                                      llvm::cl::desc(""), llvm::cl::init("-"));

namespace exegesis {

static llvm::ExitOnError ExitOnErr;

static unsigned GetOpcodeOrDie(const llvm::MCInstrInfo &MCInstrInfo) {
  if (OpcodeName.empty() && (OpcodeIndex == 0))
    llvm::report_fatal_error(
        "please provide one and only one of 'opcode-index' or 'opcode-name'");
  if (OpcodeIndex > 0)
    return OpcodeIndex;
  // Resolve opcode name -> opcode.
  for (unsigned I = 0, E = MCInstrInfo.getNumOpcodes(); I < E; ++I)
    if (MCInstrInfo.getName(I) == OpcodeName)
      return I;
  llvm::report_fatal_error(llvm::Twine("unknown opcode ").concat(OpcodeName));
}

static BenchmarkResultContext
getBenchmarkResultContext(const LLVMState &State) {
  BenchmarkResultContext Ctx;

  const llvm::MCInstrInfo &InstrInfo = State.getInstrInfo();
  for (unsigned E = InstrInfo.getNumOpcodes(), I = 0; I < E; ++I)
    Ctx.addInstrEntry(I, InstrInfo.getName(I).data());

  const llvm::MCRegisterInfo &RegInfo = State.getRegInfo();
  for (unsigned E = RegInfo.getNumRegs(), I = 0; I < E; ++I)
    Ctx.addRegEntry(I, RegInfo.getName(I));

  return Ctx;
}

void benchmarkMain() {
  if (exegesis::pfm::pfmInitialize())
    llvm::report_fatal_error("cannot initialize libpfm");

  llvm::InitializeNativeTarget();
  llvm::InitializeNativeTargetAsmPrinter();

  // FIXME: Target-specific filter.
  X86Filter Filter;

  const LLVMState State;

  // FIXME: Do not require SchedModel for latency.
  if (!State.getSubtargetInfo().getSchedModel().hasExtraProcessorInfo())
    llvm::report_fatal_error("sched model is missing extra processor info!");

  std::unique_ptr<BenchmarkRunner> Runner;
  switch (BenchmarkMode) {
  case BenchmarkModeE::Latency:
    Runner = llvm::make_unique<LatencyBenchmarkRunner>(State);
    break;
  case BenchmarkModeE::Uops:
    Runner = llvm::make_unique<UopsBenchmarkRunner>(State);
    break;
  case BenchmarkModeE::Analysis:
    llvm_unreachable("not a benchmark");
  }

  if (NumRepetitions == 0)
    llvm::report_fatal_error("--num-repetitions must be greater than zero");

  // Write to standard output if file is not set.
  if (BenchmarkFile.empty())
    BenchmarkFile = "-";

  const BenchmarkResultContext Context = getBenchmarkResultContext(State);
  std::vector<InstructionBenchmark> Results = ExitOnErr(Runner->run(
      GetOpcodeOrDie(State.getInstrInfo()), Filter, NumRepetitions));
  for (InstructionBenchmark &Result : Results)
    Result.writeYaml(Context, BenchmarkFile);

  exegesis::pfm::pfmTerminate();
}

// Prints the results of running analysis pass `Pass` to file `OutputFilename`
// if OutputFilename is non-empty.
template <typename Pass>
static void maybeRunAnalysis(const Analysis &Analyzer, const std::string &Name,
                             const std::string &OutputFilename) {
  if (OutputFilename.empty())
    return;
  if (OutputFilename != "-") {
    llvm::errs() << "Printing " << Name << " results to file '"
                 << OutputFilename << "'\n";
  }
  std::error_code ErrorCode;
  llvm::raw_fd_ostream ClustersOS(OutputFilename, ErrorCode,
                                  llvm::sys::fs::FA_Read |
                                      llvm::sys::fs::FA_Write);
  if (ErrorCode)
    llvm::report_fatal_error("cannot open out file: " + OutputFilename);
  if (auto Err = Analyzer.run<Pass>(ClustersOS))
    llvm::report_fatal_error(std::move(Err));
}

static void analysisMain() {
  if (BenchmarkFile.empty())
    llvm::report_fatal_error("--benchmarks-file must be set.");

  llvm::InitializeNativeTarget();
  llvm::InitializeNativeTargetAsmPrinter();
  // Read benchmarks.
  const LLVMState State;
  const std::vector<InstructionBenchmark> Points =
      ExitOnErr(InstructionBenchmark::readYamls(
          getBenchmarkResultContext(State), BenchmarkFile));
  llvm::outs() << "Parsed " << Points.size() << " benchmark points\n";
  if (Points.empty()) {
    llvm::errs() << "no benchmarks to analyze\n";
    return;
  }
  // FIXME: Check that all points have the same triple/cpu.
  // FIXME: Merge points from several runs (latency and uops).

  std::string Error;
  const auto *TheTarget =
      llvm::TargetRegistry::lookupTarget(Points[0].LLVMTriple, Error);
  if (!TheTarget) {
    llvm::errs() << "unknown target '" << Points[0].LLVMTriple << "'\n";
    return;
  }
  const auto Clustering = ExitOnErr(InstructionBenchmarkClustering::create(
      Points, AnalysisNumPoints, AnalysisEpsilon));

  const Analysis Analyzer(*TheTarget, Clustering);

  maybeRunAnalysis<Analysis::PrintClusters>(Analyzer, "analysis clusters",
                                            AnalysisClustersOutputFile);
  maybeRunAnalysis<Analysis::PrintSchedClassInconsistencies>(
      Analyzer, "sched class consistency analysis",
      AnalysisInconsistenciesOutputFile);
}

} // namespace exegesis

int main(int Argc, char **Argv) {
  llvm::cl::ParseCommandLineOptions(Argc, Argv, "");

  exegesis::ExitOnErr.setExitCodeMapper([](const llvm::Error &Err) {
    if (Err.isA<llvm::StringError>())
      return EXIT_SUCCESS;
    return EXIT_FAILURE;
  });

  if (BenchmarkMode == BenchmarkModeE::Analysis) {
    exegesis::analysisMain();
  } else {
    exegesis::benchmarkMain();
  }
  return EXIT_SUCCESS;
}

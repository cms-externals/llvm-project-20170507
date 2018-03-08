; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown-unknown -mattr=+sse4.2 | FileCheck %s --check-prefix=X86
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse4.2 | FileCheck %s --check-prefix=X64
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+xop  | FileCheck %s --check-prefix=X64-AVX --check-prefix=X64-XOP
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx2 | FileCheck %s --check-prefix=X64-AVX --check-prefix=X64-AVX2

;
; PowOf2 (uniform)
;

define <2 x i64> @mul_v2i64_8(<2 x i64> %a0) nounwind {
; X86-LABEL: mul_v2i64_8:
; X86:       # %bb.0:
; X86-NEXT:    psllq $3, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: mul_v2i64_8:
; X64:       # %bb.0:
; X64-NEXT:    psllq $3, %xmm0
; X64-NEXT:    retq
;
; X64-AVX-LABEL: mul_v2i64_8:
; X64-AVX:       # %bb.0:
; X64-AVX-NEXT:    vpsllq $3, %xmm0, %xmm0
; X64-AVX-NEXT:    retq
  %1 = mul <2 x i64> %a0, <i64 8, i64 8>
  ret <2 x i64> %1
}

define <4 x i32> @mul_v4i32_8(<4 x i32> %a0) nounwind {
; X86-LABEL: mul_v4i32_8:
; X86:       # %bb.0:
; X86-NEXT:    pslld $3, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: mul_v4i32_8:
; X64:       # %bb.0:
; X64-NEXT:    pslld $3, %xmm0
; X64-NEXT:    retq
;
; X64-AVX-LABEL: mul_v4i32_8:
; X64-AVX:       # %bb.0:
; X64-AVX-NEXT:    vpslld $3, %xmm0, %xmm0
; X64-AVX-NEXT:    retq
  %1 = mul <4 x i32> %a0, <i32 8, i32 8, i32 8, i32 8>
  ret <4 x i32> %1
}

define <8 x i16> @mul_v8i16_8(<8 x i16> %a0) nounwind {
; X86-LABEL: mul_v8i16_8:
; X86:       # %bb.0:
; X86-NEXT:    psllw $3, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: mul_v8i16_8:
; X64:       # %bb.0:
; X64-NEXT:    psllw $3, %xmm0
; X64-NEXT:    retq
;
; X64-AVX-LABEL: mul_v8i16_8:
; X64-AVX:       # %bb.0:
; X64-AVX-NEXT:    vpsllw $3, %xmm0, %xmm0
; X64-AVX-NEXT:    retq
  %1 = mul <8 x i16> %a0, <i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8>
  ret <8 x i16> %1
}

define <16 x i8> @mul_v16i8_32(<16 x i8> %a0) nounwind {
; X86-LABEL: mul_v16i8_32:
; X86:       # %bb.0:
; X86-NEXT:    psllw $5, %xmm0
; X86-NEXT:    pand {{\.LCPI.*}}, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: mul_v16i8_32:
; X64:       # %bb.0:
; X64-NEXT:    psllw $5, %xmm0
; X64-NEXT:    pand {{.*}}(%rip), %xmm0
; X64-NEXT:    retq
;
; X64-XOP-LABEL: mul_v16i8_32:
; X64-XOP:       # %bb.0:
; X64-XOP-NEXT:    vpshlb {{.*}}(%rip), %xmm0, %xmm0
; X64-XOP-NEXT:    retq
;
; X64-AVX2-LABEL: mul_v16i8_32:
; X64-AVX2:       # %bb.0:
; X64-AVX2-NEXT:    vpsllw $5, %xmm0, %xmm0
; X64-AVX2-NEXT:    vpand {{.*}}(%rip), %xmm0, %xmm0
; X64-AVX2-NEXT:    retq
  %1 = mul <16 x i8> %a0, <i8 32, i8 32, i8 32, i8 32, i8 32, i8 32, i8 32, i8 32, i8 32, i8 32, i8 32, i8 32, i8 32, i8 32, i8 32, i8 32>
  ret <16 x i8> %1
}

;
; PowOf2 (non-uniform)
;

define <2 x i64> @mul_v2i64_32_8(<2 x i64> %a0) nounwind {
; X86-LABEL: mul_v2i64_32_8:
; X86:       # %bb.0:
; X86-NEXT:    movdqa %xmm0, %xmm1
; X86-NEXT:    psllq $3, %xmm1
; X86-NEXT:    psllq $5, %xmm0
; X86-NEXT:    pblendw {{.*#+}} xmm0 = xmm0[0,1,2,3],xmm1[4,5,6,7]
; X86-NEXT:    retl
;
; X64-LABEL: mul_v2i64_32_8:
; X64:       # %bb.0:
; X64-NEXT:    movdqa %xmm0, %xmm1
; X64-NEXT:    psllq $3, %xmm1
; X64-NEXT:    psllq $5, %xmm0
; X64-NEXT:    pblendw {{.*#+}} xmm0 = xmm0[0,1,2,3],xmm1[4,5,6,7]
; X64-NEXT:    retq
;
; X64-XOP-LABEL: mul_v2i64_32_8:
; X64-XOP:       # %bb.0:
; X64-XOP-NEXT:    vpshlq {{.*}}(%rip), %xmm0, %xmm0
; X64-XOP-NEXT:    retq
;
; X64-AVX2-LABEL: mul_v2i64_32_8:
; X64-AVX2:       # %bb.0:
; X64-AVX2-NEXT:    vpsllvq {{.*}}(%rip), %xmm0, %xmm0
; X64-AVX2-NEXT:    retq
  %1 = mul <2 x i64> %a0, <i64 32, i64 8>
  ret <2 x i64> %1
}

define <4 x i32> @mul_v4i32_1_2_4_8(<4 x i32> %a0) nounwind {
; X86-LABEL: mul_v4i32_1_2_4_8:
; X86:       # %bb.0:
; X86-NEXT:    pmulld {{\.LCPI.*}}, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: mul_v4i32_1_2_4_8:
; X64:       # %bb.0:
; X64-NEXT:    pmulld {{.*}}(%rip), %xmm0
; X64-NEXT:    retq
;
; X64-XOP-LABEL: mul_v4i32_1_2_4_8:
; X64-XOP:       # %bb.0:
; X64-XOP-NEXT:    vpshld {{.*}}(%rip), %xmm0, %xmm0
; X64-XOP-NEXT:    retq
;
; X64-AVX2-LABEL: mul_v4i32_1_2_4_8:
; X64-AVX2:       # %bb.0:
; X64-AVX2-NEXT:    vpsllvd {{.*}}(%rip), %xmm0, %xmm0
; X64-AVX2-NEXT:    retq
  %1 = mul <4 x i32> %a0, <i32 1, i32 2, i32 4, i32 8>
  ret <4 x i32> %1
}

define <8 x i16> @mul_v8i16_1_2_4_8_16_32_64_128(<8 x i16> %a0) nounwind {
; X86-LABEL: mul_v8i16_1_2_4_8_16_32_64_128:
; X86:       # %bb.0:
; X86-NEXT:    pmullw {{\.LCPI.*}}, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: mul_v8i16_1_2_4_8_16_32_64_128:
; X64:       # %bb.0:
; X64-NEXT:    pmullw {{.*}}(%rip), %xmm0
; X64-NEXT:    retq
;
; X64-XOP-LABEL: mul_v8i16_1_2_4_8_16_32_64_128:
; X64-XOP:       # %bb.0:
; X64-XOP-NEXT:    vpshlw {{.*}}(%rip), %xmm0, %xmm0
; X64-XOP-NEXT:    retq
;
; X64-AVX2-LABEL: mul_v8i16_1_2_4_8_16_32_64_128:
; X64-AVX2:       # %bb.0:
; X64-AVX2-NEXT:    vpmullw {{.*}}(%rip), %xmm0, %xmm0
; X64-AVX2-NEXT:    retq
  %1 = mul <8 x i16> %a0, <i16 1, i16 2, i16 4, i16 8, i16 16, i16 32, i16 64, i16 128>
  ret <8 x i16> %1
}

define <16 x i8> @mul_v16i8_1_2_4_8_1_2_4_8_1_2_4_8_1_2_4_8(<16 x i8> %a0) nounwind {
; X86-LABEL: mul_v16i8_1_2_4_8_1_2_4_8_1_2_4_8_1_2_4_8:
; X86:       # %bb.0:
; X86-NEXT:    movdqa %xmm0, %xmm1
; X86-NEXT:    movdqa %xmm0, %xmm2
; X86-NEXT:    psllw $4, %xmm2
; X86-NEXT:    pand {{\.LCPI.*}}, %xmm2
; X86-NEXT:    movdqa {{.*#+}} xmm0 = [8192,24640,8192,24640,8192,24640,8192,24640]
; X86-NEXT:    pblendvb %xmm0, %xmm2, %xmm1
; X86-NEXT:    movdqa %xmm1, %xmm2
; X86-NEXT:    psllw $2, %xmm2
; X86-NEXT:    pand {{\.LCPI.*}}, %xmm2
; X86-NEXT:    paddb %xmm0, %xmm0
; X86-NEXT:    pblendvb %xmm0, %xmm2, %xmm1
; X86-NEXT:    movdqa %xmm1, %xmm2
; X86-NEXT:    paddb %xmm1, %xmm2
; X86-NEXT:    paddb %xmm0, %xmm0
; X86-NEXT:    pblendvb %xmm0, %xmm2, %xmm1
; X86-NEXT:    movdqa %xmm1, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: mul_v16i8_1_2_4_8_1_2_4_8_1_2_4_8_1_2_4_8:
; X64:       # %bb.0:
; X64-NEXT:    movdqa %xmm0, %xmm1
; X64-NEXT:    movdqa %xmm0, %xmm2
; X64-NEXT:    psllw $4, %xmm2
; X64-NEXT:    pand {{.*}}(%rip), %xmm2
; X64-NEXT:    movdqa {{.*#+}} xmm0 = [8192,24640,8192,24640,8192,24640,8192,24640]
; X64-NEXT:    pblendvb %xmm0, %xmm2, %xmm1
; X64-NEXT:    movdqa %xmm1, %xmm2
; X64-NEXT:    psllw $2, %xmm2
; X64-NEXT:    pand {{.*}}(%rip), %xmm2
; X64-NEXT:    paddb %xmm0, %xmm0
; X64-NEXT:    pblendvb %xmm0, %xmm2, %xmm1
; X64-NEXT:    movdqa %xmm1, %xmm2
; X64-NEXT:    paddb %xmm1, %xmm2
; X64-NEXT:    paddb %xmm0, %xmm0
; X64-NEXT:    pblendvb %xmm0, %xmm2, %xmm1
; X64-NEXT:    movdqa %xmm1, %xmm0
; X64-NEXT:    retq
;
; X64-XOP-LABEL: mul_v16i8_1_2_4_8_1_2_4_8_1_2_4_8_1_2_4_8:
; X64-XOP:       # %bb.0:
; X64-XOP-NEXT:    vpshlb {{.*}}(%rip), %xmm0, %xmm0
; X64-XOP-NEXT:    retq
;
; X64-AVX2-LABEL: mul_v16i8_1_2_4_8_1_2_4_8_1_2_4_8_1_2_4_8:
; X64-AVX2:       # %bb.0:
; X64-AVX2-NEXT:    vpsllw $4, %xmm0, %xmm1
; X64-AVX2-NEXT:    vpand {{.*}}(%rip), %xmm1, %xmm1
; X64-AVX2-NEXT:    vmovdqa {{.*#+}} xmm2 = [8192,24640,8192,24640,8192,24640,8192,24640]
; X64-AVX2-NEXT:    vpblendvb %xmm2, %xmm1, %xmm0, %xmm0
; X64-AVX2-NEXT:    vpsllw $2, %xmm0, %xmm1
; X64-AVX2-NEXT:    vpand {{.*}}(%rip), %xmm1, %xmm1
; X64-AVX2-NEXT:    vpaddb %xmm2, %xmm2, %xmm2
; X64-AVX2-NEXT:    vpblendvb %xmm2, %xmm1, %xmm0, %xmm0
; X64-AVX2-NEXT:    vpaddb %xmm0, %xmm0, %xmm1
; X64-AVX2-NEXT:    vpaddb %xmm2, %xmm2, %xmm2
; X64-AVX2-NEXT:    vpblendvb %xmm2, %xmm1, %xmm0, %xmm0
; X64-AVX2-NEXT:    retq
  %1 = mul <16 x i8> %a0, <i8 1, i8 2, i8 4, i8 8, i8 1, i8 2, i8 4, i8 8, i8 1, i8 2, i8 4, i8 8, i8 1, i8 2, i8 4, i8 8>
  ret <16 x i8> %1
}

;
; PowOf2 + 1 (uniform)
;

define <2 x i64> @mul_v2i64_17(<2 x i64> %a0) nounwind {
; X86-LABEL: mul_v2i64_17:
; X86:       # %bb.0:
; X86-NEXT:    movdqa {{.*#+}} xmm1 = [17,0,17,0]
; X86-NEXT:    movdqa %xmm0, %xmm2
; X86-NEXT:    pmuludq %xmm1, %xmm2
; X86-NEXT:    psrlq $32, %xmm0
; X86-NEXT:    pmuludq %xmm1, %xmm0
; X86-NEXT:    psllq $32, %xmm0
; X86-NEXT:    paddq %xmm2, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: mul_v2i64_17:
; X64:       # %bb.0:
; X64-NEXT:    movdqa {{.*#+}} xmm1 = [17,17]
; X64-NEXT:    movdqa %xmm0, %xmm2
; X64-NEXT:    pmuludq %xmm1, %xmm2
; X64-NEXT:    psrlq $32, %xmm0
; X64-NEXT:    pmuludq %xmm1, %xmm0
; X64-NEXT:    psllq $32, %xmm0
; X64-NEXT:    paddq %xmm2, %xmm0
; X64-NEXT:    retq
;
; X64-AVX-LABEL: mul_v2i64_17:
; X64-AVX:       # %bb.0:
; X64-AVX-NEXT:    vmovdqa {{.*#+}} xmm1 = [17,17]
; X64-AVX-NEXT:    vpmuludq %xmm1, %xmm0, %xmm2
; X64-AVX-NEXT:    vpsrlq $32, %xmm0, %xmm0
; X64-AVX-NEXT:    vpmuludq %xmm1, %xmm0, %xmm0
; X64-AVX-NEXT:    vpsllq $32, %xmm0, %xmm0
; X64-AVX-NEXT:    vpaddq %xmm0, %xmm2, %xmm0
; X64-AVX-NEXT:    retq
  %1 = mul <2 x i64> %a0, <i64 17, i64 17>
  ret <2 x i64> %1
}

define <4 x i32> @mul_v4i32_17(<4 x i32> %a0) nounwind {
; X86-LABEL: mul_v4i32_17:
; X86:       # %bb.0:
; X86-NEXT:    pmulld {{\.LCPI.*}}, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: mul_v4i32_17:
; X64:       # %bb.0:
; X64-NEXT:    pmulld {{.*}}(%rip), %xmm0
; X64-NEXT:    retq
;
; X64-XOP-LABEL: mul_v4i32_17:
; X64-XOP:       # %bb.0:
; X64-XOP-NEXT:    vpmulld {{.*}}(%rip), %xmm0, %xmm0
; X64-XOP-NEXT:    retq
;
; X64-AVX2-LABEL: mul_v4i32_17:
; X64-AVX2:       # %bb.0:
; X64-AVX2-NEXT:    vpbroadcastd {{.*#+}} xmm1 = [17,17,17,17]
; X64-AVX2-NEXT:    vpmulld %xmm1, %xmm0, %xmm0
; X64-AVX2-NEXT:    retq
  %1 = mul <4 x i32> %a0, <i32 17, i32 17, i32 17, i32 17>
  ret <4 x i32> %1
}

define <8 x i16> @mul_v8i16_17(<8 x i16> %a0) nounwind {
; X86-LABEL: mul_v8i16_17:
; X86:       # %bb.0:
; X86-NEXT:    pmullw {{\.LCPI.*}}, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: mul_v8i16_17:
; X64:       # %bb.0:
; X64-NEXT:    pmullw {{.*}}(%rip), %xmm0
; X64-NEXT:    retq
;
; X64-AVX-LABEL: mul_v8i16_17:
; X64-AVX:       # %bb.0:
; X64-AVX-NEXT:    vpmullw {{.*}}(%rip), %xmm0, %xmm0
; X64-AVX-NEXT:    retq
  %1 = mul <8 x i16> %a0, <i16 17, i16 17, i16 17, i16 17, i16 17, i16 17, i16 17, i16 17>
  ret <8 x i16> %1
}

define <16 x i8> @mul_v16i8_17(<16 x i8> %a0) nounwind {
; X86-LABEL: mul_v16i8_17:
; X86:       # %bb.0:
; X86-NEXT:    pmovsxbw %xmm0, %xmm1
; X86-NEXT:    movdqa {{.*#+}} xmm2 = [17,17,17,17,17,17,17,17]
; X86-NEXT:    pmullw %xmm2, %xmm1
; X86-NEXT:    movdqa {{.*#+}} xmm3 = [255,255,255,255,255,255,255,255]
; X86-NEXT:    pand %xmm3, %xmm1
; X86-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[2,3,0,1]
; X86-NEXT:    pmovsxbw %xmm0, %xmm0
; X86-NEXT:    pmullw %xmm2, %xmm0
; X86-NEXT:    pand %xmm3, %xmm0
; X86-NEXT:    packuswb %xmm0, %xmm1
; X86-NEXT:    movdqa %xmm1, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: mul_v16i8_17:
; X64:       # %bb.0:
; X64-NEXT:    pmovsxbw %xmm0, %xmm1
; X64-NEXT:    movdqa {{.*#+}} xmm2 = [17,17,17,17,17,17,17,17]
; X64-NEXT:    pmullw %xmm2, %xmm1
; X64-NEXT:    movdqa {{.*#+}} xmm3 = [255,255,255,255,255,255,255,255]
; X64-NEXT:    pand %xmm3, %xmm1
; X64-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[2,3,0,1]
; X64-NEXT:    pmovsxbw %xmm0, %xmm0
; X64-NEXT:    pmullw %xmm2, %xmm0
; X64-NEXT:    pand %xmm3, %xmm0
; X64-NEXT:    packuswb %xmm0, %xmm1
; X64-NEXT:    movdqa %xmm1, %xmm0
; X64-NEXT:    retq
;
; X64-XOP-LABEL: mul_v16i8_17:
; X64-XOP:       # %bb.0:
; X64-XOP-NEXT:    vpmovsxbw %xmm0, %xmm1
; X64-XOP-NEXT:    vmovdqa {{.*#+}} xmm2 = [17,17,17,17,17,17,17,17]
; X64-XOP-NEXT:    vpmullw %xmm2, %xmm1, %xmm1
; X64-XOP-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[2,3,0,1]
; X64-XOP-NEXT:    vpmovsxbw %xmm0, %xmm0
; X64-XOP-NEXT:    vpmullw %xmm2, %xmm0, %xmm0
; X64-XOP-NEXT:    vpperm {{.*#+}} xmm0 = xmm1[0,2,4,6,8,10,12,14],xmm0[0,2,4,6,8,10,12,14]
; X64-XOP-NEXT:    retq
;
; X64-AVX2-LABEL: mul_v16i8_17:
; X64-AVX2:       # %bb.0:
; X64-AVX2-NEXT:    vpmovsxbw %xmm0, %ymm0
; X64-AVX2-NEXT:    vpmullw {{.*}}(%rip), %ymm0, %ymm0
; X64-AVX2-NEXT:    vextracti128 $1, %ymm0, %xmm1
; X64-AVX2-NEXT:    vmovdqa {{.*#+}} xmm2 = <0,2,4,6,8,10,12,14,u,u,u,u,u,u,u,u>
; X64-AVX2-NEXT:    vpshufb %xmm2, %xmm1, %xmm1
; X64-AVX2-NEXT:    vpshufb %xmm2, %xmm0, %xmm0
; X64-AVX2-NEXT:    vpunpcklqdq {{.*#+}} xmm0 = xmm0[0],xmm1[0]
; X64-AVX2-NEXT:    vzeroupper
; X64-AVX2-NEXT:    retq
  %1 = mul <16 x i8> %a0, <i8 17, i8 17, i8 17, i8 17, i8 17, i8 17, i8 17, i8 17, i8 17, i8 17, i8 17, i8 17, i8 17, i8 17, i8 17, i8 17>
  ret <16 x i8> %1
}

;
; PowOf2 + 1 (non-uniform)
;

define <2 x i64> @mul_v2i64_17_65(<2 x i64> %a0) nounwind {
; X86-LABEL: mul_v2i64_17_65:
; X86:       # %bb.0:
; X86-NEXT:    movdqa {{.*#+}} xmm1 = [17,0,65,0]
; X86-NEXT:    movdqa %xmm0, %xmm2
; X86-NEXT:    pmuludq %xmm1, %xmm2
; X86-NEXT:    psrlq $32, %xmm0
; X86-NEXT:    pmuludq %xmm1, %xmm0
; X86-NEXT:    psllq $32, %xmm0
; X86-NEXT:    paddq %xmm2, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: mul_v2i64_17_65:
; X64:       # %bb.0:
; X64-NEXT:    movdqa {{.*#+}} xmm1 = [17,65]
; X64-NEXT:    movdqa %xmm0, %xmm2
; X64-NEXT:    pmuludq %xmm1, %xmm2
; X64-NEXT:    psrlq $32, %xmm0
; X64-NEXT:    pmuludq %xmm1, %xmm0
; X64-NEXT:    psllq $32, %xmm0
; X64-NEXT:    paddq %xmm2, %xmm0
; X64-NEXT:    retq
;
; X64-AVX-LABEL: mul_v2i64_17_65:
; X64-AVX:       # %bb.0:
; X64-AVX-NEXT:    vmovdqa {{.*#+}} xmm1 = [17,65]
; X64-AVX-NEXT:    vpmuludq %xmm1, %xmm0, %xmm2
; X64-AVX-NEXT:    vpsrlq $32, %xmm0, %xmm0
; X64-AVX-NEXT:    vpmuludq %xmm1, %xmm0, %xmm0
; X64-AVX-NEXT:    vpsllq $32, %xmm0, %xmm0
; X64-AVX-NEXT:    vpaddq %xmm0, %xmm2, %xmm0
; X64-AVX-NEXT:    retq
  %1 = mul <2 x i64> %a0, <i64 17, i64 65>
  ret <2 x i64> %1
}

define <4 x i32> @mul_v4i32_5_17_33_65(<4 x i32> %a0) nounwind {
; X86-LABEL: mul_v4i32_5_17_33_65:
; X86:       # %bb.0:
; X86-NEXT:    pmulld {{\.LCPI.*}}, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: mul_v4i32_5_17_33_65:
; X64:       # %bb.0:
; X64-NEXT:    pmulld {{.*}}(%rip), %xmm0
; X64-NEXT:    retq
;
; X64-AVX-LABEL: mul_v4i32_5_17_33_65:
; X64-AVX:       # %bb.0:
; X64-AVX-NEXT:    vpmulld {{.*}}(%rip), %xmm0, %xmm0
; X64-AVX-NEXT:    retq
  %1 = mul <4 x i32> %a0, <i32 5, i32 17, i32 33, i32 65>
  ret <4 x i32> %1
}

define <8 x i16> @mul_v8i16_2_3_9_17_33_65_129_257(<8 x i16> %a0) nounwind {
; X86-LABEL: mul_v8i16_2_3_9_17_33_65_129_257:
; X86:       # %bb.0:
; X86-NEXT:    pmullw {{\.LCPI.*}}, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: mul_v8i16_2_3_9_17_33_65_129_257:
; X64:       # %bb.0:
; X64-NEXT:    pmullw {{.*}}(%rip), %xmm0
; X64-NEXT:    retq
;
; X64-AVX-LABEL: mul_v8i16_2_3_9_17_33_65_129_257:
; X64-AVX:       # %bb.0:
; X64-AVX-NEXT:    vpmullw {{.*}}(%rip), %xmm0, %xmm0
; X64-AVX-NEXT:    retq
  %1 = mul <8 x i16> %a0, <i16 2, i16 3, i16 9, i16 17, i16 33, i16 65, i16 129, i16 257>
  ret <8 x i16> %1
}

define <16 x i8> @mul_v16i8_2_3_9_17_33_65_129_2_3_9_17_33_65_129_2_3(<16 x i8> %a0) nounwind {
; X86-LABEL: mul_v16i8_2_3_9_17_33_65_129_2_3_9_17_33_65_129_2_3:
; X86:       # %bb.0:
; X86-NEXT:    pmovsxbw %xmm0, %xmm1
; X86-NEXT:    pmullw {{\.LCPI.*}}, %xmm1
; X86-NEXT:    movdqa {{.*#+}} xmm2 = [255,255,255,255,255,255,255,255]
; X86-NEXT:    pand %xmm2, %xmm1
; X86-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[2,3,0,1]
; X86-NEXT:    pmovsxbw %xmm0, %xmm0
; X86-NEXT:    pmullw {{\.LCPI.*}}, %xmm0
; X86-NEXT:    pand %xmm2, %xmm0
; X86-NEXT:    packuswb %xmm0, %xmm1
; X86-NEXT:    movdqa %xmm1, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: mul_v16i8_2_3_9_17_33_65_129_2_3_9_17_33_65_129_2_3:
; X64:       # %bb.0:
; X64-NEXT:    pmovsxbw %xmm0, %xmm1
; X64-NEXT:    pmullw {{.*}}(%rip), %xmm1
; X64-NEXT:    movdqa {{.*#+}} xmm2 = [255,255,255,255,255,255,255,255]
; X64-NEXT:    pand %xmm2, %xmm1
; X64-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[2,3,0,1]
; X64-NEXT:    pmovsxbw %xmm0, %xmm0
; X64-NEXT:    pmullw {{.*}}(%rip), %xmm0
; X64-NEXT:    pand %xmm2, %xmm0
; X64-NEXT:    packuswb %xmm0, %xmm1
; X64-NEXT:    movdqa %xmm1, %xmm0
; X64-NEXT:    retq
;
; X64-XOP-LABEL: mul_v16i8_2_3_9_17_33_65_129_2_3_9_17_33_65_129_2_3:
; X64-XOP:       # %bb.0:
; X64-XOP-NEXT:    vpmovsxbw %xmm0, %xmm1
; X64-XOP-NEXT:    vpmullw {{.*}}(%rip), %xmm1, %xmm1
; X64-XOP-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[2,3,0,1]
; X64-XOP-NEXT:    vpmovsxbw %xmm0, %xmm0
; X64-XOP-NEXT:    vpmullw {{.*}}(%rip), %xmm0, %xmm0
; X64-XOP-NEXT:    vpperm {{.*#+}} xmm0 = xmm1[0,2,4,6,8,10,12,14],xmm0[0,2,4,6,8,10,12,14]
; X64-XOP-NEXT:    retq
;
; X64-AVX2-LABEL: mul_v16i8_2_3_9_17_33_65_129_2_3_9_17_33_65_129_2_3:
; X64-AVX2:       # %bb.0:
; X64-AVX2-NEXT:    vpmovsxbw %xmm0, %ymm0
; X64-AVX2-NEXT:    vpmullw {{.*}}(%rip), %ymm0, %ymm0
; X64-AVX2-NEXT:    vextracti128 $1, %ymm0, %xmm1
; X64-AVX2-NEXT:    vmovdqa {{.*#+}} xmm2 = <0,2,4,6,8,10,12,14,u,u,u,u,u,u,u,u>
; X64-AVX2-NEXT:    vpshufb %xmm2, %xmm1, %xmm1
; X64-AVX2-NEXT:    vpshufb %xmm2, %xmm0, %xmm0
; X64-AVX2-NEXT:    vpunpcklqdq {{.*#+}} xmm0 = xmm0[0],xmm1[0]
; X64-AVX2-NEXT:    vzeroupper
; X64-AVX2-NEXT:    retq
  %1 = mul <16 x i8> %a0, <i8 2, i8 3, i8 9, i8 17, i8 33, i8 65, i8 129, i8 2, i8 3, i8 9, i8 17, i8 33, i8 65, i8 129, i8 2, i8 3>
  ret <16 x i8> %1
}

;
; PowOf2 - 1 (uniform)
;

define <2 x i64> @mul_v2i64_7(<2 x i64> %a0) nounwind {
; X86-LABEL: mul_v2i64_7:
; X86:       # %bb.0:
; X86-NEXT:    movdqa {{.*#+}} xmm1 = [7,0,7,0]
; X86-NEXT:    movdqa %xmm0, %xmm2
; X86-NEXT:    pmuludq %xmm1, %xmm2
; X86-NEXT:    psrlq $32, %xmm0
; X86-NEXT:    pmuludq %xmm1, %xmm0
; X86-NEXT:    psllq $32, %xmm0
; X86-NEXT:    paddq %xmm2, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: mul_v2i64_7:
; X64:       # %bb.0:
; X64-NEXT:    movdqa {{.*#+}} xmm1 = [7,7]
; X64-NEXT:    movdqa %xmm0, %xmm2
; X64-NEXT:    pmuludq %xmm1, %xmm2
; X64-NEXT:    psrlq $32, %xmm0
; X64-NEXT:    pmuludq %xmm1, %xmm0
; X64-NEXT:    psllq $32, %xmm0
; X64-NEXT:    paddq %xmm2, %xmm0
; X64-NEXT:    retq
;
; X64-AVX-LABEL: mul_v2i64_7:
; X64-AVX:       # %bb.0:
; X64-AVX-NEXT:    vmovdqa {{.*#+}} xmm1 = [7,7]
; X64-AVX-NEXT:    vpmuludq %xmm1, %xmm0, %xmm2
; X64-AVX-NEXT:    vpsrlq $32, %xmm0, %xmm0
; X64-AVX-NEXT:    vpmuludq %xmm1, %xmm0, %xmm0
; X64-AVX-NEXT:    vpsllq $32, %xmm0, %xmm0
; X64-AVX-NEXT:    vpaddq %xmm0, %xmm2, %xmm0
; X64-AVX-NEXT:    retq
  %1 = mul <2 x i64> %a0, <i64 7, i64 7>
  ret <2 x i64> %1
}

define <4 x i32> @mul_v4i32_7(<4 x i32> %a0) nounwind {
; X86-LABEL: mul_v4i32_7:
; X86:       # %bb.0:
; X86-NEXT:    pmulld {{\.LCPI.*}}, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: mul_v4i32_7:
; X64:       # %bb.0:
; X64-NEXT:    pmulld {{.*}}(%rip), %xmm0
; X64-NEXT:    retq
;
; X64-XOP-LABEL: mul_v4i32_7:
; X64-XOP:       # %bb.0:
; X64-XOP-NEXT:    vpmulld {{.*}}(%rip), %xmm0, %xmm0
; X64-XOP-NEXT:    retq
;
; X64-AVX2-LABEL: mul_v4i32_7:
; X64-AVX2:       # %bb.0:
; X64-AVX2-NEXT:    vpbroadcastd {{.*#+}} xmm1 = [7,7,7,7]
; X64-AVX2-NEXT:    vpmulld %xmm1, %xmm0, %xmm0
; X64-AVX2-NEXT:    retq
  %1 = mul <4 x i32> %a0, <i32 7, i32 7, i32 7, i32 7>
  ret <4 x i32> %1
}

define <8 x i16> @mul_v8i16_7(<8 x i16> %a0) nounwind {
; X86-LABEL: mul_v8i16_7:
; X86:       # %bb.0:
; X86-NEXT:    pmullw {{\.LCPI.*}}, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: mul_v8i16_7:
; X64:       # %bb.0:
; X64-NEXT:    pmullw {{.*}}(%rip), %xmm0
; X64-NEXT:    retq
;
; X64-AVX-LABEL: mul_v8i16_7:
; X64-AVX:       # %bb.0:
; X64-AVX-NEXT:    vpmullw {{.*}}(%rip), %xmm0, %xmm0
; X64-AVX-NEXT:    retq
  %1 = mul <8 x i16> %a0, <i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7>
  ret <8 x i16> %1
}

define <16 x i8> @mul_v16i8_31(<16 x i8> %a0) nounwind {
; X86-LABEL: mul_v16i8_31:
; X86:       # %bb.0:
; X86-NEXT:    pmovsxbw %xmm0, %xmm1
; X86-NEXT:    movdqa {{.*#+}} xmm2 = [31,31,31,31,31,31,31,31]
; X86-NEXT:    pmullw %xmm2, %xmm1
; X86-NEXT:    movdqa {{.*#+}} xmm3 = [255,255,255,255,255,255,255,255]
; X86-NEXT:    pand %xmm3, %xmm1
; X86-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[2,3,0,1]
; X86-NEXT:    pmovsxbw %xmm0, %xmm0
; X86-NEXT:    pmullw %xmm2, %xmm0
; X86-NEXT:    pand %xmm3, %xmm0
; X86-NEXT:    packuswb %xmm0, %xmm1
; X86-NEXT:    movdqa %xmm1, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: mul_v16i8_31:
; X64:       # %bb.0:
; X64-NEXT:    pmovsxbw %xmm0, %xmm1
; X64-NEXT:    movdqa {{.*#+}} xmm2 = [31,31,31,31,31,31,31,31]
; X64-NEXT:    pmullw %xmm2, %xmm1
; X64-NEXT:    movdqa {{.*#+}} xmm3 = [255,255,255,255,255,255,255,255]
; X64-NEXT:    pand %xmm3, %xmm1
; X64-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[2,3,0,1]
; X64-NEXT:    pmovsxbw %xmm0, %xmm0
; X64-NEXT:    pmullw %xmm2, %xmm0
; X64-NEXT:    pand %xmm3, %xmm0
; X64-NEXT:    packuswb %xmm0, %xmm1
; X64-NEXT:    movdqa %xmm1, %xmm0
; X64-NEXT:    retq
;
; X64-XOP-LABEL: mul_v16i8_31:
; X64-XOP:       # %bb.0:
; X64-XOP-NEXT:    vpmovsxbw %xmm0, %xmm1
; X64-XOP-NEXT:    vmovdqa {{.*#+}} xmm2 = [31,31,31,31,31,31,31,31]
; X64-XOP-NEXT:    vpmullw %xmm2, %xmm1, %xmm1
; X64-XOP-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[2,3,0,1]
; X64-XOP-NEXT:    vpmovsxbw %xmm0, %xmm0
; X64-XOP-NEXT:    vpmullw %xmm2, %xmm0, %xmm0
; X64-XOP-NEXT:    vpperm {{.*#+}} xmm0 = xmm1[0,2,4,6,8,10,12,14],xmm0[0,2,4,6,8,10,12,14]
; X64-XOP-NEXT:    retq
;
; X64-AVX2-LABEL: mul_v16i8_31:
; X64-AVX2:       # %bb.0:
; X64-AVX2-NEXT:    vpmovsxbw %xmm0, %ymm0
; X64-AVX2-NEXT:    vpmullw {{.*}}(%rip), %ymm0, %ymm0
; X64-AVX2-NEXT:    vextracti128 $1, %ymm0, %xmm1
; X64-AVX2-NEXT:    vmovdqa {{.*#+}} xmm2 = <0,2,4,6,8,10,12,14,u,u,u,u,u,u,u,u>
; X64-AVX2-NEXT:    vpshufb %xmm2, %xmm1, %xmm1
; X64-AVX2-NEXT:    vpshufb %xmm2, %xmm0, %xmm0
; X64-AVX2-NEXT:    vpunpcklqdq {{.*#+}} xmm0 = xmm0[0],xmm1[0]
; X64-AVX2-NEXT:    vzeroupper
; X64-AVX2-NEXT:    retq
  %1 = mul <16 x i8> %a0, <i8 31, i8 31, i8 31, i8 31, i8 31, i8 31, i8 31, i8 31, i8 31, i8 31, i8 31, i8 31, i8 31, i8 31, i8 31, i8 31>
  ret <16 x i8> %1
}

;
; PowOf2 - 1 (non-uniform)
;

define <2 x i64> @mul_v2i64_15_63(<2 x i64> %a0) nounwind {
; X86-LABEL: mul_v2i64_15_63:
; X86:       # %bb.0:
; X86-NEXT:    movdqa {{.*#+}} xmm1 = [15,0,63,0]
; X86-NEXT:    movdqa %xmm0, %xmm2
; X86-NEXT:    pmuludq %xmm1, %xmm2
; X86-NEXT:    psrlq $32, %xmm0
; X86-NEXT:    pmuludq %xmm1, %xmm0
; X86-NEXT:    psllq $32, %xmm0
; X86-NEXT:    paddq %xmm2, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: mul_v2i64_15_63:
; X64:       # %bb.0:
; X64-NEXT:    movdqa {{.*#+}} xmm1 = [15,63]
; X64-NEXT:    movdqa %xmm0, %xmm2
; X64-NEXT:    pmuludq %xmm1, %xmm2
; X64-NEXT:    psrlq $32, %xmm0
; X64-NEXT:    pmuludq %xmm1, %xmm0
; X64-NEXT:    psllq $32, %xmm0
; X64-NEXT:    paddq %xmm2, %xmm0
; X64-NEXT:    retq
;
; X64-AVX-LABEL: mul_v2i64_15_63:
; X64-AVX:       # %bb.0:
; X64-AVX-NEXT:    vmovdqa {{.*#+}} xmm1 = [15,63]
; X64-AVX-NEXT:    vpmuludq %xmm1, %xmm0, %xmm2
; X64-AVX-NEXT:    vpsrlq $32, %xmm0, %xmm0
; X64-AVX-NEXT:    vpmuludq %xmm1, %xmm0, %xmm0
; X64-AVX-NEXT:    vpsllq $32, %xmm0, %xmm0
; X64-AVX-NEXT:    vpaddq %xmm0, %xmm2, %xmm0
; X64-AVX-NEXT:    retq
  %1 = mul <2 x i64> %a0, <i64 15, i64 63>
  ret <2 x i64> %1
}

define <2 x i64> @mul_v2i64_neg_15_63(<2 x i64> %a0) nounwind {
; X86-LABEL: mul_v2i64_neg_15_63:
; X86:       # %bb.0:
; X86-NEXT:    movdqa %xmm0, %xmm1
; X86-NEXT:    psrlq $32, %xmm1
; X86-NEXT:    movdqa {{.*#+}} xmm2 = [4294967281,4294967295,4294967233,4294967295]
; X86-NEXT:    pmuludq %xmm2, %xmm1
; X86-NEXT:    movdqa %xmm2, %xmm3
; X86-NEXT:    psrlq $32, %xmm3
; X86-NEXT:    pmuludq %xmm0, %xmm3
; X86-NEXT:    paddq %xmm1, %xmm3
; X86-NEXT:    psllq $32, %xmm3
; X86-NEXT:    pmuludq %xmm2, %xmm0
; X86-NEXT:    paddq %xmm3, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: mul_v2i64_neg_15_63:
; X64:       # %bb.0:
; X64-NEXT:    movdqa {{.*#+}} xmm1 = [18446744073709551601,18446744073709551553]
; X64-NEXT:    movdqa %xmm0, %xmm2
; X64-NEXT:    pmuludq %xmm1, %xmm2
; X64-NEXT:    movdqa %xmm0, %xmm3
; X64-NEXT:    psrlq $32, %xmm3
; X64-NEXT:    pmuludq %xmm1, %xmm3
; X64-NEXT:    pmuludq {{.*}}(%rip), %xmm0
; X64-NEXT:    paddq %xmm3, %xmm0
; X64-NEXT:    psllq $32, %xmm0
; X64-NEXT:    paddq %xmm2, %xmm0
; X64-NEXT:    retq
;
; X64-AVX-LABEL: mul_v2i64_neg_15_63:
; X64-AVX:       # %bb.0:
; X64-AVX-NEXT:    vmovdqa {{.*#+}} xmm1 = [18446744073709551601,18446744073709551553]
; X64-AVX-NEXT:    vpmuludq %xmm1, %xmm0, %xmm2
; X64-AVX-NEXT:    vpsrlq $32, %xmm0, %xmm3
; X64-AVX-NEXT:    vpmuludq %xmm1, %xmm3, %xmm1
; X64-AVX-NEXT:    vpmuludq {{.*}}(%rip), %xmm0, %xmm0
; X64-AVX-NEXT:    vpaddq %xmm1, %xmm0, %xmm0
; X64-AVX-NEXT:    vpsllq $32, %xmm0, %xmm0
; X64-AVX-NEXT:    vpaddq %xmm0, %xmm2, %xmm0
; X64-AVX-NEXT:    retq
  %1 = mul <2 x i64> %a0, <i64 -15, i64 -63>
  ret <2 x i64> %1
}

define <2 x i64> @mul_v2i64_neg_17_65(<2 x i64> %a0) nounwind {
; X86-LABEL: mul_v2i64_neg_17_65:
; X86:       # %bb.0:
; X86-NEXT:    movdqa %xmm0, %xmm1
; X86-NEXT:    psrlq $32, %xmm1
; X86-NEXT:    movdqa {{.*#+}} xmm2 = [4294967279,4294967295,4294967231,4294967295]
; X86-NEXT:    pmuludq %xmm2, %xmm1
; X86-NEXT:    movdqa %xmm2, %xmm3
; X86-NEXT:    psrlq $32, %xmm3
; X86-NEXT:    pmuludq %xmm0, %xmm3
; X86-NEXT:    paddq %xmm1, %xmm3
; X86-NEXT:    psllq $32, %xmm3
; X86-NEXT:    pmuludq %xmm2, %xmm0
; X86-NEXT:    paddq %xmm3, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: mul_v2i64_neg_17_65:
; X64:       # %bb.0:
; X64-NEXT:    movdqa {{.*#+}} xmm1 = [18446744073709551599,18446744073709551551]
; X64-NEXT:    movdqa %xmm0, %xmm2
; X64-NEXT:    pmuludq %xmm1, %xmm2
; X64-NEXT:    movdqa %xmm0, %xmm3
; X64-NEXT:    psrlq $32, %xmm3
; X64-NEXT:    pmuludq %xmm1, %xmm3
; X64-NEXT:    pmuludq {{.*}}(%rip), %xmm0
; X64-NEXT:    paddq %xmm3, %xmm0
; X64-NEXT:    psllq $32, %xmm0
; X64-NEXT:    paddq %xmm2, %xmm0
; X64-NEXT:    retq
;
; X64-AVX-LABEL: mul_v2i64_neg_17_65:
; X64-AVX:       # %bb.0:
; X64-AVX-NEXT:    vmovdqa {{.*#+}} xmm1 = [18446744073709551599,18446744073709551551]
; X64-AVX-NEXT:    vpmuludq %xmm1, %xmm0, %xmm2
; X64-AVX-NEXT:    vpsrlq $32, %xmm0, %xmm3
; X64-AVX-NEXT:    vpmuludq %xmm1, %xmm3, %xmm1
; X64-AVX-NEXT:    vpmuludq {{.*}}(%rip), %xmm0, %xmm0
; X64-AVX-NEXT:    vpaddq %xmm1, %xmm0, %xmm0
; X64-AVX-NEXT:    vpsllq $32, %xmm0, %xmm0
; X64-AVX-NEXT:    vpaddq %xmm0, %xmm2, %xmm0
; X64-AVX-NEXT:    retq
  %1 = mul <2 x i64> %a0, <i64 -17, i64 -65>
  ret <2 x i64> %1
}

define <2 x i64> @mul_v2i64_0_1(<2 x i64> %a0) nounwind {
; X86-LABEL: mul_v2i64_0_1:
; X86:       # %bb.0:
; X86-NEXT:    movdqa {{.*#+}} xmm1 = [0,0,1,0]
; X86-NEXT:    movdqa %xmm0, %xmm2
; X86-NEXT:    pmuludq %xmm1, %xmm2
; X86-NEXT:    psrlq $32, %xmm0
; X86-NEXT:    pmuludq %xmm1, %xmm0
; X86-NEXT:    psllq $32, %xmm0
; X86-NEXT:    paddq %xmm2, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: mul_v2i64_0_1:
; X64:       # %bb.0:
; X64-NEXT:    movl $1, %eax
; X64-NEXT:    movq %rax, %xmm1
; X64-NEXT:    pslldq {{.*#+}} xmm1 = zero,zero,zero,zero,zero,zero,zero,zero,xmm1[0,1,2,3,4,5,6,7]
; X64-NEXT:    movdqa %xmm0, %xmm2
; X64-NEXT:    pmuludq %xmm1, %xmm2
; X64-NEXT:    psrlq $32, %xmm0
; X64-NEXT:    pmuludq %xmm1, %xmm0
; X64-NEXT:    psllq $32, %xmm0
; X64-NEXT:    paddq %xmm2, %xmm0
; X64-NEXT:    retq
;
; X64-AVX-LABEL: mul_v2i64_0_1:
; X64-AVX:       # %bb.0:
; X64-AVX-NEXT:    movl $1, %eax
; X64-AVX-NEXT:    vmovq %rax, %xmm1
; X64-AVX-NEXT:    vpslldq {{.*#+}} xmm1 = zero,zero,zero,zero,zero,zero,zero,zero,xmm1[0,1,2,3,4,5,6,7]
; X64-AVX-NEXT:    vpmuludq %xmm1, %xmm0, %xmm2
; X64-AVX-NEXT:    vpsrlq $32, %xmm0, %xmm0
; X64-AVX-NEXT:    vpmuludq %xmm1, %xmm0, %xmm0
; X64-AVX-NEXT:    vpsllq $32, %xmm0, %xmm0
; X64-AVX-NEXT:    vpaddq %xmm0, %xmm2, %xmm0
; X64-AVX-NEXT:    retq
  %1 = mul <2 x i64> %a0, <i64 0, i64 1>
  ret <2 x i64> %1
}

define <2 x i64> @mul_v2i64_neg_0_1(<2 x i64> %a0) nounwind {
; X86-LABEL: mul_v2i64_neg_0_1:
; X86:       # %bb.0:
; X86-NEXT:    movdqa %xmm0, %xmm1
; X86-NEXT:    psrlq $32, %xmm1
; X86-NEXT:    movdqa {{.*#+}} xmm2 = [0,0,4294967295,4294967295]
; X86-NEXT:    pmuludq %xmm2, %xmm1
; X86-NEXT:    movdqa %xmm2, %xmm3
; X86-NEXT:    psrlq $32, %xmm3
; X86-NEXT:    pmuludq %xmm0, %xmm3
; X86-NEXT:    paddq %xmm1, %xmm3
; X86-NEXT:    psllq $32, %xmm3
; X86-NEXT:    pmuludq %xmm2, %xmm0
; X86-NEXT:    paddq %xmm3, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: mul_v2i64_neg_0_1:
; X64:       # %bb.0:
; X64-NEXT:    movdqa %xmm0, %xmm1
; X64-NEXT:    psrlq $32, %xmm1
; X64-NEXT:    movq $-1, %rax
; X64-NEXT:    movq %rax, %xmm2
; X64-NEXT:    pslldq {{.*#+}} xmm2 = zero,zero,zero,zero,zero,zero,zero,zero,xmm2[0,1,2,3,4,5,6,7]
; X64-NEXT:    pmuludq %xmm2, %xmm1
; X64-NEXT:    movl $4294967295, %eax # imm = 0xFFFFFFFF
; X64-NEXT:    movq %rax, %xmm3
; X64-NEXT:    pslldq {{.*#+}} xmm3 = zero,zero,zero,zero,zero,zero,zero,zero,xmm3[0,1,2,3,4,5,6,7]
; X64-NEXT:    pmuludq %xmm0, %xmm3
; X64-NEXT:    paddq %xmm1, %xmm3
; X64-NEXT:    psllq $32, %xmm3
; X64-NEXT:    pmuludq %xmm2, %xmm0
; X64-NEXT:    paddq %xmm3, %xmm0
; X64-NEXT:    retq
;
; X64-AVX-LABEL: mul_v2i64_neg_0_1:
; X64-AVX:       # %bb.0:
; X64-AVX-NEXT:    vpsrlq $32, %xmm0, %xmm1
; X64-AVX-NEXT:    movq $-1, %rax
; X64-AVX-NEXT:    vmovq %rax, %xmm2
; X64-AVX-NEXT:    vpslldq {{.*#+}} xmm2 = zero,zero,zero,zero,zero,zero,zero,zero,xmm2[0,1,2,3,4,5,6,7]
; X64-AVX-NEXT:    vpmuludq %xmm2, %xmm1, %xmm1
; X64-AVX-NEXT:    movl $4294967295, %eax # imm = 0xFFFFFFFF
; X64-AVX-NEXT:    vmovq %rax, %xmm3
; X64-AVX-NEXT:    vpslldq {{.*#+}} xmm3 = zero,zero,zero,zero,zero,zero,zero,zero,xmm3[0,1,2,3,4,5,6,7]
; X64-AVX-NEXT:    vpmuludq %xmm3, %xmm0, %xmm3
; X64-AVX-NEXT:    vpaddq %xmm1, %xmm3, %xmm1
; X64-AVX-NEXT:    vpsllq $32, %xmm1, %xmm1
; X64-AVX-NEXT:    vpmuludq %xmm2, %xmm0, %xmm0
; X64-AVX-NEXT:    vpaddq %xmm1, %xmm0, %xmm0
; X64-AVX-NEXT:    retq
  %1 = mul <2 x i64> %a0, <i64 0, i64 -1>
  ret <2 x i64> %1
}

define <2 x i64> @mul_v2i64_15_neg_63(<2 x i64> %a0) nounwind {
; X86-LABEL: mul_v2i64_15_neg_63:
; X86:       # %bb.0:
; X86-NEXT:    movdqa %xmm0, %xmm1
; X86-NEXT:    psrlq $32, %xmm1
; X86-NEXT:    movdqa {{.*#+}} xmm2 = [15,0,4294967233,4294967295]
; X86-NEXT:    pmuludq %xmm2, %xmm1
; X86-NEXT:    movdqa %xmm2, %xmm3
; X86-NEXT:    psrlq $32, %xmm3
; X86-NEXT:    pmuludq %xmm0, %xmm3
; X86-NEXT:    paddq %xmm1, %xmm3
; X86-NEXT:    psllq $32, %xmm3
; X86-NEXT:    pmuludq %xmm2, %xmm0
; X86-NEXT:    paddq %xmm3, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: mul_v2i64_15_neg_63:
; X64:       # %bb.0:
; X64-NEXT:    movdqa %xmm0, %xmm1
; X64-NEXT:    psrlq $32, %xmm1
; X64-NEXT:    movdqa {{.*#+}} xmm2 = [15,18446744073709551553]
; X64-NEXT:    pmuludq %xmm2, %xmm1
; X64-NEXT:    movl $4294967295, %eax # imm = 0xFFFFFFFF
; X64-NEXT:    movq %rax, %xmm3
; X64-NEXT:    pslldq {{.*#+}} xmm3 = zero,zero,zero,zero,zero,zero,zero,zero,xmm3[0,1,2,3,4,5,6,7]
; X64-NEXT:    pmuludq %xmm0, %xmm3
; X64-NEXT:    paddq %xmm1, %xmm3
; X64-NEXT:    psllq $32, %xmm3
; X64-NEXT:    pmuludq %xmm2, %xmm0
; X64-NEXT:    paddq %xmm3, %xmm0
; X64-NEXT:    retq
;
; X64-AVX-LABEL: mul_v2i64_15_neg_63:
; X64-AVX:       # %bb.0:
; X64-AVX-NEXT:    vpsrlq $32, %xmm0, %xmm1
; X64-AVX-NEXT:    vmovdqa {{.*#+}} xmm2 = [15,18446744073709551553]
; X64-AVX-NEXT:    vpmuludq %xmm2, %xmm1, %xmm1
; X64-AVX-NEXT:    movl $4294967295, %eax # imm = 0xFFFFFFFF
; X64-AVX-NEXT:    vmovq %rax, %xmm3
; X64-AVX-NEXT:    vpslldq {{.*#+}} xmm3 = zero,zero,zero,zero,zero,zero,zero,zero,xmm3[0,1,2,3,4,5,6,7]
; X64-AVX-NEXT:    vpmuludq %xmm3, %xmm0, %xmm3
; X64-AVX-NEXT:    vpaddq %xmm1, %xmm3, %xmm1
; X64-AVX-NEXT:    vpsllq $32, %xmm1, %xmm1
; X64-AVX-NEXT:    vpmuludq %xmm2, %xmm0, %xmm0
; X64-AVX-NEXT:    vpaddq %xmm1, %xmm0, %xmm0
; X64-AVX-NEXT:    retq
  %1 = mul <2 x i64> %a0, <i64 15, i64 -63>
  ret <2 x i64> %1
}

define <4 x i32> @mul_v4i32_0_15_31_7(<4 x i32> %a0) nounwind {
; X86-LABEL: mul_v4i32_0_15_31_7:
; X86:       # %bb.0:
; X86-NEXT:    pmulld {{\.LCPI.*}}, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: mul_v4i32_0_15_31_7:
; X64:       # %bb.0:
; X64-NEXT:    pmulld {{.*}}(%rip), %xmm0
; X64-NEXT:    retq
;
; X64-AVX-LABEL: mul_v4i32_0_15_31_7:
; X64-AVX:       # %bb.0:
; X64-AVX-NEXT:    vpmulld {{.*}}(%rip), %xmm0, %xmm0
; X64-AVX-NEXT:    retq
  %1 = mul <4 x i32> %a0, <i32 0, i32 15, i32 31, i32 7>
  ret <4 x i32> %1
}

define <8 x i16> @mul_v8i16_0_1_7_15_31_63_127_255(<8 x i16> %a0) nounwind {
; X86-LABEL: mul_v8i16_0_1_7_15_31_63_127_255:
; X86:       # %bb.0:
; X86-NEXT:    pmullw {{\.LCPI.*}}, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: mul_v8i16_0_1_7_15_31_63_127_255:
; X64:       # %bb.0:
; X64-NEXT:    pmullw {{.*}}(%rip), %xmm0
; X64-NEXT:    retq
;
; X64-AVX-LABEL: mul_v8i16_0_1_7_15_31_63_127_255:
; X64-AVX:       # %bb.0:
; X64-AVX-NEXT:    vpmullw {{.*}}(%rip), %xmm0, %xmm0
; X64-AVX-NEXT:    retq
  %1 = mul <8 x i16> %a0, <i16 0, i16 1, i16 7, i16 15, i16 31, i16 63, i16 127, i16 255>
  ret <8 x i16> %1
}

define <16 x i8> @mul_v16i8_0_1_3_7_15_31_63_127_0_1_3_7_15_31_63_127(<16 x i8> %a0) nounwind {
; X86-LABEL: mul_v16i8_0_1_3_7_15_31_63_127_0_1_3_7_15_31_63_127:
; X86:       # %bb.0:
; X86-NEXT:    pmovsxbw %xmm0, %xmm1
; X86-NEXT:    movdqa {{.*#+}} xmm2 = [0,1,3,7,15,31,63,127]
; X86-NEXT:    pmullw %xmm2, %xmm1
; X86-NEXT:    movdqa {{.*#+}} xmm3 = [255,255,255,255,255,255,255,255]
; X86-NEXT:    pand %xmm3, %xmm1
; X86-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[2,3,0,1]
; X86-NEXT:    pmovsxbw %xmm0, %xmm0
; X86-NEXT:    pmullw %xmm2, %xmm0
; X86-NEXT:    pand %xmm3, %xmm0
; X86-NEXT:    packuswb %xmm0, %xmm1
; X86-NEXT:    movdqa %xmm1, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: mul_v16i8_0_1_3_7_15_31_63_127_0_1_3_7_15_31_63_127:
; X64:       # %bb.0:
; X64-NEXT:    pmovsxbw %xmm0, %xmm1
; X64-NEXT:    movdqa {{.*#+}} xmm2 = [0,1,3,7,15,31,63,127]
; X64-NEXT:    pmullw %xmm2, %xmm1
; X64-NEXT:    movdqa {{.*#+}} xmm3 = [255,255,255,255,255,255,255,255]
; X64-NEXT:    pand %xmm3, %xmm1
; X64-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[2,3,0,1]
; X64-NEXT:    pmovsxbw %xmm0, %xmm0
; X64-NEXT:    pmullw %xmm2, %xmm0
; X64-NEXT:    pand %xmm3, %xmm0
; X64-NEXT:    packuswb %xmm0, %xmm1
; X64-NEXT:    movdqa %xmm1, %xmm0
; X64-NEXT:    retq
;
; X64-XOP-LABEL: mul_v16i8_0_1_3_7_15_31_63_127_0_1_3_7_15_31_63_127:
; X64-XOP:       # %bb.0:
; X64-XOP-NEXT:    vpmovsxbw %xmm0, %xmm1
; X64-XOP-NEXT:    vmovdqa {{.*#+}} xmm2 = [0,1,3,7,15,31,63,127]
; X64-XOP-NEXT:    vpmullw %xmm2, %xmm1, %xmm1
; X64-XOP-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[2,3,0,1]
; X64-XOP-NEXT:    vpmovsxbw %xmm0, %xmm0
; X64-XOP-NEXT:    vpmullw %xmm2, %xmm0, %xmm0
; X64-XOP-NEXT:    vpperm {{.*#+}} xmm0 = xmm1[0,2,4,6,8,10,12,14],xmm0[0,2,4,6,8,10,12,14]
; X64-XOP-NEXT:    retq
;
; X64-AVX2-LABEL: mul_v16i8_0_1_3_7_15_31_63_127_0_1_3_7_15_31_63_127:
; X64-AVX2:       # %bb.0:
; X64-AVX2-NEXT:    vpmovsxbw %xmm0, %ymm0
; X64-AVX2-NEXT:    vpmullw {{.*}}(%rip), %ymm0, %ymm0
; X64-AVX2-NEXT:    vextracti128 $1, %ymm0, %xmm1
; X64-AVX2-NEXT:    vmovdqa {{.*#+}} xmm2 = <0,2,4,6,8,10,12,14,u,u,u,u,u,u,u,u>
; X64-AVX2-NEXT:    vpshufb %xmm2, %xmm1, %xmm1
; X64-AVX2-NEXT:    vpshufb %xmm2, %xmm0, %xmm0
; X64-AVX2-NEXT:    vpunpcklqdq {{.*#+}} xmm0 = xmm0[0],xmm1[0]
; X64-AVX2-NEXT:    vzeroupper
; X64-AVX2-NEXT:    retq
  %1 = mul <16 x i8> %a0, <i8 0, i8 1, i8 3, i8 7, i8 15, i8 31, i8 63, i8 127, i8 0, i8 1, i8 3, i8 7, i8 15, i8 31, i8 63, i8 127>
  ret <16 x i8> %1
}

define <2 x i64> @mul_v2i64_68_132(<2 x i64> %x) nounwind {
; X86-LABEL: mul_v2i64_68_132:
; X86:       # %bb.0:
; X86-NEXT:    movdqa {{.*#+}} xmm1 = [68,0,132,0]
; X86-NEXT:    movdqa %xmm0, %xmm2
; X86-NEXT:    pmuludq %xmm1, %xmm2
; X86-NEXT:    psrlq $32, %xmm0
; X86-NEXT:    pmuludq %xmm1, %xmm0
; X86-NEXT:    psllq $32, %xmm0
; X86-NEXT:    paddq %xmm2, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: mul_v2i64_68_132:
; X64:       # %bb.0:
; X64-NEXT:    movdqa {{.*#+}} xmm1 = [68,132]
; X64-NEXT:    movdqa %xmm0, %xmm2
; X64-NEXT:    pmuludq %xmm1, %xmm2
; X64-NEXT:    psrlq $32, %xmm0
; X64-NEXT:    pmuludq %xmm1, %xmm0
; X64-NEXT:    psllq $32, %xmm0
; X64-NEXT:    paddq %xmm2, %xmm0
; X64-NEXT:    retq
;
; X64-AVX-LABEL: mul_v2i64_68_132:
; X64-AVX:       # %bb.0:
; X64-AVX-NEXT:    vmovdqa {{.*#+}} xmm1 = [68,132]
; X64-AVX-NEXT:    vpmuludq %xmm1, %xmm0, %xmm2
; X64-AVX-NEXT:    vpsrlq $32, %xmm0, %xmm0
; X64-AVX-NEXT:    vpmuludq %xmm1, %xmm0, %xmm0
; X64-AVX-NEXT:    vpsllq $32, %xmm0, %xmm0
; X64-AVX-NEXT:    vpaddq %xmm0, %xmm2, %xmm0
; X64-AVX-NEXT:    retq
  %mul = mul <2 x i64> %x, <i64 68, i64 132>
  ret <2 x i64> %mul
}

define <2 x i64> @mul_v2i64_60_120(<2 x i64> %x) nounwind {
; X86-LABEL: mul_v2i64_60_120:
; X86:       # %bb.0:
; X86-NEXT:    movdqa {{.*#+}} xmm1 = [60,0,124,0]
; X86-NEXT:    movdqa %xmm0, %xmm2
; X86-NEXT:    pmuludq %xmm1, %xmm2
; X86-NEXT:    psrlq $32, %xmm0
; X86-NEXT:    pmuludq %xmm1, %xmm0
; X86-NEXT:    psllq $32, %xmm0
; X86-NEXT:    paddq %xmm2, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: mul_v2i64_60_120:
; X64:       # %bb.0:
; X64-NEXT:    movdqa {{.*#+}} xmm1 = [60,124]
; X64-NEXT:    movdqa %xmm0, %xmm2
; X64-NEXT:    pmuludq %xmm1, %xmm2
; X64-NEXT:    psrlq $32, %xmm0
; X64-NEXT:    pmuludq %xmm1, %xmm0
; X64-NEXT:    psllq $32, %xmm0
; X64-NEXT:    paddq %xmm2, %xmm0
; X64-NEXT:    retq
;
; X64-AVX-LABEL: mul_v2i64_60_120:
; X64-AVX:       # %bb.0:
; X64-AVX-NEXT:    vmovdqa {{.*#+}} xmm1 = [60,124]
; X64-AVX-NEXT:    vpmuludq %xmm1, %xmm0, %xmm2
; X64-AVX-NEXT:    vpsrlq $32, %xmm0, %xmm0
; X64-AVX-NEXT:    vpmuludq %xmm1, %xmm0, %xmm0
; X64-AVX-NEXT:    vpsllq $32, %xmm0, %xmm0
; X64-AVX-NEXT:    vpaddq %xmm0, %xmm2, %xmm0
; X64-AVX-NEXT:    retq
  %mul = mul <2 x i64> %x, <i64 60, i64 124>
  ret <2 x i64> %mul
}

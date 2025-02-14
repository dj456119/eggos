#include "textflag.h"

// copy from go_tls.h
#define get_tls(r)	MOVL TLS, r
#define g(r)	0(r)(TLS*1)

TEXT ·rt0(SB), NOSPLIT, $0-0
	// switch to new stack
	MOVQ $0x80000, SP
	XORQ BP, BP

	// DI and SI store multiboot magic and info passed by bootloader
	SUBQ $0x10, SP
	MOVQ DI, 0(SP)
	MOVQ SI, 8(SP)
	CALL ·preinit(SB)
	INT  $3

	// never return

TEXT ·go_entry(SB), NOSPLIT, $0
	SUBQ  $256, SP
	PUSHQ SP
	CALL  ·prepareArgs(SB)
	ADDQ  $8, SP
	JMP   _rt0_amd64_linux(SB)

TEXT ·sseInit(SB), NOSPLIT, $0
	MOVL CR0, AX
	ANDW $0xFFFB, AX
	ORW  $0x2, AX
	MOVL AX, CR0
	MOVL CR4, AX
	ORW  $3<<9, AX
	MOVL AX, CR4
	RET

TEXT ·avxInit(SB), NOSPLIT, $0
	// enable XGETBV and XSETBV
	MOVL CR4, AX
	ORL  $1<<18, AX
	MOVL AX, CR4

	// enable avx
	XORQ CX, CX
	XGETBV

	ORQ  $7, AX
	XORQ CX, CX
	XSETBV
	RET

TEXT ·rdmsr(SB), NOSPLIT, $0-16
	MOVL reg+0(FP), CX
	RDMSR
	MOVL AX, lo+8(FP)
	MOVL DX, hi+12(FP)
	RET

TEXT ·wrmsr(SB), NOSPLIT, $0-16
	MOVL reg+0(FP), CX
	MOVL lo+8(FP), AX
	MOVL hi+12(FP), DX
	WRMSR
	RET

TEXT ·getg(SB), NOSPLIT, $0-8
	get_tls(CX)
	MOVQ g(CX), BX
	MOVQ BX, ret+0(FP)
	RET

TEXT ·cpuid(SB), NOSPLIT, $0-24
	MOVL fn+0(FP), AX
	MOVL cx+4(FP), CX
	CPUID
	MOVL AX, eax+8(FP)
	MOVL BX, ebx+12(FP)
	MOVL CX, ecx+16(FP)
	MOVL DX, edx+20(FP)
	RET


#define CPU_STACK_SIZE 1024*1024*50 // 50MiB

main:
	// Setup EL1 (OS execution ring) exception vector table
    ldr x1, =exception_vector_table
    msr vbar_el3, x1

	// Asynchronous exceptions routing
	MRS X0, SCR_EL3
	ORR X0, X0, #(1<<3) // The EA bit.
	ORR X0, X0, #(1<<1) // The IRQ bit.
	ORR X0, X0, #(1<<2) // The FIQ bit.
	MSR SCR_EL3, X0

	// Enable SError, IRQ and FIQ (fix PSTATE for EL1)
	MSR DAIFClr, #0x7

	// Initialize the register bank.
	// (ARM processors use some non-reset flip-flops. This can cause X-propagation issues in simulations.
	// Register initialization helps reduce the possibility of the issue. Note: This initialization is not
	// required on silicon chips because X status only exists in hardware simulations.)
	MOV X0, XZR
	MOV X1, XZR
	MOV X2, XZR
	MOV X3, XZR
	MOV X4, XZR
	MOV X5, XZR
	MOV X6, XZR
	MOV X7, XZR
	MOV X8, XZR
	MOV X9, XZR
	MOV X10, XZR
	MOV X11, XZR
	MOV X12, XZR
	MOV X13, XZR
	MOV X14, XZR
	MOV X15, XZR
	MOV X16, XZR
	MOV X17, XZR
	MOV X18, XZR
	MOV X19, XZR
	MOV X20, XZR
	MOV X21, XZR
	MOV X22, XZR
	MOV X23, XZR
	MOV X24, XZR
	MOV X25, XZR
	MOV X26, XZR
	MOV X27, XZR
	MOV X28, XZR
	MOV X29, XZR
	MOV X30, XZR

	MSR CPTR_EL3, XZR
	MSR CPTR_EL2, XZR

	// Enable advanced SIMD instructions (required for variadic functions): set CPACR_EL1 = CPACR_EL1|1671168;
	mrs x0, cpacr_el1
	mov x1, 32768
	movk x1, 0x19, lsl 16
	orr x0, x0, x1
	msr cpacr_el1, x0

	// If a processor implements the NEON and FP extension, floating-point registers must be initialized as well.
	FMOV D0, XZR
	FMOV D1, XZR
	FMOV D2, XZR
	FMOV D3, XZR
	FMOV D4, XZR
	FMOV D5, XZR
	FMOV D6, XZR
	FMOV D7, XZR
	FMOV D8, XZR
	FMOV D9, XZR
	FMOV D10, XZR
	FMOV D11, XZR
	FMOV D12, XZR
	FMOV D13, XZR
	FMOV D14, XZR
	FMOV D15, XZR
	FMOV D16, XZR
	FMOV D17, XZR
	FMOV D18, XZR
	FMOV D19, XZR
	FMOV D20, XZR
	FMOV D21, XZR
	FMOV D22, XZR
	FMOV D23, XZR
	FMOV D24, XZR
	FMOV D25, XZR
	FMOV D26, XZR
	FMOV D27, XZR
	FMOV D28, XZR
	FMOV D29, XZR
	FMOV D30, XZR
	FMOV D31, XZR

	// Initialize the stack pointer (same code runs on different threads in SMP mode
	// and thus ends up with seperate SPs: stack_top-0*CPU_STACK_SIZE,
	// stack_top-1*CPU_STACK_SIZE, ... and so on)
	LDR X1, =stack_top
	ADD X1, X1, #4
	MRS X2, MPIDR_EL1
	AND X2, X2, #0xFF // X2 == CPU number.
	MOV X3, #CPU_STACK_SIZE
	MUL X3, X2, X3 // Create separated stack spaces
	SUB X1, X1, X3 // for each processor
	MOV SP, X1

	// Initializing system control registers
	// Some system control registers do not have architectural reset values. Therefore, you must initialize the registers based on your software requirements before using them.
	MSR HCR_EL2, XZR
	LDR X1, =0x30C50838
	MSR SCTLR_EL2, X1
	MSR SCTLR_EL1, X1

    // Jump to kmain in c-world
	bl kmain
	b .


.balign 0x800
exception_vector_table:
exception_vector_table_curelsp0_sync:
	bl kInterruptCurrentElSp0
	eret

.balign 0x80
exception_vector_table_curelsp0_irq:
	bl kInterruptCurrentElSp0Unhandled
	eret

.balign 0x80
exception_vector_table_curelsp0_fiq:
	bl kInterruptCurrentElSp0Unhandled
	eret

.balign 0x80
exception_vector_table_curelsp0_serror:
	bl kInterruptCurrentElSp0Unhandled
	eret


.balign 0x80
exception_vector_table_curelcursp_sync:
	bl kInterruptCurrentEl
	eret

.balign 0x80
exception_vector_table_curelcursp_irq:
	bl kInterruptCurrentElUnhandled
	eret

.balign 0x80
exception_vector_table_curelcursp_fiq:
	bl kInterruptCurrentElUnhandled
	eret

.balign 0x80
exception_vector_table_curelcursp_serror:
	bl kInterruptCurrentElUnhandled
	eret


.balign 0x80
exception_vector_table_lowela64_sync:
	bl kInterruptLowerEl
	eret

.balign 0x80
exception_vector_table_lowela64_irq:
	bl kInterruptLowerElUnhandled
	eret

.balign 0x80
exception_vector_table_lowela64_fiq:
	bl kInterruptLowerElUnhandled
	eret

.balign 0x80
exception_vector_table_lowela64_serror:
	bl kInterruptLowerElUnhandled
	eret


.balign 0x80
exception_vector_table_lowela32_sync:
	bl kInterruptLowerElUnhandledAarch32
	eret

.balign 0x80
exception_vector_table_lowela32_irq:
	bl kInterruptLowerElUnhandledAarch32
	eret

.balign 0x80
exception_vector_table_lowela32_fiq:
	bl kInterruptLowerElUnhandledAarch32
	eret

.balign 0x80
exception_vector_table_lowela32_serror:
	bl kInterruptLowerElUnhandledAarch32
	eret

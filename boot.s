.global _main
_main:
	// Enable advanced SIMD instructions (required for variadic functions): set CPACR_EL1 = CPACR_EL1|1671168;
	mrs x0, cpacr_el1
	mov x1, 32768
	movk x1, 0x19, lsl 16
	orr x0, x0, x1
	msr cpacr_el1, x0

	// Setup stack, jump to kmain in c-world
	ldr x30, =stack_top
	mov sp, x30
	bl kmain
	b .

.global enable_exceptions
enable_exceptions:
    // Setup EL1 (OS execution ring) exception vector table
    ldr x1,=exception_vector_table
    msr vbar_el1,x1

    // Setup secure zones (not sure how this works at the moment)
    mrs x0, scr_el3
    orr x0, x0, #8
    orr x0, x0, #4
    orr x0, x0, #2
    msr scr_el3, x0

    // Clear/enable irq bit in PSTATE
    msr daifclr, #2
	ret

/*
	b _main
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	.balign 128
	b .
	.balign 128
	b .
	.balign 128
	b .
	.balign 128
	b .
	.balign 128
	b _irq_handler
*/

.global exception_vector_table
exception_vector_table:
	/* Current EL with SP0 */
	b interrupt /* Synchronous */
	.balign 128
	b interrupt  /* IRQ/vIRQ */
	.balign 128
	b interrupt  /* FIQ/vFIQ */
	.balign 128
	b interrupt /* SError/vSError */
	.balign 128

	/* Current EL with SPn */
	b interrupt /* Synchronous */
	.balign 128
	b interrupt  /* IRQ/vIRQ */
	.balign 128
	b interrupt  /* FIQ/vFIQ */
	.balign 128
	b interrupt /* SError/vSError */
	.balign 128

	/* Lower EL with Aarch64 */
	b interrupt /* Synchronous */
	.balign 128
	b interrupt  /* IRQ/vIRQ */
	.balign 128
	b interrupt  /* FIQ/vFIQ */
	.balign 128
	b interrupt /* SError/vSError */
	.balign 128

	/* Lower EL with Aarch32 */
	b interrupt /* Synchronous */
	.balign 128
	b interrupt  /* IRQ/vIRQ */
	.balign 128
	b interrupt  /* FIQ/vFIQ */
	.balign 128
	b interrupt /* SError/vSError */
	.balign 128

interrupt:
    stp x0,x1,[sp,#-16]!
    stp x2,x3,[sp,#-16]!
    stp x4,x5,[sp,#-16]!
    stp x6,x7,[sp,#-16]!
    stp x8,x9,[sp,#-16]!
    stp x10,x11,[sp,#-16]!
    stp x12,x13,[sp,#-16]!
    stp x14,x15,[sp,#-16]!
    stp x16,x17,[sp,#-16]!
    stp x18,x19,[sp,#-16]!

	// mrs x0,esr_el1
	b kinterrupt
    msr daifclr, #2 // Clear IRQ bit

    ldp x18,x19,[sp],#16
    ldp x16,x17,[sp],#16
    ldp x14,x15,[sp],#16
    ldp x12,x13,[sp],#16
    ldp x10,x11,[sp],#16
    ldp x8,x9,[sp],#16
    ldp x6,x7,[sp],#16
    ldp x4,x5,[sp],#16
    ldp x2,x3,[sp],#16
    ldp x0,x1,[sp],#16

    eret

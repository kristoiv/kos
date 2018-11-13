main:
	// Enable advanced SIMD instructions (required for variadic functions): set CPACR_EL1 = CPACR_EL1|1671168;
	mrs x0, cpacr_el1
	mov x1, 32768
	movk x1, 0x19, lsl 16
	orr x0, x0, x1
	msr cpacr_el1, x0

    // Setup EL1 (OS execution ring) exception vector table
    ldr x1, =exception_vector_table
    msr vbar_el1, x1

    // Setup secure zones (not sure how this works at the moment)
	/*
    mrs x0, scr_el3
    orr x0, x0, #8
    orr x0, x0, #4
    orr x0, x0, #2
    msr scr_el3, x0
	*/

    // Clear/enable irq bit in PSTATE
    // msr daifclr, #2

	// Setup stack, jump to kmain in c-world
	ldr x30, =stack_top
	mov sp, x30
	bl kmain
	b .

interrupt:
	mrs	x1, esr_el1		// read the syndrome register
	lsr	x24, x1, #26	// exception class

	cmp x24, #0x15 		// Compare to exception class SVC64
	b.eq interrupt_svc

interrupt_unknown:
	bl kinterruptunknown
	eret

interrupt_svc:
	bl kinterruptsvc
	eret

/*.balign 128*/
.balign 32
exception_vector_table:
	/* Current EL with SP0 */
	b . /* Synchronous */
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .  /* IRQ/vIRQ */
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .  /* FIQ/vFIQ */
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b . /* SError/vSError */
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .

	/* Current EL with SPn */
	b interrupt /* Synchronous */
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .  /* IRQ/vIRQ */
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .  /* FIQ/vFIQ */
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b . /* SError/vSError */
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .

	/* Lower EL with Aarch64 */
	b . /* Synchronous */
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .  /* IRQ/vIRQ */
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .  /* FIQ/vFIQ */
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b . /* SError/vSError */
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .

	/* Lower EL with Aarch32 */
	b . /* Synchronous */
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .  /* IRQ/vIRQ */
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .  /* FIQ/vFIQ */
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b . /* SError/vSError */
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .
	b .

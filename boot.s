.global _RESET
_RESET:
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
	bl exceptionHandlerSynch
	b .

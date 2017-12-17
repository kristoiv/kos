.global _RESET
_RESET:
	ldr x30, =stack_top
	mov sp, x30
	bl kmain
	b .

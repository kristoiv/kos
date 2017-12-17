ENTRY(_RESET)
SECTIONS
{
	. = 0x40000000;
	.startup . : { boot.o(.text) }
	.text : { *(.text) }
	.data : { *(.data) }
	.bss : { *(.bss COMMON) }
	. = ALIGN(16);
	. = . + 0x100000;
	stack_top = .;
}

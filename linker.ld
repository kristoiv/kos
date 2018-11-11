/*
	Exciting examples: https://stackoverflow.com/questions/44991264/armv8-exception-vectors-and-handling

	Memory mapping of "virt" machine type in qemu
	(src: https://git.qemu.org/?p=qemu.git;a=blob;f=hw/arm/virt.c;h=1b1cc716add0d85a004bc71cc4ad4f077816a5a3;hb=HEAD#l112)

	100  Addresses and sizes of our components.
	101  * 0..128MB is space for a flash device so we can run bootrom code such as UEFI.
	102  * 128MB..256MB is used for miscellaneous device I/O.
	103  * 256MB..1GB is reserved for possible future PCI support (ie where the
	104  * PCI memory window will go if we add a PCI host controller).
	105  * 1GB and up is RAM (which may happily spill over into the
	106  * high memory region beyond 4GB).
	107  * This represents a compromise between how much RAM can be given to
	108  * a 32 bit VM and leaving space for expansion and in particular for PCI.
	109  * Note that devices should generally be placed at multiples of 0x10000,
	110  * to accommodate guests using 64K pages.
	111
	112 static const MemMapEntry a15memmap[] = {
	113     Space up to 0x8000000 is reserved for a boot ROM
	114     [VIRT_FLASH] =              {          0, 0x08000000 },
	115     [VIRT_CPUPERIPHS] =         { 0x08000000, 0x00020000 },
	116     GIC distributor and CPU interfaces sit inside the CPU peripheral space
	117     [VIRT_GIC_DIST] =           { 0x08000000, 0x00010000 },
	118     [VIRT_GIC_CPU] =            { 0x08010000, 0x00010000 },
	119     [VIRT_GIC_V2M] =            { 0x08020000, 0x00001000 },
	120     [VIRT_UART] =               { 0x09000000, 0x00001000 },
	121     [VIRT_RTC] =                { 0x09010000, 0x00001000 },
	122     [VIRT_FW_CFG] =             { 0x09020000, 0x0000000a },
	123     [VIRT_MMIO] =               { 0x0a000000, 0x00000200 },
	124     ...repeating for a total of NUM_VIRTIO_TRANSPORTS, each of that size
	125     [VIRT_PLATFORM_BUS] =       { 0x0c000000, 0x02000000 },
	126     [VIRT_PCIE_MMIO] =          { 0x10000000, 0x2eff0000 },
	127     [VIRT_PCIE_PIO] =           { 0x3eff0000, 0x00010000 },
	128     [VIRT_PCIE_ECAM] =          { 0x3f000000, 0x01000000 },
	129     [VIRT_MEM] =                { 0x40000000, 30ULL * 1024 * 1024 * 1024 },
	130 };
*/

SECTIONS
{
	. = 0x40000000;
    .text : { *(.text*) }
	.data : { *(.data) }
    .bss : { *(.bss*) }
	. = ALIGN(16);
	. = . + 1000M;
	stack_top = .;
}

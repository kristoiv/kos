
build:
	aarch64-elf-gcc -s -nostdlib -nostartfiles -ffreestanding -std=gnu99 -c *.c *.s
	aarch64-elf-gcc -T linker.ld -o kernel.elf -ffreestanding *.o -nostdlib -lgcc
	aarch64-elf-objcopy -O binary kernel.elf kernel.bin

emu:
	qemu-system-aarch64 -M virt -cpu cortex-a57 -nographic -kernel kernel.elf

clean:
	rm -f *.o *.elf *.bin


TOOLCHAIN=./toolchain/gcc-linaro-7.2.1-2017.11-x86_64_aarch64-elf/bin
GCC=${TOOLCHAIN}/aarch64-elf-gcc
OBJCOPY=${TOOLCHAIN}/aarch64-elf-objcopy

build:
	${GCC} -s -nostdlib -nostartfiles -ffreestanding -std=gnu99 -c *.c *.s
	${GCC} -T linker.ld -o kernel.elf -ffreestanding *.o -nostdlib -lgcc
	${OBJCOPY} -O binary kernel.elf kernel.bin

build_container:
	(docker image ls kos-factory | grep kos-factory) || (docker build -t kos-factory .)
	docker run -it -v `pwd`:/mnt --rm kos-factory:latest make build

emu:
	qemu-system-aarch64 -M virt -cpu cortex-a57 -nographic -kernel kernel.elf

emu_container:
	(docker image ls kos-factory | grep kos-factory) || (docker build -t kos-factory .)
	docker run -it -v `pwd`:/mnt --rm kos-factory:latest make emu

clean:
	rm -f *.o *.elf *.bin

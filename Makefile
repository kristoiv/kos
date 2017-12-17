
TOOLCHAIN=./toolchain/gcc-linaro-7.2.1-2017.11-x86_64_aarch64-elf/bin
GCC=${TOOLCHAIN}/aarch64-elf-gcc
OBJCOPY=${TOOLCHAIN}/aarch64-elf-objcopy
GDB=${TOOLCHAIN}/aarch64-elf-gdb

build:
	(ls ${TOOLCHAIN}) || (tar -xJf ./toolchain/gcc-linaro-7.2.1-2017.11-x86_64_aarch64-elf.tar.xz -C ./toolchain/)
	${GCC} -s -nostdlib -nostartfiles -ffreestanding -std=gnu99 -g -c *.c *.s
	${GCC} -T linker.ld -o kernel.elf -ffreestanding -g *.o -nostdlib -lgcc
	${OBJCOPY} -O binary kernel.elf kernel.bin

build_container:
	(docker image ls kos-factory | grep kos-factory) || (docker build -t kos-factory .)
	docker run -it -v `pwd`:/mnt --rm kos-factory:latest make build

emu:
	qemu-system-aarch64 -M virt -cpu cortex-a57 -nographic -kernel kernel.elf

emu_container:
	(docker image ls kos-factory | grep kos-factory) || (docker build -t kos-factory .)
	docker run -it -v `pwd`:/mnt --rm kos-factory:latest make emu

emud:
	qemu-system-aarch64 -M virt -cpu cortex-a57 -nographic -kernel kernel.elf -s -S

emud_container:
	(docker image ls kos-factory | grep kos-factory) || (docker build -t kos-factory .)
	docker run -it -v `pwd`:/mnt --rm kos-factory:latest make emud

GCC_CONTAINER := $(shell docker ps | grep kos-factory | awk '{print $$1}')
gcc_emud_container:
	(docker ps | grep kos-factory) || exit 1
	docker exec -it $(GCC_CONTAINER) ${GDB} kernel.elf

clean:
	rm -f *.o *.elf *.bin

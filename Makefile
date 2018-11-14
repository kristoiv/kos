
TOOLCHAIN=./toolchain/gcc-linaro-7.2.1-2017.11-x86_64_aarch64-elf/bin
GCC=${TOOLCHAIN}/aarch64-elf-gcc
OBJCOPY=${TOOLCHAIN}/aarch64-elf-objcopy
OBJDUMP=${TOOLCHAIN}/aarch64-elf-objdump
GDB=${TOOLCHAIN}/aarch64-elf-gdb

build:
	@(ls ${TOOLCHAIN}) > /dev/null || (tar -xJf ./toolchain/gcc-linaro-7.2.1-2017.11-x86_64_aarch64-elf.tar.xz -C ./toolchain/)
	@${GCC} -s -nostdlib -nostartfiles -ffreestanding -std=gnu99 -g -c -O0 -fpic -DCOMPILETIME="\"`date`\"" *.c *.S
	@${GCC} -T linker.ld -o kernel.elf -ffreestanding -Wl,--build-id=none -g -O0 -fpic *.o -nostdlib -lgcc
	@${OBJDUMP} -D kernel.elf > kernel.list
	@${OBJCOPY} -O binary kernel.elf kernel.bin

build_container:
	@(docker image ls kos-factory | grep kos-factory) || (docker build -t kos-factory .)
	@docker run -it -v `pwd`:/mnt --rm kos-factory:latest make build

emu:
	@qemu-system-aarch64 -M virt -cpu cortex-a57 -m 4000 -nographic -kernel kernel.elf

emu_container:
	@(docker image ls kos-factory | grep kos-factory) || (docker build -t kos-factory .)
	@docker run -it -v `pwd`:/mnt --rm kos-factory:latest make emu

emud:
	@qemu-system-aarch64 -M virt -cpu cortex-a57 -m 4000 -nographic -kernel kernel.elf -s -S # -d int

emud_container:
	@(docker image ls kos-factory | grep kos-factory) || (docker build -t kos-factory .)
	@docker run -it -v `pwd`:/mnt --rm kos-factory:latest make emud

gdb_emud:
	gdb -tui -ex "target remote :1234" -ex "layout split" kernel.elf

GDB_CONTAINER := $(shell docker ps | grep kos-factory | awk '{print $$1}')
gdb_emud_container:
	@(docker ps | grep kos-factory) || exit 1
	docker exec -it $(GDB_CONTAINER) ${GDB} -tui -ex "target remote :1234" -ex "layout split" kernel.elf

clean:
	rm -f *.o *.elf *.bin *.list

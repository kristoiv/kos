#include "util.h"
#include <stdint.h>

void __attribute__((naked)) exceptionHandlerSynch() {

}

void installExceptionHandlers() {
    uint32_t base = 0;
    asm("mrs %[base], vbar_el1" : [base] "=r" (base));

    *((uint32_t*)base+0x200) = &exceptionHandlerSynch;

    // TODO: Install exception handlers, with debug info on panics
}

void kmain() {
    kprintf("Welcome to kos\n---------------\n");

    installExceptionHandlers();
    // TODO: Paged Memory mapping
    // TODO: Boot core 2, 3, 4?
    // TODO: Boot screen? Direct framebuffer?
    // TODO: Threads?
    // TODO: Monolithic or microkernel?

    kprintf("---------------\nkos exiting\n");
}

#include "util.h"
#include <stdint.h>

extern void enable_exceptions();

void kmain() {
    kprintf("Welcome to kos\n---------------\n");

    // TODO: installExceptionHandlers();
    // TODO: Paged Memory mapping
    // TODO: Boot core 2, 3, 4?
    // TODO: Boot screen? Direct framebuffer?
    // TODO: Threads?
    // TODO: Monolithic or microkernel?

    kprintf("Testing a SVC interrupt: ");
    enable_exceptions();
    asm("svc 0");

    kprintf("---------------\nkos exiting\n");
}

void kinterruptsvc() {
    kprintf("Supervisor interrupt called. Ignoring...\n");
}

void kinterruptunknown() {
    kprintf("Unknown interrupt called. Ignoring...\n");
}

#include "util.h"
#include <stdint.h>

void kmain() {
    kprintf("Welcome to kos (Kristoffer OS), a project to learn a bit of aarch64 low-level details.\n");
    kprintf("Compiled at %s\n", COMPILETIME);
    kprintln("");

    kprintf("Testing a SVC interrupt: ");
    asm("svc 0");

    // TODO: Paged Memory mapping
    // TODO: Boot core 2, 3, 4?
    // TODO: Boot screen? Direct framebuffer?
    // TODO: Threads?
    // TODO: Monolithic or microkernel?

    kpanic("kernel panic: kmain ended.");
}

void kinterruptsvc() {
    kprintf("Supervisor interrupt called. Ignoring...\n");
}

void kinterruptunknown() {
    kprintf("Unknown interrupt called. Ignoring...\n");
}

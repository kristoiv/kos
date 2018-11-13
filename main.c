#include "util.h"
#include <stdint.h>

void kmain() {
    // Print kernel header
    kprintf("Welcome to kos (Kristoffer OS), a project to learn a bit of aarch64 low-level details.\n");
    kprintf("Compiled at %s\n", COMPILETIME);
    kprintln("");

    // Test software interrupt (supervisor interrupt)
    // asm("svc 0");

    // Start timer for preemptive scheduling
    // TODO

    // TODO: Threads?
    // TODO: Paged Memory mapping
    // TODO: Boot core 2, 3, 4?
    // TODO: Boot screen? Direct framebuffer?
    // TODO: Monolithic or microkernel?

    kpanic("kernel panic: kmain ended.");
}

void kInterruptPreemptiveScheduling() {
}

void kInterruptSvc() {
    kprintf("Supervisor interrupt called. Ignoring...\n");
}

void kInterruptUnknown() {
    kpanic("Unknown interrupt called.");
}

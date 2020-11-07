#include "util.h"
#include <stdint.h>

void kmain() {
    // Print kernel header
    kprintf("Welcome to kos (Kristoffer OS), a project to learn a bit of aarch64 low-level details.\n");
    kprintf("Compiled at %s\n", COMPILETIME);
    kprintln("");

    // Test software interrupt (supervisor interrupt)
    // kprintf("Interrupting: ");
    asm("svc 0");
    asm("svc 0");

    // Start timer for preemptive scheduling
    // TODO

    // TODO: Threads?
    // TODO: Paged Memory mapping
    // TODO: Boot core 2, 3, 4?
    // TODO: Boot screen? Direct framebuffer?
    // TODO: Monolithic or microkernel?

    kpanic("kernel panic: kmain ended.");
}

void kInterruptCurrentElSp0() {
    kprintf("kInterruptCurrentElSp0. Ignoring...\n");
}

void kInterruptCurrentElSp0Unhandled() {
    kprintf("kInterruptCurrentElSp0Unhandled. Ignoring...\n");
}

void kInterruptCurrentEl() {
    kprintf("kInterruptCurrentEl. Ignoring...\n");
}

void kInterruptCurrentElUnhandled() {
    kprintf("kInterruptCurrentElUnhandled. Ignoring...\n");
}

void kInterruptLowerEl() {
    kprintf("kInterruptLowerEl. Ignoring...\n");
}

void kInterruptLowerElUnhandled() {
    kprintf("kInterruptLowerElUnhandled. Ignoring...\n");
}

void kInterruptLowerElUnhandledAarch32() {
    kprintf("kInterruptLowerElUnhandledAarch32. Ignoring...\n");
}
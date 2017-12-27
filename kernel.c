#include "util.h"

void kmain() {
    kputs("Welcome to kos\n");
    char buf[50];
    ksprintf(buf, "hello worl%s %d\n", "d", 5);
    kputs(buf);
    kputs("----\nkmain exiting\n");
}

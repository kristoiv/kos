#include "util.h"

void test(int i, ...);

void kmain() {
     kputs("Welcome to kos\n");
     char buf[50];
     ksprintf(buf, "hello worl%s\n", "d");
     kputs(buf);
     kputs("----\nkmain exiting\n");
}

#ifndef __BOARD_VIRT_H
#define __BOARD_VIRT_H

volatile unsigned int * const UART0DR = (unsigned int *) 0x09000000;

void kputc(const char c) {
    *UART0DR = (unsigned int)(c);
}

#endif

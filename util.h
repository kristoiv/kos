#ifndef __UTIL_H
#define __UTIL_H

#include <stdarg.h>

#ifdef BOARD_QCOM410C
    #include "boards/qcom410c/board.h"
#else
    #include "boards/virt/board.h"
#endif

void kputs(const char *buf) {
    while(*buf != '\0') {
        kputc(*buf);
        buf++;
    }
}

char *itoh(int i, char *buf) {
	int	n;
	int	b;
	int	z;
	int	s;

	const char 	*itoh_map = "0123456789ABCDEF";

	if (sizeof(void*) == 4) s = 8;
	if (sizeof(void*) == 8) s = 16;

	for (z = 0, n = 8; n > -1; --n) {
		b = (i >> (n * 4)) & 0xf;
		buf[z] = itoh_map[b];
		++z;
	}
	buf[z] = 0;
	return buf;
}

void ksprintf(char *buf, const char *format, ...) {
    kputc('A');
    // __builtin_va_list argp;
    // __builtin_va_start(argp, format);
    // __builtin_va_end(argp);
    kputc('B');
    /*
    int 					i;
    const char 				*p;
    char 					*s;
    int						x, y;
    char 					fmtbuf[256];

    __builtin_va_list		argp;
    __builtin_va_start(argp, format);

    x = 0;
    kputc('B');

    for (p = format; *p != '\0'; p++) {
        kputc(*p);
        if (*p == '\\') {
            switch (*++p) {
            case 'n':
                buf[x++] = '\n';
                break;
            case 'r':
                buf[x++] = '\r';
                break;
            default:
                break;
            }
            continue;
        }

        if(*p != '%') {
            buf[x++] = *p;
            continue;
        }

        switch(*++p) {
        case 'c':
            i = __builtin_va_arg(argp, int);
            buf[x++] = i;
            break;
        case 's':
            s = __builtin_va_arg(argp, char *);
            for (y = 0; s[y]; ++y) {
                buf[x++] = s[y];
            }
            break;
        case 'x':
            i = __builtin_va_arg(argp, int);
            s = itoh(i, fmtbuf);
            for (y = 0; s[y]; ++y) {
                buf[x++] = s[y];
            }
            break;
        case '%':
            buf[x++] = '%';
            break;
        }
    }

    __builtin_va_end(argp);
    buf[x] = 0;
    */
}

#endif

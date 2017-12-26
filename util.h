#ifndef __UTIL_H
#define __UTIL_H

#include <stdbool.h>
#include <stdarg.h>

#define NULL 0

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

void reverse(char str[], int length) {
    int start = 0;
    int end = length -1;
    char temp;
    while (start < end) {
        temp = *(str+start);
        *(str+start) = *(str+end);
        *(str+end) = temp;
        //swap(*(str+start), *(str+end));
        start++;
        end--;
    }
}

char *itoa(int num, char *str, int base) {
    int i = 0;
    bool isNegative = false;

    /* Handle 0 explicitely, otherwise empty string is printed for 0 */
    if (num == 0) {
        str[i++] = '0';
        str[i] = '\0';
        return str;
    }

    // In standard itoa(), negative numbers are handled only with
    // base 10. Otherwise numbers are considered unsigned.
    if (num < 0 && base == 10) {
        isNegative = true;
        num = -num;
    }

    // Process individual digits
    while (num != 0) {
        int rem = num % base;
        str[i++] = (rem > 9)? (rem-10) + 'a' : rem + '0';
        num = num/base;
    }

    // If number is negative, append '-'
    if (isNegative) str[i++] = '-';

    str[i] = '\0'; // Append string terminator

    // Reverse the string
    reverse(str, i);

    return str;
}

void _kprintf(char *buf, const char *format, va_list *argp) {
    int 					i;
    const char 				*p;
    char 					*s;
    int						x, y;
    char 					fmtbuf[256];

    x = 0;

    for (p = format; *p != '\0'; p++) {
        if (*p == '\\') {
            switch (*++p) {
            case 'n':
                if (buf == NULL) {
                    kputc('\n');
                }else{
                    buf[x++] = '\n';
                }
                break;
            case 'r':
                if (buf == NULL) {
                    kputc('\r');
                }else{
                    buf[x++] = '\r';
                }
                break;
            default:
                break;
            }
            continue;
        }

        if(*p != '%') {
            if (buf == NULL) {
                kputc(*p);
            }else{
                buf[x++] = *p;
            }
            continue;
        }

        switch(*++p) {
        case 'c':
            i = __builtin_va_arg(*argp, int);
            if (buf == NULL) {
                kputc(i);
            }else{
                buf[x++] = i;
            }
            break;
        case 's':
            s = __builtin_va_arg(*argp, char *);
            for (y = 0; s[y]; ++y) {
                if (buf == NULL) {
                    kputc(s[y]);
                }else{
                    buf[x++] = s[y];
                }
            }
            break;
        case 'x':
            i = __builtin_va_arg(*argp, int);
            s = itoh(i, fmtbuf);
            for (y = 0; s[y]; ++y) {
                if (buf == NULL) {
                    kputc(s[y]);
                }else{
                    buf[x++] = s[y];
                }
            }
            break;
        case 'd':
            i = __builtin_va_arg(*argp, int);
            char temp[33]; // sizeof(int)*8 + 1 - Should be 33 bytes for 32bit int ref.: http://www.cplusplus.com/reference/cstdlib/itoa/
            itoa(i, temp, 10);
            s = temp;
            while (*s != '\0') {
                if (buf == NULL) {
                    kputc(*s);
                }else{
                    buf[x++] = *s;
                }
                s++;
            }
            break;
        case '%':
            if (buf == NULL) {
                kputc('%');
            }else{
                buf[x++] = '%';
            }
            break;
        }
    }

    if (buf != NULL) {
        buf[x] = 0;
    }
}

void kprintf(const char *format, ...) {
    __builtin_va_list argp;
    __builtin_va_start(argp, format);
    _kprintf(NULL, format, &argp);
    __builtin_va_end(argp);
}

void ksprintf(char *buf, const char *format, ...) {
    __builtin_va_list argp;
    __builtin_va_start(argp, format);
    _kprintf(buf, format, &argp);
    __builtin_va_end(argp);
}

#endif

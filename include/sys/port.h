#ifndef PORT_H_
#define PORT_H_
#include <sys/defs.h>

static inline void outb(uint16_t port, unsigned char val)
{
    __asm__ volatile ( "outb %0, %1" : : "a"(val), "d"(port) );
}

static inline void io_wait(void)
{
    __asm__ volatile ( "jmp 1f\n\t"
                   "1:jmp 2f\n\t"
                   "2:" );
}

static inline uint16_t inb(uint16_t port)
{
	unsigned char ret;
    __asm__ volatile ( "inb %1, %0" : "=a"(ret) : "d"(port) );
    return ret;
}

#endif 

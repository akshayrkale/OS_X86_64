#ifndef _GDT_H
#define _GDT_H

#include <sys/defs.h>

struct tss_t {
	uint32_t reserved;
	uint64_t rsp0;
	uint32_t unused[11];
}__attribute__((packed));
extern struct tss_t tss;

extern uint64_t gdt[];

void reload_gdt();
void setup_tss();

#define K_CS 0x08 
#define K_DS 0x10
#define U_CS 0x18 
#define U_DS 0x20

#define RPL0          0  /*** descriptor privilege level 0 ***/
#define RPL1          1 /*** descriptor privilege level 1 ***/
#define RPL2          2  /*** descriptor privilege level 2 ***/
#define RPL3          0  /*** descriptor privilege level 3 ***/

#endif



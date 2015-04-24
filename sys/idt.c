#include <sys/defs.h>
#include <stdlib.h>
#include <sys/sbunix.h>
#include <sys/isr.h>

#define INTERRUPT 0x0e /*** type of entry: Interrupt***/
#define TRAP_GATE 0x0f /*** type of entry:Trap ***/

struct idt_t {

    uint16_t offset_0_15;
    uint16_t selector;
    unsigned ist : 3 ;
    unsigned reserved0 : 5;
    unsigned type : 4;
    unsigned zero : 1;
    unsigned dpl : 2;
    unsigned p : 1;
    uint16_t offset_16_31;
    uint32_t offset_63_32;
    uint32_t reserved1;

} __attribute__((packed));


typedef struct idt_t idt_t;

/*
 * The structure of the idtr pointer
 * To be loaded.
 */
struct idtr_t {

		uint16_t size;
        uint64_t addr;
}__attribute__((packed));


typedef struct idtr_t idtr_t;

idt_t idt_entries[256];
idtr_t   idt_ptr;

void idt_set_gate(uint16_t num, uint64_t isrAddr, uint16_t selector,uint16_t dpl,uint16_t type, uint16_t ist){

	idt_entries[num].ist = ist;
	idt_entries[num].dpl = dpl;
	idt_entries[num].selector = selector;
	idt_entries[num].type = type;
	idt_entries[num].reserved0=0;
	idt_entries[num].reserved1=0;
	idt_entries[num].p = 1;
	idt_entries[num].zero=0;

	idt_entries[num].offset_0_15 = (isrAddr) & 0x0000ffff;
	idt_entries[num].offset_16_31 = (isrAddr >> 16) & 0x0000ffff;
	idt_entries[num].offset_63_32 = (isrAddr >> 32) & 0xffffffff;


}


static inline void cpu_lidt(void* idt) {

        __asm__(
                        
                        "lidt (%0)"
                :       /* no output */
                :       "r" (idt)
        );
}


void init_idt()
{
	//initialize the idt_ptr
   idt_ptr.size = (uint16_t)sizeof(idt_entries);
   idt_ptr.addr  = (uint64_t)&idt_entries[0];

   //clear all the idt entries to zero
   //memset(&idt_entries, 0, sizeof(idt_entries)*256);

   //set the idt gates with address of isr functions
   idt_set_gate( 32, (uint64_t)&isr32 , 8,0,INTERRUPT,0);
   idt_set_gate( 33, (uint64_t)&isr33 , 8,0,INTERRUPT,0);
   idt_set_gate( 14, (uint64_t)&isr14 , 8,0,INTERRUPT,0);
   idt_set_gate( 0, (uint64_t)&isr0 , 8,0,INTERRUPT,0);
   idt_set_gate( 11, (uint64_t)&isr11 , 8,0,INTERRUPT,0);
   idt_set_gate( 13, (uint64_t)&isr13 , 8,0,INTERRUPT,0);
   idt_set_gate( 8, (uint64_t)&isr8 , 8,0,INTERRUPT,0);
   idt_set_gate( 12, (uint64_t)&isr12 , 8,0,INTERRUPT,0);
   idt_set_gate( 17, (uint64_t)&isr17 , 8,0,INTERRUPT,0);
   idt_set_gate( 4, (uint64_t)&isr4 , 8,0,INTERRUPT,0);
   idt_set_gate( 6, (uint64_t)&isr6 , 8,0,INTERRUPT,0);
   idt_set_gate( 5, (uint64_t)&isr5 , 8,0,INTERRUPT,0);
idt_set_gate( 128, (uint64_t)&isr128 , 8,3,TRAP_GATE,0); //Entry for syscalls. DPL should be 3 to enable entry from ser mode

   cpu_lidt(&idt_ptr);
}



#include <sys/sbunix.h>
#include<sys/defs.h>
#include<sys/pic.h>
#include<sys/timer.h>
#include<sys/keyboard.h>
#include<sys/isr.h>
#include<sys/paging.h>
/* adapted from Chris Stones, shovelos */
#define INTERRUPT(vector) \
__asm__(".global isr" #vector "\n"\
                        "isr" #vector ":\n" \
                        "    pushq %rax;" \
                        "    pushq %rcx;" \
                        "    pushq %rdx;" \
                        "    pushq %rsi;" \
                        "    pushq %rdi;" \
                        "    pushq %r8;" \
                        "    pushq %r9;" \
                        "    pushq %r10;" \
                        "    pushq %r11;" \
                        "    movq  %rsp,%rdi;" \
                        "    addq  $72, %rdi;"  \
                        "    call isr" #vector "_handler;" \
                        "    popq %r11;" \
                        "    popq %r10;" \
                        "    popq %r9;" \
                        "    popq %r8;" \
                        "    popq %rdi;" \
                        "    popq %rsi;" \
                        "    popq %rdx;" \
                        "    popq %rcx;" \
                        "    popq %rax;" \
                        "    iretq;    ");




 uint64_t CPU_READ_REG64() {
		
			uint64_t ret = 0; 
__asm __volatile("movq %%cr2,%0"  : "=r" (ret));

			return ((uint64_t)ret); 
		
}

INTERRUPT(32);   // divide by zero
INTERRUPT(33);
INTERRUPT(14);

void isr32_handler(){
static unsigned long int ticks=0;
volatile char *video = (volatile char*)VIDEO_START+2*(24*80+73);
*(video+2) = 's';
*(video+3) = 0x1F;
*(video+4) = 'e';
*(video+5) = 0x1F;
*(video+6) = 'c';
*(video+7) = 0x1F;

print_time(ticks++/1000,video);
PIC_sendEOI(0);
}


   
void isr33_handler(){
 keyboard_read();
 PIC_sendEOI(0);
}






void isr14_handler(struct isr_pf_stack_frame *stack) {

        uint64_t vaddr = CPU_READ_REG64();
        uint64_t   pde = PADDR(vaddr);
	pde=pde;
//      uint64_t stale_tlb = 1;

        /*
        if(stack->error.error.p && !(pde & PT_PRESENT_FLAG))
                stale_tlb = 0; // real page fault on present status.

        if(stack->error.error.wr && !(pde & PT_WRITABLE_FLAG))
                stale_tlb = 0; // real page fault on writable status.

        if(stack->error.error.us && !(pde & PT_USER_FLAG))
                stale_tlb = 0; // real page fault on user permission.

        if(stale_tlb) {

                cpu_invlpg((uint64_t*)vaddr);
        }
        else {
        */
                /*printf("PAGE FAULT!\n");
                printf("          pde  : 0x%lx\n", pde);
                printf("     v-address : 0x%lx\n", vaddr);
                printf("             p : %d\n", stack->error.error.p);
                printf("            id : %d\n", stack->error.error.id);
                printf("            wr : %d\n", stack->error.error.wr);
                printf("            us : %d\n", stack->error.error.us);
                printf("          rsvd : %d\n", stack->error.error.rsvd);
                printf("            CS : 0x%x\n", stack->cs);
                printf("           RIP : 0x%lx\n",stack->rip);
*/
                //HALT("");
//      }
}




#include <sys/sbunix.h>
#include<sys/defs.h>
#include<sys/pic.h>
#include<sys/timer.h>
#include<sys/keyboard.h>
#include<sys/isr.h>
#include<sys/paging.h>
#include<sys/process.h>



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






INTERRUPT(32);   // divide by zero
INTERRUPT(33);
INTERRUPT(14);
INTERRUPT(11);
INTERRUPT(13);
INTERRUPT(0);
INTERRUPT(8);
INTERRUPT(12);
INTERRUPT(17);
INTERRUPT(4);
INTERRUPT(5);
INTERRUPT(6);
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
void isr11_handler(){
printf("inside segment not present\n");
while(1);
}
void isr13_handler(){
 printf("inside GPL Fault \n");
while(1);
}
void isr0_handler(){
printf("inside Devide By Zero\n");
while(1);
}
void isr8_handler(){
printf("inside Double Fault\n");
while(1);
}
void isr12_handler(){
printf("inside Stack Segment fault\n");
while(1);
}
void isr17_handler(){
printf("inside Alignment check\n");
while(1);
}
void isr4_handler(){
printf("inside Overflow\n");
while(1);
}
void isr5_handler(){
printf("inside Bound Range Exceeded\n");
while(1);
}
void isr6_handler(){
printf("inside Invalid Opcode\n");
while(1);
}
uint64_t read_cr2_register(){

        uint64_t faultAddr;

        __asm__("movq %%cr2, %0;" : "=r"(faultAddr));

        return faultAddr;
}


void isr14_handler(struct faultStruct *faultFrame) {

        uint64_t vaddr = read_cr2_register();
        //uint64_t   pde = PADDR(vaddr);
        //pde=pde;

        printf("Kernel mode Page Fault");

        printf("Address of faultFrame %p",faultFrame);

        printf(" \n Error occured at %p ", faultFrame->rip);

        printf(" \n Faulting virtual address is %p", vaddr);

        while(1);
}








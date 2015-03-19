#include <sys/sbunix.h>
#include<sys/defs.h>
#include<sys/pic.h>
#include<sys/timer.h>
#include<sys/keyboard.h>

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

void isr32_handler(){
static unsigned long int ticks=0;
volatile char *video = (volatile char*)0xB8000+2*(24*80+73);
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


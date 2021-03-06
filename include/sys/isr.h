/*
    * isr.h
     *
      *  Created on: Feb 28, 2015
       *      Author: santosh
        */

#ifndef ISR_H_
#define ISR_H_

#include<sys/idt.h>

void isr0();
void isr1();
void isr2();
void isr32();
void isr33();
void isr14();
void isr11();
void isr13();
void isr8();
void isr12();
void isr17();
void isr4();
void isr6();
void isr5();
void isr128();

#define ER_P 0x1
#define ER_W 0x2   
#define ER_U 0x4
struct faultStruct {

    uint64_t errorCode;
    uint64_t rip;
    uint64_t cs;
    uint64_t rflags;
    uint64_t rsp;
    uint64_t ss;


};
typedef struct faultStruct faultFrame;

void syscall_dispatcher(struct Trapframe*);

#endif /* ISR_H_ */

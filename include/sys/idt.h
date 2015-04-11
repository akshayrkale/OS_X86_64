/*
 * idt.h
 *
 *  Created on: Feb 28, 2015
 *      Author: santosh
 */

#ifndef IDT_H_
#define IDT_H_

void init_idt();
void idt_set_get(uint16_t num, uint64_t isrAddr, uint16_t selector,uint16_t dpl,uint16_t type, uint16_t ist);
struct GpRegs {
	/* registers as pushed by pusha */
    uint64_t reg_r15;
    uint64_t reg_r14;
    uint64_t reg_r13;
    uint64_t reg_r12;
    uint64_t reg_r11;
    uint64_t reg_r10;
    uint64_t reg_r9;
    uint64_t reg_r8;
	uint64_t reg_rsi;
	uint64_t reg_rdi;
	uint64_t reg_rbp;
	uint64_t reg_rdx;
	uint64_t reg_rcx;
	uint64_t reg_rbx;
	uint64_t reg_rax;
} __attribute__((packed));

struct Trapframe {
	struct GpRegs tf_regs;
	uint16_t tf_es;
	uint16_t tf_padding1;
    uint32_t tf_padding2;
	uint16_t tf_ds;
	uint16_t tf_padding3;
    uint32_t tf_padding4;
	uint64_t tf_trapno;
	/* below here defined by x86 hardware */
	uint64_t tf_err;
	uintptr_t tf_rip;
	uint16_t tf_cs;
	uint16_t tf_padding5;
    uint32_t tf_padding6;
	uint64_t tf_eflags;
	/* below here only when crossing rings, such as from user to kernel */
	uintptr_t tf_rsp;
	uint16_t tf_ss;
	uint16_t tf_padding7;
    uint32_t tf_padding8;
} __attribute__((packed));


#endif /* IDT_H_ */

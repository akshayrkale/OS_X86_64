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

#endif /* IDT_H_ */

/*
 * isr.h
 *
 *  Created on: Feb 28, 2015
 *      Author: santosh
 */

#ifndef ISR_H_
#define ISR_H_

void isr0();
void isr1();
void isr2();
void isr32();
void isr33();
void isr14();

struct isr_pf_stack_frame
{
        union {

                uint64_t reserved;
                struct {
                        unsigned p              : 1;
                        unsigned wr     : 1;
                        unsigned us     : 1;
                        unsigned rsvd   : 1;
                        unsigned id     : 1;
                }error;
        }error;
        uint64_t rip;
        uint64_t cs;
        uint64_t rflags;
        uint64_t rsp;
        uint64_t ss;
};

#endif /* ISR_H_ */

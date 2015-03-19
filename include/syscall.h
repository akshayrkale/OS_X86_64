#ifndef _SYSCALL_H
#define _SYSCALL_H

#include <sys/defs.h>
#include <sys/syscall.h>

static __inline uint64_t syscall_0(uint64_t n) {

	uint64_t ret;

	__asm__("movq %1,%%rax;"
			"syscall;"
			"movq %%rax,%0;"
			:"=r"(ret):"m"(n));

	return ret;
}

static __inline int64_t syscall_1(uint64_t n, uint64_t a1) {

	int64_t ret;

	if(n==SYS_exit){
		__asm__("movq %0,%%rax;"
				"movq %1,%%rdi;"
				"syscall;"
				::"m"(n),"m"(a1));
	}
	else{

		__asm__("movq %1,%%rax;"
				"movq %2,%%rdi;"
				"syscall;"
				"movq %%rax,%0;"
				:"=r"(ret):"m"(n),"m"(a1));
	}
	return ret;
}

static __inline uint64_t syscall_2(uint64_t n, uint64_t a1, uint64_t a2) {

	uint64_t ret;
	__asm__("movq %1,%%rax;"
			"movq %2,%%rdi;"
			"movq %3,%%rsi;"
			"syscall;"
			"movq %%rax,%0;"
			:"=r"(ret):"m"(n),"m"(a1),"m"(a2));
	return ret;
}

static __inline uint64_t syscall_3(uint64_t n, uint64_t a1, uint64_t a2, uint64_t a3) {

	uint64_t ret;
	__asm__("movq %1,%%rax;"
			"movq %2,%%rdi;"
			"movq %3, %%rsi;"
			"movq %4, %%rdx;"
			"syscall;"
			"movq %%rax,%0;"
			:"=r"(ret):"m"(n),"m"(a1),"m"(a2),"m"(a3));
	return ret;
}

#endif

/*
 * paging.h
 *
 *  Created on: Mar 19, 2015
 *      Author: santosh
 */

#ifndef PAGING_H_
#define PAGING_H_

#include <sys/defs.h>
#define PGSIZE 4096
#define KERNBASE    0xffffffff80000000

#define PHYSBASE    0xffffffff80200000
#define PHYSFREE    0xffffffff8029f000
#define AVAIL1_BASE 0x0
#define AVAIL1_LIM  0xffffffff8009fc00
#define AVAIL2_BASE 0xffffffff80100000
#define AVAIL2_LIM  0xffffffff87ffd000 //check this value o sbrocks

#define VIDEO_START 0xffffffff800B8000 


typedef struct PageStruct {
	// Next page on the free list.
        struct PageStruct *next;

	// pp_ref is the count of pointers (usually in page table entries)
	// to this page, for pages allocated using page_alloc.
	// Pages allocated at boot time using pmap.c's
	// boot_alloc do not have valid reference count fields.

	uint16_t ref_count;
}PageStruct;


static __inline void
lcr3(uint64_t val)
{
	__asm __volatile("movq %0,%%cr3" : : "r" (val));
}

void my_memset(uint64_t* start, int x, size_t size);
#define PADDR(addr) \
({\
if((uint64_t)addr < KERNBASE)\
{\
printf("Invalid Kernel Virtual address:%p",addr);\
while(1);\
}\
(uint64_t)addr - KERNBASE; \
})

#define KADDR(addr) \
({\
 \
(uint64_t)addr + KERNBASE; \
})


#define ROUNDDOWN(a, n)						\
({								\
	uint64_t __a = (uint64_t) (a);				\
	 (__a - __a % (n));				\
})

// Round up to the nearest multiple of n
#define ROUNDUP(a, n)						\
({								\
	uint64_t __n = (uint64_t) (n);				\
	 (ROUNDDOWN((uint64_t) (a) + __n - 1, __n));	\
})


uint16_t  map_vm_pm(pml4e_t* boot_pml4e, uint64_t va,uint64_t pa,uint64_t size, uint16_t flags);
void initialize_page_lists();
void initialize_vm_64();
struct PageStruct* allocate_page();
struct PageStruct *physicalAddressToPage(uint64_t *addr);
uint64_t* pageToPhysicalAddress(struct PageStruct* page);
PageStruct * physicalAddressToPage(uint64_t *addr);

#endif /* PAGING_H_ */

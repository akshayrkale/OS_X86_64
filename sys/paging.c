#include <stdio.h>
#include <sys/paging.h>
#include <sys/defs.h>
#include <sys/mmu.h>
#include <sys/process.h>
#include<sys/tarfs.h>
#include<sys/utils.h>
#include<sys/defs.h>

struct PageStruct *pages;
//boot_alloc function to create the initial space for pages array and page_free_list and PMLE4
static char* nextfree;

static struct PageStruct *page_free_list;	// Free list of physical pages. page_free_list is the head of the free list

int Allocations;
//static int end_bss;

extern int deleteme;
static void *
boot_alloc(uint32_t n){

		// virtual address of next byte of free memory
	char *result;
	//printf("endbss is:%p",&end_bss);
	if (!nextfree) {
			nextfree = (char*)ROUNDUP((uint64_t)PHYSFREE, PGSIZE);//(char*)ROUNDUP((uint64_t)&end_bss, PGSIZE);
	}

	if((nextfree + n) > ((char*)(npages*PGSIZE + KERNBASE))) {

		printf("Out of memory");

	}
	result = nextfree;

	//nextfree will always point to the next virtual adress that is free for allocation
	nextfree = (char*)ROUNDUP(nextfree + n, PGSIZE);
	return result;
}



void initialize_vm_64(void){
	uint64_t* pml4e;
    pages = boot_alloc(npages*sizeof(struct PageStruct));
    procs = boot_alloc(NPROCS*sizeof(struct ProcStruct)); 
    proc_free_list = procs;

	pml4e = boot_alloc(PGSIZE);
	boot_pml4e = pml4e;
	boot_cr3 = (physaddr_t*)PADDR(pml4e);
	kmemset(boot_pml4e,0,PGSIZE);
         initialize_page_lists();
    PageStruct *last =page_free_list;
    

    uint64_t i=299999999;
//    while(i--);
     map_vm_pm(boot_pml4e, (uint64_t)PHYSBASE,PADDR(PHYSBASE),(uint64_t)(boot_alloc(0)-PHYSBASE),PTE_P|PTE_W);
     map_vm_pm(boot_pml4e, (uint64_t)KERNBASE+PGSIZE,0x1000,0x200000-0x1000,PTE_P|PTE_W);//KERNELSTACK =tss.rsp0
     map_vm_pm(boot_pml4e, (uint64_t)VIDEO_START,PADDR(VIDEO_START),10*0x1000,PTE_P|PTE_W);
     last =page_free_list;
     i=1;
     while((uint64_t)last && i++)
        last=last->next;

     lcr3(boot_cr3);
}

uint16_t  map_vm_pm(pml4e_t* pml4e, uint64_t va,uint64_t pa,uint64_t size, uint16_t perm)
{
    uint64_t* pdpe,*pde,*pte;
//extract the upper 9 bits of VA to get the index into pml4e.
    for(uint64_t i=0; i<size; i+=PGSIZE)
    {
    if((pml4e[PML4(va+i)] & (uint64_t)PTE_P) == 0)
    {
        pdpe = pageToPhysicalAddress(allocate_page());
        
        //printf("ret=%p",pdpe);
        if(physicalAddressToPage(pdpe))
        {
            physicalAddressToPage(pdpe)->ref_count++;
            pml4e[PML4(va+i)] = (((uint64_t) pdpe)  & (~0xFFF))|(perm|PTE_P);

        }
        else
        {
            printf("Failed in PML4E:%x",pdpe);
            return 0;
        }
    }
    pdpe = (uint64_t*) (KADDR(pml4e[PML4(va+i)]) & (~0xFFF));
       // printf("pdpe retu=%p",pdpe);
    if((pdpe[PDPE(va+i)] &  (uint64_t)PTE_P) == 0)
    {
        pde = pageToPhysicalAddress(allocate_page());
        // printf("ret=%p",pde);
    //   printf("pde retu=%p",pde);
        if(pde)
        {
            physicalAddressToPage(pde)->ref_count++; 
            pdpe[PDPE(va+i)] = ( (uint64_t)pde & (~0xFFF))|(perm|PTE_P);
        }
        else
        {
            printf("Failed in PDPE:%x",pde);
            return 0;
        }
     }
    pde = (uint64_t*)(KADDR(pdpe[PDPE(va+i)]) & ~0xFFF);
    if((pde[PDX(va+i)] & (uint64_t)PTE_P) == 0)
    {
        pte = pageToPhysicalAddress(allocate_page());
         // printf("ret=%p",pte);
      if(pte)
        {
            physicalAddressToPage(pte)->ref_count++;
            pde[PDX(va+i)] =((uint64_t)pte  & (~0xFFF))|(perm|PTE_P);
        }
        else
        {
            printf("Failed in PDE:%x",pte);
            return 0;
        }
     }  
    pte = (uint64_t*)(KADDR(pde[PDX(va+i)]) & ~0xFFF);   
    if(deleteme)
    {      }
    pte[PTX(va+i)] = ((pa+i) & (~0xFFF))|(perm|PTE_P);;
    tlb_invalidate(pml4e,(void*)va+i);
   }//for loop end
//   printf("Mapped Region:%p-%p to %p-%p\n",ROUNDDOWN(va,PGSIZE),ROUNDDOWN(va+size,PGSIZE), ROUNDDOWN(pa,PGSIZE),ROUNDDOWN(pa+size,PGSIZE));	
   return 1;
}

void initialize_page_lists(){

			size_t i;
		uint16_t free=0;
		struct PageStruct* last = NULL;
		for (i = 0; i < npages; i++) {
			// Off-limits until proven otherwise.
            free = 0;
			uint64_t page_start = i*PGSIZE;
            uint64_t page_end = (i+1)*PGSIZE-1;

			
			if(page_start >= (uint64_t)PADDR(nextfree))
				free = 1;
			if(page_end < (uint64_t)PADDR(AVAIL1_LIM))
				free =1;
			if(page_start >= (uint64_t)PADDR(AVAIL2_BASE) && page_end < (uint64_t)PADDR(PHYSBASE))
				free =1;
		
        pages[i].ref_count=0;
		pages[i].next = NULL;

		if (free) {
			if (last !=NULL)
				last->next = &pages[i];
			else
				page_free_list = &pages[i];
			last = &pages[i];
		}
        }
}

void
tlb_invalidate(pml4e_t *pml4e, void *va)
{
       invlpg(va);
}


uint64_t* pageToPhysicalAddress(PageStruct* page){

	//This function gives us the mapping of a page to its corresponding physical address

	//pages is the base address of the array of all pages in the sysytem

	return(uint64_t*) ((page - pages) << PGSHIFT );


}

PageStruct * physicalAddressToPage(uint64_t *addr){

	//This function returrns the PageStruct correesponding to a given page

	return &pages[((uint64_t)addr >> PTXSHIFT)];

}

PageStruct* allocate_page(){

	/*
	Thus function pulls the first available page from the page free list and returns a 
	virtual addresss corresponding to that free page
	*/
	PageStruct* pageToReturn = page_free_list;

	if(pageToReturn){

//	printf("Allocating page: %p\t", pageToPhysicalAddress(pageToReturn));
        Allocations++;
		page_free_list = page_free_list->next;

		pageToReturn->next = NULL;
		kmemset((uint64_t*)KADDR(pageToPhysicalAddress(pageToReturn)),0,PGSIZE);
	}
	else{
		printf("ERROR!!! No pages to allocate in the free list\n");
    while(1);
    }
	return pageToReturn;
}
int remove_page(uint64_t* pa)
{
PageStruct* pstruct = physicalAddressToPage(pa);
pstruct->ref_count--;

if(pstruct->ref_count <= 0)
{
    pstruct->next=page_free_list;
    page_free_list = pstruct;

}return 0;
}




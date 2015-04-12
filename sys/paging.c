#include <stdio.h>
#include <sys/paging.h>
#include <sys/defs.h>
#include <sys/mmu.h>
#include <sys/process.h>
#include<sys/tarfs.h>
struct PageStruct *pages;
//boot_alloc function to create the initial space for pages array and page_free_list and PMLE4
static char* nextfree;

static struct PageStruct *page_free_list;	// Free list of physical pages. page_free_list is the head of the free list

int Allocations;
//static int end_bss;


static void *
boot_alloc(uint32_t n){

		// virtual address of next byte of free memory
	char *result;
	//printf("endbss is:%p",&end_bss);
	if (!nextfree) {
			printf("PHYSFREE is %p\n",PHYSFREE);
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
	my_memset(boot_pml4e,0,PGSIZE);
         initialize_page_lists();
    PageStruct *last =page_free_list;
    

    uint64_t i=299999999;
//    while(i--);
     map_vm_pm(boot_pml4e, (uint64_t)PHYSBASE,PADDR(PHYSBASE),(uint64_t)(boot_alloc(0)-PHYSBASE),PTE_P|PTE_W);
     map_vm_pm(boot_pml4e, (uint64_t)KERNBASE,0x0,0x20000,PTE_P|PTE_W);
     map_vm_pm(boot_pml4e, (uint64_t)VIDEO_START,PADDR(VIDEO_START),10*0x1000,PTE_P|PTE_W);

     last =page_free_list;
     i=1;
     while((uint64_t)last && i++)
        last=last->next;
     printf("total free pages:%d",i);
     lcr3(boot_cr3);
     printf("CR3 Loaded. Allocation:%d ",Allocations);
}

uint16_t  map_vm_pm(pml4e_t* pml4e, uint64_t va,uint64_t pa,uint64_t size, uint16_t perm)
{
    uint64_t* pdpe,*pde,*pte;
//extract the upper 9 bits of VA to get the index into pml4e.
    for(uint64_t i=0; i<=size; i+=PGSIZE)
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
    pde = (uint64_t*)(KADDR(pdpe[PDPE(va+i)]) & ~0xFFF) ;
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

    pte[PTX(va+i)] = ((pa+i) & (~0xFFF))|(perm|PTE_P);;
   }//for loop end
   printf("Mapped Region:%p-%p to %p-%p\n",ROUNDDOWN(va,PGSIZE),ROUNDDOWN(va+size,PGSIZE), ROUNDDOWN(pa,PGSIZE),ROUNDDOWN(pa+size,PGSIZE));	
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

void my_memcpy(void* dst, void* src , uint64_t size)
{
    char* i=src;
    char* j=dst;
    for(;i<(char*)src+size; )
    {
        *j=*i;
        i++;
        j++;
    }
}



void my_memset(void* start, int x, size_t size){

if(size==0)
	return;
for(char* i=(char*)start;(char*)i<(char*)start+size; i++)
	*i = x;

return;
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
		my_memset((uint64_t*)KADDR(pageToPhysicalAddress(pageToReturn)),0,sizeof(struct PageStruct));
	}
	else{
		printf("ERROR!!! No pages to allocate in the free list\n");
    while(1);
    }
	return pageToReturn;
}

void remove_page(uint64_t* pml4e, uint64_t *va ){

//This function removes the page and adds it to the tail of the page_free_list

//The pagestruct structure to remove
PageStruct *pageToRemove = NULL; 

uint64_t *pdpe =(uint64_t*) pml4e[PML4(va)];


if ( pdpe !=NULL && ((uint64_t)pdpe & PTE_P)){

uint64_t* pde = (uint64_t*)pdpe[PDPE(va)];

if(pde !=NULL && ((uint64_t)pde & PTE_P)){

uint64_t *pte = (uint64_t*)pde[PDX(va)];

if (pte !=NULL && ((uint64_t)pte & PTE_P) ){

pageToRemove = physicalAddressToPage((uint64_t*)*pte);

if(--pageToRemove->ref_count == 0){
//This page is no longer referred to by anyone else.
//Put it in the free list
pageToRemove->next = page_free_list;
page_free_list = pageToRemove;
pml4e[PML4(va)]= pdpe[PDPE(va)]= pde[PDX(va)] = pte[PTX(va)] =0;
}
}
}
}

}

#include <sys/defs.h>
#include <sys/process.h>
#include <sys/paging.h>
#include <sys/mmu.h>
#include <sys/gdt.h>
#include <sys/sbunix.h>
#include <sys/elf.h>
#include <sys/paging.h>

int deleteme=0;
void initialize_process()
{
unsigned char i;
for(i=0;i<=NPROCS;i++)
{
    procs[i].proc_id=0;
    if(i<NPROCS)
        procs[i].next=&procs[i+1];
    else
        procs[i].next=NULL;
}
}


ProcStruct* create_process(uint64_t* binary, enum ProcType type)
{
ProcStruct *NewProc=NULL;

if((NewProc=allocate_process(0)) != NULL)
{    printf("Allcated");    
     if(load_elf(NewProc,binary)==0)
     {
        printf("Loaded");
            NewProc->type =type;
        return NewProc;
     }
}
return NULL;
}


ProcStruct* allocate_process(unsigned char parentid)
{
    ProcStruct* NewProc=NULL; 
    if((NewProc = getnewprocess())==NULL)
        return NULL;
    //printf("New Proc Created");
    if(setupt_proc_vm(NewProc)==0)
        return NULL;
    printf("Proc vm set");
    NewProc->proc_id = (unsigned char)(NewProc-procs); 
    NewProc->parent_id = parentid;
    NewProc->status = RUNNABLE;
    my_memset((void*)&NewProc->tf, 0, sizeof(NewProc->tf));
    NewProc->tf.tf_ds =(uint16_t)(U_DS|RPL3); 
    NewProc->tf.tf_es =(uint16_t)(U_DS|RPL3);
    NewProc->tf.tf_ss = (uint16_t)(U_DS|RPL3);
    NewProc->tf.tf_rsp = USERSTACKTOP;
    NewProc->tf.tf_cs = (uint16_t)(U_CS|RPL3);
    NewProc->tf.tf_eflags = 0x200;//9th bit=IF flag

    proc_free_list = NewProc->next;
    return NewProc;
}

int
setupt_proc_vm(ProcStruct* NewProc)
{
    PageStruct* pa=allocate_page();
    if(!pa)
        return 0;
     NewProc->pml4e=(uint64_t*)KADDR(pageToPhysicalAddress(pa));
    //printf("userpml4=%p",NewProc->pml4e);
    NewProc->cr3 = (physaddr_t*)PADDR(NewProc->pml4e);
    
    /*
    CHANGE THIS LATER. SET extries at indexes less than UTOP to 0
    */
    NewProc->pml4e[PML4(PHYSBASE)]=boot_pml4e[PML4(PHYSBASE)];
    NewProc->pml4e[PML4(VIDEO_START)]=boot_pml4e[PML4(VIDEO_START)];
        
    return 1;
}

int allocate_proc_area(ProcStruct* p, void* va, uint64_t size)
{
    char* start = (char*)ROUNDDOWN((uint64_t)va, PGSIZE);
    char* end = (char*)ROUNDUP((char*)va+size, PGSIZE);
    uint64_t* newpage;
    PageStruct* pa;
    for(char* i=start; i<end; i+=PGSIZE)
    {
        pa = allocate_page();

        if(!pa)
           return -1;
        newpage = pageToPhysicalAddress(pa);
        //printf("Mapping..%p to %p",i,newpage);
        map_vm_pm(p->pml4e, (uint64_t)i,(uint64_t)newpage,PGSIZE,PTE_P | PTE_U | PTE_W);

    }

    return 0;
}

ProcStruct *getnewprocess()
{
    ProcStruct* p =proc_free_list;
    if(proc_free_list)
    proc_free_list=proc_free_list->next;
    
    p->next=proc_running_list;
    proc_running_list=p;

    return p;
}

void
proc_run(struct ProcStruct *proc)
{
   
    if(curproc)
    {
        curproc->status =RUNNABLE;
        proc->status = RUNNING;
    }

        lcr3(proc->cr3);
        tss.rsp0 = KERNBASE+2*PGSIZE;
        ltr((uint16_t)(0x28));
        curproc = proc;
    	env_pop_tf(&(proc->tf));
}


int load_elf(ProcStruct *e,uint64_t* binary)
{
	struct Elf *elf = (struct Elf *)binary;
	struct Proghdr *ph, *eph;
    PageStruct *pa=allocate_page();
    e->mm=(mm_struct*)KADDR(pageToPhysicalAddress(pa));
    my_memset((void *)(e->mm), 0, sizeof(mm_struct));

    if (elf && elf->e_magic == ELF_MAGIC) {
        printf("this is elf");
 		lcr3(e->cr3);       
		ph  = (struct Proghdr *)((unsigned char *)elf + elf->e_phoff);
		eph = ph + elf->e_phnum;
		for(;ph < eph; ph++) {
			if (ph->p_type == ELF_PROG_LOAD) {
		    	allocate_proc_area(e, (void *)ph->p_va, ph->p_memsz);
    	my_memcpy((void *)ph->p_va, (void *)((unsigned char *)elf + ph->p_offset), ph->p_filesz);
    /*    vma_struct* vma;

        vma = allocate_vma(e->mm);
        vma->vm_start = ph->p_va;
        vma->vm_end = vma->vm_start + ph->p_memsz;
        vma->vm_mm=e->mm;
        vma->vm_size = ph->p_memsz;
        vma->vm_next = NULL;
        vma->vm_type=LOAD;
        vma->vm_file = (uint64_t*)elf;
        vma->vm_flags = ph->p_flags;
        vma->vm_offset = ph->p_offset;  */

			if (ph->p_filesz < ph->p_memsz) {
				my_memset((void *)(ph->p_va + ph->p_filesz), 0, ph->p_memsz-ph->p_filesz);
				}
			}
		}
         /*vma_struct* vma;
         vma = allocate_vma(e->mm);
        uint64_t* pdpe = (uint64_t*)KADDR(e->pml4e[0]);

    uint64_t* pde = (uint64_t*)KADDR(pdpe[0]);
         uint64_t* pte = (uint64_t*)KADDR(pde[0]);
 printf("testing");  printf("At pte2", pte[2]);*/
/*
         vma->vm_mm=e->mm;
         vma->vm_start = USERSTACKTOP-PGSIZE;
         vma->vm_end = USERSTACKTOP+1;
         vma->vm_size = PGSIZE;
         vma->vm_type=STACK ;  
         vma->vm_next = NULL;
         vma->vm_flags = PTE_U|PTE_W;
         vma->vm_offset = ph->p_offset;  
*/
		 allocate_proc_area(e, (void*)(USERSTACKTOP-PGSIZE), 1);
		 e->tf.tf_rip    = elf->e_entry;
		 e->tf.tf_rsp    = USERSTACKTOP;
        
		lcr3(boot_cr3);
	} else {
		return -1;
	}
	// Give environment a stack
    e->elf = binary;
    return 0;
}

struct vma_struct* allocate_vma(mm_struct* mem)
{
    vma_struct* vma;
    printf("vma allocated");  
    if(mem->mmap == 0)
    {
        printf("T2");
      mem->mmap=(vma_struct*)(mem+1); //(vma_struct*)KADDR(pageToPhysicalAddress(pa));
      mem->count++;
      return mem->mmap;
    }
    else
    {
        vma=mem->mmap;
        while(vma->vm_next!=0)
            vma=vma->vm_next;
        mem->count++;
        vma->vm_next=(vma_struct*)((char*)vma+sizeof(vma_struct));
       return (vma_struct*)(vma->vm_next);
    }

}

void env_pop_tf(struct Trapframe *tf1)
{
	__asm__ volatile("movq %0,%%rsp\n"
            "movw %%rsp,%%rsp\n"
			 POPA
			 "movw (%%rsp),%%es\n"
			 "movw 8(%%rsp),%%ds\n"
			 "addq $16,%%rsp\n"
			 "\taddq $16,%%rsp\n" /* skip tf_trapno and tf_errcode */
			 "\tiretq"
			 : : "g" (tf1) : "memory");
}

int scheduler()
{
    ProcStruct *start=curproc;
    if(!start)
        return 0;
    else if(start->next!=NULL)
        start = start->next;
    else
        start = proc_running_list;
        
    while(start->status!=RUNNABLE && start !=curproc)
    {
        if(start->next!=NULL)
            start=start->next;
        else 
            start=proc_running_list;
    }
    if(start->status == RUNNABLE)
    {
        printf("Running process:%d",start->proc_id);
        proc_run(start);
    }
    return 0;
}


int proc_free(ProcStruct *proc)
{

    uint64_t* pml4e=proc->pml4e,ipml4e;
    
    for(ipml4e = 0; ipml4e<512; ipml4e++)
    {
        if(PML4(PHYSBASE)==ipml4e || PML4(VIDEO_START)==ipml4e)
            continue;
        if(pml4e[ipml4e]&PTE_P)
        {
           uint64_t ipdpe,*pdpe=(uint64_t*)KADDR((pml4e[ipml4e]&~0xFFF));
           if(deleteme)
           printf("pdpe:%p",pdpe);
            for(ipdpe=0; ipdpe<512; ipdpe++)
            {
                if((uint64_t)pdpe[ipdpe]&PTE_P)
                {
                    uint64_t ipde,*pde=(uint64_t*)KADDR((pdpe[ipdpe]&~0xFFF));           
                    for(ipde=0; ipde<512; ipde++)
                    {
                        if((uint64_t)pde[ipde]&PTE_P)
                        {
                           uint64_t ipte,*pte=(uint64_t*)KADDR((pde[ipde]&~0xFFF));
                            for(ipte=0;ipte<512;ipte++)
                            {
                                if((uint64_t)pte[ipte]&PTE_P)
                                {
//printf("in pml4e ipdpe=%d ipml4e=%d ipde=%d ipte=%d entry=%p",ipdpe,ipml4e,ipde,ipte,pte[ipte]);
 //                                   printf("herepteis=%p pte[]=%d",pte,pte[0]);

                                    remove_page((uint64_t*)((uint64_t)pte[ipte]&~0xFFF));
printf("Removed page:%p",((uint64_t)pte[ipte]&~0xFFF));

                                    pte[ipte]=0;

                                }
                            }
                            remove_page((uint64_t*)((uint64_t)pde[ipde]&~0xFFF));
                printf("Removed pte:%p",((uint64_t)pde[ipde]&~0xFFF));
            pde[ipde]=0;

                        }
                   }
                   remove_page((uint64_t*)((uint64_t)pdpe[ipdpe]&~0xFFF));printf("Removed pde:%p",((uint64_t)pdpe[ipdpe]&~0xFFF));

                   pdpe[ipdpe]=0;
                }
            }
            remove_page((uint64_t*)((uint64_t)pml4e[ipml4e]&~0xFFF));
printf("Removed pdpe:%p ",((uint64_t)pml4e[ipml4e]&~0xFFF));

            pml4e[ipml4e]=0;
        }
        if(ipml4e==510)
            deleteme=1;

    }
    remove_page(proc->cr3);
    printf("removed");
     uint64_t i=499999999;
      while(i--);

my_memset((void*)proc,0,sizeof(ProcStruct));
    proc->next=proc_free_list;
    proc_free_list=proc;

    return 0;
}

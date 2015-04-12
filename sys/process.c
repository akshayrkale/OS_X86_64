#include <sys/defs.h>
#include <sys/process.h>
#include <sys/paging.h>
#include <sys/mmu.h>
#include <sys/gdt.h>
#include <sys/sbunix.h>
#include <sys/elf.h>
#include <sys/paging.h>

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
{
     if(load_elf(NewProc,binary)==0)
     {

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
    printf("New Proc Created");
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
    NewProc->tf.tf_rsp = KERNBASE-18*PGSIZE;
    NewProc->tf.tf_cs = (uint16_t)(U_CS|RPL3);
    proc_free_list = NewProc->next;
    return NewProc;
}

int
setupt_proc_vm(ProcStruct* NewProc)
{
    PageStruct* pa=allocate_page();
    printf("allocated");
    if(!pa)
        return 0;
    pa->ref_count++;
    NewProc->pml4e=(uint64_t*)KADDR(pageToPhysicalAddress(pa));
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
        map_vm_pm(p->pml4e, (uint64_t)i,(uint64_t)newpage,PGSIZE,PTE_P | PTE_U | PTE_W);

    }
        printf("size=%p",end);

    return 0;
}

ProcStruct *getnewprocess()
{
    ProcStruct* p =proc_free_list;
    if(proc_free_list)
    proc_free_list=proc_free_list->next;
    return p;
}

void
proc_run(struct ProcStruct *proc)
{
    
	lcr3(proc->cr3);
	env_pop_tf(&(proc->tf));
}



int load_elf(ProcStruct *e,uint64_t* binary)
{
	struct Elf *elf = (struct Elf *)binary;
	struct Proghdr *ph, *eph;
    printf("magic=%x",*binary);

	if (elf && elf->e_magic == ELF_MAGIC) {
        printf("this is elf");
 		lcr3(e->cr3);       
		ph  = (struct Proghdr *)((unsigned char *)elf + elf->e_phoff);
		eph = ph + elf->e_phnum;
		for(;ph < eph; ph++) {
			if (ph->p_type == ELF_PROG_LOAD) {
			allocate_proc_area(e, (void *)ph->p_va, ph->p_memsz);
				uint64_t    i=499999999;
    while(i--);

	my_memcpy((void *)ph->p_va, (void *)((unsigned char *)elf + ph->p_offset), ph->p_filesz);
          printf("start:%p end:%p ",ph->p_va, ph->p_va+ph->p_memsz);

				if (ph->p_filesz < ph->p_memsz) {
					my_memset((void *)(ph->p_va + ph->p_filesz), 0, ph->p_memsz-ph->p_filesz);
				}
			}
		}
		allocate_proc_area(e, (void*)(USER_STACK - PGSIZE), PGSIZE);
		e->tf.tf_rip    = elf->e_entry;
		e->tf.tf_rsp    = USER_STACK;
        
		lcr3(boot_cr3);
	} else {
		return -1;
	}
	// Give environment a stack
    e->elf = binary;
    return 0;
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

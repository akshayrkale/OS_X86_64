#include <sys/defs.h>
#include <sys/process.h>
#include <sys/paging.h>
#include <sys/mmu.h>
#include <sys/gdt.h>
#include <sys/sbunix.h>
#include <sys/elf.h>
#include <sys/paging.h>

uint16_t proccount=0;
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
{    //printf("Allcated");   
// uint64_t i=499999999;
  //          while(i--);

     if(load_elf(NewProc,binary)==0)
     {
       // printf("Loaded");
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
//    printf("Proc vm set");
    NewProc->proc_id = (unsigned char)(NewProc-procs)+1; 
    NewProc->parent_id = parentid;
    my_memset((void*)&NewProc->tf, 0, sizeof(NewProc->tf));
    NewProc->tf.tf_ds =(uint16_t)(U_DS|RPL3); 
    NewProc->tf.tf_es =(uint16_t)(U_DS|RPL3);
    NewProc->tf.tf_ss = (uint16_t)(U_DS|RPL3);
    NewProc->tf.tf_rsp = USERSTACKTOP;
    NewProc->tf.tf_cs = (uint16_t)(U_CS|RPL3);
    NewProc->tf.tf_eflags = 0x200;//9th bit=IF flag
    NewProc->status = RUNNABLE;
    proccount++;
    PageStruct *pa=allocate_page();
    NewProc->mm=(mm_struct*)KADDR(pageToPhysicalAddress(pa));
    my_memset((void *)(NewProc->mm), 0, sizeof(mm_struct));

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
    uint64_t* newpage=0;
    PageStruct* pa;
    for(char* i=start; i<end; i+=PGSIZE)
    {
        pa = allocate_page();

        if(!pa)
           return -1;
        newpage = pageToPhysicalAddress(pa);
        //printf("Mapping..%p to %p",i,newpage);
        map_vm_pm(p->pml4e, (uint64_t)i,(uint64_t)newpage,PGSIZE,PTE_P |PTE_U|PTE_W);

    }
return (uint64_t)newpage;
}

ProcStruct *getnewprocess()
{
    ProcStruct* p =proc_free_list;
    if(proc_free_list)
    {
        proc_free_list=proc_free_list->next;
        p->next=proc_running_list;
        proc_running_list=p;
        return p;
    }
    return NULL;
}

void
proc_run(struct ProcStruct *proc)
{
   
    if(curproc && curproc->status!=FREE)
        curproc->status =RUNNABLE;
         
        proc->status = RUNNING;
        lcr3(proc->cr3);
        tss.rsp0 =(uint64_t) &proc->kstack[511];
        curproc = proc;
    	env_pop_tf(&(proc->tf));
}


int load_elf(ProcStruct *e,uint64_t* binary)
{
	struct Elf *elf = (struct Elf *)binary;
	struct Proghdr *ph, *eph;
    
    if (elf && elf->e_magic == ELF_MAGIC) {
        printf("this is elf");
 		lcr3(e->cr3);       
		ph  = (struct Proghdr *)((unsigned char *)elf + elf->e_phoff);
		eph = ph + elf->e_phnum;
		for(;ph < eph; ph++) {
			if (ph->p_type == ELF_PROG_LOAD) {
		    	//allocate_proc_area(e, (void *)ph->p_va, ph->p_memsz);
    	//my_memcpy((void *)ph->p_va, (void *)((unsigned char *)elf + ph->p_offset), ph->p_filesz);
        vma_struct* vma;
        vma = allocate_vma(e->mm);
        vma->vm_start = ph->p_va;
        vma->vm_end = vma->vm_start + ph->p_memsz;
        vma->vm_mm=e->mm;
        vma->vm_size = ph->p_memsz;
        vma->vm_next = NULL;
        vma->vm_type=LOAD;
        vma->vm_file = (uint64_t*)elf;
        vma->vm_flags = ph->p_flags;
        vma->vm_offset = ph->p_offset;

    	if (ph->p_filesz < ph->p_memsz) {
		vma->vm_filesz=ph->p_filesz;	//my_memset((void *)(ph->p_va + ph->p_filesz), 0, ph->p_memsz-ph->p_filesz);
		}
		}
		}
        vma_struct* vma;
        vma = allocate_vma(e->mm);
/*      uint64_t* pdpe = (uint64_t*)KADDR(e->pml4e[0]);
        uint64_t* pde = (uint64_t*)KADDR(pdpe[0]);
        uint64_t* pte = (uint64_t*)KADDR(pde[0]);*/
         
         vma->vm_mm=e->mm;
         vma->vm_start = USERSTACKTOP-PGSIZE;
         vma->vm_end = USERSTACKTOP+1;
         vma->vm_size = PGSIZE;
         vma->vm_type=STACK; 
         vma->vm_next = NULL;
         vma->vm_flags = PTE_U|PTE_W;
         vma->vm_offset = ph->p_offset;  

		 int p=allocate_proc_area(e, (void*)(USERSTACKTOP-PGSIZE), PGSIZE);
         physicalAddressToPage((uint64_t*)(uint64_t)p)->ref_count++;
printf("stack page:%p-%d ",p,e->proc_id);
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

      mem->mmap=(vma_struct*)(mem+1); //(vma_struct*)KADDR(pageToPhysicalAddress(pa));
      mem->count++;
      printf("T2");     return mem->mmap;
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
    
    if(!start || start->next==NULL)
    {
        start=proc_running_list;
    }
    else 
        start = start->next;
   
        
    while(start->status!=RUNNABLE && proccount>0)
    {
        while(start->next!=NULL && start->next->status == FREE) //if proc_rinning_list->status==free it wont be added to free list immediately
        {
            ProcStruct *newnext = start->next->next;
            start->next = proc_free_list;
            proc_free_list = start->next;
            start->next=newnext;
        }
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
            //         printf("pdpe:%p",pdpe);
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
//printf("Removed page:%p",((uint64_t)pte[ipte]&~0xFFF));

                                    pte[ipte]=0;

                                }
                            }
                            remove_page((uint64_t*)((uint64_t)pde[ipde]&~0xFFF));
//                printf("Removed pte:%p",((uint64_t)pde[ipde]&~0xFFF));
            pde[ipde]=0;

                        }
                   }
                   remove_page((uint64_t*)((uint64_t)pdpe[ipdpe]&~0xFFF));//printf("Removed pde:%p",((uint64_t)pdpe[ipdpe]&~0xFFF));

                   pdpe[ipdpe]=0;
                }
            }
            remove_page((uint64_t*)((uint64_t)pml4e[ipml4e]&~0xFFF));
//printf("Removed pdpe:%p ",((uint64_t)pml4e[ipml4e]&~0xFFF));

            pml4e[ipml4e]=0;
        }
       
    }
    remove_page(proc->cr3);
    printf("Last removal");

   // my_memset((void*)proc,0,sizeof(ProcStruct));
    proc->status = FREE;
    proccount--;
    return 0;
}

uint64_t execvpe(char *arg1,char *arg2[], char* arg3[])
{
/*
        char *tmp_pathname = arg1;
        char **tmp_argument = (char **)arg2;
        char **tmp_env = (char **)arg3;
        int i=0;
        int j=0;
        char pathname[1024];
        //strcpy(pathname,tmp_pathname);
         
        char **temp1=tmp_argument;
        while(i<3){
                    printf("arg%d is %s\n",i,temp1[i]);
                            i++;
        } 
     
        char **temp2=tmp_env;
        while(j<3){
                    printf("env%d is %s\n",j,temp2[j]);
                            j++;
         }
        //print("done");

        struct ProcStruct *proc=create_process(pathname,USER_PROCESS);
        //print("done");
       
       
        proc->proc_id =  curproc->proc_id;
        proc->parent_id = curproc->parent_id;
        exit_process(0);*/
        return 0;
}     
int fork_process(struct Trapframe* tf)
{
    ProcStruct* NewProc=NULL;

    if((NewProc=allocate_process(curproc->proc_id)) != NULL)
    {    
        printf("Allcated child");
       
        NewProc->tf = curproc->tf;       
        copypagetables(NewProc);
        copyvmas(NewProc);
      //lcr3(NewProc->cr3);
  //      allocate_proc_area(NewProc, (void*)(USERSTACKTOP), PGSIZE);
//        my_memcpy((void*)(USERSTACKTOP),(void*)USERSTACKTOP-PGSIZE,PGSIZE); //?
     //   lcr3(curproc->cr3);       //?
        //my_memcpy((void*)NewProc->kstack,(void*) curproc->kstack, PGSIZE);
        //for(int i=511;i>0;i--)
    //        NewProc->kstack[i]=curproc->kstack[i];
   //     NewProc->tf.tf_rsp = USERSTACKTOP+PGSIZE;
        NewProc->tf.tf_regs.reg_rax=0; //?
    }
    return (tf->tf_regs.reg_rax= NewProc->proc_id);
}

int copypagetables(ProcStruct *proc)
{
    uint64_t* pml4e=curproc->pml4e;
    uint64_t* chpml4e=proc->pml4e;
    uint64_t* pdpe,*pde,*pte,*chpdpe,*chpde,*chpte;

//extract the upper 9 bits of VA to get the index into pml4e.
    for(int ipml4e=0; ipml4e<512; ipml4e++)
    {
        if(PML4(PHYSBASE)==ipml4e || PML4(VIDEO_START)==ipml4e)
            continue;

    if((pml4e[ipml4e] & (uint64_t)PTE_P))
    {
        chpdpe = pageToPhysicalAddress(allocate_page());
        chpml4e[ipml4e]= ((uint64_t)chpdpe &(~0xFFF)) | (pml4e[ipml4e]&(0xfff));

        if(chpml4e[ipml4e] & PTE_W)
        {
            chpml4e[ipml4e]=(chpml4e[ipml4e]&~PTE_W)|PTE_COW;
            pml4e[ipml4e]=(pml4e[ipml4e]&~PTE_W)|PTE_COW;
        }

        //printf("ret=%p",pdpe);
    
    pdpe = (uint64_t*) (KADDR(pml4e[ipml4e]) & (~0xFFF));
    chpdpe = (uint64_t*) (KADDR(chpml4e[ipml4e]) & (~0xFFF));
      // printf("pdpe retu=%p",pdpe);

    for(int ipdpe=0; ipdpe<512; ipdpe++)
    {
        if((pdpe[ipdpe] & (uint64_t)PTE_P))
    {
        
        chpde = pageToPhysicalAddress(allocate_page());
        chpdpe[ipdpe]= ((uint64_t)chpde &(~0xFFF)) | (pdpe[ipdpe]&(0xfff));

        if(chpdpe[ipdpe] & PTE_W)
        {
            chpdpe[ipdpe]=(chpdpe[ipdpe]&~PTE_W) | PTE_COW;
            pdpe[ipdpe]=(pdpe[ipdpe]&~PTE_W) | PTE_COW;
        }

        //printf("ret=%p",pdpe);
    
      pde = (uint64_t*) (KADDR(pdpe[ipdpe]) & (~0xFFF));
      chpde = (uint64_t*) (KADDR(chpdpe[ipdpe]) & (~0xFFF));
    for(int ipde=0; ipde<512; ipde++)
    {
        if((pde[ipde] & (uint64_t)PTE_P))
        { 
        
        chpte = pageToPhysicalAddress(allocate_page());
        chpde[ipde]= ((uint64_t)chpte &(~0xFFF)) | (pde[ipde]&(0xfff));

        if(chpde[ipde] & PTE_W)
        {
            chpde[ipde]=(chpde[ipde]&~PTE_W)| PTE_COW;
            pde[ipde]=(pde[ipde]&~PTE_W)| PTE_COW;

        }

        //printf("ret=%p",pdpe);
    
    
    pte = (uint64_t*) (KADDR(pde[ipde]) & (~0xFFF));
    chpte = (uint64_t*) (KADDR(chpde[ipde]) & (~0xFFF));
    for(int ipte=0; ipte<512; ipte++)
    {
    if((pte[ipte] & (uint64_t)PTE_P))
    {
        
       chpte[ipte]= pte[ipte];

        if(chpte[ipte] & PTE_W)
        {
            chpte[ipte]=(chpte[ipte]&~PTE_W)| PTE_COW;
            pte[ipte]=(pte[ipte]&~PTE_W)| PTE_COW;
            physicalAddressToPage((uint64_t*)(pte[ipte]&~0xfff))->ref_count++;
        }
        //printf("ret=%p",pdpe);
    }
    }
   } 
   }
  }  
  } 
 }
 }
return 0;
}


int copyvmas(ProcStruct *proc)
{   
    vma_struct *vma=curproc->mm->mmap;
    vma_struct* newvma=0;
    while(vma)    
    {
        newvma=allocate_vma(proc->mm);
        my_memcpy((void*)newvma,(void*)vma,sizeof(vma_struct));
        newvma->vm_next=NULL;
        vma=vma->vm_next;
    }
    return 0;
}




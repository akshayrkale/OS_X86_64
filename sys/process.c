#include <sys/defs.h>
#include <sys/process.h>
#include <sys/paging.h>
#include <sys/mmu.h>
#include <sys/gdt.h>
#include <sys/sbunix.h>
#include <sys/elf.h>
#include <sys/paging.h>
#include <sys/utils.h>
#include <sys/kstring.h>
#include <sys/tarfs.h>
#include <sys/file_table.h>

uint16_t proccount=0;
extern unsigned long int timeTillNow;

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

int maxcount=0;
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
    kmemset((void*)&NewProc->tf, 0, sizeof(NewProc->tf));
    NewProc->tf.tf_ds =(uint16_t)(U_DS|RPL3); 
    NewProc->tf.tf_es =(uint16_t)(U_DS|RPL3);
    NewProc->tf.tf_ss = (uint16_t)(U_DS|RPL3);
    NewProc->tf.tf_rsp = USERSTACKTOP;
    NewProc->tf.tf_cs = (uint16_t)(U_CS|RPL3);
    NewProc->tf.tf_eflags = 0x200;//9th bit=IF flag
    NewProc->status = RUNNABLE;
    NewProc->waitingfor = -1;
    NewProc->num_child=0;
    ((ProcStruct*)(procs+parentid-1))->num_child++;
    maxcount=proccount++;
    
    PageStruct *pa=allocate_page();
    NewProc->mm=(mm_struct*)KADDR(pageToPhysicalAddress(pa));
    kmemset((void *)(NewProc->mm), 0, sizeof(mm_struct));
    
    //printf("Before copying the fd table to child\n");

    //while(1);

    kstrcpy(NewProc->cwd,"/"); //set the cwd of a new process to root dir.
    if(parentid==0)
    {

      //printf("IN if\n");
      NewProc->fd_table[0] = 0;
      NewProc->fd_table[1] = 1;
      NewProc->fd_table[2] = 2;
      NewProc->fd_table[3] = -1;
      NewProc->fd_table[4] = -1;
      NewProc->fd_table[5] = -1;
      NewProc->fd_table[6] = -1;
      NewProc->fd_table[7] = -1;
      NewProc->fd_table[8] = -1; 
      NewProc->fd_table[9] = -1;
    }
    else{

      //printf("In else\n");
      NewProc->fd_table[0] = curproc->fd_table[0];
      NewProc->fd_table[1] = curproc->fd_table[1];
      NewProc->fd_table[2] = curproc->fd_table[2];

      //while(1);

      for(int i=3;i<10;i++)
      {    
      
    //    printf("Inside while loop\n");

        //while(1);

        NewProc->fd_table[i] = curproc->fd_table[i];
          
          if(NewProc->fd_table[i]!=-1)
          {
              file_table[NewProc->fd_table[i]].ref_count++;
          }
      }
    }

    //while(1);
    //printf("After copying the fd table to child\n");
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
	    pa->ref_count++;
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
   
    if(curproc && curproc->status!=FREE &&curproc->status!=WAITING)
        curproc->status =RUNNABLE;
         
        proc->status = RUNNING;
        lcr3(proc->cr3);
        tss.rsp0 =(uint64_t) &proc->kstack[511];
        curproc = proc;
        printf("\nRUN:%d",curproc->proc_id);
        env_pop_tf(&(proc->tf));
}

uint64_t stackpage=0;
int load_elf(ProcStruct *e,uint64_t* binary)
{
    struct Elf *elf = (struct Elf *)binary;
    struct Proghdr *ph, *eph;
    uint64_t max_addr=0;
    
    if (elf && elf->e_magic == ELF_MAGIC) {
        //printf("this is elf");
        lcr3(e->cr3);       
        ph  = (struct Proghdr *)((unsigned char *)elf + elf->e_phoff);
        eph = ph + elf->e_phnum;
        for(;ph < eph; ph++) {
            if (ph->p_type == ELF_PROG_LOAD) {
                //allocate_proc_area(e, (void *)ph->p_va, ph->p_memsz);
        //kmemcpy((void *)ph->p_va, (void *)((unsigned char *)elf + ph->p_offset), ph->p_filesz);
        vma_struct* vma;
        vma = allocate_vma(e->mm);
        vma->vm_start = ph->p_va;
        vma->vm_end = vma->vm_start + ph->p_memsz;
        if(vma->vm_end>max_addr)
            max_addr=vma->vm_end;
        vma->vm_mm=e->mm;
        vma->vm_size = ph->p_memsz;
        vma->vm_filesz = ph->p_filesz;
        vma->vm_next = NULL;
        vma->vm_type=LOAD;
        vma->vm_file = (uint64_t*)elf;
        vma->vm_flags = ph->p_flags;
        vma->vm_offset = ph->p_offset;

        if (ph->p_filesz < ph->p_memsz) {
        vma->vm_filesz=ph->p_filesz;    //kmemset((void *)(ph->p_va + ph->p_filesz), 0, ph->p_memsz-ph->p_filesz);
        }
        }
        }
        vma_struct* vma;
        vma = allocate_vma(e->mm);
         
         vma->vm_mm=e->mm;
         vma->vm_start = USERSTACKTOP-PGSIZE;
         vma->vm_end = USERSTACKTOP+1;
         vma->vm_size = PGSIZE;
         vma->vm_type=STACK; 
         vma->vm_next = NULL;
         vma->vm_flags = PTE_U|PTE_W;
         vma->vm_offset = ph->p_offset;  
       
         stackpage=allocate_proc_area(e, (void*)(USERSTACKTOP-PGSIZE), PGSIZE);
        // physicalAddressToPage((uint64_t*)(uint64_t)p)->ref_count++;
//printf("stack page:%p-%d ",p,e->proc_id);
         e->tf.tf_rip    = elf->e_entry;
         e->tf.tf_rsp    = USERSTACKTOP;
       
         //Alocate heam vma
         vma = allocate_vma(e->mm);
         vma->vm_mm=e->mm;
         max_addr=((((max_addr - 1) >> 12) + 1) << 12);
         vma->vm_start = max_addr;
         vma->vm_end = max_addr;
         vma->vm_size = PGSIZE;
         vma->vm_type=HEAP; 
         vma->vm_next = NULL;
         vma->vm_flags = PTE_U|PTE_W;
         vma->vm_offset = ph->p_offset;  
	    e->mm->start_brk=e->mm->end_brk=max_addr;
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
//    printf("vma allocated");  
    if(mem->mmap == 0)
    {

      mem->mmap=(vma_struct*)(mem+1); //(vma_struct*)KADDR(pageToPhysicalAddress(pa));
      mem->count++;
      //printf("T2");    
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
    
    if(!start || start->next==NULL)
    {
        start=proc_running_list;
    }
    else 
        start = start->next;
    
    int num_procs=proccount+1;
        
    while((start->status!=RUNNABLE || start->wakeuptime > timeTillNow) && num_procs>0)
    {
        while(start->next!=NULL && start->next->status == FREE) //if proc_rinning_list->status==free it wont be added to free list immediately
        {
            ProcStruct *newnext = start->next->next;
            start->next = proc_free_list;
            proc_free_list = start->next;
            start->next=newnext;
            proccount--;
            num_procs--;
        }
        if(start->next!=NULL)
            start=start->next;
        else 
            start=proc_running_list;

        num_procs--;
    }
    if(start->status == RUNNABLE )
    {
        //printf("Running process:%d",start->proc_id);
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
//printf("Removed page:%p-%d ",((uint64_t)pte[ipte]&~0xFFF),physicalAddressToPage(((uint64_t*)((uint64_t)pte[ipte]&~0xFFF)))->ref_count);

                                    remove_page((uint64_t*)((uint64_t)pte[ipte]&~0xFFF));

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

    proc->mm->mmap=0;
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
        lcr3(NewProc->cr3);
        lcr3(curproc->cr3);
  //      allocate_proc_area(NewProc, (void*)(USERSTACKTOP), PGSIZE);
//        kmemcpy((void*)(USERSTACKTOP),(void*)USERSTACKTOP-PGSIZE,PGSIZE); //?
     //   lcr3(curproc->cr3);       //?
        //kmemcpy((void*)NewProc->kstack,(void*) curproc->kstack, PGSIZE);
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
/*
        if(chpml4e[ipml4e] & PTE_W)
        {
            chpml4e[ipml4e]=(chpml4e[ipml4e]&~PTE_W)|PTE_COW;
            pml4e[ipml4e]=(pml4e[ipml4e]&~PTE_W)|PTE_COW;
        }
*/
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

  /*      if(chpdpe[ipdpe] & PTE_W)
        {
            chpdpe[ipdpe]=(chpdpe[ipdpe]&~PTE_W) | PTE_COW;
            pdpe[ipdpe]=(pdpe[ipdpe]&~PTE_W) | PTE_COW;
        }
*/
        //printf("ret=%p",pdpe);
    
      pde = (uint64_t*) (KADDR(pdpe[ipdpe]) & (~0xFFF));
      chpde = (uint64_t*) (KADDR(chpdpe[ipdpe]) & (~0xFFF));
    for(int ipde=0; ipde<512; ipde++)
    {
        if((pde[ipde] & (uint64_t)PTE_P))
        { 
        
        chpte = pageToPhysicalAddress(allocate_page());
        chpde[ipde]= ((uint64_t)chpte &(~0xFFF)) | (pde[ipde]&(0xfff));

  /*      if(chpde[ipde] & PTE_W)
        {
            chpde[ipde]=(chpde[ipde]&~PTE_W)| PTE_COW;
            pde[ipde]=(pde[ipde]&~PTE_W)| PTE_COW;

        }

    */    //printf("ret=%p",pdpe);
    
    
    pte = (uint64_t*) (KADDR(pde[ipde]) & (~0xFFF));
    chpte = (uint64_t*) (KADDR(chpde[ipde]) & (~0xFFF));
    for(int ipte=0; ipte<512; ipte++)
    {
    if((pte[ipte] & (uint64_t)PTE_P))
    {
        
       chpte[ipte]= pte[ipte];

        if(chpte[ipte] & PTE_W || chpte[ipte] & PTE_COW)
        {
            
            chpte[ipte]=(chpte[ipte]&~PTE_W)| PTE_COW;
            pte[ipte]=(pte[ipte]&~PTE_W)| PTE_COW;
                physicalAddressToPage((uint64_t*)(pte[ipte]&~0xfff))->ref_count++;
            if((chpte[ipte]&~0xfff)== stackpage)
                printf("inc %p %d",pte[ipte],physicalAddressToPage((uint64_t*)(pte[ipte]&~0xfff))->ref_count);
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
        kmemcpy((void*)newvma,(void*)vma,sizeof(vma_struct));
        newvma->vm_next=NULL;
        vma=vma->vm_next;
    }
    return 0;
}
/* OLD
uint64_t inc_brk(uint64_t n)
{
vma_struct* vma=curproc->mm->mmap;
while(vma->vm_type!=HEAP)
{
vma=vma->vm_next;
}

if(vma)
{
    vma->vm_end=vma->vm_end+n;
    curproc->mm->end_brk+=n;
    return vma->vm_end;
}
else
    return -1;
}
*/



uint64_t inc_brk(uint64_t n)
{
vma_struct* vma=curproc->mm->mmap;

//printf("inc_brk\n");
while(vma->vm_type!=HEAP)
{
vma=vma->vm_next;
}

//printf("inc_brk: after loop\n");

if(vma)
{
    //printf("inc_brk:in if\n");
    uint64_t base=vma->vm_end;
    vma->vm_end=vma->vm_end+n;
    curproc->mm->end_brk+=n;
//    printf("incbrk return%d ",vma->vm_end);
    return base;

}


else
    return -1;
}




int get_running_process(){


  //int i;
  int j = proccount;
  
  ProcStruct* temp = proc_running_list;
    
  if(temp==NULL){

    return -1;

  }
      
  printf("\nNumber of running process in the list: %d\n", proccount);
  while(j!=0){

    if(temp->status == RUNNABLE || temp->status == RUNNING){
      printf("Process ID : %d \n", temp->proc_id);
    }         
    
    j--;
    temp = temp->next;

  }
    return 0;
}


int proc_sleep(void* t){
 
  printf("In sleep syscall\n");

  struct K_timespec* x = t;

  curproc->wakeuptime = timeTillNow + x->tv_sec;

  printf("Current Time %d\nProcess%d Wakeup time %d", timeTillNow,curproc->proc_id,curproc->wakeuptime);

  curproc->status = RUNNABLE;

  scheduler();

  return 0;


}


char args[15][60];
uint64_t execve(const char *arg1,const char *arg2[],const  char* arg3[])
{
    
     uint64_t* elf;
     for(int i=0; i<numOfEntries; i++)
     {
        if(kstrcmp(arg1,tarfs_fs[i].name) == 0)
        {
            printf("foundbinaryto:%d ",curproc->proc_id);
            elf=(uint64_t*)((char*)tarfs_fs[i].addr_hdr+sizeof(struct posix_header_ustar));
            break;
        }
     }
     kstrcpy(args[0],arg1);
     int argc=1;
     while(arg2 && arg2[argc-1]!=NULL)
     {
        kstrcpy(args[argc],arg2[argc-1]);
        argc++;
     } 
        
     proc_free(curproc);
     load_elf(curproc,elf);
     //printf("REPLACED");
     vma_struct* vma=curproc->mm->mmap;

     for(int i=0;i<curproc->mm->count;i++)
     {
         if(vma->vm_type==STACK)
             break;
         vma=vma->vm_next;
     }
     
     //printf("calling");
    lcr3(curproc->cr3);
          //lcr3(boot_cr3);
     argc=copy_args_to_stack(vma->vm_end,argc);

     printf("REPLACED");
        curproc->status=RUNNABLE; 
     scheduler();
     return -1;
}   

int copy_args_to_stack(uint64_t stacktop,int argc)
{

     uint64_t argv[15];

     int i=argc;
     
     while(i)
     {
        int len = kstrlen(args[i-1])+1;
        kstrcpy((char*)(stacktop=stacktop-len-1),args[i-1]);
        argv[i-1]=stacktop;
        i--;
     }
     for(int i=0;i<argc;i++)
     {
         stacktop=stacktop-8;
        *((uint64_t*)stacktop)=(uint64_t)argv[i];
     }
     curproc->tf.tf_rsp=stacktop;
     return argc;
}








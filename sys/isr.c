
#include <sys/sbunix.h>
#include<sys/defs.h>
#include<sys/pic.h>
#include<sys/timer.h>
#include<sys/keyboard.h>
#include<sys/isr.h>
#include<sys/paging.h>
#include<sys/process.h>
#include<sys/syscall.h>
#include<sys/utils.h>
#include<sys/mmu.h>
#include<sys/tarfs.h>
#include <errno.h>



/* adapted from Chris Stones, shovelos */
#define INTERRUPT(vector) \
__asm__(".global isr" #vector "\n"\
                        "isr" #vector ":\n" \
                        "    pushq %rax;" \
                        "    pushq %rcx;" \
                        "    pushq %rdx;" \
                        "    pushq %rsi;" \
                        "    pushq %rdi;" \
                        "    pushq %r8;" \
                        "    pushq %r9;" \
                        "    pushq %r10;" \
                        "    pushq %r11;" \
                        "    movq  %rsp,%rdi;" \
                        "    call isr" #vector "_handler;" \
                        "    popq %r11;" \
                        "    popq %r10;" \
                        "    popq %r9;" \
                        "    popq %r8;" \
                        "    popq %rdi;" \
                        "    popq %rsi;" \
                        "    popq %rdx;" \
                        "    popq %rcx;" \
                        "    popq %rax;" \
                        "    iretq;    ");
#define INTERRUPTP_ERRORCODE(vector) \
__asm__(".global isr" #vector "\n"\
                        "isr" #vector ":\n" \
                        "    pushq %rax;" \
                        "    pushq %rcx;" \
                        "    pushq %rdx;" \
                        "    pushq %rsi;" \
                        "    pushq %rdi;" \
                        "    pushq %r8;" \
                        "    pushq %r9;" \
                        "    pushq %r10;" \
                        "    pushq %r11;" \
                        "    movq  %rsp,%rdi;" \
                        "    addq  $72, %rdi;"  \
                        "    call isr" #vector "_handler;" \
                        "    popq %r11;" \
                        "    popq %r10;" \
                        "    popq %r9;" \
                        "    popq %r8;" \
                        "    popq %rdi;" \
                        "    popq %rsi;" \
                        "    popq %rdx;" \
                        "    popq %rcx;" \
                        "    popq %rax;" \
                        "    addq $8,%rsp;" \
                        "    iretq;    ");


#define INTERRUPT_NO_ERRORCODE(vector) \
__asm__(".global isr" #vector "\n"\
                        "isr" #vector ":\n" \
                        "pushq $0;" \
                        "pushq %rax;" \
                        "subq $8,%rsp;" \
                        "movw %es, (%rsp);" \
                        "subq $8,%rsp;" \
                        "movw %ds, (%rsp);" \
                         PUSHA \
                        "movw $0x10, %ax;" \
                        "movw %ax, %ds;" \
                        "movw %ax, %es;" \
                        "movq %rsp, %rdi;" \
                        "call isr" #vector "_handler;" \
                         POPA2 \
                        "addq $32, %rsp;" \
                        "iretq;    ");

INTERRUPT_NO_ERRORCODE(32);   
INTERRUPT_NO_ERRORCODE(33);
INTERRUPTP_ERRORCODE(14);
INTERRUPT(11);
INTERRUPT(13);
INTERRUPT(0);
INTERRUPT(8);
INTERRUPT(12);
INTERRUPT(17);
INTERRUPT(4);
INTERRUPT(5);
INTERRUPT(6);
INTERRUPT_NO_ERRORCODE(128);

unsigned long int timeTillNow=0;

void isr32_handler(struct Trapframe *tf){
static unsigned long int ticks=0;
volatile char *video = (volatile char*)VIDEO_START+2*(24*80+73);
*(video+2) = 's';
*(video+3) = 0x1F;
*(video+4) = 'e';
*(video+5) = 0x1F;
*(video+6) = 'c';
*(video+7) = 0x1F;

print_time(ticks++/1000,video);
PIC_sendEOI(0);

//update time till now for use in sleep
timeTillNow=ticks/1000;

if(ticks%900 == 0)
{
    if((tf->tf_cs & 3) == 3)
    {
        curproc->tf=*tf;
        tf=&curproc->tf;
        if(curproc->status==RUNNING)
            curproc->status =RUNNABLE;
        //printf("RIP",tf->tf_rip);
        
    }

   // scheduler();

}

}


   
void isr33_handler(){
 keyboard_read();
 PIC_sendEOI(0);
}
void isr11_handler(){
printf("inside segment not present\n");
while(1);
}
void isr13_handler(){
 printf("inside GPL Fault \n");

while(1);
}
void isr0_handler(){
printf("inside Devide By Zero\n");
while(1);
}
void isr8_handler(){
printf("inside Double Fault\n");
while(1);
}
void isr12_handler(){
printf("inside Stack Segment fault\n");
while(1);
}
void isr17_handler(){
printf("inside Alignment check\n");
while(1);
}
void isr4_handler(){
printf("inside Overflow\n");
while(1);
}
void isr5_handler(){
printf("inside Bound Range Exceeded\n");
while(1);
}
void isr6_handler(){
printf("inside Invalid Opcode\n");
while(1);
}
uint64_t read_cr2_register(){

        uint64_t faultAddr;

        __asm__("movq %%cr2, %0;" : "=r"(faultAddr));

        return faultAddr;
}


void isr14_handler(struct faultStruct *faultFrame)
{

        uint64_t vaddr = read_cr2_register();
        //uint64_t   pde = PADDR(vaddr);
        //pde=pde;
//        printf("Kernel mode Page Fault");
//        printf("Address of faultFrame %p",faultFrame);
//        printf(" \n Error occured at %p ", faultFrame->rip);
//        printf(" \n Faulting virtual address is %p", vaddr);
//
        if(curproc->status==RUNNING)
        {
            vma_struct *vma=curproc->mm->mmap;
            vma_struct *stack=NULL,*heap=NULL;
            int count=curproc->mm->count;
            while(!(vma->vm_start<=vaddr && vma->vm_end>=vaddr)&& count--)
            {
                if(vma->vm_type == STACK)
                    stack=vma;
                if(vma->vm_type == HEAP)
                    heap = vma;
                vma=vma->vm_next;
            }
            
            if(vma)
            {
                
                if((faultFrame->errorCode & 0x1))
                {
                 uint64_t* pdpe = (uint64_t*) (KADDR(curproc->pml4e[PML4(vaddr)]) & (~0xFFF));
                    uint64_t* pde = (uint64_t*) (KADDR(pdpe[PDPE(vaddr)]) & (~0xFFF));
                    uint64_t* pte = (uint64_t*) (KADDR(pde[PDX(vaddr)]) & (~0xFFF));

                if(pte[PTX(vaddr)]&PTE_COW)//cow
                {
                    
                    if(physicalAddressToPage((uint64_t*)(pte[PTX(vaddr)]&~0xfff))->ref_count<=1)
                   {

                      /*  curproc->pml4e[PML4(vaddr)] &=~PTE_COW;
                        curproc->pml4e[PML4(vaddr)] |=PTE_W;
                        pdpe[PDPE(vaddr)] &=~PTE_COW;
                        pdpe[PDPE(vaddr)] |=PTE_W;
                        pde[PDX(vaddr)] &=~PTE_COW;
                        pde[PDX(vaddr)] |=PTE_W;*/
                        pte[PTX(vaddr)] &=~PTE_COW;
                        pte[PTX(vaddr)] |=PTE_W;
                  	printf("accesing%d %p %p",curproc->proc_id,vaddr,pte[PTX(vaddr)]); 
                   } 
                   else
                   {
                       /* curproc->pml4e[PML4(vaddr)] &=~PTE_COW;
                        curproc->pml4e[PML4(vaddr)] |=PTE_W;
                        pdpe[PDPE(vaddr)] &=~PTE_COW;
                        pdpe[PDPE(vaddr)] |=PTE_W;
                        pde[PDX(vaddr)] &=~PTE_COW;
                        pde[PDX(vaddr)] |=PTE_W;
                        pte[PTX(vaddr)] &=~PTE_COW;
                        pte[PTX(vaddr)] |=PTE_W;*/
		printf("Copying %d %p %p",curproc->proc_id,vaddr,pte[PTX(vaddr)]);
                      physicalAddressToPage((uint64_t*)(pte[PTX(vaddr)]&~0xfff))->ref_count--;
                      uint64_t page= pte[PTX(vaddr)]&~0xfff;
                      uint64_t newpage=allocate_proc_area(curproc, (void*)ROUNDDOWN(vaddr,PGSIZE),PGSIZE);

                     lcr3(boot_cr3);
                     kmemcpy((void*)KADDR(newpage),(void*)KADDR(page), PGSIZE);    
                     lcr3(curproc->cr3);
                   
                   }
                }
			else{
	printf("Permission Violation");
} //handle other permission violations else{} here
                }
                else //always LOAD type
                {//printf("OLD");
                     int x=allocate_proc_area(curproc, (void*)ROUNDDOWN(vaddr,PGSIZE),PGSIZE); printf("(%p %p)",vaddr,x);
                     if(vma->vm_type == LOAD)
		     {

			uint64_t copyfrom=(uint64_t)((unsigned char*)vma->vm_file)+vma->vm_offset+ROUNDDOWN(vaddr,PGSIZE)-vma->vm_start;
            int size=PGSIZE;
            if(ROUNDDOWN(vaddr,PGSIZE)+size>vma->vm_start+vma->filesz)
                size= vma->vm_start+vma->vm_filesz-ROUNDDOWN(vaddr,PGSIZE); 
            if(size<0)
                size=0;
            printf("sizecpd=%d",size);
                     kmemcpy((void*)(ROUNDDOWN(vaddr,PGSIZE)),(void*)(copyfrom),size);
                    
                     }
 
                }
            }
            else 
            {
                 if(vaddr < stack->vm_start && vaddr > stack->vm_start-PGSIZE)    
                 {
                     printf("Stack Fault");

                     allocate_proc_area(curproc, (void*)stack->vm_start-PGSIZE,PGSIZE);
                 //stack or heap
                 }
                 else
                 {
                     printf("Segmentation Fault:%d %p",curproc->proc_id,vaddr);
                     while(1);
                     proc_free(curproc);
                     curproc->status=FREE;
                     //proccount--;
                     //kill process
                 }
                 heap++;
            }
              
        }
}


void isr128_handler(struct Trapframe* tf){

        int syscall_number = tf->tf_trapno;
        int syscall_ret_value;
        //printf("SYSCALNO %d ",syscall_number);
        curproc->tf=*tf;
                        tf=&curproc->tf;

        switch(syscall_number){
    
                case SYS_write:
                        //printf("In sys write isr\n");
                        syscall_ret_value = sys_write(tf->tf_regs.reg_rdi,tf->tf_regs.reg_rsi,tf->tf_regs.reg_rdx);
                        tf->tf_regs.reg_rax = (uint64_t)syscall_ret_value;
                        break;


                case SYS_exit:
                      sys_exit(2);
                                              scheduler();
                         //printf("exited");
                        break;

                case SYS_fork:
                        curproc->tf=*tf;
                        tf=&curproc->tf;
                        //curproc->status =RUNNABLE;
                        uint64_t id = sys_fork(tf);
  __asm__ __volatile__("movq %0, %%rax;":: "r"(id)); //?
                        break;
                case SYS_getpid:

                    printf("In sys getpid call in kernel\n");
                    syscall_ret_value = sys_getpid();
                    tf->tf_regs.reg_rax = syscall_ret_value;

                    break;


                case SYS_getdents:

                    //printf("Calling sys_read_dir %d %d\n",SYS_getdents,syscall_number);
                    //while(1);
                    syscall_ret_value = sys_read_dir((void*)tf->tf_regs.reg_rdi,(char*)tf->tf_regs.reg_rsi);
                    tf->tf_regs.reg_rax = (uint64_t)syscall_ret_value;
                    break;

                case SYS_open:

                    //printf("Inside open syscall\n");
                    //printf("%d\n",tf->tf_regs.reg_rsi );
                    //printf("%d\n",(O_DIRECTORY|O_RDONLY) );
                    if(tf->tf_regs.reg_rsi == (KO_DIRECTORY|KO_RDONLY)){

        //                printf("Going to open a directory\n");
                        syscall_ret_value  = sys_open_dir((char*)tf->tf_regs.reg_rdi);
                        tf->tf_regs.reg_rax = (uint64_t)syscall_ret_value;

                    }

                    else if(tf->tf_regs.reg_rsi == KO_RDONLY){

          //              printf("Going to open Normal file\n");
                        syscall_ret_value  = sys_open_file((char*)tf->tf_regs.reg_rdi);
                        tf->tf_regs.reg_rax = (uint64_t)syscall_ret_value;
                        


                    }

                    break;

                case SYS_read:

                    //printf("In file read syscall\n");
 
                    syscall_ret_value  = sys_read_file((int)tf->tf_regs.reg_rdi,(char*)tf->tf_regs.reg_rsi,(int)tf->tf_regs.reg_rdx);
                    tf->tf_regs.reg_rax = (uint64_t)syscall_ret_value;
                    break;


                    
                case SYS_close:

                    //This is directory close
                    //printf("This is directory close\n");
                    syscall_ret_value  = sys_close_file(tf->tf_regs.reg_rdi);
                    tf->tf_regs.reg_rax = (uint64_t)syscall_ret_value;

                    break;


                case SYS_lseek:

                    //printf("Inside LSEEK SYSCALL\n");
                    syscall_ret_value  = sys_lseek_file((int)tf->tf_regs.reg_rdi,(uint64_t)tf->tf_regs.reg_rsi,(int)tf->tf_regs.reg_rdx);
                    tf->tf_regs.reg_rax = (uint64_t)syscall_ret_value;
                    break;


                case SYS_getcwd:

                    //printf("Inside getcwd\n");
                    syscall_ret_value  = sys_getcwd((char*)tf->tf_regs.reg_rdi,(uint64_t)tf->tf_regs.reg_rsi);
                    tf->tf_regs.reg_rax = (uint64_t)syscall_ret_value;
                    break;

                case SYS_chdir:

                    //printf("Inside change dir\n");
                    syscall_ret_value  = sys_chdir((char*)tf->tf_regs.reg_rdi);
                    tf->tf_regs.reg_rax = (uint64_t)syscall_ret_value;
                    break;

                case SYS_pipe:

                    //printf("Inside pipe sycall: isr.c\n");
                    syscall_ret_value  = sys_pipe((int*)tf->tf_regs.reg_rdi);
                    tf->tf_regs.reg_rax = (uint64_t)syscall_ret_value;
                    break;

                case SYS_ps:
                    tf->tf_regs.reg_rax=sys_ps();
                    break;
		      case SYS_brk:
        			tf->tf_regs.reg_rax = sys_brk(tf->tf_regs.reg_rdi);
        			break;



                case SYS_dup2:

                    //printf("Inside isr.c dup2\n");
                    syscall_ret_value  = sys_dup2((int)tf->tf_regs.reg_rdi,(int)tf->tf_regs.reg_rsi);
                    tf->tf_regs.reg_rax = (uint64_t)syscall_ret_value;
                    break;

                    
                case SYS_nanosleep:

                    printf("IN ISR\n");
                    syscall_ret_value  = sys_sleep((void*)tf->tf_regs.reg_rdi);
                    tf->tf_regs.reg_rax = (uint64_t)syscall_ret_value;
                    break;
                case SYS_execve:
                    syscall_ret_value  = sys_execve((const char*)tf->tf_regs.reg_rdi,(const char**)tf->tf_regs.reg_rsi,(const char**)tf->tf_regs.reg_rdx);
                    tf->tf_regs.reg_rax = (uint64_t)syscall_ret_value;
                    break;
                case SYS_wait4:
                     tf->tf_regs.reg_rax = sys_waitpid(tf->tf_regs.reg_rdi,tf->tf_regs.reg_rsi,tf->tf_regs.reg_rdx);

curproc->tf=*tf;
        tf=&curproc->tf;

                    scheduler();
                break;

                default:
                        break;

                };
}



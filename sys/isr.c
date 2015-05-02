
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

if(ticks%900 == 0)
{
    if((tf->tf_cs & 3) == 3)
    {
        curproc->tf=*tf;
        tf=&curproc->tf;
        curproc->status =RUNNABLE;
        printf(" RIP:%p",tf->tf_rip);
        
    }
    scheduler();
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

        if(curproc->status==RUNNING)
        {
            vma_struct *vma=curproc->mm->mmap;
            vma_struct *stack=NULL,*heap=NULL;
            while(!(vma->vm_start<=vaddr && vma->vm_end>=vaddr))
            {
                if(vma->vm_type == STACK)
                    stack=vma;
                if(vma->vm_type == HEAP)
                    heap = vma;
                vma=vma->vm_next;
            }
            
            if(vma == NULL)
            {
                 if(vaddr < stack->vm_start && vaddr > stack->vm_start-PGSIZE)    
                 {
                     printf("Stack Fault");

                     allocate_proc_area(curproc, (void*)stack->vm_start-PGSIZE,PGSIZE);
                 //stack or heap
                 }
                 heap++;
            }
            else
            {
               allocate_proc_area(curproc, (void*)ROUNDDOWN(vaddr,PGSIZE),PGSIZE); 
//               allocate_proc_area(curproc, (void*)vma->vm_start,vma->vm_size); 
/*               uint64_t size =PGSIZE;
               if(ROUNDDOWN(vaddr,PGSIZE)+PGSIZE >= vma->vm_end)
                   size=vma->vm_end-ROUNDDOWN(vaddr,PGSIZE);*/
                                 uint64_t copyfrom=(uint64_t)((unsigned char*)vma->vm_file)+vma->vm_offset+ROUNDDOWN(vaddr,PGSIZE)-vma->vm_start;
               
               my_memcpy((void*)(ROUNDDOWN(vaddr,PGSIZE)),(void*)(copyfrom),PGSIZE);
//             my_memcpy((void*)vma->vm_start,(void*)(unsigned char*)vma->vm_file+vma->vm_offset,vma->vm_size);

//             printf("Allocated page");        
            }   
        }
}


void isr128_handler(struct Trapframe* tf){

        int syscall_number = tf->tf_trapno;

        switch(syscall_number){

                case SYS_write:
                        sys_write(tf->tf_regs.reg_rdi,tf->tf_regs.reg_rsi,tf->tf_regs.reg_rdx);
                        break;


                case SYS_exit:
                        sys_exit(2);
                        printf("exited");
                        break;

                case SYS_fork:
                        curproc->tf=*tf;
//                        tf=&curproc->tf;
                        curproc->status =RUNNABLE;
                        uint64_t id = sys_fork(tf);
  __asm__ __volatile__("movq %0, %%rax;":: "r"(id)); //?
                        break;
                default:
                        break;

                };
}



#include <sys/idt.h>
#define NPROCS 250
extern uint16_t proccount;

enum ProcStatus{
FREE,
RUNNABLE,
RUNNING,
WAITING
};

enum ProcType
{
USER_PROCESS=0,
KERNEL_PROCESS
};

enum SegType{
STACK,
HEAP,
LOAD,
};

typedef struct vma_struct{
struct mm_struct    *vm_mm; 
uint64_t    vm_start; 
uint64_t    vm_end; 
uint64_t    *vm_file;          /* mapped file, if any */
uint64_t vm_size;
uint64_t vm_filesz;
uint64_t vm_offset;
enum SegType vm_type;
struct vma_struct   *vm_next;
uint64_t    vm_flags;      /* flags */
}vma_struct;
typedef struct mm_struct {
    int count;
    uint64_t * pt; // page table pointer  
    struct vma_struct * mmap;
    struct vma_struct * mmap_avl;
    uint64_t end_brk,start_brk;
}mm_struct;

vma_struct* allocate_vma();

typedef struct ProcStruct{
unsigned char proc_id;
unsigned char parent_id;
enum ProcType type;
uint64_t* pml4e;
uint64_t *binary;
enum ProcStatus status;
struct ProcStruct* next;
struct Trapframe tf;
physaddr_t* cr3;
uint64_t wakeuptime;
uint64_t *elf;
struct mm_struct *mm;
uint64_t kstack[512];
int fd_table[50];  //per process file descriptor array
char cwd[50]; //store the current working directory of a process
int waitingfor;
int num_child;
}ProcStruct;


struct K_timespec
{
	unsigned int tv_sec;
	int64_t tv_nsec;
};

ProcStruct* proc_free_list,*proc_running_list,*curproc;
ProcStruct* procs; 

int setupt_proc_vm(ProcStruct *NewProc);
void env_pop_tf(struct Trapframe *tf);

int scheduler();
int allocate_proc_area(ProcStruct* p, void* va, uint64_t size);
void initialize_process();
ProcStruct* create_process(uint64_t*, enum ProcType);
ProcStruct* allocate_process(unsigned char parent_id);
int load_elf(ProcStruct *,uint64_t* binary);
ProcStruct * getnewprocess();
void proc_run(struct ProcStruct *proc);
int proc_free(ProcStruct*);
int fork_process(struct Trapframe* );
uint64_t execvpe(char *arg1,char *arg2[], char* arg3[]);
int copypagetables(ProcStruct *proc);
int copyvmas(ProcStruct *proc);
int get_running_process();
uint64_t inc_brk(uint64_t n);
int proc_sleep(void* t);
uint64_t execve(const char *arg1,const char *arg2[],const  char* arg3[]);
int copy_args_to_stack(uint64_t stacktop,int argc);

#define POPA \
	"\tmovq 0(%%rsp),%%r15\n" \
	"\tmovq 8(%%rsp),%%r14\n" \
	"\tmovq 16(%%rsp),%%r13\n" \
	"\tmovq 24(%%rsp),%%r12\n" \
	"\tmovq 32(%%rsp),%%r11\n" \
	"\tmovq 40(%%rsp),%%r10\n" \
	"\tmovq 48(%%rsp),%%r9\n" \
	"\tmovq 56(%%rsp),%%r8\n" \
	"\tmovq 64(%%rsp),%%rsi\n" \
	"\tmovq 72(%%rsp),%%rdi\n" \
	"\tmovq 80(%%rsp),%%rbp\n" \
	"\tmovq 88(%%rsp),%%rdx\n" \
	"\tmovq 96(%%rsp),%%rcx\n" \
	"\tmovq 104(%%rsp),%%rbx\n" \
	"\tmovq 112(%%rsp),%%rax\n" \
	"\taddq $120,%%rsp\n"



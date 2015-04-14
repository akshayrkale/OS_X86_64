#include <sys/idt.h>
#define NPROCS 250
uint16_t curproc;
enum ProcStatus{
FREE,
RUNNABLE,
RUNNING,
};

enum ProcType
{
USER_PROCESS=0,
KERNEL_PROCESS
};

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
uint64_t *elf;
}ProcStruct;


ProcStruct* proc_free_list;
uint16_t proc_queue[250];
ProcStruct* procs; 

int setupt_proc_vm(ProcStruct *NewProc);
void env_pop_tf(struct Trapframe *tf);

int allocate_proc_area(ProcStruct* p, void* va, uint64_t size);
void initialize_process();
ProcStruct* create_process(uint64_t*, enum ProcType);
ProcStruct* allocate_process(unsigned char parent_id);
int load_elf(ProcStruct *,uint64_t* binary);
ProcStruct * getnewprocess();
void proc_run(struct ProcStruct *proc);
void scheduler();


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


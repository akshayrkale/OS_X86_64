#include <sys/idt.h>
#define NPROCS 250

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
uint64_t* cr3;
uint64_t *elf;
}ProcStruct;


ProcStruct* proc_free_list;
ProcStruct* procs; 

int setupt_proc_vm(ProcStruct *NewProc);

int allocate_proc_area(ProcStruct* p, void* va, uint64_t size);
void initialize_process();
ProcStruct* create_process(uint64_t*, enum ProcType);
ProcStruct* allocate_process(unsigned char parent_id);
int load_elf(ProcStruct *,uint64_t* binary);
ProcStruct * getnewprocess();

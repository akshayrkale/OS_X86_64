#include <sys/sbunix.h>
#include <sys/gdt.h>
#include <sys/tarfs.h>
#include <sys/idt.h>
#include <sys/pic.h>
#include <sys/timer.h>
#include <sys/keyboard.h>
#include <sys/paging.h>
#include <sys/process.h>
#include <sys/tarfs.h>
#include <sys/sbunix.h>


int errno = 0;


uint64_t* proc_binary2=0;

void start(uint32_t* modulep, void* physbase, void* physfree)
{
    struct smap_t {
		uint64_t base, length;
		uint32_t type;
	}__attribute__((packed)) *smap;
	//printf("Physbase =%p physfree =%p",physbase,physfree);
	
	while(modulep[0] != 0x9001) modulep += modulep[1]+2;
	for(smap = (struct smap_t*)(modulep+2); smap < (struct smap_t*)((char*)modulep+modulep[1]+2*4); ++smap) {
		if (smap->type == 1 /* memory */ && smap->length != 0) {
            
        //printf("Available Physical Memory [%x-%x] \n", smap->base, smap->base + smap->length);
        npages = (smap->base+smap->length)/PGSIZE;
		}
    }

	//printf("tarfs in [%p:%p]\n Toatal Pages:%d\n", &_binary_tarfs_start, &_binary_tarfs_end,npages);
    //printf("physfree=%p \n",physfree);
  uint64_t i=0;
	initialize_vm_64();

  //printf("After initializing vm\n");

   i=499999999;
    while(i--);

  tarfs_init();

  printf("After initialize tarfs\n");
  initialize_process();
  //printf("After initialize procs\n");
    ProcStruct *tp=proc_free_list;
    while(tp->next!=NULL) 
    {
        tp=tp->next;
        i++;
    }
     
    
  //  printf("Total procs:%d",i);
    struct posix_header_ustar* start= (struct posix_header_ustar*)&_binary_tarfs_start;
//    printf("name of bin=%s ",start->name);
    //printf("name of file:%s",((struct posix_header_ustar*)((uint64_t)start+sizeof(struct posix_header_ustar)))->size);
    
    uint64_t* proc_binary = ((uint64_t*)((uint64_t)start+sizeof(struct posix_header_ustar)+sizeof(struct posix_header_ustar)));
//    uint64_t* struct1  = ((uint64_t*)((uint64_t)start+sizeof(struct posix_header_ustar)));

     create_process(proc_binary,USER_PROCESS);
//printf("name=%s",((struct posix_header_ustar*)((unsigned char*)proc_binary+ROUNDUP(19796,512)))->name);
//    uint64_t* proc_binary1=(uint64_t*)((unsigned char*)proc_binary+ROUNDUP(19796,512)+512);
//    create_process(proc_binary1,USER_PROCESS);
 //   proc_binary2=(uint64_t*)((unsigned char*)proc_binary1+ROUNDUP(18353,512)+512);
//    create_process(proc_binary2,USER_PROCESS);

    //printf("done");
ltr((uint16_t)(0x28));

  __asm__("sti");
scheduler();
printf("ENDING");
    while(1);
    // kernel starts here
}

#define INITIAL_STACK_SIZE 4096
char stack[INITIAL_STACK_SIZE];
uint32_t* loader_stack;
extern char kernmem, physbase;
struct tss_t tss;

void boot(void)
{
	// note: function changes rsp, local stack variables can't be practically used
	//register char *s, *v;
	__asm__(
		"movq %%rsp, %0;"
		"movq %1, %%rsp;"
		:"=g"(loader_stack)
		:"r"(&stack[INITIAL_STACK_SIZE])
	);
	reload_gdt();
    
	setup_tss();
    init_idt();
    PIC_remap(32,40);
   
    init_PIT(1000);
    keyboard_init();
   // __asm__("sti");
    start(
		(uint32_t*)((char*)(uint64_t)loader_stack[3] + (uint64_t)&kernmem - (uint64_t)&physbase),
		&physbase,
		(void*)(uint64_t)loader_stack[4]
	);

    printf("!!!!! start() returned !!!!! ");
	//for(v = (char*)0xb8000; *s; ++s, v += 2) *v = *s;
}

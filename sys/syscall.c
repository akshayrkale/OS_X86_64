#include <sys/sbunix.h>
#include <sys/defs.h>
#include <sys/sbunix.h>
#include<sys/process.h>

void sys_write(uint64_t fd,uint64_t buff,uint64_t len){

	//printf(" In kernel printf.. in buffer %s",buff);
	
	//while(1);
	kprintf((char*)buff,(int)len);


}
void sys_exit(uint64_t error_code){
//    printf("Exiting Process%p %d",curproc,curproc->proc_id);
    if(curproc)
    {
        proc_free(curproc);
        //uint64_t i = 499999999;
        //while(i--);

//        while(1);
        scheduler();
    }
}



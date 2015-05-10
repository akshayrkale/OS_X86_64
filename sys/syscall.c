#include <sys/sbunix.h>
#include <sys/defs.h>
#include <sys/sbunix.h>
#include <sys/process.h>
#include <sys/tarfs.h>
#include <sys/keyboard.h>
#include <sys/paging.h>
#include <sys/pipe.h>
#include <errno.h>



void sys_write(uint64_t fd,uint64_t buff,uint64_t len){

	//printf(" In kernel printf.. in buffer %s",buff);
	
	//while(1);
	 kwrite(fd,(char*)buff,(int)len);


}

void sys_exit(uint64_t error_code){
//    printf("Exiting Process%p %d",curproc,curproc->proc_id);
    if(curproc)
    {
    proc_free(curproc);
    remove_page(curproc->cr3);
    remove_page((uint64_t*)PADDR((uint64_t)curproc->mm));

    ProcStruct* parent =((ProcStruct*)procs+curproc->parent_id-1);

    if(parent)
        parent->num_child--; 
    if((parent) && (parent->status == WAITING) && (parent->waitingfor == curproc->proc_id || parent->waitingfor == 0 || (parent->num_child==0)))
    {
        parent->status=RUNNABLE;
        parent->waitingfor=-1;
    }
                      
    printf("Exited%d ",curproc->proc_id);
    
   // kmemset((void*)proc,0,sizeof(ProcStruct));
    curproc->status = FREE;
    //proccount--
        }
}

int sys_fork(struct Trapframe* tf)
{
    return fork_process(tf);
}

int sys_getpid(){

	//printf("In kernel mode curr proc address: %p",curproc);
	//while(1);
	return curproc->proc_id;

}

// ######################################################
// ################# DIRECTORY SYSCALLS #################
// ######################################################

uint64_t sys_open_dir(const char *name){

	//printf("Inside the sys_open_dir\n");

	return kopendir(name);


}

uint64_t sys_read_dir(void* dir,char* userBuff){

	return kreaddir(dir,userBuff);
}


int sys_close_directory(void* dir){

	//return kclosedir(dir);

	return 0;
}

// ##################################################
// ################# FILE SYSCALLS #################
// ##################################################

uint64_t sys_open_file(const char* name){

	return kopen(name);
	//return x;

}

uint64_t sys_read_file(int fd, char* buf , int numBytes){
   // printf("FDD DDD=%d",fd);
	return kread(fd,buf,numBytes);
	

}

uint64_t sys_close_file(int fd){

    //printf("Closing File");
	return kclose(fd);

}

uint64_t sys_lseek_file(int fd, uint64_t offset, int whence){

	int x =  klseek(fd,offset,whence);

	//printf("cursor : %d" , file_table[4].cursor);

	return x;

}

uint64_t sys_read_terminal(char* buf){

	return kscanf(buf);

}

uint64_t sys_getcwd(char* buff, uint64_t size){


	kgetcwd(buff);
	return (uint64_t)buff; //No meaning as getcwd itself passed buff pointer

}

int sys_chdir(char* path){

	//printf("In syscall PATH: %s\n", path );
	return kchdir(path);

}

int sys_pipe(int* pipeFD){

	return pipe(pipeFD);

}

int sys_ps()
{
return get_running_process();
}


uint64_t sys_brk(uint64_t n)
{
return inc_brk(n); 
}



int sys_dup2(int oldfd,int newfd){

	return dup2(oldfd,newfd);
}


int sys_sleep(void* t){

	//t=t;

	return proc_sleep(t);

}

int sys_kill(int pid){

	//t=t;
    ProcStruct *proc=(procs+pid-1);
	proc_free(proc);
    remove_page(proc->cr3);
    remove_page((uint64_t*)PADDR((uint64_t)proc->mm));

    ProcStruct* parent =((ProcStruct*)procs+proc->parent_id-1);

    if(parent)
        parent->num_child--; 
    if((parent) && (parent->status == WAITING) && (parent->waitingfor == proc->proc_id || parent->waitingfor == 0 || (parent->num_child==0)))
    {
        parent->status=RUNNABLE;
        parent->waitingfor=-1;
    }
                      
    printf("Killed %d ",proc->proc_id);
    
   // kmemset((void*)proc,0,sizeof(ProcStruct));
    proc->status = FREE;
    //proccount--
   return 0; 
}

int sys_execve(const char *arg1,const char *arg2[],const  char* arg3[])
{
return execve(arg1,arg2,arg3);
}


int sys_waitpid(uint64_t chpid, uint64_t chstatus, uint64_t choptions)
{

   printf("sys_waitpid %d) ",curproc->proc_id);
    if( curproc->num_child==0)
    {

//    	printf("In sys_waitpid 1st if... FD=%d) ",curproc->fd_table[3]);
     //   *((int*)chstatus) =-1;
        return -1;
    }

if(chpid>0)
{

	//printf("In sys_waitpid 2nd if... FD=%d) ",curproc->fd_table[3]);
curproc->waitingfor = chpid;
}
else
{
	printf("sys_waitpid RARE:%d ",curproc->proc_id);
curproc->waitingfor = 0;
}

curproc->status =WAITING;

//if(chstatus!=0)
   // * ((int*)chstatus) =0;

return curproc->waitingfor;
}

#include <sys/sbunix.h>
#include <sys/defs.h>
#include <sys/sbunix.h>
#include <sys/process.h>
#include <sys/tarfs.h>
#include <sys/keyboard.h>

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

	return kclosedir(dir);
}

// ##################################################
// ################# FILE SYSCALLS #################
// ##################################################

uint64_t sys_open_file(const char* name){

	return kopen(name);

}

uint64_t sys_read_file(int fd, char* buf , int numBytes){

	return kread(fd,buf,numBytes);
	

}

uint64_t sys_close_file(int fd){

    printf("Closing File");
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


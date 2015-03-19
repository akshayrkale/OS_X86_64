#include <sys/defs.h>
#include <sys/syscall.h>
#include <syscall.h>
#include <errno.h>
#include <stdlib.h>

int chdir(const char *path){

	int retvalue;
	retvalue=syscall_1(SYS_chdir,(uint64_t)path);

	if(retvalue >=0){
		return retvalue;
	}
	errno = -retvalue;
	return -1;

}

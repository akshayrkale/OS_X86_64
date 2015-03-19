#include<stdio.h>
#include<sys/syscall.h>
#include<syscall.h>
#include<sys/defs.h>
#include<stdlib.h>
#include<errno.h>


int closedir(void *dir){

	int fd = *(int*)dir;

	int retvalue;
	retvalue = syscall_1(SYS_close,fd);

	if(retvalue<0){
		errno = - retvalue;
		//printf("Directory not closed Error\n\n");
		return -1;

	}
	return retvalue;


}

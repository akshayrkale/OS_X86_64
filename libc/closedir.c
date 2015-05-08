#include<stdio.h>
#include<sys/syscall.h>
#include<syscall.h>
#include<sys/defs.h>
#include<stdlib.h>
#include<errno.h>


int closedir(void *dir){


	if((uint64_t)dir == -1){

		printf("Cannot close bad directory stream\n");
		return -1;
	}
	int fd = (uint64_t)dir;

	int retvalue;
	retvalue = syscall_1(SYS_close,(uint64_t)fd);

	//printf("closedir syscall returned %d\n",retvalue );

	if(retvalue<0){
		
		return -1;

	}
	return retvalue;


}

#include<sys/defs.h>
#include<sys/syscall.h>
#include<syscall.h>
#include<stdlib.h>
#include<errno.h>

int errno=0; //Only define here. declaration seeps through to the files via stdlib.h

char* getcwd(char *buf, size_t size){

	int retvalue;
	retvalue=syscall_2(SYS_getcwd,(uint64_t)buf,(uint64_t)size);

	if(retvalue >=0){
		return buf;
	}
	errno = -retvalue;
	return NULL;

}

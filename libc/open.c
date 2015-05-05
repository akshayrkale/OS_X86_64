
#include<sys/defs.h>
#include<sys/syscall.h>
#include<syscall.h>
#include<stdlib.h>
#include<stdio.h>

int open(const char *pathname, int flags)
{
	int retvalue;
	printf("In libc open :%s\n",pathname);
	retvalue = syscall_2(SYS_open, (uint64_t)pathname, (uint64_t)flags);
	if(retvalue >=0){
		return retvalue;
	}
	errno = -retvalue;

	return -1;

}

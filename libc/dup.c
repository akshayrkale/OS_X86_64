#include<sys/defs.h>
#include<sys/syscall.h>
#include<syscall.h>
#include<stdlib.h>

int dup(int oldfd)
{
	int retvalue;

	retvalue = syscall_1(SYS_dup, oldfd);

	if(retvalue >=0){
		return retvalue;
	}
	errno = -retvalue;
	return -1;

}

#include <syscall.h>
#include <sys/syscall.h>
#include <stdlib.h>
#include <stdio.h>

pid_t fork()
{
	int retvalue;

	retvalue = syscall_0(SYS_fork);

	if(retvalue >=0){
		return retvalue;
	}
	errno = -retvalue;
	return -1;

}



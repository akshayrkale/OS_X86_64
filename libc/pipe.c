#include<sys/defs.h>
#include<sys/syscall.h>
#include<syscall.h>
#include<stdlib.h>
int pipe(int fd[2])
{
	int retvalue;
	retvalue = syscall_1(SYS_pipe, (uint64_t)fd);

	if(retvalue >=0){
		return retvalue;
	}
	errno = -retvalue;
	return -1;
}

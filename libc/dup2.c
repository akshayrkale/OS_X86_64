#include<sys/defs.h>
#include<sys/syscall.h>
#include<syscall.h>
#include<stdlib.h>

int dup2(int oldfd, int newfd)
{
	int retvalue;
	retvalue = syscall_2(SYS_dup2, oldfd, newfd);

	if(retvalue >=0){
		return retvalue;
	}
	errno = -retvalue;
	return -1;


}

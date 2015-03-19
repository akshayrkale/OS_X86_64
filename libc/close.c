#include<sys/defs.h>
#include<sys/syscall.h>
#include<syscall.h>
#include <stdlib.h>

int close(int fd)
{
	int retvalue;
	retvalue = syscall_1(SYS_close, fd);

	if(retvalue >=0){
		return retvalue;
	}
	errno = -retvalue;
	return -1;

}



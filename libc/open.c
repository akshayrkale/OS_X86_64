#include <sys/defs.h>
#include <sys/syscall.h>
#include <syscall.h>
#include <stdlib.h>
#include <stdio.h>
#include <errno.h>

//int errno = 0;

int open(const char *pathname, int flags)
{
	int retvalue;
	retvalue = syscall_2(SYS_open, (uint64_t)pathname, (uint64_t)flags);
	if(retvalue >=0){
		return retvalue;
	}

	return -1;

}

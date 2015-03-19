#include<sys/defs.h>
#include<sys/syscall.h>
#include<syscall.h>
#include<stdlib.h>

off_t lseek(int fildes, off_t offset, int whence)
{
	int retvalue;
	retvalue = syscall_3(SYS_lseek, (uint64_t)fildes, (uint64_t)offset, (uint64_t)whence);
	if(retvalue >=0){
		return retvalue;
	}
	errno = -retvalue;
	return -1;
}

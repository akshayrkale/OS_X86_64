#include<sys/defs.h>
#include<sys/syscall.h>
#include<syscall.h>
#include<stdlib.h>

ssize_t write(int fd, const void *buf, size_t count){

	int retvalue=syscall_3(SYS_write,fd,(uint64_t)buf,(uint64_t)count);
	if(retvalue >=0){
		return retvalue;
	}
	errno = -retvalue;
	return -1;

}


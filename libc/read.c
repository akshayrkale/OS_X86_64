#include <syscall.h>
#include <sys/syscall.h>
#include <stdlib.h>
#include <stdio.h>
#include <errno.h>

ssize_t read(int fd, void *buf, size_t count){

	int retvalue;
	retvalue =syscall_3(SYS_read,fd,(uint64_t)buf,(uint64_t)count);
	
	if(retvalue < 0 ){
		printf("Error in reading File\n");
		return -1;
	}
	
	return retvalue;

}

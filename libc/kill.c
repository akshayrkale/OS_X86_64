#include <syscall.h>
#include <sys/syscall.h>
#include <stdlib.h>
#include <stdio.h>
#include <errno.h>

int kill(int pid){

	int retvalue;
	retvalue =syscall_1(SYS_kill,pid);
	if(retvalue >=0){
		return retvalue;
	}
	return -1;

}

#include <syscall.h>
#include <sys/syscall.h>
#include <stdlib.h>
#include <stdio.h>
#include <errno.h>

int ps(){

	int retvalue;
	retvalue =syscall_0(SYS_ps);
	if(retvalue >=0){
		return retvalue;
	}
	return -1;

}

#include<sys/defs.h>
#include<sys/syscall.h>
#include<syscall.h>
#include<stdio.h>
#include<stdlib.h>


unsigned int alarm(unsigned int sec)
{

	int retvalue;

	retvalue =  syscall_1(SYS_alarm, (uint64_t)sec);

	if(retvalue >=0){
		return retvalue;
	}
	errno = -retvalue;
	return -1;


}

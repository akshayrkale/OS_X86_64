#include <syscall.h>
#include <sys/defs.h>
#include <stdlib.h>
#include <sys/syscall.h>

pid_t getpid()
{
	int retvalue;
	retvalue = syscall_0(SYS_getpid);
	if(retvalue >=0){
		return retvalue;
	}
	return -1;


}

pid_t getppid()
{
	int retvalue;
	retvalue = syscall_0(SYS_getppid);
	if(retvalue >=0){
		return retvalue;
	}

	return -1;


}

pid_t waitpid(pid_t pid, int *status, int options)
{
	pid_t retvalue;
	retvalue = syscall_3(SYS_wait4,(uint64_t)pid,(uint64_t)status,(uint64_t)options);
	if(retvalue >=0){
		return retvalue;
	}

	return -1;

}


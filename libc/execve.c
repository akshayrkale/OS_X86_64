#include<sys/defs.h>
#include<sys/syscall.h>
#include<syscall.h>
#include<stdlib.h>

int execve(const char *filename, char *const argv[], char *const envp[])
{
		int retvalue;
		retvalue = syscall_3(SYS_execve, (uint64_t)filename, (uint64_t)argv, (uint64_t)envp);
		if(retvalue >=0){
			return retvalue;
		}
		errno = -retvalue;
		return -1;

}

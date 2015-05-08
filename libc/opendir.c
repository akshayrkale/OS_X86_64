#include<stdio.h>
#include<sys/syscall.h>
#include<stdlib.h>
#include<errno.h>
#include<syscall.h>
#include<string.h>


void *opendir(const char *name)
{

	
	uint64_t fd=0;

	//WARNING THIS IS A HACK MUST ALLOCATE SPACE FR FD and return it

	fd = (uint64_t)syscall_2(SYS_open, (uint64_t) name, O_DIRECTORY | O_RDONLY);

	


	if(fd == -1){
		printf("No such file or directory\n");
		return (void*)-1;
	}

	return (void*)fd;
}

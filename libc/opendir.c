#include<stdio.h>
#include<sys/syscall.h>
#include<stdlib.h>
#include<errno.h>
#include<syscall.h>
#include<string.h>


void *opendir(const char *name)
{

	//printf("In opendir libc path passed: %s \n",name );


	// char fullName[100];
	// char temp[100];
	
	// fullName[0]='/';
	// fullName[1]='\0';

	// strcpy(temp,name);
	// int pathLen = strlen(temp);

	// if(temp[pathLen-1] != '/'){
	// 	strcat(temp,"/");
	// } //Ensures that the name has a trailing slash

	// if(temp[0] != '/'){
	// 	strcat(fullName,temp);
	// }
	// else{
	// 	strcpy(fullName,temp);
	// }



	printf("Sending %s to opendir\n", name );

	uint64_t fd=0;



	fd = (uint64_t)syscall_2(SYS_open, (uint64_t) name, O_DIRECTORY | O_RDONLY);

	//printf("Value returned from opendir *(&fd):%d &fd:%p fd:%x *fd:%d\n",*(&fd),&fd,fd,*fd);

	//printf("In open dir fd: %d",fd);
	//printf("Leaving opendir errno : %d\n",errno );


	if(fd == -1){
		return (void*)-1;
	}

	return (void*)fd;
}

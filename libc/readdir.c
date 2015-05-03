#include<stdio.h>
#include<sys/syscall.h>
#include<syscall.h>
#include<stdlib.h>
#include<errno.h>
#include<stdlib.h>
#include<string.h>
/*
static int dir_traverse = 0;
static int nread = -1;

   struct dirent *readdir(void *dir) {

	//nread = -1;
	int fd;
	fd = *((int*) dir); //get the fd for the dir pointer
	static char buf[1024];
	struct dirent *d;

	if (dir_traverse >= nread) {

		dir_traverse = 0;
		nread = -1;
		nread = syscall_3(SYS_getdents, fd, (uint64_t) buf, 1024);

	}

	if (nread == -1) {
		//printf("Error in getdents\n");
	}
	if (nread == 0) {

		// end of records
		//printf("Directory exhausted\n");
		//errno = EBADF;
		return (struct dirent *) NULL;
	}

	//printf("Processing record %d\n",i);
	d = (struct dirent *) (buf + dir_traverse);
	//printf("File =%s   Value of i = %d\n", d->d_name, dir_traverse);
	dir_traverse += d->d_reclen;
	return (struct dirent *) d;
}

void *opendir(const char *name)
{

	int* fd = malloc(sizeof(int));

	*fd = syscall_2(SYS_open, (uint64_t) name, O_DIRECTORY | O_RDONLY);
	dir_traverse = 0;
	nread = -1;
	if (*fd < 0) {
		//printf("Error opening dir \n");
		errno = -*fd;
		return (void*) NULL;
	} else {
		//printf("Succeded in opendir. Fd = %p...Opened %s\n",fd,name);
		return (void*) fd;

	}

}*/
void *opendir(const char *name)
{

	//printf("In opendir errno : %d\n",errno );

	uint64_t fd;

	char fullName[100];
	char temp[100];
	
	fullName[0]='/';
	fullName[1]='\0';

	strcpy(temp,name);
	int pathLen = strlen(temp);

	if(temp[pathLen-1] != '/'){
		strcat(temp,"/");
	} //Ensures that the name has a trailing slash

	if(temp[0] != '/'){
		strcat(fullName,temp);
	}
	else{
		strcpy(fullName,temp);
	}



	//printf("Sending %s to opendir\n", fullName );

	fd = (uint64_t)syscall_2(SYS_open, (uint64_t) fullName, O_DIRECTORY | O_RDONLY);

	//printf("Leaving opendir errno : %d\n",errno );


	if(fd == -1){
		return (void*)NULL;
	}



	//dir_traverse = 0;
	//nread = -1;
	// if (*fd < 0) {
	// 	//printf("Error opening dir \n");
	// 	errno = -*fd;
	// 	return (void*) NULL;
	// } else {
	// 	//printf("Succeded in opendir. Fd = %p...Opened %s\n",fd,name);
	// 	return (void*) fd;

	// }

	return (void*) fd;

}
uint64_t test(uint64_t n, uint64_t a1, uint64_t a2, uint64_t a3){


	//printf("Inside test\n");


	uint64_t ret;
	__asm__("movq %1,%%rax;"
			"movq %2,%%rdi;"
			"movq %3,%%rsi;"
			"movq %4, %%rdx;"
			"int $0x80;"
			"movq %%rax,%0;"
			:"=r"(ret):"m"(n),"m"(a1),"m"(a2),"m"(a3));
	return ret;


}




struct dirent* readdir(void *dir){

	char buff[1024];

	int ret = test(78,(uint64_t)dir,(uint64_t)buff,(uint64_t)1024);

	//printf("Ret value %d\n", ret );

	if(ret == -1){

		//Error
		printf("Error while reading directory\n");
		return NULL;

	}

	else if (ret == 0){

		//End of directory stream
		return NULL;

	}

	else if(ret !=0){

		//There is a valid child
		struct dirent* x = (struct dirent*)buff;
		//printf("Name of entry dir%s\n",x->d_name );
		return x;
	}


	return NULL;

}







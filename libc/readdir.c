#include <stdio.h>
#include <sys/syscall.h>
#include <syscall.h>
#include <stdlib.h>
#include <errno.h>
#include <stdlib.h>
#include <string.h>


	
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

	if((uint64_t)dir == -1){

		printf("Bad directory stream\n");
		return NULL;
	}


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
		//printf("Ret of readdir is not 0\n");
		struct dirent* x = (struct dirent*)buff;
		//printf("Name of entry dir%s\n",x->d_name );
		return x;
	}


	return NULL;

}







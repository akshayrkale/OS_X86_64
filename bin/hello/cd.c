#include <stdio.h>
#include <stdlib.h>
#include <memory.h>
#include <stringTokenizer.h>
#include <parser.h>
#include <errno.h>
#include <string.h>
#include <shell.h>


void changedir(char* dir){

	int ret;
	ret = chdir(dir);

	if(ret <0){

		//printf("Could not change the directory\n");
		stderr(errno);

	}



}

#include <stdio.h>
#include <stdlib.h>

void cat(char* filename){


	int fd = open(filename,O_RDONLY);
	char buff[1024];
	if(fd > 0){

		read(fd,buff,1024);
		printf("%s\n",buff);
	}
	else{

		
	}

}
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <sys/utils.h>


int main(int argc, char** arg2, char** envp)
{



	int pid = fork();

	int pipeFD[2];
	pipe(pipeFD);


	if(pid==0){


		dup2(pipeFD[1],1);
		close(pipeFD[0]);

		printf("This is child writing into pipe\n");

	}
	else{

		// //parent reads
		// int i=499999;
		// while(i--);

		char buff[100];
		int status;

		waitpid(pid,&status,0);

		close(pipeFD[1]);
		read(pipeFD[0],buff,100);

		printf("In parent Read :%s\n",buff);



	}



return 0;
}

#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>
#include <test.h>



void file_read_test_case(){

	int fd = open("mnt/sample",O_RDONLY);

	printf("In open fd: %d",fd);
	char buff[100];

	int x = read(fd,buff,100);

	printf("After read bytes read %d read: %s",x,buff);

	close(fd);

	read(fd,buff,100);

	//int fd2 = open("mnt/sample",O_RDONLY);
	//printf("In open fd: %d",fd2);

}



void directroy_test_case(){


	void *dir = opendir("/bin");

	//printf("In main %d \n",(uint64_t)dir );

	//dir = dir;

	struct dirent* entry;

	

	while((entry=readdir(dir))!=NULL){

		printf("Name %s\n",entry->d_name );
	}

	closedir(dir);
	//readdir(dir);
}


void pipe_test_case(){

	//printf("IN PIPE TEST CASE\n");
	int pipeFD[2];

	pipe(pipeFD);

	//printf("pipeFD[0] %d pipeFD[1]: %d\n",pipeFD[0],pipeFD[1] );

	int pid = fork();

	if(pid == 0){

		int i = 499999;
		while(i--);

		char output_buff[10];
		close(pipeFD[1]);
		read(pipeFD[0],output_buff,6);
		printf("In child0 read: %s",output_buff);
		//close(pipeFD[0]);
	}

	else{

		printf("In Parent0\n");
		char buff[10]="ABCDEF";
		close(pipeFD[0]);
		write(pipeFD[1],buff,6);

		//close(pipeFD[1]);
	}


	int pipeFD2[2];

	pipe(pipeFD2);

	//printf("pipeFD[0] %d pipeFD[1]: %d\n",pipeFD[0],pipeFD[1] );

	int pid2 = fork();

	if(pid2 == 0){

		int i = 499999;
		while(i--);

		char output_buff2[10];
		close(pipeFD[1]);
		read(pipeFD2[0],output_buff2,6);
		printf("In child1 read: %s",output_buff2);
	}

	else{

		printf("In Parent1\n");
		char buff2[10]="PQRSTUVW";
		close(pipeFD[0]);
		write(pipeFD2[1],buff2,7);


	}

	
}

int main(int argc, char* argv[], char* envp[])
{
//printf("In Malluaunty");

//file_read_test_case();
//directroy_test_case();
//cd_test_case();
//fork_test_case();
pipe_test_case();

return 0;
}


void fork_test_case(){

	printf("In fork\n");

	char buff[100];

	int fd = open("mnt/sample",O_RDONLY);


	int pid = fork();

	if(pid == 0){


		read(fd,buff,10);
		printf("In child : %s\n",buff);


	}

	else{

		read(fd,buff,10);
		printf("In parent : %s\n",buff);


	}







}


#include <stdio.h>
#include <stdlib.h>
void ls(){

        //printf("In LS\n");
        char buff[100];

            getcwd(buff,100);

                printf("%s\n",buff );

                    void * dir = opendir(buff);

                        struct dirent *entry;

                            while((entry = readdir(dir)) != NULL){

                                        printf("Name of dir %s\n", entry->d_name);
                                            }
}

int fact(int n)
{
    if (n==0|| n==1)
        return 1;

return fact(n-1)+fact(n-2);
}
int main(int argc, char* argv[], char* envp[])
{
//char buf[200];
//int fd=open("/mnt/tp.txt",O_RDONLY);
//printf("after open fd %d",fd);
//read(fd,buf,200);
//close(fd);
//printf("After close fd %d",fd);
//read(fd,buf,200);
/*
void *dir = opendir("/");
struct dirent* entry=0;
while((entry=readdir(dir))!=NULL){
    printf("NAME: %s",entry->d_name);
        }
closedir(dir);*/

//ls();
//printf("Bytes READ:%s",buf);


        int pipeFD[2];

            pipe(pipeFD);

                int status;


                    int pid = fork();

                        if(pid == 0){

                                    //printf("In parent process\n");
                                    close(pipeFD[0]);
                                    dup2(pipeFD[1],1);
                                    printf("This is child writing in pipe\n");

                                  }

                            else{

                                  char buff[100];
                                   close(pipeFD[1]);
                                  waitpid(pid,&status,0);
                                  int i=4999999;
                                  while(i--);
                                       printf("The parent has woken up\n");
                                                                        read(pipeFD[0],buff,100);
                                                                                printf("The child wrote: %s\n",buff);

                                                                                    }




/*
       int pid = fork();

        if(pid == 0){
             int i = 499999;
             while(i--);
         ps();
            execve("/bin/malluaunty",NULL,NULL);
            printf("Child done\n");
       }
       else{
        int j = 9999;
        while(j--);
        printf("Parent done\n");
     }



printf("In fork\n");

	char buff[100];

    void * fd = opendir("/");
    struct dirent* entry;
        while((entry=readdir(fd))!=NULL){
            printf("Name: %s  ",entry->d_name);
        }
	int pid = fork();

	if(pid == 0){

        
	//	read(fd,buff,10);
		printf("In child : %s\n",buff);
        

	}

	else{

		//read(fd,buff,10);
		printf("In parent : %s\n",buff);


	}

*/

}
/*
int main (int argc, char* argv[], char* envp[])
{
  int k=9;
  k=k+1;

printf("In Hello%d",k);
char buf[100];

int fd=open("/mnt/tp.txt",O_RDONLY);
read(fd,buf,50);
printf("Bytes READ:%s",buf);
k=fork();
if(k==0)
    printf("in child process");
if(k>0)
    printf("In parent of child:%d",k);
return 0;
//while(1);
}  */  
 
 /*int a,c=0;
               
    a=1;
    k=9+a;
    __asm__("movq $12,%r13;"
    		"movq $15,%r14;");
    //while(1);
    printf("\nHi this is santosh %d",a);
    return k+c;*/



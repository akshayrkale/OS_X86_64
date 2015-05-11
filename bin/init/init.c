#include<stdio.h>
#include<stdlib.h>
#include<string.h>
int main(int argc, char** arg2, char** envp)
{
    
    
    int pid=fork();
    if(pid==0)
    {
        char* envp[2];
        envp[0]=(char*)malloc(10);
        envp[1]=NULL;
        strcpy(envp[0],"PATH=/bin");
        char* arg2[2];
        arg2[0]=(char*)malloc(10);
        arg2[1]=NULL;
        strcpy(arg2[0],"/bin/sh");
	    
        execve("/bin/sh",arg2,envp);
    }
    else
    {
            int status=0;
            waitpid(2,&status,0);
    }

    printf("\n\n \tSYSTEM SHUTTING DOWN...BYE");
    while(1);
}

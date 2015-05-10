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
        envp[1]=NULL;        
        execve("/bin/sh",NULL,envp);
    }
    else
    {
            int status=0;
            waitpid(2,&status,0);
    }

    printf("\n\n \tSYSTEM SHUTTING DOWN...BYE");
    while(1);
}

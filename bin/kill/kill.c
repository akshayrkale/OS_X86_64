#include<stdlib.h>
#include<stdio.h>
#include<string.h>
#include<sys/utils.h>

int main(int argc, char** argv, char** envp)
{
if(argc!=3)
{
    printf("\nWrong Number of Arguments\n KILL:USAGE: \"kill -9 pid\"");
    exit(0);
}


if(strcmp(argv[1],"\\9")!=0)
{
    printf("\nSecond Argument Wrong\n KILL:USAGE: \"kill -9 pid\"");
    exit(0);
}
    
int pid=stoi(argv[2]);
if (kill(pid)==0)
    printf("\n%d process Killed Successfully.\n",pid);

}

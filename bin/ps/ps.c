#include<stdlib.h>
#include<stdio.h>
#include<string.h>
#include<sys/utils.h>


int main(int argc, char** arg2, char** envp)
{

printf("Argc in ps: %d at %p",argc,&argc);

 if(argc!=1)
 {
      printf("\nWrong Number of Arguments\n PS:USAGE: \"ps\"");
     exit(0);
 }


ps();
return 0;
}

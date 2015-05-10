#include <stdio.h>
#include <stdlib.h>
#include <test.h>
#include <errno.h>
#include <string.h>

void parallel_fork(){



    //int *pipe = (int*)malloc(4*sizeof(int));


}


int fact(int n)
{
    if(n==0 || n==1)
        return 1;
    int ret =fact(n-1)+fact(n-2);
    printf("returning %d ",ret);
    return ret;
    
}
int main11(int argc, char* argv[], char* envp[])
{

fact(10);

    /*
#define tot 2
	
//     dup2_test_case();
//    parallel_fork();
    int pid[tot] ;

    int i;
    int p;
    int status=(uint64_t)&p;

    for(i=0;i<tot;i++){


        pid[i] = fork();

       if(pid[i] == 0){

            execve("/bin/malluaunty",NULL,NULL);

        }

      }
    status=status;
     for(i=0;i<tot;i++)
     {
         printf("chpid[%d]= %d",0,pid[0]);
         waitpid(pid[i],&status,0);
   }
printf("\n***PARENT EXITNG***\n");*/

return 0;
}





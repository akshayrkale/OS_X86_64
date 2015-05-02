#include <stdio.h>
#include <stdlib.h>
int k;
int main (int argc, char* argv[], char* envp[])
{
  int k=9;
  k=k+1;

printf("In Hello%d",k);
k=fork();
if(k==0)
    printf("in child process");
if(k>0)
    printf("In parent of child:%d",k);
return 0;
//while(1);
    
 
 /*int a,c=0;
               
    a=1;
    k=9+a;
    __asm__("movq $12,%r13;"
    		"movq $15,%r14;");
    //while(1);
    printf("\nHi this is santosh %d",a);
    return k+c;*/

}

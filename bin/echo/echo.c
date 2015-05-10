#include<stdio.h>
#include<stdlib.h>

int main(int argc, char** arg2, char** envp)
{
int i=0;
while(arg2 && arg2[i]!=NULL)
    printf("%s",arg2[i]);

return 0;
}

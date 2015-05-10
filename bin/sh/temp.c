#include<stdlib.h>
#include<stdio.h>
int main2 (int argc, char *argv[], char* envp[])
{
char* s=(char*)malloc(10);

printf("s=%d",s);
return 0;
}

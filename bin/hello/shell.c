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

    ls();
//printf("Bytes READ:%s",buf);
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



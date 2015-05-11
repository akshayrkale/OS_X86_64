
#include <stdio.h>
#include <stdlib.h>

int main(int argc,char *argv[],char*envp[]){
    
    //printf("IN LS: argv1:%s",argv[0]);
    //printf("In LS\n");
    //char buff[100];
    
    //getcwd(buff,100);

    //printf("CWD: %s\n",buff);

    void * dir = opendir(argv[0]);

    struct dirent *entry;

    printf("Directory Listing: \n");

    while((entry = readdir(dir)) != NULL){

        printf("%s\n", entry->d_name);
    }

}

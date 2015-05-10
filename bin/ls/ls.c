
#include <stdio.h>
#include <stdlib.h>

int main(int argc,char *argv[],char*envp[]){

    //printf("In LS\n");
    char buff[100];

    getcwd(buff,100);

    void * dir = opendir(buff);

    struct dirent *entry;

    printf("Directory Listing: \n");

    while((entry = readdir(dir)) != NULL){

        printf("%s\n", entry->d_name);
    }

}

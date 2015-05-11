#include <sys/defs.h>
#include <sys/syscall.h>
#include <syscall.h>
#include <errno.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

int chdir(const char *path){

    int retvalue;

    //char pathToSend[100];
    //strcpy(pathToSend,path);

    //printf("In libc PATH: %s\n", pathToSend );
    retvalue=syscall_1(SYS_chdir,(uint64_t)path);

    if(retvalue >=0){
        return retvalue;
    }
    //errno = -retvalue;
    return -1;

}

#include <sys/defs.h>
#include <sys/syscall.h>
#include <syscall.h>
#include <stdlib.h>

void exit(int status){

	syscall_1(SYS_exit,status);


}

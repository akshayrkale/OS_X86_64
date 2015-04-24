#include <sys/defs.h>
#include <syscall.h>
#include <stdlib.h>
#include <sys/syscall.h>

void exit(int status){

	syscall_1(SYS_exit,44);


}

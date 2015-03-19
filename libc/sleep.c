#include<sys/defs.h>
#include<sys/syscall.h>
#include<syscall.h>
#include<stdlib.h>

struct timespec
{
	unsigned int tv_sec;
	int64_t tv_nsec;
};
unsigned int sleep(unsigned int sec)
{
	//printf("calling sleep");
	int retvalue;
	struct timespec t= {0,0};
	t.tv_sec = sec;
	t.tv_nsec = (sec - t.tv_sec)*1000000000;
	retvalue =  syscall_1(SYS_nanosleep, (uint64_t)&t);
	//printf("sleep ret:%d",-retvalue);

	if(retvalue >=0){
		return retvalue;
	}
	errno = -retvalue;
	return -1;

}

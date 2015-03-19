#include<stdio.h>
#include<sys/syscall.h>
#include<syscall.h>
#include<stdlib.h>
#include<errno.h>
#include<stdlib.h>

static int dir_traverse = 0;
static int nread = -1;
struct dirent *readdir(void *dir) {

	//nread = -1;
	int fd;
	fd = *((int*) dir); //get the fd for the dir pointer
	static char buf[1024];
	struct dirent *d;

	if (dir_traverse >= nread) {

		dir_traverse = 0;
		nread = -1;
		nread = syscall_3(SYS_getdents, fd, (uint64_t) buf, 1024);

	}

	if (nread == -1) {
		//printf("Error in getdents\n");
	}
	if (nread == 0) {

		// end of records
		//printf("Directory exhausted\n");
		//errno = EBADF;
		return (struct dirent *) NULL;
	}

	//printf("Processing record %d\n",i);
	d = (struct dirent *) (buf + dir_traverse);
	//printf("File =%s   Value of i = %d\n", d->d_name, dir_traverse);
	dir_traverse += d->d_reclen;
	return (struct dirent *) d;
}

void *opendir(const char *name)
{

	int* fd = malloc(sizeof(int));

	*fd = syscall_2(SYS_open, (uint64_t) name, O_DIRECTORY | O_RDONLY);
	dir_traverse = 0;
	nread = -1;
	if (*fd < 0) {
		//printf("Error opening dir \n");
		errno = -*fd;
		return (void*) NULL;
	} else {
		//printf("Succeded in opendir. Fd = %p...Opened %s\n",fd,name);
		return (void*) fd;

	}

}


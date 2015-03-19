#include <errno.h>
#include <sys/defs.h>
#include <stdio.h>

int64_t stderr(int err)
{

	switch(err)
	{

	case EPERM    : return  printf("Operation not permitted \n");
	case ENOENT   : return  printf("No such file or directory \n");
	case ESRCH    : return  printf("No such process \n");
	case EINTR    : return  printf("Interrupted system call \n");
	case EIO      : return  printf("error \n");
	case ENXIO    : return  printf("No such device or address \n");
	case E2BIG    : return  printf("Argument list too long \n");
	case ENOEXEC  : return  printf("Exec format error \n");
	case EBADF    : return  printf("Bad file number \n");
	case ECHILD   : return  printf("No child processes \n");
	case EAGAIN   : return  printf("Try again \n");
	case ENOMEM   : return  printf("Out of memory \n");
	case EACCES   : return  printf("Permission denied \n");
	case EFAULT   : return  printf("Bad address \n");
	case ENOTBLK  : return  printf("Block device required \n");
	case EBUSY    : return  printf("Device or resource busy \n");
	case EEXIST   : return  printf("File exists \n");
	case EXDEV    : return  printf("Cross-device link \n");
	case ENODEV   : return  printf("No such device \n");
	case ENOTDIR  : return  printf("Not a directory \n");
	case EISDIR   : return  printf("Is a directory \n");
	case EINVAL   : return  printf("Invalid argument \n");
	case ENFILE   : return  printf("File table overflow \n");
	case EMFILE   : return  printf("Too many open files \n");
	case ENOTTY   : return  printf("Not a typewriter \n");
	case ETXTBSY  : return  printf("Text file busy \n");
	case EFBIG    : return  printf("File too large \n");
	case ENOSPC   : return  printf("No space left on device \n");
	case ESPIPE   : return  printf("Illegal seek \n");
	case EROFS    : return  printf("Read-only file system \n");
	case EMLINK   : return  printf("Too many links \n");
	case EPIPE    : return  printf("Broken pipe \n");
	case EDOM     : return  printf("Math argument out of domain of func \n");
	case ERANGE   : return  printf("Math result not representable \n");
	case ENAMETOOLONG:	return printf(" The path is too long to search \n");
	
	//return printf("error occured.\n");
	}
return 0;
}

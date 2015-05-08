#include <stdio.h>
#include <stdlib.h>
#include <errno.h>



int strlen(const char *str)
{
	const char *ptr=str;
	for(;*ptr != '\0'; ptr++);

	return ptr-str;
}

char* strcpy(char* dst, const char* src)
{
	////printf("In strcpy\n");
	int i, len=strlen(src);
	//printf("In strlen.... length of src %d\n",len);
	char* ptr=dst;

	for(i=0; i<=len; i++)
	{
		*ptr++ = src[i];
	}
	return dst;
}


int strcmp(const char *str1, const char *str2)
{

	while(1)
	{
		////printf("In strcmp\n");

		if(*str1 != *str2)
			return (*str1 - *str2);

		else if((*str1 == *str2) && (*(str1+1) == *(str2 + 1)) && (*(str1 + 1) == '\0'))
			return 0;


		str1++;
		str2++;

	}

	return 0;
}

const char *strstr(const char *haystack, const char *needle)
{

	//printf("In strstrt\n %s %s\n\n", haystack,  needle);
	int len = strlen(haystack), i, j;
	for(i=0; i< len; i++)
	{
		for(j = i; j< strlen(needle); j++)
		{
			if(*(haystack+i+j) != *(needle+j))
				break;
		}	

		if( (j == strlen(needle) ) && (*(haystack+i+j-1) == *(needle+j-1)))
		{
			return (haystack + i);
		}
	}

	return NULL;
}

char *strcat(char *dst, const char *src)
{
	strcpy(&dst[strlen(dst)],src);
	//printf("after cat: %s\n\n\n",dst);
	return dst;
}

uint64_t strerror(int err)
{

	switch(err)
	{

	case EPERM    : {return  printf("Operation not permitted \n");break;}
	case ENOENT   : {return  printf("No such file or directory \n");break;}
	case ESRCH    : {return  printf("No such process \n");;break;}
	case EINTR    : {return  printf("Interrupted system call \n");break;}
	case EIO      : {return  printf("error \n");;break;}
	case ENXIO    : {return  printf("No such device or address \n");break;}
	case E2BIG    : {return  printf("Argument list too long \n");break;}
	case ENOEXEC  : {return  printf("Exec format error \n");break;}
	case EBADF    : {return  printf("Bad file number \n");break;}
	case ECHILD   : {return  printf("No child processes \n");break;}
	case EAGAIN   : {return  printf("Try again \n");;break;}
	case ENOMEM   : {return  printf("Out of memory \n");;break;}
	case EACCES   : {return  printf("Permission denied \n");break;}
	case EFAULT   : {return  printf("Bad address \n");;break;}
	case ENOTBLK  : {return  printf("Block device required \n");break;}
	case EBUSY    : {return  printf("Device or resource busy \n");break;}
	case EEXIST   : {return  printf("File exists \n");;break;}
	case EXDEV    : {return  printf("Cross-device link \n");break;}
	case ENODEV   : {return  printf("No such device \n");break;}
	case ENOTDIR  : {return  printf("Not a directory \n");break;}
	case EISDIR   : {return  printf("Is a directory \n");break;}
	case EINVAL   : {return  printf("Invalid argument \n");break;}
	case ENFILE   : {return  printf("File table overflow \n");break;}
	case EMFILE   : {return  printf("Too many open files \n");break;}
	case ENOTTY   : {return  printf("Not a typewriter \n");break;}
	case ETXTBSY  : {return  printf("Text file busy \n");break;}
	case EFBIG    : {return  printf("File too large \n");break;}
	case ENOSPC   : {return  printf("No space left on device \n");break;}
	case ESPIPE   : {return  printf("Illegal seek \n");break;}
	case EROFS    : {return  printf("Read-only file system \n");break;}
	case EMLINK   : {return  printf("Too many links \n");break;}
	case EPIPE    : {return  printf("Broken pipe \n");break;}
	case EDOM     : {return  printf("Math argument out of domain of func \n");break;}
	case ERANGE   : {return  printf("Math result not representable \n");break;}
	case ENAMETOOLONG:	{return printf(" The path is too long to search \n");break;}
	
	//return printf("error occured.\n");
	}
return 0;
}
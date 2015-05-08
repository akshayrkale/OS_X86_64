#include <sys/sbunix.h>

int kstrlen(const char *str)
{
	const char *ptr=str;
	for(;*ptr != '\0'; ptr++);

	return ptr-str;
}

char* kstrcpy(char* dst, const char* src)
{
	////printf("In strcpy\n");
	int i, len=kstrlen(src);
	//printf("In strlen.... length of src %d\n",len);
	char* ptr=dst;

	for(i=0; i<=len; i++)
	{
		*ptr++ = src[i];
	}
	return dst;
}


int kstrcmp(const char *str1, const char *str2)
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

const char *kstrstr(const char *haystack, const char *needle)
{

	//printf("In strstrt\n %s %s\n\n", haystack,  needle);
	char* ret = 0;
	int len = kstrlen(haystack), i, j;
	for(i=0; i< len; i++)
	{
		for(j = i; j< kstrlen(needle); j++)
		{
			if(*(haystack+i+j) != *(needle+j))
				break;
		}	

		if( (j == kstrlen(needle) ) && (*(haystack+i+j-1) == *(needle+j-1)))
		{
			return (haystack + i);
		}
	}

	return ret;
}

char *kstrcat(char *dst, const char *src)
{
	kstrcpy(&dst[kstrlen(dst)],src);
	//printf("after cat: %s\n\n\n",dst);
	return dst;
}

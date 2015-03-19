#include<stdio.h>
#include<stdlib.h>
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

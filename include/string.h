
#ifndef STRING_H_
#define STRING_H_
#include <sys/defs.h>
char* strcpy(char* dst, const char* src);
int strlen(const char *str);
int strcmp(const char *str1, const char *str2);
char *strstr(const char *haystack, const char *needle);
char* strcat(char *dst, const char *src);
uint64_t strerror(int);
#endif

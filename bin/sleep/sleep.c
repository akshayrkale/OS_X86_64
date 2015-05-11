#include <stdlib.h>
#include <stdio.h>


long stoi(const char *s) 
{
    long i;
    i = 0;
    while(*s >= '0' && *s <= '9')
    {   
        i = i * 10 + (*s - '0');
        s++;
    }   
    return i;
}


int main(int argc, char** arg2, char** envp)
{

	//printf("Going to sleep for %s",arg2[1]);
	sleep(stoi(arg2[1]));
	printf("Sceduleed after sleep");

}


#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc,char *argv[],char*envp[]){
    
	
		//sleep(1);
    char buff[100];
    read(0,buff,100);
    strcat(buff,"FILTER");
    printf("%s\n",buff);
	return 0;
}

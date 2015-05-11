
#include <stdio.h>
#include <stdlib.h>

int main(int argc,char *argv[],char*envp[]){
    
	// unsigned long int i = 499999;
	// while(i--){
		//printf("%d",i );
	//}
	//sleep(3);
    char buff[100];
    read(0,buff,100);
    printf("Consumer read:%s\n",buff);
	return 0;
}

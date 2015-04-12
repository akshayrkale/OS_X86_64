#include <stdlib.h>

int main(int argc, char* argv[], char* envp[]);
int tp();
void _start(void) {
	int argc = 1;
	char* argv[0];
	char* envp[0];
	int res;
    res = tp();
	res = res+main(argc, argv, envp);
   
	exit(res);
}

int tp()
{
int a=10;
return a;
}

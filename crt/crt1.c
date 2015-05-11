#include <stdlib.h>
#include <stdio.h>
int main(int argc, char* argv[], char* envp[]);

void _start(void) {
//  int argc = 1;
//  char* argv[0];
//  char* envp[0];
    int res;
//  res = main(0, NULL, NULL);
 volatile uint64_t x=89;
 uint64_t* argcp=(uint64_t*)((char*)&x + 48);
  uint64_t* argvp=(uint64_t*)((char*)argcp+8);
  uint64_t* envp=(uint64_t*)( (*(argcp)+1)*8+(char*)argvp);
printf("bfore:%d at %p ",*argcp, argcp);
//  res=  main(*((uint64_t*)(&x+0x3UL)),(char**)(uint64_t*)(&x+0x5UL), (char **)((&x+5) +  (2*(*(&x+3)+ 1))));
  res=main(*(int*)argcp,(char**)argvp,(char**)envp);

    exit(res);
  }

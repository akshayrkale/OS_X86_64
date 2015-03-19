#ifndef _MEMORY_H
#define _MEMORY_H

#define align4(x) (((((x-1)/16))*16)+16)
#define METADATA_SIZE 32

struct block{
	int size;
	int free;
	int magic;
	struct block* next;
	struct block* prev;
	//void *filler;
	//void *ptr;
	char data[1];
};


typedef struct block *blockPTR;

void heapProfiler();


#endif

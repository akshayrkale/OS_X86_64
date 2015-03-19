#include <memory.h>
#include <stdio.h>
#include <sys/defs.h>
#include <sys/syscall.h>
#include <stdlib.h>
#include <errno.h>
#include<syscall.h>

void *base = NULL;

blockPTR find_block(blockPTR* last,size_t size){

	//printf("In find block... starting search at %x\n",base);
	blockPTR b= base;
	while (b && !(b->free && b->size >= size )) {
		*last = b;
		b = (blockPTR)b->next;
	}
	//printf("Block returned : %x\n",b);
	return (b);
}


blockPTR extend_heap(blockPTR last, size_t size){

	blockPTR currentHeapEnd,newHeapEnd;
	currentHeapEnd = (blockPTR)syscall_1(SYS_brk,(uint64_t)0);	//get current heap brk point

	char* increment=(char*)syscall_1(SYS_brk,0);

	newHeapEnd = (blockPTR)(increment + (METADATA_SIZE + size));
	//printf("New heap end %x\n",newHeapEnd);

	newHeapEnd = (blockPTR)syscall_1(SYS_brk,(uint64_t)newHeapEnd);

	//printf("After xtension...%x\n",syscall_1(SYS_brk,0));

	if(newHeapEnd == currentHeapEnd){

		//Not possible to xtend heap
		//printf("sbrk fails\n");
		return (NULL);

	}

	//system call to extend succeded..

	currentHeapEnd->size = size;
	currentHeapEnd->next = NULL;
	currentHeapEnd->prev =(blockPTR)last;
	currentHeapEnd->magic = 1234;

	if(last){

		/*
		 * The last ptr if not null means that this is not the first time
		 * So we set next of last to current block
		 */
		last->next = (struct block*)currentHeapEnd;
	}
	currentHeapEnd->free=0; //This block is now used

	//printf("Heap extended..Current heap end %x\n",syscall_1(SYS_brk,(uint64_t)0));

	return (currentHeapEnd);

}


void splitblockPTR ( blockPTR b, size_t s){

	/*
	 * This function will split block b and create a free block called "new" of size
	 * b->size - s - METADATA_SIZE
	 *
	 */
	//struct block* temp=NULL;
	//printf("In split.. old block size %x and size: %d",b,b->size);
	blockPTR new; // new is a pointer to the new split block which is free

	//b-> data is a char pointer so that we can increment our pointer in 1 byte granularity
	new = (blockPTR)(b->data + s);

	new ->size = b->size - s - METADATA_SIZE ;

	//Link the new block to next block which was previously b's next
	new ->next = (struct block*)b->next;
	new->prev =(struct block*)b;

	//make new block free
	new ->free = 1 ;
	new->magic = 1234;

	//Modify size of block b which was split into b and new blocks
	b->size = s;
	b->next= (struct block*)new;

	if (new->next){
		new->next->prev = new;
		//temp->prev=(struct block*)new;
	}


	//printf("After split.. old block %x and new block %x\n",b,new);
	//printf("Old block size: %d\n New block size: %d\n",b->size,new->size);

}


blockPTR getblock(void* p){

	char *tmp;
	tmp = p;
	tmp = tmp - METADATA_SIZE;
	p=tmp;
	return (p);

}


blockPTR fuseBlocks(blockPTR b){

	blockPTR  tmp;
	tmp = (blockPTR)b->next;

	//printf("In fuseBlocks...Before fuseBlocks size %d\n",b->size);

	if (b->next && tmp->free ){
		b->size += METADATA_SIZE + tmp->size;
		b->next = (struct block*)tmp->next;
		if (b->next)
			tmp->prev = (struct block*)b;
	}

	//printf("After fuseBlocks size: %d\n",b->size);
	return (b);

}

int valid_addr(void *p){

	void* heapEnd;
	blockPTR temp;
	//printf("In vaild adress. before call p= %d",p);
	heapEnd = (void*)syscall_1(SYS_brk,(uint64_t)0);
	//printf("In vaild adress. before call p= %d",p);
	//printf("In valid address\np = %d\nbase = %d\nheapEnd = %d",p,base,heapEnd);

	if (base)
	{
		//printf("In base \n");
		if ((p > base)&&(p < heapEnd))
		{
			//printf("Valid address\n");
			temp = getblock(p);
			//printf("Address of data block %x\nAddress of Metablock %x:\n",p,temp);
			//printf("ptr poits to %x\n",temp->data);
			return (p == temp->data );
		}
	}
	//printf("Base address %d",base);
	return (0);
}




int brk(void *end_data_segment){

	//printf("\n\nbrk called\n\n");
	blockPTR currentHeapEnd,newHeapEnd;
	currentHeapEnd = (blockPTR)syscall_1(SYS_brk,0);

	newHeapEnd = (blockPTR)syscall_1(SYS_brk,(uint64_t)end_data_segment);

	if(newHeapEnd == currentHeapEnd){
		errno = 12;
		return -1;

	}
	else
		return 0;
}


void free(void *p){

	blockPTR b,temp;
	//heapProfiler();
	//printf("In free. P = %d",p);
	if ( valid_addr(p))
	{
		b = getblock(p);
		//printf("Freeing block %x\n",b);
		b->free = 1;
		temp = (blockPTR)b->prev;
		/* fuseBlocks with previous if possible */
		if(b->prev && temp->free)
			b = fuseBlocks((blockPTR)b->prev );
		/* then fuseBlocks with next */
		if (b->next){
			fuseBlocks(b);
		}
		else
		{
			/* free the end of the heap */
			if (b->prev)
				temp->next = NULL;
			else
				/* No more block !*/
				base = NULL;

			//printf("Heap shrunk by %d bytes\n",b->size);
			brk(b);
		}
	}

}




void *malloc(size_t size){

	blockPTR last; //last keeps track of the the last visited block
	blockPTR b;
	size_t s;
	s = align4(size);


	if(base){
		/*
		 * This is not the first time
		 */
		//printf("Not first block\t..Looking for first fit block\n");
		//1. Look for first fit free block
		last = base; //This is done incase there is no free block last will be uninitialised.
		//So we cant use last to extend_heap

		//Last variable is only modified here
		b = find_block(&last,s);

		if(b){
			// if a block is found then check if we can split it
			if((b->size - s )>=(METADATA_SIZE+16)){
				//printf("Split possible..splitting block %x\n",b);
				//splitblockPTR(b,s);
			}
			b->free = 0;
		}
		else{

			//printf("No fitting block found...Extending heap\n");
			//No fitting block has been found
			b = extend_heap(last,s);
			if(!b){
				return(NULL);
			}
		}
	}
	else{

		/*
		 * This is the first time. Extend heap
		 */
		//printf("First time extend heap\n");
		b = extend_heap(NULL,s);
		if(!b){
			return(NULL);
		}
		base = b; //initialise global base. This is the head of the Heap LL. base is initialised here only
	}

	//printf("End malloc\n");
	return b->data;

}


void heapProfiler(){


	blockPTR temp;
	int freeSize=0,usedSize=0;
	//printf("\n========HEAP PROFILER=======\n");

	if(base){

		temp=(blockPTR)base;

		while(temp!=NULL){

			if(temp->free == 1){
				freeSize += temp->size;
				//printf("Free block %x. Free Size: %d\n",temp,temp->size);
			}
			else if(temp->free == 0){
				usedSize += temp->size;
				//printf("Used block %x. Used Size: %d\n",temp,temp->size);
			}

			temp=(blockPTR)temp->next;
		}

		//printf("\n========Summary Ststistics========\n");
		//printf("Free Blocks size = %d\nUsed Blocks size = %d\n",freeSize,usedSize);

	}



}


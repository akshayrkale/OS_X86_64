#include <sys/sbunix.h>
#include <sys/defs.h>
#include <sys/kstring.h>
#include <sys/file_table.h>
#include <errno.h>
#include <sys/process.h> //for getting the current proc which is needed to get reference to the fd_table
#include <sys/keyboard.h> //to get the ref to kscanf
#include <sys/tarfs.h>
#include <sys/utils.h>
#include <sys/pipe.h>


int pipe(int *pipefd){

	//printf("Inside PIPE\n");

	//create a shared space using malloc
	char pipeBuffer[1024];

	//Find the first free entry in the file_table
	int j=-1;
	while(file_table[++j].present !=0);


	//populate the file descriptor in the file_table with appropiate entries


	//This is the read descriptor

	file_table[j].present = 1;
	file_table[j].type = TYPE_PIPE;
	file_table[j].ref_count = 1;
	file_table[j].pipe.address = (uint64_t)pipeBuffer;
	file_table[j].pipe.readers = 1;
	file_table[j].pipe.writers = 1;
	file_table[j].cursor = 0; //cursor gives the size of the data written/read
	file_table[j].read = pipe_read;
	file_table[j].write = 0; 
	file_table[j].close = pipe_close;
	

	printf("file_table[%d].read: %p\n",j,file_table[j].read );

	//This is the write descriptor

	int k=-1;
	while(file_table[++k].present !=0);

	file_table[k].present = 1;
	file_table[k].type = TYPE_PIPE;
	file_table[k].ref_count = 1;
	file_table[k].pipe.address = (uint64_t)pipeBuffer;
	file_table[k].pipe.readers = 1;
	file_table[k].pipe.writers = 1;
	file_table[k].cursor = 0; //cursor gives the size of the data written/read
	file_table[k].read = 0;
	file_table[k].write = pipe_write; 
	file_table[k].close = pipe_close;

	printf("file_table[%d].write: %p\n",k,file_table[k].write);
	
	//install duplicate pointers

	file_table[k].pipe.duplicateFD = j;
	file_table[j].pipe.duplicateFD = k;

	

	//Fnd the first free entry in the fd_table 
	int fd1=-1;
	while(curproc->fd_table[++fd1] != -1);

	//install the file_table entry in fd_table of the process
	curproc->fd_table[fd1]=j; //read end



	//Find the second free entry in the file_table
	int fd2=-1;
	while(curproc->fd_table[++fd2] != -1);


	curproc->fd_table[fd2]=k; //erite end

	printf("fd1 : %d fd2 : %d",fd1,fd2);
	//printf("file_table_index_read: %d file_table_index_write: %d",file_table[])
	

	//populate the passed pipefd array with the fd_table entry indices.
	pipefd[0]=fd1; //read end
	pipefd[1]=fd2; //write end

	return 0;

}


int pipe_write(int file_table_index,char *buf,int numBytesToWrite){

	int duplicateFD=-1;

	//printf("In pipe write\n");

	//If writing to a read pipe then fail

	if(file_table[file_table_index].write == 0){

		return -1;
	}

	
	//if buffer is full block

	if(file_table[file_table_index].cursor == 1024){

		printf("Buffer is full..Blocking process\n");
		return -1;

	}

	else{

		//buffer is not full. Check if enuf space is there for writing data
		if(1024-file_table[file_table_index].cursor < numBytesToWrite){

			printf("Not enuf space...Blocking\n");
			return -1;
		}
		else{

			//enuf space is there so write out
			kmemcpy((char*)file_table[file_table_index].pipe.address,buf,numBytesToWrite);
			char * ch;
			ch = (char*)file_table[file_table_index].pipe.address;
			ch[numBytesToWrite]='\0';

			//Update cursor in both entries of file_table
			file_table[file_table_index].cursor += numBytesToWrite;

			duplicateFD = file_table[file_table_index].pipe.duplicateFD;

			file_table[duplicateFD].cursor += numBytesToWrite;

			//printf("After writing in pipe\n");

		}


	}

	return numBytesToWrite;

}


int pipe_read(int file_table_index,char* buf, int numBytesToRead){

	
	//printf("In pipe read\n");

	//If reading from a write pipe return BADFD

	if(file_table[file_table_index].read == 0){

		return -1;
	}

	//if all writers have fone to zero read must return 0

	int writers = file_table[file_table_index].pipe.writers;
	if(writers==0){
		return 0;
	}

	//How many bytes can you actually read?
	int bytesCanBeRead;
	int cursor = file_table[file_table_index].cursor;

	if(numBytesToRead > cursor){
		bytesCanBeRead = cursor;
	}
	else{
		bytesCanBeRead = numBytesToRead;
	}


	//Assumption always read from the start of the buffer
	kmemcpy(buf,(char*)file_table[file_table_index].pipe.address,bytesCanBeRead);
	buf[bytesCanBeRead]='\0';

	return bytesCanBeRead;



}

int pipe_close(int fd){

	int file_table_index = curproc->fd_table[fd];
	//int duplicateFD;

	if(file_table[file_table_index].write == 0){

		//We are closing the read end of the pipe
		//printf("Closing read end\n");
		file_table[file_table_index].pipe.readers--;
		// duplicateFD = file_table[file_table_index].pipe.duplicateFD; //referes to the seconf pipe filetable entry
		// file_table[duplicateFD].pipe.readers--;
	}

	else if(file_table[file_table_index].read == 0){

		//We are closing the write end of the pipe
		//printf("Closing write end\n");
		file_table[file_table_index].pipe.writers--;
		// duplicateFD = file_table[file_table_index].pipe.duplicateFD; //referes to the seconf pipe filetable entry
		// file_table[duplicateFD].pipe.writers--;
	}


	if(file_table[file_table_index].pipe.readers==0 && file_table[file_table_index].pipe.writers == 0){

		file_table[file_table_index].ref_count = 0;
	}

	return 0;
}
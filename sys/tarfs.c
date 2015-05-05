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

//int errno = 0; //definition

int numOfEntries = 1; //index into the tarfs table..after tarfs_init() it has the total number of entries in FS


tarfs_entry tarfs_fs[100];
fileTable_entry file_table[10];


void show_fd_table(){


    int i = 0;
    printf("FD TABLE: ");
    for(i=0;i<10;i++){
        printf("%d",curproc->fd_table[i]);
    }
    printf("\n");
}

void show_file_table(int fd){


    //int i = 0;
    printf("FILE TABLE: ");
    
    printf("Inode: %d Refcount: %d Present: %d ",file_table[fd].inode_num,file_table[fd].ref_count,file_table[fd].present);
    
    printf("\n");
}



int get_per_ind(char* dir){

	/*
		This function returns the index of the tarfs_entry array that
		has this directory's parent directory

	*/

    char name[100];
    int len = kstrlen(dir);
    kstrcpy(&name[0], dir);
    len = len-2;
    // print("  {%d} ", len); 
    while(name[len] != '/')
    {
        len--;
        if(len == 0)
            return 0; // 0 is the tarfs table entry for root
    }
    // print("  {%d} ", len); 
    name[++len] = '\0';
    int i = 0;
    while(kstrcmp(&name[0], &(tarfs_fs[i].name[0])) !=  0)
        i++;
    // print("parent {%d}", i);
    return i;
}

int get_per_ind_file(char* dir){

	/*
		This function returns the index of the tarfs_entry array that
		has this file's parent directory

	*/

    char name[100];
    int len = kstrlen(dir);
    kstrcpy(&name[0], dir);
    len = len-1;
    // print("  {%d} ", len); 
    while(name[len] != '/')
    {
        len--;
        if(len == 0)
            return 999;
    }
    // print("  {%d} ", len); 
    name[++len] = '\0';
    int i = 0;
    while(kstrcmp(&name[0], &(tarfs_fs[i].name[0])) !=  0)
        i++;
    // print("parent {%d}", i);
    return i;
}



void tarfs_init(){


	//printf("In tarfs init errno: %d\n",errno );
	int next = 0;
	int i;
	//int sizeOfDirectory = 0;
	
	char name[200];
	

	int sizeOfEntry =0; //size of each entry Rounded up to 512 this is for traversing only
	int actualSize = 0 ; //this gets stored in tarfs table. it is NOT rounded up

	//tarfs_entry tarfs_e;
	int sizeOfFS = 0;

	struct posix_header_ustar* fileSystemEntry = (struct posix_header_ustar *)(&_binary_tarfs_start + next);


	while(1){

		kstrcpy(name,fileSystemEntry->name);

		if(kstrlen(name)==0){

			break;
		}
		
		actualSize = octalToDecimal(stoi(fileSystemEntry->size));
		sizeOfFS = sizeOfFS + actualSize; //for calculating the size of the root fs
		sizeOfEntry = ROUNDUP(octalToDecimal(stoi(fileSystemEntry->size)),512);
		next = next + sizeof(struct posix_header_ustar) + sizeOfEntry;

		kstrcpy(tarfs_fs[numOfEntries].name,name);
		tarfs_fs[numOfEntries].size = actualSize;
		tarfs_fs[numOfEntries].typeflag = stoi(fileSystemEntry->typeflag);
		tarfs_fs[numOfEntries].addr_hdr = (uint64_t)fileSystemEntry;

		if(tarfs_fs[numOfEntries].typeflag == DIRECTORY){

			tarfs_fs[numOfEntries].par_ind = get_per_ind(name);

		}
		else{

			tarfs_fs[numOfEntries].par_ind = get_per_ind_file(name);
		}


		//Update the filestructure to point to the next entry in TARFS

		fileSystemEntry = (struct posix_header_ustar *)(&_binary_tarfs_start + next); 

		numOfEntries++;


	} //end of whle loop



	//loop again for initializing the dierectory structure
	char root[100];
	root[0]='/';
	root[1]='\0';

	for(i=numOfEntries-1;i>=0;i--){

		root[0]='/';
		root[1]='\0';
		
		kstrcat(root,tarfs_fs[i].name);
		//printf("%s\n",root );
		kstrcpy(tarfs_fs[i].name,root);
		//printf("%s\n",tarfs_fs[i].name );
		//kstrcpy(tarfs_fs[i].name,name);
		tarfs_fs[tarfs_fs[i].par_ind].size += tarfs_fs[i].size;

		//tarfs_fs[i].size = sizeOfDirectory;
	}



	//Add entry for the root of the FS

	kstrcpy(tarfs_fs[0].name,"/");
	tarfs_fs[0].size = sizeOfFS;
	tarfs_fs[0].typeflag = 5; //root is a directory
	tarfs_fs[0].addr_hdr = 0; //NOT TO BE TOUCHED IN USER CODE.THIS FILD MEANS NOTHNG
	tarfs_fs[numOfEntries].par_ind = 999; //999 means end of the FS hierarchy

	//Also initialize the file_table entry for 0,1,2
	file_table[0].read = terminal_read;
	file_table[1].write = terminal_write;
	file_table[0].present = 1;
	file_table[1].present = 1;
	file_table[2].present = 1;

//	 i=0;
//	 for(i=0;i<numOfEntries;i++){
//	 	printf("%d.Name: %s Type: %d Size: %d Parent %d\n",i,tarfs_fs[i].name,tarfs_fs[i].typeflag,tarfs_fs[i].size,tarfs_fs[i].par_ind);
//	 }
	
}//end of tarfs_init()


/*
					################# DIRECTORY FUNCTIONS #################
*/


uint64_t kopendir(const char *name){

	/*
		This returns the address of the tarfs structure having the directory
	*/

	
	int i =0;

	char absPath[100];
	convert_to_absolute_path_dir(name,absPath);

	//printf("Path passed :%s\n",name);
	//printf("In open dir abspath : %s\n",absPath);
	

	for(i=0;i<numOfEntries;i++){

		char temp[100];

		kstrcpy(temp,tarfs_fs[i].name);

		if(kstrcmp(temp,absPath)==0 && (tarfs_fs[i].typeflag == DIRECTORY)){
			break;
		}
	}

	//printf("INODE IN FILE OPEN: %d\n",i);
	//i now has the entry of tarfs table corresponding to the file

	if(i==numOfEntries){
		printf("No such file or directory\n");
		return -1;
	}

	int firstFreeFileTableEntry=3;

	//show_file_table(3);

	while(!(file_table[firstFreeFileTableEntry].present == 0 || file_table[firstFreeFileTableEntry].inode_num == i)){
		firstFreeFileTableEntry++;
	}

	if(file_table[firstFreeFileTableEntry].present == 0){

		file_table[firstFreeFileTableEntry].inode_num = i; 
		file_table[firstFreeFileTableEntry].cursor = 0;  //initially set the value of the cursor to the begining of the file
		file_table[firstFreeFileTableEntry].ref_count = file_table[i].ref_count + 1 ; //Assuming extern variables have a default initial value of zero
		file_table[firstFreeFileTableEntry].size = tarfs_fs[i].size;
		file_table[firstFreeFileTableEntry].present = 1;
		file_table[firstFreeFileTableEntry].read = read_file;
		file_table[firstFreeFileTableEntry].write = write_file;
		file_table[firstFreeFileTableEntry].close = close_file;
	}
	else{


		file_table[firstFreeFileTableEntry].ref_count++;

	}
	int j=-1;
	while(curproc->fd_table[++j]!=-1);
	curproc->fd_table[j]=j;


	//show_fd_table();
	//show_file_table(firstFreeFileTableEntry);
	
	return firstFreeFileTableEntry;


}


int kreaddir(void *dir,char* userBuff){


	struct K_dirent ret;
	static int i=0;
	
	
	int file_table_index = (uint64_t)dir;
	//int file_table_index = curproc->fd_table[*(int*)dir];

	int inode_number = file_table[file_table_index].inode_num; //this is the index of tarfs entry in the tarfs_table

	if(curproc->fd_table[file_table_index] == -1){

		//fd was closed
		//printf("In read dir returning -1\n");
		return -1;
	}



	//loop over the fd_table of this process to check if this directory was closed or not?
	//If closed then we must return error EBADF

	// int j=0;
	// for(j=3;j<10;j++){ //Currently we only support 10 entries in the process's fd table

	// 	if(inode_number == curproc->fd_table[j]){
	// 		//the dir is still open. We can continue ahead
	// 		break;
	// 	}
	// }

	// if(j==10){

	// 	//printf("this directory was closed before reading\n");
	// 	return -1;
	// }

	int len=0;
	while(i++<numOfEntries){

		if(tarfs_fs[i].par_ind == inode_number){

			//extract the part of name till last but one / symbol

			len = kstrlen(tarfs_fs[i].name);
			len = len -2;

			while(tarfs_fs[i].name[len] != '/'){

				len--;
			}
			len++;



			kstrcpy(ret.d_name,tarfs_fs[i].name + len);
			kmemcpy(userBuff,&ret,sizeof(struct K_dirent)); //copy the dirent in the user provided buffer
			return (uint64_t)userBuff;
		}

	}

	if(i >= numOfEntries){
		//printf("After one cycle\n");
		i=0;
	}
 
	return 0;

}


/*
					################# DEVICE FUNCTIONS #################
*/


int read_file(int file_table_index,char *buf,int numBytesToRead){

	int readBytes=0; //This is the number of bytes that can be read after considerign cursor position
	int inode_number = file_table[file_table_index].inode_num;

	//printf("In FILE READ\n");
	if(((uint64_t)file_table[file_table_index].size - file_table[file_table_index].cursor) < numBytesToRead){

		readBytes = (uint64_t)file_table[file_table_index].size - file_table[file_table_index].cursor ; 
		numBytesToRead = readBytes ; 
	}
	else{

		readBytes = numBytesToRead ; 
	}


	char* fileSystemEntry = (char*)(tarfs_fs[inode_number].addr_hdr);

	fileSystemEntry = fileSystemEntry + sizeof(struct posix_header_ustar)  + file_table[file_table_index].cursor;

	
	kmemcpy(buf,fileSystemEntry,numBytesToRead);
	buf[numBytesToRead] = '\0';

	//Error conditions to be implemented

	return readBytes;
}

int write_file(int file_table_index,char *buf,int numBytesToWrite){


	printf("Operation not supported for tarfs.Exiting\n");
	return -1;
}

int close_file(int file_table_index){

	file_table[file_table_index].ref_count--; //reduce the ref count as the process has closed this file

	
	curproc->fd_table[file_table_index] = -1;

	//What to do if the ref count goes to zero?
	//If ref count goes to zero remove this entry from file_table
	if(file_table[file_table_index].ref_count == 0){
		file_table[file_table_index].present = 0;
	}

	return 0;

}
int terminal_read(int file_table_index,char *buf,int numBytesToRead){

	//printf("In terminal read\n");
	return kscanf(buf);

}


int terminal_write(int file_table_index,char *buff,int numBytesToWrite){

	//printf("In terninal write\n");
	kprintf((char*)buff,(int)numBytesToWrite);
	return numBytesToWrite;
}

void convert_to_absolute_path_file(const char* path,char* absPath){

	char temp[100];
	temp[0]='/';
	temp[1]='\0';

	//int pathLen = kstrlen(path);

	if(path[0] != '/'){
		kstrcat(temp,path);
	}
	else{
		kstrcpy(temp,path);
	}

	// if(path[pathLen -1 ]!='/'){
	// 	kstrcat(temp,"/");
	// }

	kstrcpy(absPath,temp);

}

void convert_to_absolute_path_dir(const char* path,char* absPath){

	char temp[100];
	temp[0]='/';
	temp[1]='\0';

	int pathLen = kstrlen(path);

	if(path[0] != '/'){
		kstrcat(temp,path);
	}
	else{
		kstrcpy(temp,path);
	}

	if(path[pathLen -1 ]!='/'){
		kstrcat(temp,"/");
	}

	kstrcpy(absPath,temp);

}




/*
					################# TOP LVEL FUNCTIONS #################
*/

int kopen(const char* name){

	/*
		This returns an integer which is the index into the tarfs_fs array
	*/


	int i =0;

	char absPath[100];
	convert_to_absolute_path_file(name,absPath);

	//printf("In open file abspath : %s\n",absPath);
	

	for(i=0;i<numOfEntries;i++){

		char temp[100];

		kstrcpy(temp,tarfs_fs[i].name);

		if(kstrcmp(temp,absPath)==0 && (tarfs_fs[i].typeflag == FILE_TYPE)){
			break;
		}
	}

	//printf("INODE IN FILE OPEN: %d\n",i);

	//i now has the entry of tarfs table corresponding to the file

	if(i==numOfEntries){
		printf("No such file or directory\n");
		return -1;
	}

	int firstFreeFileTableEntry=3;



	while(!(file_table[firstFreeFileTableEntry].present == 0 || file_table[firstFreeFileTableEntry].inode_num == i)){
		firstFreeFileTableEntry++;
	}

	if(file_table[firstFreeFileTableEntry].present == 0){

		file_table[firstFreeFileTableEntry].inode_num = i; 
		file_table[firstFreeFileTableEntry].cursor = 0;  //initially set the value of the cursor to the begining of the file
		file_table[firstFreeFileTableEntry].ref_count = file_table[i].ref_count + 1 ; //Assuming extern variables have a default initial value of zero
		file_table[firstFreeFileTableEntry].size = tarfs_fs[i].size;
		file_table[firstFreeFileTableEntry].present = 1;
		file_table[firstFreeFileTableEntry].read = read_file;
		file_table[firstFreeFileTableEntry].write = write_file;
		file_table[firstFreeFileTableEntry].close = close_file;

	}
	else{


		file_table[firstFreeFileTableEntry].ref_count++;

	}
	int j=-1;
	while(curproc->fd_table[++j]!=-1);
	curproc->fd_table[j]=j;


	//show_fd_table();
	//show_file_table(firstFreeFileTableEntry);
	
	return firstFreeFileTableEntry;
}


int kread(int fd,char* buf, int numBytesToRead){

	
	if(curproc->fd_table[fd] == -1){

		//fd was closed
		errno = EBADF;
		return -1;
	}

	int file_table_index = curproc->fd_table[fd];

	// printf("In read fd passed :%d",fd);
	// printf("file_table_index %d\n",file_table_index );
	// printf("read: %p\n",file_table[file_table_index].read );

	return file_table[file_table_index].read(file_table_index,buf,numBytesToRead);

}

int kwrite(int fd,char* buf, int numBytesToWrite){


	//Top level write function

	//printf("In top level write\n");

	int file_table_index = curproc->fd_table[fd];

	if(curproc->fd_table[fd] == -1){

		//fd was closed
		return -1;
	}

	// printf("file_table_index %d\n",file_table_index );
	// printf("write: %p\n",file_table[file_table_index].write );



	return file_table[file_table_index].write(file_table_index,buf,numBytesToWrite);

}

int kclose(int fd){

	
	if(fd == 0 || fd == 1 || fd == 2){
		return -1; //should not close stdin,stdout,stderr
	}

	int file_table_index = curproc->fd_table[fd];

	return file_table[file_table_index].close(file_table_index);
	
	file_table[file_table_index].ref_count--; //reduce the ref count as the process has closed this file

	
	curproc->fd_table[file_table_index] = -1;

	//What to do if the ref count goes to zero?
	//If ref count goes to zero remove this entry from file_table
	if(file_table[file_table_index].ref_count == 0){
		file_table[file_table_index].present = 0;
	}

	return 0;

}

uint64_t klseek(int fd, uint64_t offset, int whence){

	uint64_t modified_cursor_pos = 0;

	if(curproc->fd_table[fd] == -1){

		//fd was closed
		return -1;
	}


	int file_table_index = curproc->fd_table[fd];

	switch(whence){

		case KSEEK_SET:


			file_table[file_table_index].cursor = offset;
			modified_cursor_pos = offset;
			//printf("In seek set. fd: %d after cursor: %d\n",fd,file_table[file_table_index].cursor);
			break;
		

		case KSEEK_CUR:

			file_table[file_table_index].cursor += offset;
			modified_cursor_pos = file_table[file_table_index].cursor;
			//printf("In seek curr after cursor: %d\n",file_table[file_table_index].cursor);
			break;

		case KSEEK_END:

			file_table[fd].cursor = file_table[file_table_index].size + offset;
			modified_cursor_pos = file_table[file_table_index].cursor ;
			//printf("In seek end after cursor: %d\n",file_table[file_table_index].cursor);
			break;

		default:

			modified_cursor_pos = -1 ; //Invalid whence
			//errno = EINVAL;
			break;
	};

	//

	return modified_cursor_pos;
}


void kgetcwd(char* buff){

    
	kstrcpy(buff,curproc->cwd);

}

int kchdir(char* directoryPath){

	/*
	Search through the tarfs table to see if the directoy is present
	The user can give absolute as well as relative path
	So check "path" as well as "cwd/path"
	Check if the path ends in a directory
	*/

	int i = 0;

	//printf("In chdir PATH PASSED %s\n", path );
	char path[100];
	kstrcpy(path,directoryPath);
	char relativePath[100];
	char absolutePath[100];
	char root[100];
	char temp[100];

	int pathLen = kstrlen(path);
	int cwdPathLength = kstrlen(curproc->cwd);


	/*
		Handle special case fpr .. and . 
		If .. then simply slice of the last part of cwd i.e part from last but one /
		But be careful if the current working directory is / the cd .. should have no
		effect
	*/

	//printf("In kchdir %s <--\n", path );
	if(kstrcmp(path,"..")==0){

		//printf("In .. path\n");

		if(kstrcmp(curproc->cwd,"/")==0){
			//If cwd == / and user does cd .. the cwd remains /
			//printf("Already in root..nothing to do\n");
			return 0;
		}
		else{

			//printf("Moving one step up\n");
			//Find the last but one / character in cwd
			cwdPathLength = cwdPathLength - 2;
			while(curproc->cwd[cwdPathLength] != '/'){

				cwdPathLength--;
			}
			//Modify the cwd to be upto last but one character /
			curproc->cwd[cwdPathLength+1] = '\0';
			return 0;
		}

	}

	else if(kstrcmp(path,".")==0){

		//There is nothing to do. Stay in cwd
		return 0;
	}



	if(path[pathLen-1] != '/'){
		kstrcat(path,"/");
	}

	if(path[0] == '/'){
		kstrcpy(absolutePath,path);
		kstrcpy(temp,path+1);
		kstrcpy(path,temp);
	}
	else{

		//append a / to the beginig of the absolute path
		root[0]='/';
		root[1]='\0';
		kstrcat(root,path);
		kstrcpy(absolutePath,root);

	}
	
	//convert relative path to absolute path wrt current working directory
	kstrcpy(relativePath,curproc->cwd);
	kstrcat(relativePath,path);

	//printf("PATH : %s RELATIVEPATH : %s ABSOLUTEPATH : %s\n",path,relativePath,absolutePath);

	for(i=0;i<numOfEntries;i++){

		if(tarfs_fs[i].typeflag == DIRECTORY){

			if(kstrcmp(relativePath,tarfs_fs[i].name)==0){

				//printf("Found relative path\n");
				kstrcpy(curproc->cwd,relativePath);
				return 0;

			}
			if(kstrcmp(absolutePath,tarfs_fs[i].name)==0){

				//printf("Found absolute path\n");
				kstrcpy(curproc->cwd,absolutePath);
				return 0;
				
			}

		}
		

	}

	printf("No such file or directory\n");
	return -1;


}

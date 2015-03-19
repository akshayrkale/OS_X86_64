#include <stdio.h>
#include <stdlib.h>
#include <memory.h>
#include <stringTokenizer.h>
#include <parser.h>
#include <errno.h>
#include <string.h>
#include <shell.h>




char* find_file_in_dir (char *path, char *file)
{
	struct dirent *entry=NULL;
	char* ret = NULL;
	//ret=NULL;
	void *dir;
	dir = opendir (path);
	if(dir == NULL)
		return (char *)NULL;

	errno = 0;
	//printf("In find_file_in_dir....searching %s\n",path);
	while ((entry = readdir (dir)) != NULL) {
		//printf("entry->dname=%s file=%s",entry->d_name, file);
		if (!strcmp(entry->d_name, file)) {
			ret=malloc(sizeof(strlen(path)+1));
			strcpy(ret,path);
			break;
		}
	}
	if (errno && !entry){
		stderr(errno);
	}

	if(closedir (dir) == -1){

		printf("Fatal error. Could not close a directory\n");

	}


	//printf("In find_file_in_dir....returning %s\n",ret);
	return ret;
}


char* findBinaryFullPath(char* srchPath,char* binaryName){

	/*
	 * If binary name contains . or / or .. then assume user has given absolute path
	 * So psss it ass is to execv
	 * Else if none of the above are there then find the full path
	 *
	 */

	int i;
	char* x=NULL;
	char temp[50];


	//printf("In find full binary path\n");


	//printf("After strstr call. Search Path is :%s \n",srchPath);

	Token* dirToSearch = tokenize(srchPath,":");

	//printf("After tokenize on : Number of tokens %d\n",dirToSearch->numOfTokens);

	for(i=0;i<dirToSearch->numOfTokens;i++){

		//printf("Calling find_file_in_dir token number %d of %d",i,dirToSearch->numOfTokens);
		//printf("\n\npath component 1 %s\n\n",dirToSearch->tokenArr[i]);
		strcpy(temp,dirToSearch->tokenArr[i]);
		//printf("\n\nBefore calling find_file_in_dir %s binary=%s\n",temp, binaryName	);

		x=find_file_in_dir(temp,binaryName);

		if(x!=NULL){

			break;

		}
	}


	return x;


}



/*
void main(){

	char *path = getenv("PATH");
	char *binaryPath = findBinaryFullPath(path,"sudo");
	printf("Binary path = %s",binaryPath);
	my_free(binaryPath);
	heapProfiler();




}
 */

#include <stdio.h>
#include <stdlib.h>
#include <memory.h>
#include <stringTokenizer.h>
#include <parser.h>
#include <errno.h>
#include <string.h>
#include <shell.h>




void print_info (parseInfo *info) {
	//printf("print_info: printing info about parseInfo struct\n");
	//printf("Number of pipe separated commands %d\n",info->pipeNum);


	int i,j;

	for(i=0;i<=info->pipeNum;i++){

		//printf("Command Name : %s\n",info->CommArray[i]->commandName);

		//printf("Command Arguments :\n");
		//printf("Number of arguments %d\n",info->CommArray[i]->VarNum);

		for(j=0;j<info->CommArray[i]->VarNum;j++){
			//printf("Argument %d : %s \n", j,info->CommArray[i]->VarList[j]);
		}

	}

	return;
}

void free_info (parseInfo *info) {
	//printf("free_info: freeing memory associated to parseInfo struct\n");
	free(info);
}

parseInfo* parseModified(char *cmd,char* envp[]){

	parseInfo *Result;
	Token* tokenPipe;
	Token* tokenSpace;
	Token* path;
	singleCommand* sc = NULL;
	char** envVar;
	char *fullPath=NULL;
	int i=0,j=0;
	char srchPath[500];
	//printf("In PARSE MODIFIED");
	Result = (parseInfo*)malloc(sizeof(parseInfo));

	envVar=findEnvVar("PATH",envp);

	//printf("In parser... full PATH= %s\n\n\n",*envVar);

	path=tokenize(*envVar,"=");

	//	printf("PATH is ---> %s",path->tokenArr[1]);



	strcpy(srchPath,path->tokenArr[1]);

	//printf("Seatch PAth is %s",srchPath);

	tokenPipe = tokenize(cmd,"|");

	//printf("In PARSE MODIFIED\n");
	for(i=0;i<tokenPipe->numOfTokens;i++){

		//for each pipe separated token find space separated tokens
		tokenSpace=tokenize(tokenPipe->tokenArr[i]," ");

		//initialize the singleCommand Structure
		sc = (singleCommand*)malloc(sizeof(singleCommand));
		sc->commandName=(char*)malloc(100);
		sc->commandName[0]='\0';
		//printf("Before find full binary path\n\n\n");
		sc->commandName=tokenSpace->tokenArr[0];
		if(strcmp(tokenSpace->tokenArr[0],"set") && strcmp(tokenSpace->tokenArr[0],"cd") && strcmp(tokenSpace->tokenArr[0],"exit") )
		{
			//printf("Loop %d cmd: %s\n\n",i,tokenSpace->tokenArr[0] );

			if(strstr(tokenSpace->tokenArr[0],"/")==NULL){

				fullPath=findBinaryFullPath(srchPath,tokenSpace->tokenArr[0]);
				if(fullPath==NULL)
				{
					printf("Error:Command Not found.\n");
					return NULL;
				}
				sc->commandName = fullPath;
				sc->commandName = strcat(sc->commandName,"/");
				sc->commandName = strcat(sc->commandName,tokenSpace->tokenArr[0]);
			}



		}

		//printf("In parser..fullpath for %s is %s\n",tokenSpace->tokenArr[0],fullPath);


		//printf("COMMAND NAME=%s\n",sc->commandName);
		//sc->VarList[0]=fullPath;
		sc->VarNum = tokenSpace->numOfTokens;
		for(j=0;j<tokenSpace->numOfTokens;j++){
			sc->VarList[j]=tokenSpace->tokenArr[j];
		}
		sc->VarList[j]=NULL;

		Result->CommArray[i]=sc;

	}

	Result->pipeNum=tokenPipe->numOfTokens-1; //set the number of pipe separated commands

	return Result;
}

int read_line(int fd, char* buf)
{
	char *byte=buf;
	int ret = read(fd,byte,1);
	if(ret == 0)
	{
		byte = '\0';
		return -1;
	}
	//printf("read: %c ",*byte);
	while(*byte++!='\n')
	{
		ret = read(fd,byte,1);
		//printf("read: %c ",*byte);
		if (ret == -1)
			return -1;
	}
	*(byte-1)='\0';
	return 1;
}

#include <stdio.h>
#include <stdlib.h>
#include <memory.h>
#include <stringTokenizer.h>
#include <parser.h>
#include <errno.h>
#include <string.h>
#include <shell.h>



char PS1[200]="SBUSH";

int main (int argc, char *argv[], char* envp[])
{

	/*printf(" Agrc is %d\n",argc);
	printf("Argv[0] = %s\n",argv[0]);
	printf("Envp[0] = %s\n\n",envp[0]);
	printf("Starting shell\n");*/


    printf("argc=%d %p %p ",argc,argv,envp);
//    printf("argv=%s",envp[0]);
char cmdLine[MAXLINE];


	int fd=0,ret;

	char temp[20]; //just for storing the command name in case of testing if the command is a builtin or not

	//char x[10] ="akshay";
	parseInfo *info; //info stores all the information returned by parser.
	//printf("Akshay Kale %s, \n",x);
	//exit(0);
    //sleep(10);
//    printf("Argv1is:%s",argv[1]);
int len=strlen(argv[0]);

	if(argv[0][len-3]=='.')
	{
		printf("executing script%s",argv[0]);
		fd=open(argv[1],0);
		printf("opened%d ",fd);
	}

	while(1)
	{
		//cmdLine = "Santosh 1 2 3 | ls -l";

		if(argv[0][len-3]!='.')
		{
			printf("%s> ",PS1);
			read(0,cmdLine,256);
		}
		else
		{
			printf("here");
			read_line(fd, cmdLine);
	
printf("cmdLine=%s",cmdLine);
				while (cmdLine[0] == '#')
{
				ret=read_line(fd,cmdLine);
	printf("cmdLine=%s",cmdLine);
}			if(ret == -1)
				break;
		}
//    strcpy(cmdLine,"malluaunty");
        printf("entered: %s",cmdLine);
    
		if (cmdLine == NULL) {
			printf("Unable to read last command\n");
			continue;
		}

		if(!(*cmdLine)){
			//printf("No command entered\n");
			continue;
		}

		//printf("Calling parser%s",cmdLine);
		info = parseModified(cmdLine,envp);
		if (info == NULL){
			free(cmdLine);
			continue;
		}

		//prints the info struct
		//print_info(info);

		//printf("INFO COMMAND00");
		char buf[50];
        getcwd(buf,50);
        //printf("Command given: %s PWD: %s",info->CommArray[0]->VarList[0],buf);
		strcpy(temp,info->CommArray[0]->commandName);
		//printf("Just bfeore %s<---\n",temp);

		if(strcmp(temp,"set")==0||strcmp(temp,"cd")==0 || strcmp(temp,"exit")==0){

			printf("Executing Builtin command\n");
			executeBuiltins(info,envp);
		}
        else if(strcmp(temp,"/bin/ls")==0)
        {
         
         printf("XXXXXXXXX");
        //strcpy(info->CommArray[0]->VarList[0],temp);
        strcpy(info->CommArray[0]->VarList[0],buf);
        //info->CommArray[0]->VarList[2]=NULL;
        
    	//printf("Calling Execute with %s ",info->CommArray[0]->VarList[1]);
    	printf("Just afterre\n");

        execute_cmd(info,envp);
}
		else{
            printf("Calling Execute with %s",info->CommArray[0]->VarList[0]);
			execute_cmd(info,envp);

		}



		static int loop=0;
		loop++;
		//printf("Out of execute%d\n",loop++);
		//exit(0);
	}/* while(1) */
	//printf("BYE BYE");
	return 0;
}

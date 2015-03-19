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


	char cmdLine[MAXLINE];


	int fd=0,ret;

	char temp[20]; //just for storing the command name in case of testing if the command is a builtin or not

	//char x[10] ="akshay";
	parseInfo *info; //info stores all the information returned by parser.
	//printf("Akshay Kale %s, \n",x);
	//exit(0);

	if(argv[1]!=NULL)
	{
		//printf("executing script");
		fd=open(argv[1],0);
		//printf("opened");
	}

	while(1)
	{
		//cmdLine = "Santosh 1 2 3 | ls -l";

		if(argv[1] == NULL)
		{
			printf("%s> ",PS1);
			read_line(0,cmdLine);
		}
		else
		{
			//printf("here");
			ret=read_line(fd, cmdLine);
			while (cmdLine[0] == '#')
				ret=read_line(fd,cmdLine);
			if(ret == -1)
				break;
		}

		//printf("entered: %s",cmdLine);

		if (cmdLine == NULL) {
			printf("Unable to read last command\n");
			continue;
		}

		if(!(*cmdLine)){
			//printf("No command entered\n");
			continue;
		}

		//calls the parser
		info = parseModified(cmdLine,envp);
		if (info == NULL){
			free(cmdLine);
			continue;
		}

		//prints the info struct
		print_info(info);

		strcpy(temp,info->CommArray[0]->commandName);

		if(strcmp(temp,"set")==0||strcmp(temp,"cd")==0 || strcmp(temp,"exit")==0){

			//printf("Executing Builtin command\n");
			executeBuiltins(info,envp);
		}

		else{
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

#include <stdio.h>
#include <stdlib.h>
#include <memory.h>
#include <stringTokenizer.h>
#include <parser.h>
#include <errno.h>
#include <string.h>
#include <shell.h>

void executeBuiltins(parseInfo* command,char*envp[]){

	/*
	 *
	 * This function executes the builtin functions
	 * cd, set PATH, set PS1 and exit.
	 * It parses the parseInfo struct passed to it and calls the relevant function
	 *
	 */


	//printf("============In executeBuiltin===========\n\n");
	char cmdWithoutSpaces[100];
	//cmdWithoutSpaces[0]='\0';
	char** envVar;

	/*for(i=0;i<command->CommArray[0]->VarNum;i++){

		printf("Token %d : %s\n",i,command->CommArray[0]->VarList[i]);
	}*/



	if(strcmp(command->CommArray[0]->commandName,"set")==0){

		if(strstr(command->CommArray[0]->VarList[1],"PATH")!=NULL){
			//execute change PATH
			//printf("Going to change path");


			if(command->CommArray[0]->VarNum >2){

				printf("Too many arguments to set PATH.Please enter set PATH=ABC:XYX:... (no spaces in between)\n");
				return;
			}


			set(command->CommArray[0]->VarList[1],envp);
			envVar=findEnvVar("PATH",envp);
			printf("Current Path is :\n %s\n",*envVar);


		}
		else if(strstr(command->CommArray[0]->VarList[1],"PS1")!=NULL){
			//execute PS1
			//simple change the shell variable PS1
			//Add function to remove spaces from PS1=hgchbvh

			//printf("Going to change PS1");

			if(command->CommArray[0]->VarNum >2){

				printf("Too many arguments to set PS1.Please enter set PS1=ABCD (no spaces in between)\n");
				return;
			}

			changePS1(command->CommArray[0]->VarList[1]);




		}
	}


	else if(strcmp(command->CommArray[0]->commandName,"exit")==0){

		exit(0);
	}

	else if(strcmp(command->CommArray[0]->commandName,"cd")==0) {
		if(command->CommArray[0]->VarNum >2){

			printf("Too many arguments to cd.Please enter cd <directory name>\n");
			return;
		}


		//execute change directory
		changedir(command->CommArray[0]->VarList[1]);
		getcwd(cmdWithoutSpaces,100);
		printf("Current Working Directory is: %s\n",cmdWithoutSpaces);

	}


	return;


}

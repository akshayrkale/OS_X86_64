#include <stdio.h>
#include <stdlib.h>
#include <memory.h>
#include <stringTokenizer.h>
#include <parser.h>
#include <errno.h>
#include <string.h>
#include <shell.h>

void changePS1(char*str){

	/*
	 * This function changes the PS1 value to str.
	 * It simply copies the value of str to the global array PS1
	 * The PS1 is a shell variable
	 *
	 */

	Token* tokenEqulas;
	tokenEqulas = tokenize(str,"=");
	//printf("no:%d\n\n",tokenEqulas->numOfTokens);

	if(tokenEqulas->numOfTokens < 2)
	{
		printf("Error:Invalid PS1\n");
	}
	else if(strlen(tokenEqulas->tokenArr[1])>100){
		printf("Too long a prompt name.Pleasee try again\n");

	}


	else{

		strcpy(PS1,tokenEqulas->tokenArr[1]);
		printf("PS1 after change %s\n",PS1);
	}

}

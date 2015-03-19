#include <stdio.h>
#include <stdlib.h>
#include <memory.h>
#include <stringTokenizer.h>
#include <parser.h>
#include <errno.h>
#include <string.h>
#include <shell.h>

char** findEnvVar(char* envVar, char* envp[]){

	/*
	 * This function returns the location of the environment variable
	 * envVar in the evnp[]. It returns a pointer, which is a pointer to the array
	 * envp[] that contains a the pointer to the envVar string.
	 * If not found returns null.
	 */

	int count=0;
	Token* tokens;

	//printf("Inside findEnv var\n");

	while(envp[count]!= NULL){

		tokens = tokenize(envp[count],"=");

		//printf("%s\n",envp[count]);

		if(strcmp(tokens->tokenArr[0],envVar)==0){
			return(envp+count);
		}
		free(tokens);
		count++;
	}
	return (char**)NULL;
}

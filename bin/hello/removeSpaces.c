#include<stdio.h>
#include<string.h>
#include<stdlib.h>


char* removeSpaces(char*str){

	/*
	 * This function removes spaces from str without modifying it
	 * The string returned must be malloced
	 */

	int i=0,j=0;
	char *noSpaceStr=NULL;
	char temp[100];


	for(i=0;i<strlen(str);i++){

		if(str[i]!=' '){
			temp[j++]=str[i];
		}

	}
	temp[j]='\0';

	noSpaceStr = malloc(sizeof(char)*(strlen(temp)));
	strcpy(noSpaceStr,temp);

	return noSpaceStr;

}


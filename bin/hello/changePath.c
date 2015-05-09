#include <stdio.h>
#include <stdlib.h>
#include <memory.h>
#include <stringTokenizer.h>
#include <parser.h>
#include <errno.h>
#include <string.h>
#include <shell.h>


char * setPath(char* env,char* path,int mode){

	/*
	 * This function takes the current path "env" and the path to be added/appended "path"
	 * creates the new path as per mode EASIS or EAPPEND
	 * Returns the modified path
	 */

	int newEnvVarLength;
	//char p[500];
	char *new;

	if(mode == EASIS){

		//Calculate new space for the path
		newEnvVarLength = strlen("PATH=") + strlen(path)+1;

		//printf("In setPath.... passed path is :%s:\n newEnvVarLength :%d\n",path,newEnvVarLength);


		//Allocate that space fr the new path
		new = (char*)malloc(sizeof(char)*newEnvVarLength);

		strcpy(new,"PATH=");//copy the old env variable
		strcpy(new+strlen("PATH="),path);


	}
	else{


		//Calculate new space for the path
		newEnvVarLength = strlen(env) + strlen(path)+1;

		//Allocate that space fr the new path
		new = (char*)malloc(sizeof(char)*newEnvVarLength);

		strcpy(new,env);//copy the old env variable
		strcpy(new+strlen(env),":");
		strcpy(new+strlen(env)+1,path);


	}


	//printf("Returning new path from setPath %s\n",new);

	return new;
}



void set(char * args, char** envp){

	char *path=NULL;
	Token* tokenEquals,*tokenColon,*token;
	int i;
	char** envLoc;
	char tokentoPass[500];


	//if cmd comtains $ then assume PATH is given
	//include logic to check for entire string ${PATH} or $PATH


	//printf("In set path\n\n");

	tokenEquals = tokenize(args,"=");

	//=========================================
	//copy the first argument of tokenEquals in a seprate local variable and then pass.

	//UNKNOWN BUG!!!


	/*
	 * Get the location in the envp array where PATH
	 * is stored. We will keep the modified PATH string in this location only.
	 */


	envLoc=findEnvVar("PATH",envp);

	if(tokenEquals->numOfTokens==1){

		//printf("PATH= case.......\n\n");
		strcpy(tokentoPass,"");
		path = setPath(*envLoc,tokentoPass,EASIS);
		//*envLoc=path;
		return;

	}


	strcpy(tokentoPass,tokenEquals->tokenArr[1]);
	//printf("Token to pass after tokenizing on colon is .%s.\n",tokentoPass);
	tokenColon = tokenize(tokentoPass,":");

	//=======================================


	/*
	 * Save the value of PATH in oldSysPath.We will need this
	 * when we need to expand ${PATH}
	 */
	char oldSysPath[500];
	token = tokenize(*envLoc,"=");
	strcpy(oldSysPath,token->tokenArr[1]);



	/*
	 * First element of the tokenColon always needs to be addes ASIS
	 * Check if the component to add is ${PATH}.If yes send oldSysPath
	 */
	if((strcmp(tokenColon->tokenArr[0],"${PATH}")==0)||(strcmp(tokenColon->tokenArr[0],"$PATH")==0)){
		path = setPath(*envLoc,oldSysPath,EASIS);
		//printf("PATH IS %s\n",path);
	}
	else{
		path = setPath(*envLoc,tokenColon->tokenArr[0],EASIS);
	}

	//Assign the newly modified path to envLoc.This causes the envp array to get updated
	*envLoc = path;

	//printf("The new environment is: %s\n", getenv("PATH"));


	//Append the later elements in a loop
	for(i=1;i<tokenColon->numOfTokens;i++){

		//printf("Appending.... %s",tokenColon->tokenArr[i]);

		/*
		 * Check if the component to add is ${PATH}.If yes send oldSysPath
		 *
		 */
		if((strcmp(tokenColon->tokenArr[i],"${PATH}")==0)||(strcmp(tokenColon->tokenArr[i],"$PATH")==0)){
			path = setPath(*envLoc,oldSysPath,EAPPEND);
			//printf("PATH IS %s\n",path);
		}
		else{
			path = setPath(*envLoc,tokenColon->tokenArr[i],EAPPEND);
		}

		//Assign the newly modified path to envLoc.This causes the envp array to get updated
		*envLoc = path;


	}//End of for loop

	//printf("The new environment is: %s\n", getenv("PATH"));
}


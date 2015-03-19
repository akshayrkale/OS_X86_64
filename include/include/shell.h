/*
 * shell.h
 *
 *  Created on: Feb 16, 2015
 *      Author: santosh
 */

#ifndef SHELL_H_
#define SHELL_H_


#define MAXLINE 256
#define EASIS 1
#define EAPPEND 2
#define EPREPEND 3

extern char PS1[200];

//header for executing builtinns and external commands
void execute_cmd(parseInfo *info,char*envp[]);
void executeBuiltins(parseInfo* command,char*envp[]);

//headers for findEnvVar
char ** findEnvVar(char*,char**);

//headers for finding full binary path
char* find_file_in_dir (char *path,char *file);
char* findBinaryFullPath(char* srchPath,char* binaryName);

//header for remove spaces function
char* removeSpaces(char*str);

//headers for getting full binary path
char ** findEnvVar(char*,char**);


//builtins headers

//prototype of path change command
void set(char * , char** );
char * setPath(char* ,char* ,int );

//prototype of PS1 setting command
void changePS1(char*);

//prototype of change directory commands
void changedir(char* dir);

//header for PS1 command
void changePS1(char*);



#endif /* SHELL_H_ */

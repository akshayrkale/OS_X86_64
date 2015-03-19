/*
 * builtIns.h
 *
 *  Created on: Feb 3, 2015
 *      Author: santosh
 */

#ifndef BUILTINS_H_
#define BUILTINS_H_

#define EASIS 1
#define EAPPEND 2
#define EPREPEND 3

//prototype of path change command
void set(char * , char** );
char * setPath(char* ,char* ,int );

//prototype of PS1 setting command
void changePS1(char*);

//prototype of change directory commands
void changedir(char* dir);

//header for PS1 command
void changePS1(char*);




#endif /* BUILTINS_H_ */

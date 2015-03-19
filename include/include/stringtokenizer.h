#ifndef STRINGTOKENIZER_H_
#define STRINGTOKENIZER_H_
 //stringTokenizer.h
/ *
 *  Created on: Feb 2, 2015
 *      Author: santosh
 */

typedef struct {
	int numOfTokens;
	char *tokenArr[50];
} Token;

Token* tokenize(char *, char*);
char * substring(char*, int, int);

#endif

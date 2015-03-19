#include <stdio.h>
#include <stdlib.h>
#include <memory.h>
#include <stringTokenizer.h>
#include <parser.h>
#include <errno.h>
#include <string.h>
#include <shell.h>



int onlyWhiteSpace(char *str){

	//checks if a token is solely composed of white space.
	//if yes returns 1 else returns 0.So that token is not added to the array.

	int i=0;

	while(str[i]!='\0'){

		if(!((str[i]=='\t') || (str[i]==' '))){

			return 0;
		}
		i++;
	}

	return 1;

}


char * substring(char* str, int front, int back){

	//temporary buffer to hold the token;
	char n[500];
	char *p;
	int i=0;

	//Must handle condition of consequtive delims, delim at the end.Not done till now.

	if(back==front){

		return (char*)NULL;

	}

	while(back < front){
		n[i++]=str[back++];
	}
	n[i] = '\0';
//	printf("\n\nIn substring... %s\n\n",n);

	if(onlyWhiteSpace(n)==0){
		p = (char*)malloc(sizeof(char)*(i+1));

		strcpy(p,n);
		//printf("\n\nAfter white space p= %s\n",p);
	}
	else
		p = (char*)NULL;

	return p;

}


Token* tokenize(char *str,char* delim){

	Token* token=(Token*)malloc(sizeof(Token));
	//printf("In Tokenize Printing str %s\n",str);
	int tokenCount=0;
	int front=0,back=0;
	int i=0;
	char *p;

	//printf("IN TOKENIZER");

	while(str[front]!='\0'){

		if(str[front]== *delim){
			//delimiter found. Extract substring.
			p=substring(str,front,back);
			if(p != NULL){
				token->tokenArr[tokenCount++]=p;
				//printf("\nIn tokenizer..appending %s\n",token->tokenArr[tokenCount-1]);
			}

			back = front +1;
			front++;
			//continue;
		}

		else{
			front++;
		}
	}//end while

	p = substring(str,front,back);
	if(p != NULL){
		token->tokenArr[tokenCount++]=p;
	}
	token->numOfTokens=tokenCount;


//	printf("Before Returning Token\n\n");

	for(i=0;i<token->numOfTokens;i++){

		//printf("Token %d : %s\n",i,token->tokenArr[i]);
	}


	return token;

}




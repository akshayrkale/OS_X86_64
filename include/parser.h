#ifndef _PARSER_H
#define _PARSER_H

#define MAX_VAR_NUM 10
#define PIPE_MAX_NUM 10
#define FILE_MAX_SIZE 40
#define MAX_CMD_LEN 10


typedef struct{
	char *commandName;
	char *VarList[MAX_VAR_NUM];
	int VarNum;
}singleCommand;


/* parsing information structure */
typedef struct {
	//int   boolInfile;		       /* boolean value - infile specified */
	//int   boolOutfile;		       /* boolean value - outfile specified */
	//int   boolBackground;		       /* run the process in the background? */
	singleCommand* CommArray[PIPE_MAX_NUM];	/* Array to store individual commands*/
	int   pipeNum;
	//char  inFile[FILE_MAX_SIZE];	       /* file to be piped from */
	//char  outFile[FILE_MAX_SIZE];	       /* file to be piped into */
} parseInfo;

/* the function prototypes */

void print_info(parseInfo *);
singleCommand* parse_command(char *);
int read_line(int fd, char* buf);
parseInfo* parseModified(char *cmd,char* envp[]);

#endif

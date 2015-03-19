#include <stdio.h>
#include <stdlib.h>
#include <memory.h>
#include <stringTokenizer.h>
#include <parser.h>
#include <errno.h>
#include <string.h>
#include <shell.h>



void execute_cmd(parseInfo * info,char*envp[])
{
	int i,j,*pipes=NULL,status;
	char cmd[20][100];

	int  *proc_ids;
	//printf("pipes=%d \n",info->pipeNum);

	for(i=0; i<=info->pipeNum; i++)
	{
		//printf("info: %s\n", info->CommArray[i]->commandName);
		strcpy(cmd[i],info->CommArray[i]->commandName);
		//printf("varnum=%d\n",info->CommArray[i]->VarNum);
		//for(j=0;j<info->CommArray[i]->VarNum; j++)
		//printf("varList=%s\n",info->CommArray[i]->VarList[j]);
	}



	proc_ids = (int *)malloc(info->pipeNum+1);

	if(info->pipeNum==0)
	{
		//printf("forking");


		proc_ids[0]=fork();

		if (proc_ids[0] < 0)
		{
			stderr( errno);
			exit(1);
		}
		if(proc_ids[0]==0)
		{
			//printf("executing %s\n",cmd[0]);

			//printf("Executing Command %s\n",cmd[0]);

			char* envpChildProcess[]={NULL};
			int ret = execve(cmd[0],info->CommArray[0]->VarList,envpChildProcess);
			if(ret == -1)
			{
				stderr(errno);
				exit(1);
			}
		}
		//printf("\ndone\n");
	}
	else
	{

		pipes=(int*)malloc(2*info->pipeNum*sizeof(int));


		for(i=0; i<info->pipeNum; i++)
		{
			if(pipe(pipes+i*2) == -1)
				stderr(errno);
		}
		//printf("Multiple Commands");
		for(i=0; i<=info->pipeNum;i++)
		{
			proc_ids[i]=fork();
			if (proc_ids[i] < 0)
			{
				stderr(errno);
				exit(1);
			}
			//printf("pid=%d",proc_ids[i]);
			if(proc_ids[i]==0)
			{
				//printf("in child%d",i);

				if(i!=0)
				{
					if(dup2(pipes[i*2-2],0)==-1)
						stderr(errno);
				}
				if(i!=info->pipeNum)
				{

					if(dup2(pipes[i*2+1],1)==-1)
						stderr(errno);
				}

				for(j=0;j<info->pipeNum;j++)
				{
					close(pipes[j*2]);
					close(pipes[j*2+1]);
				}
				//printf("debug:%d\n",i);
				//printf("debug:%s ", cmd[i]);


				//printf("Executing Command %s\n",cmd[i]);

				char* envpChildProcess[]={NULL};
				int ret=execve(cmd[i],info->CommArray[i]->VarList,envpChildProcess);
				if(ret == -1)
				{
					stderr(errno);
					exit(1);
				}
			}
		}
		//printf("\nin multiple's parent\n");

		for(i=0;i<info->pipeNum;i++)
		{
			close(pipes[i*2]);
			close(pipes[i*2+1]);
			//printf("closed");
		}
	}
	//printf("\nin singles's parent\n");
	for (i = 0; i <= info->pipeNum; i++)
		waitpid(proc_ids[i], &status, 0);
	//printf("child returned:%d\n",waitpid(proc_ids[i], &status, 0));

}

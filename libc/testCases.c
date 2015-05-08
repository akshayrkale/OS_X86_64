#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>
#include <test.h>



void dup2_test_case(){

	int pipeFD[2];

	pipe(pipeFD);

	int pid=fork();

	//printf("DUP2 TEST CASE\n");

	if(pid!=0){

		//child writes parent reads
		//close(pipeFD[0]);
		printf("In parent process\n");
		dup2(pipeFD[1],1);
		printf("This is parent writing in pipe\n");
		//close(pipeFD[1]);
	}
	else{

		//parent reads
		char buff[100];
		//close(pipeFD[1]);
		uint64_t i = 499999999;
		while(i--);

		read(pipeFD[0],buff,100);

		printf("Child read: %s\n",buff);

		//close(pipeFD[0]);

	}

}


void cd(char *path){

    
    
    // First parse the path to extract all path components separated by /
    int pathLen = strlen(path);

    int forward=0;
    int back = 0;
    char temp[20];
    int i=0;
    int x=0;
    int numOfComponents = 0;

    char components[10][20];

    for(forward=0;forward<pathLen;){
        
        if(forward == 0 && path[forward] == '/'){
            strcpy(components[0],"/");
            back++;
            forward++;
            numOfComponents++;
            continue;
        }

        if(path[forward] == '/'){

            if(path[forward-1] == '/'){
                printf("Malformed path\n");
                return;
            }

            //copy from back till forward-1
            i=0;
            
            x = (forward-back);
            while(i< x){

                temp[i++] = path[back++];
              
            }
            temp[i]= '\0';
            //printf("%s\n", temp );
            
            strcpy(components[numOfComponents],temp);
            //printf("%s\n", &components[0] );
            forward++;
            back = forward;
            numOfComponents++;
            continue;

        }

        forward++;

    } //End of for

    if(path[forward-1] != '/'){

        i=0;
        x = forward-back;
        while(i<x){
            temp[i++]=path[back++];
        }
        temp[i] = '\0';
        strcpy(components[numOfComponents++],temp);
    }

    char buff[100];
    char originalWorkingDirectory[100];
    char toSend[100];

    getcwd(originalWorkingDirectory,100);

   
    i=0;

    
    while(i < numOfComponents){

        if(i == numOfComponents){
            break;
        }

        if(i==0){
            strcpy(toSend,components[i]);
            
            if(chdir(toSend) == -1){
            chdir(originalWorkingDirectory);
            break;
            }
        }

        else if(strcmp(components[i],".")==0){

        	//nothing to do
        	i++;
        	continue;

        }

        else if(strcmp(components[i],"..")==0){

            if(i == numOfComponents){
                break;
            }

            chdir("..");
            getcwd(buff,100);
            strcpy(toSend,buff);
        }


        else{

            if(i == numOfComponents){
                break;
            }


            if(toSend[strlen(toSend)-1] != '/'){
                
                strcat(toSend,"/");
            }
            
            strcat(toSend,components[i]);

            if(chdir(toSend) == -1){
            //Invalid path
            //restore to the cwd
            chdir(originalWorkingDirectory);
            break;
            }
        }

        i = i + 1;

        if(i == numOfComponents){
            break;
        }

    }

}




void ls(){

    //printf("In LS\n");
    char buff[100];

    getcwd(buff,100);

    void * dir = opendir(buff);

    struct dirent *entry;

    printf("Directory Listing: \n");

    while((entry = readdir(dir)) != NULL){

        printf("%s\n", entry->d_name);
    }

    

}


void sleep_test_case(){



    int pid = fork();

    if(pid == 0){

        printf("In child\n");

    }

    else{

        printf("Parent Going to sleep for 5 sec\n");
    int x1 = 2099999999;
    while(x1--);
    printf("Parent is back\n");


    }

    

    
}


void file_read_test_case(){

    int fd = open("mnt/sample",O_RDONLY);

    //printf("In open fd: %d",fd);
    char buff[100];

    int x = read(fd,buff,100);

    printf("After read bytes read %d read: %s",x,buff);

    close(fd);

}


void directroy_test_case(){


    void *dir = opendir("mnt");

    //printf("In main %d \n",(uint64_t)dir );

    //dir = dir;

    struct dirent* entry;

    

    while((entry=readdir(dir))!=NULL){

        printf("Name %s\n",entry->d_name );
    }

    closedir(dir);
    //readdir(dir);
}


void read_line(int fd, char* buf)
{
    // char *byte=buf;
    // int ret = read(fd,byte,1);
    // if(ret == 0)
    // {
    //     byte = '\0';
    //     return -1;
    // }
    // //printf("read: %c ",*byte);
    // while(*byte++!='\n')
    // {
    //     ret = read(fd,byte,1);
    //     //printf("read: %c ",*byte);
    //     if (ret == -1)
    //         return -1;
    // }
    // *(byte-1)='\0';
    // return 1;

    read(0,buf,256);
}
int k=0;
void fork_test_case(){
int i=9;
    printf("In fork\n");

    char buff[100];

    int fd = open("mnt/sample",O_RDONLY);

k=9;
    int pid = fork();

    if(pid == 0){
	i=i+2;


        read(fd,buff,10);
        printf("In child %d: \n",i);


    }

    else{
	i=i+5;
        read(fd,buff,10);
        printf("In parent %d:\n",i);


    }

    printf("Oot fgfgg\n");

} 

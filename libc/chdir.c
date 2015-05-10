
#include <stdio.h>
#include <stdlib.h>

int changedir(char* dir){

    
    
    // First parse the path to extract all path components separated by /

    char path[50] = strcpy(path,dir);

    int pathLen = strlen(path);

    int forward=0;
    int back = 0;
    char temp[20];
    int i=0;
    int x=0;
    int numOfComponents = 0;

    char components[10][20];

    for(forward=0;forward<pathLen;){
        
        if(forward == 0 && path[forward] == '/')
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


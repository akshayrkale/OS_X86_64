
rootfs/bin/sh:     file format elf64-x86-64


Disassembly of section .text:

00000000004000e8 <_start>:
#include <stdlib.h>
#include <stdio.h>
int main(int argc, char* argv[], char* envp[]);

void _start(void) {
  4000e8:	55                   	push   %rbp
  4000e9:	48 89 e5             	mov    %rsp,%rbp
  4000ec:	48 83 ec 30          	sub    $0x30,%rsp
//  int argc = 1;
//  char* argv[0];
//  char* envp[0];
    int res;
//  res = main(0, NULL, NULL);
 volatile uint64_t x=89;
  4000f0:	48 c7 45 d8 59 00 00 	movq   $0x59,-0x28(%rbp)
  4000f7:	00 
 uint64_t* argcp=(uint64_t*)((char*)&x + 48);
  4000f8:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  4000fc:	48 83 c0 30          	add    $0x30,%rax
  400100:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  uint64_t* argvp=(uint64_t*)((char*)argcp+8);
  400104:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  400108:	48 83 c0 08          	add    $0x8,%rax
  40010c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  uint64_t* envp=(uint64_t*)( (*(argcp)+1)*8+(char*)argvp);
  400110:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  400114:	48 8b 00             	mov    (%rax),%rax
  400117:	48 ff c0             	inc    %rax
  40011a:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  400121:	00 
  400122:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  400126:	48 01 d0             	add    %rdx,%rax
  400129:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
//  res=  main(*((uint64_t*)(&x+0x3UL)),(char**)(uint64_t*)(&x+0x5UL), (char **)((&x+5) +  (2*(*(&x+3)+ 1))));
  res=main(*(int*)argcp,(char**)argvp,(char**)envp);
  40012d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  400131:	8b 00                	mov    (%rax),%eax
  400133:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  400137:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  40013b:	48 89 ce             	mov    %rcx,%rsi
  40013e:	89 c7                	mov    %eax,%edi
  400140:	e8 a5 15 00 00       	callq  4016ea <main>
  400145:	89 45 e4             	mov    %eax,-0x1c(%rbp)

    exit(res);
  400148:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  40014b:	89 c7                	mov    %eax,%edi
  40014d:	e8 cc 2b 00 00       	callq  402d1e <exit>
  400152:	c9                   	leaveq 
  400153:	c3                   	retq   

0000000000400154 <changedir>:
#include <errno.h>
#include <string.h>
#include <shell.h>


void changedir(char* path){
  400154:	55                   	push   %rbp
  400155:	48 89 e5             	mov    %rsp,%rbp
  400158:	48 81 ec 40 02 00 00 	sub    $0x240,%rsp
  40015f:	48 89 bd c8 fd ff ff 	mov    %rdi,-0x238(%rbp)

int pathLen = strlen(path);
  400166:	48 8b 85 c8 fd ff ff 	mov    -0x238(%rbp),%rax
  40016d:	48 89 c7             	mov    %rax,%rdi
  400170:	e8 3e 22 00 00       	callq  4023b3 <strlen>
  400175:	89 45 ec             	mov    %eax,-0x14(%rbp)

    int forward=0;
  400178:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    int back = 0;
  40017f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
    char temp[20];
    int i=0;
  400186:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
    int x=0;
  40018d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%rbp)
    int numOfComponents = 0;
  400194:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)

    char components[10][20];

    for(forward=0;forward<pathLen;){
  40019b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  4001a2:	e9 1a 01 00 00       	jmpq   4002c1 <changedir+0x16d>
        
        if(forward == 0 && path[forward] == '/'){
  4001a7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  4001ab:	75 3b                	jne    4001e8 <changedir+0x94>
  4001ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  4001b0:	48 63 d0             	movslq %eax,%rdx
  4001b3:	48 8b 85 c8 fd ff ff 	mov    -0x238(%rbp),%rax
  4001ba:	48 01 d0             	add    %rdx,%rax
  4001bd:	0f b6 00             	movzbl (%rax),%eax
  4001c0:	3c 2f                	cmp    $0x2f,%al
  4001c2:	75 24                	jne    4001e8 <changedir+0x94>
            strcpy(components[0],"/");
  4001c4:	48 8d 85 08 ff ff ff 	lea    -0xf8(%rbp),%rax
  4001cb:	48 8d 35 8e 2f 00 00 	lea    0x2f8e(%rip),%rsi        # 403160 <free+0x55>
  4001d2:	48 89 c7             	mov    %rax,%rdi
  4001d5:	e8 0e 22 00 00       	callq  4023e8 <strcpy>
            back++;
  4001da:	ff 45 f8             	incl   -0x8(%rbp)
            forward++;
  4001dd:	ff 45 fc             	incl   -0x4(%rbp)
            numOfComponents++;
  4001e0:	ff 45 f0             	incl   -0x10(%rbp)
            continue;
  4001e3:	e9 d9 00 00 00       	jmpq   4002c1 <changedir+0x16d>
        }

        if(path[forward] == '/'){
  4001e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  4001eb:	48 63 d0             	movslq %eax,%rdx
  4001ee:	48 8b 85 c8 fd ff ff 	mov    -0x238(%rbp),%rax
  4001f5:	48 01 d0             	add    %rdx,%rax
  4001f8:	0f b6 00             	movzbl (%rax),%eax
  4001fb:	3c 2f                	cmp    $0x2f,%al
  4001fd:	0f 85 bb 00 00 00    	jne    4002be <changedir+0x16a>

            if(path[forward-1] == '/'){
  400203:	8b 45 fc             	mov    -0x4(%rbp),%eax
  400206:	48 98                	cltq   
  400208:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  40020c:	48 8b 85 c8 fd ff ff 	mov    -0x238(%rbp),%rax
  400213:	48 01 d0             	add    %rdx,%rax
  400216:	0f b6 00             	movzbl (%rax),%eax
  400219:	3c 2f                	cmp    $0x2f,%al
  40021b:	75 16                	jne    400233 <changedir+0xdf>
                printf("Malformed path\n");
  40021d:	48 8d 3d 3e 2f 00 00 	lea    0x2f3e(%rip),%rdi        # 403162 <free+0x57>
  400224:	b8 00 00 00 00       	mov    $0x0,%eax
  400229:	e8 da 1a 00 00       	callq  401d08 <printf>
  40022e:	e9 0d 04 00 00       	jmpq   400640 <changedir+0x4ec>
                return;
            }

            //copy from back till forward-1
            i=0;
  400233:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
            
            x = (forward-back);
  40023a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  40023d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  400240:	29 c2                	sub    %eax,%edx
  400242:	89 d0                	mov    %edx,%eax
  400244:	89 45 e8             	mov    %eax,-0x18(%rbp)
            while(i< x){
  400247:	eb 28                	jmp    400271 <changedir+0x11d>

                temp[i++] = path[back++];
  400249:	8b 45 f4             	mov    -0xc(%rbp),%eax
  40024c:	8d 50 01             	lea    0x1(%rax),%edx
  40024f:	89 55 f4             	mov    %edx,-0xc(%rbp)
  400252:	8b 55 f8             	mov    -0x8(%rbp),%edx
  400255:	8d 4a 01             	lea    0x1(%rdx),%ecx
  400258:	89 4d f8             	mov    %ecx,-0x8(%rbp)
  40025b:	48 63 ca             	movslq %edx,%rcx
  40025e:	48 8b 95 c8 fd ff ff 	mov    -0x238(%rbp),%rdx
  400265:	48 01 ca             	add    %rcx,%rdx
  400268:	0f b6 12             	movzbl (%rdx),%edx
  40026b:	48 98                	cltq   
  40026d:	88 54 05 d0          	mov    %dl,-0x30(%rbp,%rax,1)

            //copy from back till forward-1
            i=0;
            
            x = (forward-back);
            while(i< x){
  400271:	8b 45 f4             	mov    -0xc(%rbp),%eax
  400274:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  400277:	7c d0                	jl     400249 <changedir+0xf5>

                temp[i++] = path[back++];
              
            }
            temp[i]= '\0';
  400279:	8b 45 f4             	mov    -0xc(%rbp),%eax
  40027c:	48 98                	cltq   
  40027e:	c6 44 05 d0 00       	movb   $0x0,-0x30(%rbp,%rax,1)
            //printf("%s\n", temp );
            
            strcpy(components[numOfComponents],temp);
  400283:	48 8d 95 08 ff ff ff 	lea    -0xf8(%rbp),%rdx
  40028a:	8b 45 f0             	mov    -0x10(%rbp),%eax
  40028d:	48 98                	cltq   
  40028f:	48 c1 e0 02          	shl    $0x2,%rax
  400293:	48 8d 0c 85 00 00 00 	lea    0x0(,%rax,4),%rcx
  40029a:	00 
  40029b:	48 01 c8             	add    %rcx,%rax
  40029e:	48 01 c2             	add    %rax,%rdx
  4002a1:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  4002a5:	48 89 c6             	mov    %rax,%rsi
  4002a8:	48 89 d7             	mov    %rdx,%rdi
  4002ab:	e8 38 21 00 00       	callq  4023e8 <strcpy>
            //printf("%s\n", &components[0] );
            forward++;
  4002b0:	ff 45 fc             	incl   -0x4(%rbp)
            back = forward;
  4002b3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  4002b6:	89 45 f8             	mov    %eax,-0x8(%rbp)
            numOfComponents++;
  4002b9:	ff 45 f0             	incl   -0x10(%rbp)
            continue;
  4002bc:	eb 03                	jmp    4002c1 <changedir+0x16d>

        }

        forward++;
  4002be:	ff 45 fc             	incl   -0x4(%rbp)
    int x=0;
    int numOfComponents = 0;

    char components[10][20];

    for(forward=0;forward<pathLen;){
  4002c1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  4002c4:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  4002c7:	0f 8c da fe ff ff    	jl     4001a7 <changedir+0x53>

        forward++;

    } //End of for

    if(path[forward-1] != '/'){
  4002cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  4002d0:	48 98                	cltq   
  4002d2:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  4002d6:	48 8b 85 c8 fd ff ff 	mov    -0x238(%rbp),%rax
  4002dd:	48 01 d0             	add    %rdx,%rax
  4002e0:	0f b6 00             	movzbl (%rax),%eax
  4002e3:	3c 2f                	cmp    $0x2f,%al
  4002e5:	0f 84 83 00 00 00    	je     40036e <changedir+0x21a>

        i=0;
  4002eb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
        x = forward-back;
  4002f2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  4002f5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  4002f8:	29 c2                	sub    %eax,%edx
  4002fa:	89 d0                	mov    %edx,%eax
  4002fc:	89 45 e8             	mov    %eax,-0x18(%rbp)
        while(i<x){
  4002ff:	eb 28                	jmp    400329 <changedir+0x1d5>
            temp[i++]=path[back++];
  400301:	8b 45 f4             	mov    -0xc(%rbp),%eax
  400304:	8d 50 01             	lea    0x1(%rax),%edx
  400307:	89 55 f4             	mov    %edx,-0xc(%rbp)
  40030a:	8b 55 f8             	mov    -0x8(%rbp),%edx
  40030d:	8d 4a 01             	lea    0x1(%rdx),%ecx
  400310:	89 4d f8             	mov    %ecx,-0x8(%rbp)
  400313:	48 63 ca             	movslq %edx,%rcx
  400316:	48 8b 95 c8 fd ff ff 	mov    -0x238(%rbp),%rdx
  40031d:	48 01 ca             	add    %rcx,%rdx
  400320:	0f b6 12             	movzbl (%rdx),%edx
  400323:	48 98                	cltq   
  400325:	88 54 05 d0          	mov    %dl,-0x30(%rbp,%rax,1)

    if(path[forward-1] != '/'){

        i=0;
        x = forward-back;
        while(i<x){
  400329:	8b 45 f4             	mov    -0xc(%rbp),%eax
  40032c:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  40032f:	7c d0                	jl     400301 <changedir+0x1ad>
            temp[i++]=path[back++];
        }
        temp[i] = '\0';
  400331:	8b 45 f4             	mov    -0xc(%rbp),%eax
  400334:	48 98                	cltq   
  400336:	c6 44 05 d0 00       	movb   $0x0,-0x30(%rbp,%rax,1)
        strcpy(components[numOfComponents++],temp);
  40033b:	8b 45 f0             	mov    -0x10(%rbp),%eax
  40033e:	8d 50 01             	lea    0x1(%rax),%edx
  400341:	89 55 f0             	mov    %edx,-0x10(%rbp)
  400344:	48 8d 95 08 ff ff ff 	lea    -0xf8(%rbp),%rdx
  40034b:	48 98                	cltq   
  40034d:	48 c1 e0 02          	shl    $0x2,%rax
  400351:	48 8d 0c 85 00 00 00 	lea    0x0(,%rax,4),%rcx
  400358:	00 
  400359:	48 01 c8             	add    %rcx,%rax
  40035c:	48 01 c2             	add    %rax,%rdx
  40035f:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  400363:	48 89 c6             	mov    %rax,%rsi
  400366:	48 89 d7             	mov    %rdx,%rdi
  400369:	e8 7a 20 00 00       	callq  4023e8 <strcpy>

    char buff[100];
    char originalWorkingDirectory[100];
    char toSend[100];

    getcwd(originalWorkingDirectory,100);
  40036e:	48 8d 85 40 fe ff ff 	lea    -0x1c0(%rbp),%rax
  400375:	be 64 00 00 00       	mov    $0x64,%esi
  40037a:	48 89 c7             	mov    %rax,%rdi
  40037d:	e8 c6 26 00 00       	callq  402a48 <getcwd>

   
    i=0;
  400382:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)

    while(i<numOfComponents){
  400389:	eb 38                	jmp    4003c3 <changedir+0x26f>

        printf("%s ",components[i++]);
  40038b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  40038e:	8d 50 01             	lea    0x1(%rax),%edx
  400391:	89 55 f4             	mov    %edx,-0xc(%rbp)
  400394:	48 8d 95 08 ff ff ff 	lea    -0xf8(%rbp),%rdx
  40039b:	48 98                	cltq   
  40039d:	48 c1 e0 02          	shl    $0x2,%rax
  4003a1:	48 8d 0c 85 00 00 00 	lea    0x0(,%rax,4),%rcx
  4003a8:	00 
  4003a9:	48 01 c8             	add    %rcx,%rax
  4003ac:	48 01 d0             	add    %rdx,%rax
  4003af:	48 89 c6             	mov    %rax,%rsi
  4003b2:	48 8d 3d b9 2d 00 00 	lea    0x2db9(%rip),%rdi        # 403172 <free+0x67>
  4003b9:	b8 00 00 00 00       	mov    $0x0,%eax
  4003be:	e8 45 19 00 00       	callq  401d08 <printf>
    getcwd(originalWorkingDirectory,100);

   
    i=0;

    while(i<numOfComponents){
  4003c3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  4003c6:	3b 45 f0             	cmp    -0x10(%rbp),%eax
  4003c9:	7c c0                	jl     40038b <changedir+0x237>

        printf("%s ",components[i++]);
    }

    i=0;
  4003cb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
    
    while(i < numOfComponents){
  4003d2:	e9 2e 02 00 00       	jmpq   400605 <changedir+0x4b1>

        if(i == numOfComponents){
  4003d7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  4003da:	3b 45 f0             	cmp    -0x10(%rbp),%eax
  4003dd:	75 05                	jne    4003e4 <changedir+0x290>
            break;
  4003df:	e9 2d 02 00 00       	jmpq   400611 <changedir+0x4bd>
        }

        

        if(i==0){
  4003e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  4003e8:	75 5c                	jne    400446 <changedir+0x2f2>
            
            strcpy(toSend,components[i]);
  4003ea:	48 8d 95 08 ff ff ff 	lea    -0xf8(%rbp),%rdx
  4003f1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  4003f4:	48 98                	cltq   
  4003f6:	48 c1 e0 02          	shl    $0x2,%rax
  4003fa:	48 8d 0c 85 00 00 00 	lea    0x0(,%rax,4),%rcx
  400401:	00 
  400402:	48 01 c8             	add    %rcx,%rax
  400405:	48 01 c2             	add    %rax,%rdx
  400408:	48 8d 85 dc fd ff ff 	lea    -0x224(%rbp),%rax
  40040f:	48 89 d6             	mov    %rdx,%rsi
  400412:	48 89 c7             	mov    %rax,%rdi
  400415:	e8 ce 1f 00 00       	callq  4023e8 <strcpy>
            if(chdir(toSend) == -1){
  40041a:	48 8d 85 dc fd ff ff 	lea    -0x224(%rbp),%rax
  400421:	48 89 c7             	mov    %rax,%rdi
  400424:	e8 7f 28 00 00       	callq  402ca8 <chdir>
  400429:	83 f8 ff             	cmp    $0xffffffff,%eax
  40042c:	0f 85 c6 01 00 00    	jne    4005f8 <changedir+0x4a4>
            chdir(originalWorkingDirectory);
  400432:	48 8d 85 40 fe ff ff 	lea    -0x1c0(%rbp),%rax
  400439:	48 89 c7             	mov    %rax,%rdi
  40043c:	e8 67 28 00 00       	callq  402ca8 <chdir>
            break;
  400441:	e9 cb 01 00 00       	jmpq   400611 <changedir+0x4bd>
            }
        }

        else if(strcmp(components[i],".")==0){
  400446:	48 8d 95 08 ff ff ff 	lea    -0xf8(%rbp),%rdx
  40044d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  400450:	48 98                	cltq   
  400452:	48 c1 e0 02          	shl    $0x2,%rax
  400456:	48 8d 0c 85 00 00 00 	lea    0x0(,%rax,4),%rcx
  40045d:	00 
  40045e:	48 01 c8             	add    %rcx,%rax
  400461:	48 01 d0             	add    %rdx,%rax
  400464:	48 8d 35 0b 2d 00 00 	lea    0x2d0b(%rip),%rsi        # 403176 <free+0x6b>
  40046b:	48 89 c7             	mov    %rax,%rdi
  40046e:	e8 d4 1f 00 00       	callq  402447 <strcmp>
  400473:	85 c0                	test   %eax,%eax
  400475:	75 08                	jne    40047f <changedir+0x32b>

        	//nothing to do
        	i++;
  400477:	ff 45 f4             	incl   -0xc(%rbp)
        	continue;
  40047a:	e9 86 01 00 00       	jmpq   400605 <changedir+0x4b1>

        }

        else if(strcmp(components[i],"..")==0){
  40047f:	48 8d 95 08 ff ff ff 	lea    -0xf8(%rbp),%rdx
  400486:	8b 45 f4             	mov    -0xc(%rbp),%eax
  400489:	48 98                	cltq   
  40048b:	48 c1 e0 02          	shl    $0x2,%rax
  40048f:	48 8d 0c 85 00 00 00 	lea    0x0(,%rax,4),%rcx
  400496:	00 
  400497:	48 01 c8             	add    %rcx,%rax
  40049a:	48 01 d0             	add    %rdx,%rax
  40049d:	48 8d 35 d4 2c 00 00 	lea    0x2cd4(%rip),%rsi        # 403178 <free+0x6d>
  4004a4:	48 89 c7             	mov    %rax,%rdi
  4004a7:	e8 9b 1f 00 00       	callq  402447 <strcmp>
  4004ac:	85 c0                	test   %eax,%eax
  4004ae:	75 4b                	jne    4004fb <changedir+0x3a7>

            if(i == numOfComponents){
  4004b0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  4004b3:	3b 45 f0             	cmp    -0x10(%rbp),%eax
  4004b6:	75 05                	jne    4004bd <changedir+0x369>
                break;
  4004b8:	e9 54 01 00 00       	jmpq   400611 <changedir+0x4bd>
            }

            chdir("..");
  4004bd:	48 8d 3d b4 2c 00 00 	lea    0x2cb4(%rip),%rdi        # 403178 <free+0x6d>
  4004c4:	e8 df 27 00 00       	callq  402ca8 <chdir>
            getcwd(buff,100);
  4004c9:	48 8d 85 a4 fe ff ff 	lea    -0x15c(%rbp),%rax
  4004d0:	be 64 00 00 00       	mov    $0x64,%esi
  4004d5:	48 89 c7             	mov    %rax,%rdi
  4004d8:	e8 6b 25 00 00       	callq  402a48 <getcwd>
            strcpy(toSend,buff);
  4004dd:	48 8d 95 a4 fe ff ff 	lea    -0x15c(%rbp),%rdx
  4004e4:	48 8d 85 dc fd ff ff 	lea    -0x224(%rbp),%rax
  4004eb:	48 89 d6             	mov    %rdx,%rsi
  4004ee:	48 89 c7             	mov    %rax,%rdi
  4004f1:	e8 f2 1e 00 00       	callq  4023e8 <strcpy>
  4004f6:	e9 fd 00 00 00       	jmpq   4005f8 <changedir+0x4a4>
        }


        else{

            if(i == numOfComponents){
  4004fb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  4004fe:	3b 45 f0             	cmp    -0x10(%rbp),%eax
  400501:	75 05                	jne    400508 <changedir+0x3b4>
                break;
  400503:	e9 09 01 00 00       	jmpq   400611 <changedir+0x4bd>
            }



            if(strcmp(toSend,"..")==0 || strcmp(toSend,".")==0){
  400508:	48 8d 85 dc fd ff ff 	lea    -0x224(%rbp),%rax
  40050f:	48 8d 35 62 2c 00 00 	lea    0x2c62(%rip),%rsi        # 403178 <free+0x6d>
  400516:	48 89 c7             	mov    %rax,%rdi
  400519:	e8 29 1f 00 00       	callq  402447 <strcmp>
  40051e:	85 c0                	test   %eax,%eax
  400520:	74 1a                	je     40053c <changedir+0x3e8>
  400522:	48 8d 85 dc fd ff ff 	lea    -0x224(%rbp),%rax
  400529:	48 8d 35 46 2c 00 00 	lea    0x2c46(%rip),%rsi        # 403176 <free+0x6b>
  400530:	48 89 c7             	mov    %rax,%rdi
  400533:	e8 0f 1f 00 00       	callq  402447 <strcmp>
  400538:	85 c0                	test   %eax,%eax
  40053a:	75 16                	jne    400552 <changedir+0x3fe>

                getcwd(toSend,100);
  40053c:	48 8d 85 dc fd ff ff 	lea    -0x224(%rbp),%rax
  400543:	be 64 00 00 00       	mov    $0x64,%esi
  400548:	48 89 c7             	mov    %rax,%rdi
  40054b:	e8 f8 24 00 00       	callq  402a48 <getcwd>
  400550:	eb 35                	jmp    400587 <changedir+0x433>
            }
            else if(toSend[strlen(toSend)-1] != '/'){
  400552:	48 8d 85 dc fd ff ff 	lea    -0x224(%rbp),%rax
  400559:	48 89 c7             	mov    %rax,%rdi
  40055c:	e8 52 1e 00 00       	callq  4023b3 <strlen>
  400561:	ff c8                	dec    %eax
  400563:	48 98                	cltq   
  400565:	0f b6 84 05 dc fd ff 	movzbl -0x224(%rbp,%rax,1),%eax
  40056c:	ff 
  40056d:	3c 2f                	cmp    $0x2f,%al
  40056f:	74 16                	je     400587 <changedir+0x433>
                
                strcat(toSend,"/");
  400571:	48 8d 85 dc fd ff ff 	lea    -0x224(%rbp),%rax
  400578:	48 8d 35 e1 2b 00 00 	lea    0x2be1(%rip),%rsi        # 403160 <free+0x55>
  40057f:	48 89 c7             	mov    %rax,%rdi
  400582:	e8 25 20 00 00       	callq  4025ac <strcat>
            }
            
            strcat(toSend,components[i]);
  400587:	48 8d 95 08 ff ff ff 	lea    -0xf8(%rbp),%rdx
  40058e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  400591:	48 98                	cltq   
  400593:	48 c1 e0 02          	shl    $0x2,%rax
  400597:	48 8d 0c 85 00 00 00 	lea    0x0(,%rax,4),%rcx
  40059e:	00 
  40059f:	48 01 c8             	add    %rcx,%rax
  4005a2:	48 01 c2             	add    %rax,%rdx
  4005a5:	48 8d 85 dc fd ff ff 	lea    -0x224(%rbp),%rax
  4005ac:	48 89 d6             	mov    %rdx,%rsi
  4005af:	48 89 c7             	mov    %rax,%rdi
  4005b2:	e8 f5 1f 00 00       	callq  4025ac <strcat>

            if(chdir(toSend) == -1){
  4005b7:	48 8d 85 dc fd ff ff 	lea    -0x224(%rbp),%rax
  4005be:	48 89 c7             	mov    %rax,%rdi
  4005c1:	e8 e2 26 00 00       	callq  402ca8 <chdir>
  4005c6:	83 f8 ff             	cmp    $0xffffffff,%eax
  4005c9:	75 2d                	jne    4005f8 <changedir+0x4a4>
            //Invalid path
            //restore to the cwd
           int ret= chdir(originalWorkingDirectory);
  4005cb:	48 8d 85 40 fe ff ff 	lea    -0x1c0(%rbp),%rax
  4005d2:	48 89 c7             	mov    %rax,%rdi
  4005d5:	e8 ce 26 00 00       	callq  402ca8 <chdir>
  4005da:	89 45 e4             	mov    %eax,-0x1c(%rbp)
           if(ret<0)
  4005dd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  4005e1:	79 13                	jns    4005f6 <changedir+0x4a2>
               printf("Could Not Change Directory");
  4005e3:	48 8d 3d 91 2b 00 00 	lea    0x2b91(%rip),%rdi        # 40317b <free+0x70>
  4005ea:	b8 00 00 00 00       	mov    $0x0,%eax
  4005ef:	e8 14 17 00 00       	callq  401d08 <printf>
            break;
  4005f4:	eb 1b                	jmp    400611 <changedir+0x4bd>
  4005f6:	eb 19                	jmp    400611 <changedir+0x4bd>
            }
        }

        i = i + 1;
  4005f8:	ff 45 f4             	incl   -0xc(%rbp)

        if(i == numOfComponents){
  4005fb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  4005fe:	3b 45 f0             	cmp    -0x10(%rbp),%eax
  400601:	75 02                	jne    400605 <changedir+0x4b1>
            break;
  400603:	eb 0c                	jmp    400611 <changedir+0x4bd>
        printf("%s ",components[i++]);
    }

    i=0;
    
    while(i < numOfComponents){
  400605:	8b 45 f4             	mov    -0xc(%rbp),%eax
  400608:	3b 45 f0             	cmp    -0x10(%rbp),%eax
  40060b:	0f 8c c6 fd ff ff    	jl     4003d7 <changedir+0x283>
            break;
        }

    }

    getcwd(buff,100);
  400611:	48 8d 85 a4 fe ff ff 	lea    -0x15c(%rbp),%rax
  400618:	be 64 00 00 00       	mov    $0x64,%esi
  40061d:	48 89 c7             	mov    %rax,%rdi
  400620:	e8 23 24 00 00       	callq  402a48 <getcwd>
    printf("CWD: %s",buff);
  400625:	48 8d 85 a4 fe ff ff 	lea    -0x15c(%rbp),%rax
  40062c:	48 89 c6             	mov    %rax,%rsi
  40062f:	48 8d 3d 60 2b 00 00 	lea    0x2b60(%rip),%rdi        # 403196 <free+0x8b>
  400636:	b8 00 00 00 00       	mov    $0x0,%eax
  40063b:	e8 c8 16 00 00       	callq  401d08 <printf>
	

}
  400640:	c9                   	leaveq 
  400641:	c3                   	retq   

0000000000400642 <setPath>:
#include <errno.h>
#include <string.h>
#include <shell.h>


char * setPath(char* env,char* path,int mode){
  400642:	55                   	push   %rbp
  400643:	48 89 e5             	mov    %rsp,%rbp
  400646:	53                   	push   %rbx
  400647:	48 83 ec 38          	sub    $0x38,%rsp
  40064b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  40064f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  400653:	89 55 cc             	mov    %edx,-0x34(%rbp)

	int newEnvVarLength;
	//char p[500];
	char *new;

	if(mode == EASIS){
  400656:	83 7d cc 01          	cmpl   $0x1,-0x34(%rbp)
  40065a:	75 6f                	jne    4006cb <setPath+0x89>

		//Calculate new space for the path
		newEnvVarLength = strlen("PATH=") + strlen(path)+1;
  40065c:	48 8d 3d 3b 2b 00 00 	lea    0x2b3b(%rip),%rdi        # 40319e <free+0x93>
  400663:	e8 4b 1d 00 00       	callq  4023b3 <strlen>
  400668:	89 c3                	mov    %eax,%ebx
  40066a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  40066e:	48 89 c7             	mov    %rax,%rdi
  400671:	e8 3d 1d 00 00       	callq  4023b3 <strlen>
  400676:	01 d8                	add    %ebx,%eax
  400678:	ff c0                	inc    %eax
  40067a:	89 45 e4             	mov    %eax,-0x1c(%rbp)

		//printf("In setPath.... passed path is :%s:\n newEnvVarLength :%d\n",path,newEnvVarLength);


		//Allocate that space fr the new path
		new = (char*)malloc(sizeof(char)*newEnvVarLength);
  40067d:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  400680:	48 98                	cltq   
  400682:	48 89 c7             	mov    %rax,%rdi
  400685:	e8 14 29 00 00       	callq  402f9e <malloc>
  40068a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)

		strcpy(new,"PATH=");//copy the old env variable
  40068e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  400692:	48 8d 35 05 2b 00 00 	lea    0x2b05(%rip),%rsi        # 40319e <free+0x93>
  400699:	48 89 c7             	mov    %rax,%rdi
  40069c:	e8 47 1d 00 00       	callq  4023e8 <strcpy>
		strcpy(new+strlen("PATH="),path);
  4006a1:	48 8d 3d f6 2a 00 00 	lea    0x2af6(%rip),%rdi        # 40319e <free+0x93>
  4006a8:	e8 06 1d 00 00       	callq  4023b3 <strlen>
  4006ad:	48 63 d0             	movslq %eax,%rdx
  4006b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  4006b4:	48 01 c2             	add    %rax,%rdx
  4006b7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  4006bb:	48 89 c6             	mov    %rax,%rsi
  4006be:	48 89 d7             	mov    %rdx,%rdi
  4006c1:	e8 22 1d 00 00       	callq  4023e8 <strcpy>
  4006c6:	e9 92 00 00 00       	jmpq   40075d <setPath+0x11b>
	}
	else{


		//Calculate new space for the path
		newEnvVarLength = strlen(env) + strlen(path)+1;
  4006cb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  4006cf:	48 89 c7             	mov    %rax,%rdi
  4006d2:	e8 dc 1c 00 00       	callq  4023b3 <strlen>
  4006d7:	89 c3                	mov    %eax,%ebx
  4006d9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  4006dd:	48 89 c7             	mov    %rax,%rdi
  4006e0:	e8 ce 1c 00 00       	callq  4023b3 <strlen>
  4006e5:	01 d8                	add    %ebx,%eax
  4006e7:	ff c0                	inc    %eax
  4006e9:	89 45 e4             	mov    %eax,-0x1c(%rbp)

		//Allocate that space fr the new path
		new = (char*)malloc(sizeof(char)*newEnvVarLength);
  4006ec:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  4006ef:	48 98                	cltq   
  4006f1:	48 89 c7             	mov    %rax,%rdi
  4006f4:	e8 a5 28 00 00       	callq  402f9e <malloc>
  4006f9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)

		strcpy(new,env);//copy the old env variable
  4006fd:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  400701:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  400705:	48 89 d6             	mov    %rdx,%rsi
  400708:	48 89 c7             	mov    %rax,%rdi
  40070b:	e8 d8 1c 00 00       	callq  4023e8 <strcpy>
		strcpy(new+strlen(env),":");
  400710:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  400714:	48 89 c7             	mov    %rax,%rdi
  400717:	e8 97 1c 00 00       	callq  4023b3 <strlen>
  40071c:	48 63 d0             	movslq %eax,%rdx
  40071f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  400723:	48 01 d0             	add    %rdx,%rax
  400726:	48 8d 35 77 2a 00 00 	lea    0x2a77(%rip),%rsi        # 4031a4 <free+0x99>
  40072d:	48 89 c7             	mov    %rax,%rdi
  400730:	e8 b3 1c 00 00       	callq  4023e8 <strcpy>
		strcpy(new+strlen(env)+1,path);
  400735:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  400739:	48 89 c7             	mov    %rax,%rdi
  40073c:	e8 72 1c 00 00       	callq  4023b3 <strlen>
  400741:	48 98                	cltq   
  400743:	48 8d 50 01          	lea    0x1(%rax),%rdx
  400747:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  40074b:	48 01 c2             	add    %rax,%rdx
  40074e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  400752:	48 89 c6             	mov    %rax,%rsi
  400755:	48 89 d7             	mov    %rdx,%rdi
  400758:	e8 8b 1c 00 00       	callq  4023e8 <strcpy>
	}


	//printf("Returning new path from setPath %s\n",new);

	return new;
  40075d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  400761:	48 83 c4 38          	add    $0x38,%rsp
  400765:	5b                   	pop    %rbx
  400766:	5d                   	pop    %rbp
  400767:	c3                   	retq   

0000000000400768 <set>:



void set(char * args, char** envp){
  400768:	55                   	push   %rbp
  400769:	48 89 e5             	mov    %rsp,%rbp
  40076c:	48 81 ec 30 04 00 00 	sub    $0x430,%rsp
  400773:	48 89 bd d8 fb ff ff 	mov    %rdi,-0x428(%rbp)
  40077a:	48 89 b5 d0 fb ff ff 	mov    %rsi,-0x430(%rbp)

	char *path=NULL;
  400781:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  400788:	00 
	//include logic to check for entire string ${PATH} or $PATH


	//printf("In set path\n\n");

	tokenEquals = tokenize(args,"=");
  400789:	48 8b 85 d8 fb ff ff 	mov    -0x428(%rbp),%rax
  400790:	48 8d 35 0f 2a 00 00 	lea    0x2a0f(%rip),%rsi        # 4031a6 <free+0x9b>
  400797:	48 89 c7             	mov    %rax,%rdi
  40079a:	e8 1e 12 00 00       	callq  4019bd <tokenize>
  40079f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	 * Get the location in the envp array where PATH
	 * is stored. We will keep the modified PATH string in this location only.
	 */


	envLoc=findEnvVar("PATH",envp);
  4007a3:	48 8b 85 d0 fb ff ff 	mov    -0x430(%rbp),%rax
  4007aa:	48 89 c6             	mov    %rax,%rsi
  4007ad:	48 8d 3d f4 29 00 00 	lea    0x29f4(%rip),%rdi        # 4031a8 <free+0x9d>
  4007b4:	e8 93 09 00 00       	callq  40114c <findEnvVar>
  4007b9:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if(tokenEquals->numOfTokens==1){
  4007bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  4007c1:	8b 00                	mov    (%rax),%eax
  4007c3:	83 f8 01             	cmp    $0x1,%eax
  4007c6:	75 3d                	jne    400805 <set+0x9d>

		//printf("PATH= case.......\n\n");
		strcpy(tokentoPass,"");
  4007c8:	48 8d 85 dc fd ff ff 	lea    -0x224(%rbp),%rax
  4007cf:	48 8d 35 d7 29 00 00 	lea    0x29d7(%rip),%rsi        # 4031ad <free+0xa2>
  4007d6:	48 89 c7             	mov    %rax,%rdi
  4007d9:	e8 0a 1c 00 00       	callq  4023e8 <strcpy>
		path = setPath(*envLoc,tokentoPass,EASIS);
  4007de:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  4007e2:	48 8b 00             	mov    (%rax),%rax
  4007e5:	48 8d 8d dc fd ff ff 	lea    -0x224(%rbp),%rcx
  4007ec:	ba 01 00 00 00       	mov    $0x1,%edx
  4007f1:	48 89 ce             	mov    %rcx,%rsi
  4007f4:	48 89 c7             	mov    %rax,%rdi
  4007f7:	e8 46 fe ff ff       	callq  400642 <setPath>
  4007fc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  400800:	e9 ab 01 00 00       	jmpq   4009b0 <set+0x248>
		return;

	}


	strcpy(tokentoPass,tokenEquals->tokenArr[1]);
  400805:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  400809:	48 8b 50 10          	mov    0x10(%rax),%rdx
  40080d:	48 8d 85 dc fd ff ff 	lea    -0x224(%rbp),%rax
  400814:	48 89 d6             	mov    %rdx,%rsi
  400817:	48 89 c7             	mov    %rax,%rdi
  40081a:	e8 c9 1b 00 00       	callq  4023e8 <strcpy>
	//printf("Token to pass after tokenizing on colon is .%s.\n",tokentoPass);
	tokenColon = tokenize(tokentoPass,":");
  40081f:	48 8d 85 dc fd ff ff 	lea    -0x224(%rbp),%rax
  400826:	48 8d 35 77 29 00 00 	lea    0x2977(%rip),%rsi        # 4031a4 <free+0x99>
  40082d:	48 89 c7             	mov    %rax,%rdi
  400830:	e8 88 11 00 00       	callq  4019bd <tokenize>
  400835:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	/*
	 * Save the value of PATH in oldSysPath.We will need this
	 * when we need to expand ${PATH}
	 */
	char oldSysPath[500];
	token = tokenize(*envLoc,"=");
  400839:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  40083d:	48 8b 00             	mov    (%rax),%rax
  400840:	48 8d 35 5f 29 00 00 	lea    0x295f(%rip),%rsi        # 4031a6 <free+0x9b>
  400847:	48 89 c7             	mov    %rax,%rdi
  40084a:	e8 6e 11 00 00       	callq  4019bd <tokenize>
  40084f:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	strcpy(oldSysPath,token->tokenArr[1]);
  400853:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  400857:	48 8b 50 10          	mov    0x10(%rax),%rdx
  40085b:	48 8d 85 e8 fb ff ff 	lea    -0x418(%rbp),%rax
  400862:	48 89 d6             	mov    %rdx,%rsi
  400865:	48 89 c7             	mov    %rax,%rdi
  400868:	e8 7b 1b 00 00       	callq  4023e8 <strcpy>

	/*
	 * First element of the tokenColon always needs to be addes ASIS
	 * Check if the component to add is ${PATH}.If yes send oldSysPath
	 */
	if((strcmp(tokenColon->tokenArr[0],"${PATH}")==0)||(strcmp(tokenColon->tokenArr[0],"$PATH")==0)){
  40086d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  400871:	48 8b 40 08          	mov    0x8(%rax),%rax
  400875:	48 8d 35 32 29 00 00 	lea    0x2932(%rip),%rsi        # 4031ae <free+0xa3>
  40087c:	48 89 c7             	mov    %rax,%rdi
  40087f:	e8 c3 1b 00 00       	callq  402447 <strcmp>
  400884:	85 c0                	test   %eax,%eax
  400886:	74 1b                	je     4008a3 <set+0x13b>
  400888:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  40088c:	48 8b 40 08          	mov    0x8(%rax),%rax
  400890:	48 8d 35 1f 29 00 00 	lea    0x291f(%rip),%rsi        # 4031b6 <free+0xab>
  400897:	48 89 c7             	mov    %rax,%rdi
  40089a:	e8 a8 1b 00 00       	callq  402447 <strcmp>
  40089f:	85 c0                	test   %eax,%eax
  4008a1:	75 24                	jne    4008c7 <set+0x15f>
		path = setPath(*envLoc,oldSysPath,EASIS);
  4008a3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  4008a7:	48 8b 00             	mov    (%rax),%rax
  4008aa:	48 8d 8d e8 fb ff ff 	lea    -0x418(%rbp),%rcx
  4008b1:	ba 01 00 00 00       	mov    $0x1,%edx
  4008b6:	48 89 ce             	mov    %rcx,%rsi
  4008b9:	48 89 c7             	mov    %rax,%rdi
  4008bc:	e8 81 fd ff ff       	callq  400642 <setPath>
  4008c1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  4008c5:	eb 23                	jmp    4008ea <set+0x182>
		//printf("PATH IS %s\n",path);
	}
	else{
		path = setPath(*envLoc,tokenColon->tokenArr[0],EASIS);
  4008c7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  4008cb:	48 8b 48 08          	mov    0x8(%rax),%rcx
  4008cf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  4008d3:	48 8b 00             	mov    (%rax),%rax
  4008d6:	ba 01 00 00 00       	mov    $0x1,%edx
  4008db:	48 89 ce             	mov    %rcx,%rsi
  4008de:	48 89 c7             	mov    %rax,%rdi
  4008e1:	e8 5c fd ff ff       	callq  400642 <setPath>
  4008e6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	}

	//Assign the newly modified path to envLoc.This causes the envp array to get updated
	*envLoc = path;
  4008ea:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  4008ee:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  4008f2:	48 89 10             	mov    %rdx,(%rax)

	//printf("The new environment is: %s\n", getenv("PATH"));


	//Append the later elements in a loop
	for(i=1;i<tokenColon->numOfTokens;i++){
  4008f5:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%rbp)
  4008fc:	e9 a0 00 00 00       	jmpq   4009a1 <set+0x239>

		/*
		 * Check if the component to add is ${PATH}.If yes send oldSysPath
		 *
		 */
		if((strcmp(tokenColon->tokenArr[i],"${PATH}")==0)||(strcmp(tokenColon->tokenArr[i],"$PATH")==0)){
  400901:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  400905:	8b 55 f4             	mov    -0xc(%rbp),%edx
  400908:	48 63 d2             	movslq %edx,%rdx
  40090b:	48 8b 44 d0 08       	mov    0x8(%rax,%rdx,8),%rax
  400910:	48 8d 35 97 28 00 00 	lea    0x2897(%rip),%rsi        # 4031ae <free+0xa3>
  400917:	48 89 c7             	mov    %rax,%rdi
  40091a:	e8 28 1b 00 00       	callq  402447 <strcmp>
  40091f:	85 c0                	test   %eax,%eax
  400921:	74 22                	je     400945 <set+0x1dd>
  400923:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  400927:	8b 55 f4             	mov    -0xc(%rbp),%edx
  40092a:	48 63 d2             	movslq %edx,%rdx
  40092d:	48 8b 44 d0 08       	mov    0x8(%rax,%rdx,8),%rax
  400932:	48 8d 35 7d 28 00 00 	lea    0x287d(%rip),%rsi        # 4031b6 <free+0xab>
  400939:	48 89 c7             	mov    %rax,%rdi
  40093c:	e8 06 1b 00 00       	callq  402447 <strcmp>
  400941:	85 c0                	test   %eax,%eax
  400943:	75 24                	jne    400969 <set+0x201>
			path = setPath(*envLoc,oldSysPath,EAPPEND);
  400945:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  400949:	48 8b 00             	mov    (%rax),%rax
  40094c:	48 8d 8d e8 fb ff ff 	lea    -0x418(%rbp),%rcx
  400953:	ba 02 00 00 00       	mov    $0x2,%edx
  400958:	48 89 ce             	mov    %rcx,%rsi
  40095b:	48 89 c7             	mov    %rax,%rdi
  40095e:	e8 df fc ff ff       	callq  400642 <setPath>
  400963:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  400967:	eb 2a                	jmp    400993 <set+0x22b>
			//printf("PATH IS %s\n",path);
		}
		else{
			path = setPath(*envLoc,tokenColon->tokenArr[i],EAPPEND);
  400969:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  40096d:	8b 55 f4             	mov    -0xc(%rbp),%edx
  400970:	48 63 d2             	movslq %edx,%rdx
  400973:	48 8b 4c d0 08       	mov    0x8(%rax,%rdx,8),%rcx
  400978:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  40097c:	48 8b 00             	mov    (%rax),%rax
  40097f:	ba 02 00 00 00       	mov    $0x2,%edx
  400984:	48 89 ce             	mov    %rcx,%rsi
  400987:	48 89 c7             	mov    %rax,%rdi
  40098a:	e8 b3 fc ff ff       	callq  400642 <setPath>
  40098f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
		}

		//Assign the newly modified path to envLoc.This causes the envp array to get updated
		*envLoc = path;
  400993:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  400997:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  40099b:	48 89 10             	mov    %rdx,(%rax)

	//printf("The new environment is: %s\n", getenv("PATH"));


	//Append the later elements in a loop
	for(i=1;i<tokenColon->numOfTokens;i++){
  40099e:	ff 45 f4             	incl   -0xc(%rbp)
  4009a1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  4009a5:	8b 00                	mov    (%rax),%eax
  4009a7:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  4009aa:	0f 8f 51 ff ff ff    	jg     400901 <set+0x199>


	}//End of for loop

	//printf("The new environment is: %s\n", getenv("PATH"));
}
  4009b0:	c9                   	leaveq 
  4009b1:	c3                   	retq   

00000000004009b2 <executeBuiltins>:
#include <parser.h>
#include <errno.h>
#include <string.h>
#include <shell.h>

void executeBuiltins(parseInfo* command,char*envp[]){
  4009b2:	55                   	push   %rbp
  4009b3:	48 89 e5             	mov    %rsp,%rbp
  4009b6:	48 83 c4 80          	add    $0xffffffffffffff80,%rsp
  4009ba:	48 89 7d 88          	mov    %rdi,-0x78(%rbp)
  4009be:	48 89 75 80          	mov    %rsi,-0x80(%rbp)
		printf("Token %d : %s\n",i,command->CommArray[0]->VarList[i]);
	}*/



	if(strcmp(command->CommArray[0]->commandName,"set")==0){
  4009c2:	48 8b 45 88          	mov    -0x78(%rbp),%rax
  4009c6:	48 8b 00             	mov    (%rax),%rax
  4009c9:	48 8b 00             	mov    (%rax),%rax
  4009cc:	48 8d 35 ed 27 00 00 	lea    0x27ed(%rip),%rsi        # 4031c0 <free+0xb5>
  4009d3:	48 89 c7             	mov    %rax,%rdi
  4009d6:	e8 6c 1a 00 00       	callq  402447 <strcmp>
  4009db:	85 c0                	test   %eax,%eax
  4009dd:	0f 85 f5 00 00 00    	jne    400ad8 <executeBuiltins+0x126>

		if(strstr(command->CommArray[0]->VarList[1],"PATH")!=NULL){
  4009e3:	48 8b 45 88          	mov    -0x78(%rbp),%rax
  4009e7:	48 8b 00             	mov    (%rax),%rax
  4009ea:	48 8b 40 10          	mov    0x10(%rax),%rax
  4009ee:	48 8d 35 cf 27 00 00 	lea    0x27cf(%rip),%rsi        # 4031c4 <free+0xb9>
  4009f5:	48 89 c7             	mov    %rax,%rdi
  4009f8:	e8 d1 1a 00 00       	callq  4024ce <strstr>
  4009fd:	48 85 c0             	test   %rax,%rax
  400a00:	74 76                	je     400a78 <executeBuiltins+0xc6>
			//execute change PATH
			//printf("Going to change path");


			if(command->CommArray[0]->VarNum >2){
  400a02:	48 8b 45 88          	mov    -0x78(%rbp),%rax
  400a06:	48 8b 00             	mov    (%rax),%rax
  400a09:	8b 40 58             	mov    0x58(%rax),%eax
  400a0c:	83 f8 02             	cmp    $0x2,%eax
  400a0f:	7e 16                	jle    400a27 <executeBuiltins+0x75>

				printf("Too many arguments to set PATH.Please enter set PATH=ABC:XYX:... (no spaces in between)\n");
  400a11:	48 8d 3d b8 27 00 00 	lea    0x27b8(%rip),%rdi        # 4031d0 <free+0xc5>
  400a18:	b8 00 00 00 00       	mov    $0x0,%eax
  400a1d:	e8 e6 12 00 00       	callq  401d08 <printf>
				return;
  400a22:	e9 56 01 00 00       	jmpq   400b7d <executeBuiltins+0x1cb>
			}


			set(command->CommArray[0]->VarList[1],envp);
  400a27:	48 8b 45 88          	mov    -0x78(%rbp),%rax
  400a2b:	48 8b 00             	mov    (%rax),%rax
  400a2e:	48 8b 40 10          	mov    0x10(%rax),%rax
  400a32:	48 8b 55 80          	mov    -0x80(%rbp),%rdx
  400a36:	48 89 d6             	mov    %rdx,%rsi
  400a39:	48 89 c7             	mov    %rax,%rdi
  400a3c:	e8 27 fd ff ff       	callq  400768 <set>
			envVar=findEnvVar("PATH",envp);
  400a41:	48 8b 45 80          	mov    -0x80(%rbp),%rax
  400a45:	48 89 c6             	mov    %rax,%rsi
  400a48:	48 8d 3d 75 27 00 00 	lea    0x2775(%rip),%rdi        # 4031c4 <free+0xb9>
  400a4f:	e8 f8 06 00 00       	callq  40114c <findEnvVar>
  400a54:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
			printf("Current Path is :\n %s\n",*envVar);
  400a58:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  400a5c:	48 8b 00             	mov    (%rax),%rax
  400a5f:	48 89 c6             	mov    %rax,%rsi
  400a62:	48 8d 3d c0 27 00 00 	lea    0x27c0(%rip),%rdi        # 403229 <free+0x11e>
  400a69:	b8 00 00 00 00       	mov    $0x0,%eax
  400a6e:	e8 95 12 00 00       	callq  401d08 <printf>
  400a73:	e9 04 01 00 00       	jmpq   400b7c <executeBuiltins+0x1ca>


		}
		else if(strstr(command->CommArray[0]->VarList[1],"PS1")!=NULL){
  400a78:	48 8b 45 88          	mov    -0x78(%rbp),%rax
  400a7c:	48 8b 00             	mov    (%rax),%rax
  400a7f:	48 8b 40 10          	mov    0x10(%rax),%rax
  400a83:	48 8d 35 b6 27 00 00 	lea    0x27b6(%rip),%rsi        # 403240 <free+0x135>
  400a8a:	48 89 c7             	mov    %rax,%rdi
  400a8d:	e8 3c 1a 00 00       	callq  4024ce <strstr>
  400a92:	48 85 c0             	test   %rax,%rax
  400a95:	0f 84 e1 00 00 00    	je     400b7c <executeBuiltins+0x1ca>
			//simple change the shell variable PS1
			//Add function to remove spaces from PS1=hgchbvh

			//printf("Going to change PS1");

			if(command->CommArray[0]->VarNum >2){
  400a9b:	48 8b 45 88          	mov    -0x78(%rbp),%rax
  400a9f:	48 8b 00             	mov    (%rax),%rax
  400aa2:	8b 40 58             	mov    0x58(%rax),%eax
  400aa5:	83 f8 02             	cmp    $0x2,%eax
  400aa8:	7e 16                	jle    400ac0 <executeBuiltins+0x10e>

				printf("Too many arguments to set PS1.Please enter set PS1=ABCD (no spaces in between)\n");
  400aaa:	48 8d 3d 97 27 00 00 	lea    0x2797(%rip),%rdi        # 403248 <free+0x13d>
  400ab1:	b8 00 00 00 00       	mov    $0x0,%eax
  400ab6:	e8 4d 12 00 00       	callq  401d08 <printf>
				return;
  400abb:	e9 bd 00 00 00       	jmpq   400b7d <executeBuiltins+0x1cb>
			}

			changePS1(command->CommArray[0]->VarList[1]);
  400ac0:	48 8b 45 88          	mov    -0x78(%rbp),%rax
  400ac4:	48 8b 00             	mov    (%rax),%rax
  400ac7:	48 8b 40 10          	mov    0x10(%rax),%rax
  400acb:	48 89 c7             	mov    %rax,%rdi
  400ace:	e8 b9 0a 00 00       	callq  40158c <changePS1>
		printf("Current Working Directory is: %s\n",cmdWithoutSpaces);

	}


	return;
  400ad3:	e9 a5 00 00 00       	jmpq   400b7d <executeBuiltins+0x1cb>

		}
	}


	else if(strcmp(command->CommArray[0]->commandName,"exit")==0){
  400ad8:	48 8b 45 88          	mov    -0x78(%rbp),%rax
  400adc:	48 8b 00             	mov    (%rax),%rax
  400adf:	48 8b 00             	mov    (%rax),%rax
  400ae2:	48 8d 35 af 27 00 00 	lea    0x27af(%rip),%rsi        # 403298 <free+0x18d>
  400ae9:	48 89 c7             	mov    %rax,%rdi
  400aec:	e8 56 19 00 00       	callq  402447 <strcmp>
  400af1:	85 c0                	test   %eax,%eax
  400af3:	75 0c                	jne    400b01 <executeBuiltins+0x14f>

		exit(0);
  400af5:	bf 00 00 00 00       	mov    $0x0,%edi
  400afa:	e8 1f 22 00 00       	callq  402d1e <exit>
  400aff:	eb 7b                	jmp    400b7c <executeBuiltins+0x1ca>
	}

	else if(strcmp(command->CommArray[0]->commandName,"cd")==0) {
  400b01:	48 8b 45 88          	mov    -0x78(%rbp),%rax
  400b05:	48 8b 00             	mov    (%rax),%rax
  400b08:	48 8b 00             	mov    (%rax),%rax
  400b0b:	48 8d 35 8b 27 00 00 	lea    0x278b(%rip),%rsi        # 40329d <free+0x192>
  400b12:	48 89 c7             	mov    %rax,%rdi
  400b15:	e8 2d 19 00 00       	callq  402447 <strcmp>
  400b1a:	85 c0                	test   %eax,%eax
  400b1c:	75 5e                	jne    400b7c <executeBuiltins+0x1ca>
		if(command->CommArray[0]->VarNum >2){
  400b1e:	48 8b 45 88          	mov    -0x78(%rbp),%rax
  400b22:	48 8b 00             	mov    (%rax),%rax
  400b25:	8b 40 58             	mov    0x58(%rax),%eax
  400b28:	83 f8 02             	cmp    $0x2,%eax
  400b2b:	7e 13                	jle    400b40 <executeBuiltins+0x18e>

			printf("Too many arguments to cd.Please enter cd <directory name>\n");
  400b2d:	48 8d 3d 6c 27 00 00 	lea    0x276c(%rip),%rdi        # 4032a0 <free+0x195>
  400b34:	b8 00 00 00 00       	mov    $0x0,%eax
  400b39:	e8 ca 11 00 00       	callq  401d08 <printf>
			return;
  400b3e:	eb 3d                	jmp    400b7d <executeBuiltins+0x1cb>
		}


		//execute change directory
		changedir(command->CommArray[0]->VarList[1]);
  400b40:	48 8b 45 88          	mov    -0x78(%rbp),%rax
  400b44:	48 8b 00             	mov    (%rax),%rax
  400b47:	48 8b 40 10          	mov    0x10(%rax),%rax
  400b4b:	48 89 c7             	mov    %rax,%rdi
  400b4e:	e8 01 f6 ff ff       	callq  400154 <changedir>
		getcwd(cmdWithoutSpaces,100);
  400b53:	48 8d 45 94          	lea    -0x6c(%rbp),%rax
  400b57:	be 64 00 00 00       	mov    $0x64,%esi
  400b5c:	48 89 c7             	mov    %rax,%rdi
  400b5f:	e8 e4 1e 00 00       	callq  402a48 <getcwd>
		printf("Current Working Directory is: %s\n",cmdWithoutSpaces);
  400b64:	48 8d 45 94          	lea    -0x6c(%rbp),%rax
  400b68:	48 89 c6             	mov    %rax,%rsi
  400b6b:	48 8d 3d 6e 27 00 00 	lea    0x276e(%rip),%rdi        # 4032e0 <free+0x1d5>
  400b72:	b8 00 00 00 00       	mov    $0x0,%eax
  400b77:	e8 8c 11 00 00       	callq  401d08 <printf>

	}


	return;
  400b7c:	90                   	nop


}
  400b7d:	c9                   	leaveq 
  400b7e:	c3                   	retq   

0000000000400b7f <execute_cmd>:
#include <shell.h>



void execute_cmd(parseInfo * info,char*envp[])
{
  400b7f:	55                   	push   %rbp
  400b80:	48 89 e5             	mov    %rsp,%rbp
  400b83:	53                   	push   %rbx
  400b84:	48 81 ec 28 08 00 00 	sub    $0x828,%rsp
  400b8b:	48 89 bd d8 f7 ff ff 	mov    %rdi,-0x828(%rbp)
  400b92:	48 89 b5 d0 f7 ff ff 	mov    %rsi,-0x830(%rbp)
	int i,j,*pipes=NULL,status;
  400b99:	48 c7 45 e0 00 00 00 	movq   $0x0,-0x20(%rbp)
  400ba0:	00 
	char cmd[20][100];

	int  *proc_ids;
	//printf("pipes=%d \n",info->pipeNum);

	for(i=0; i<=info->pipeNum; i++)
  400ba1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  400ba8:	eb 36                	jmp    400be0 <execute_cmd+0x61>
	{
		//printf("info: %s\n", info->CommArray[i]->commandName);
		strcpy(cmd[i],info->CommArray[i]->commandName);
  400baa:	48 8b 85 d8 f7 ff ff 	mov    -0x828(%rbp),%rax
  400bb1:	8b 55 ec             	mov    -0x14(%rbp),%edx
  400bb4:	48 63 d2             	movslq %edx,%rdx
  400bb7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  400bbb:	48 8b 00             	mov    (%rax),%rax
  400bbe:	48 8d 8d fc f7 ff ff 	lea    -0x804(%rbp),%rcx
  400bc5:	8b 55 ec             	mov    -0x14(%rbp),%edx
  400bc8:	48 63 d2             	movslq %edx,%rdx
  400bcb:	48 6b d2 64          	imul   $0x64,%rdx,%rdx
  400bcf:	48 01 ca             	add    %rcx,%rdx
  400bd2:	48 89 c6             	mov    %rax,%rsi
  400bd5:	48 89 d7             	mov    %rdx,%rdi
  400bd8:	e8 0b 18 00 00       	callq  4023e8 <strcpy>
	char cmd[20][100];

	int  *proc_ids;
	//printf("pipes=%d \n",info->pipeNum);

	for(i=0; i<=info->pipeNum; i++)
  400bdd:	ff 45 ec             	incl   -0x14(%rbp)
  400be0:	48 8b 85 d8 f7 ff ff 	mov    -0x828(%rbp),%rax
  400be7:	8b 40 50             	mov    0x50(%rax),%eax
  400bea:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  400bed:	7d bb                	jge    400baa <execute_cmd+0x2b>
		//printf("varList=%s\n",info->CommArray[i]->VarList[j]);
	}



	proc_ids = (int *)malloc(info->pipeNum+1);
  400bef:	48 8b 85 d8 f7 ff ff 	mov    -0x828(%rbp),%rax
  400bf6:	8b 40 50             	mov    0x50(%rax),%eax
  400bf9:	ff c0                	inc    %eax
  400bfb:	48 98                	cltq   
  400bfd:	48 89 c7             	mov    %rax,%rdi
  400c00:	e8 99 23 00 00       	callq  402f9e <malloc>
  400c05:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
printf("proc_ids=%p",proc_ids);
  400c09:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  400c0d:	48 89 c6             	mov    %rax,%rsi
  400c10:	48 8d 3d eb 26 00 00 	lea    0x26eb(%rip),%rdi        # 403302 <free+0x1f7>
  400c17:	b8 00 00 00 00       	mov    $0x0,%eax
  400c1c:	e8 e7 10 00 00       	callq  401d08 <printf>

	if(info->pipeNum==0)
  400c21:	48 8b 85 d8 f7 ff ff 	mov    -0x828(%rbp),%rax
  400c28:	8b 40 50             	mov    0x50(%rax),%eax
  400c2b:	85 c0                	test   %eax,%eax
  400c2d:	0f 85 ca 00 00 00    	jne    400cfd <execute_cmd+0x17e>
	{
		printf("forking");
  400c33:	48 8d 3d d4 26 00 00 	lea    0x26d4(%rip),%rdi        # 40330e <free+0x203>
  400c3a:	b8 00 00 00 00       	mov    $0x0,%eax
  400c3f:	e8 c4 10 00 00       	callq  401d08 <printf>


		proc_ids[0]=fork();
  400c44:	e8 a9 1d 00 00       	callq  4029f2 <fork>
  400c49:	89 c2                	mov    %eax,%edx
  400c4b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  400c4f:	89 10                	mov    %edx,(%rax)

		if (proc_ids[0] < 0)
  400c51:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  400c55:	8b 00                	mov    (%rax),%eax
  400c57:	85 c0                	test   %eax,%eax
  400c59:	79 1a                	jns    400c75 <execute_cmd+0xf6>
		{
			strerror( errno);
  400c5b:	48 8b 05 0e 35 20 00 	mov    0x20350e(%rip),%rax        # 604170 <free+0x201065>
  400c62:	8b 00                	mov    (%rax),%eax
  400c64:	89 c7                	mov    %eax,%edi
  400c66:	e8 7c 19 00 00       	callq  4025e7 <strerror>
			exit(1);
  400c6b:	bf 01 00 00 00       	mov    $0x1,%edi
  400c70:	e8 a9 20 00 00       	callq  402d1e <exit>
		}
		if(proc_ids[0]==0)
  400c75:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  400c79:	8b 00                	mov    (%rax),%eax
  400c7b:	85 c0                	test   %eax,%eax
  400c7d:	0f 85 08 03 00 00    	jne    400f8b <execute_cmd+0x40c>
		{
			//printf("executing %s\n",cmd[0]);

			printf("Executing Command %s\n",cmd[0]);
  400c83:	48 8d 85 fc f7 ff ff 	lea    -0x804(%rbp),%rax
  400c8a:	48 89 c6             	mov    %rax,%rsi
  400c8d:	48 8d 3d 82 26 00 00 	lea    0x2682(%rip),%rdi        # 403316 <free+0x20b>
  400c94:	b8 00 00 00 00       	mov    $0x0,%eax
  400c99:	e8 6a 10 00 00       	callq  401d08 <printf>

			char* envpChildProcess[]={NULL};
  400c9e:	48 c7 85 f0 f7 ff ff 	movq   $0x0,-0x810(%rbp)
  400ca5:	00 00 00 00 
			int ret = execve(cmd[0],info->CommArray[0]->VarList,envpChildProcess);
  400ca9:	48 8b 85 d8 f7 ff ff 	mov    -0x828(%rbp),%rax
  400cb0:	48 8b 00             	mov    (%rax),%rax
  400cb3:	48 8d 48 08          	lea    0x8(%rax),%rcx
  400cb7:	48 8d 95 f0 f7 ff ff 	lea    -0x810(%rbp),%rdx
  400cbe:	48 8d 85 fc f7 ff ff 	lea    -0x804(%rbp),%rax
  400cc5:	48 89 ce             	mov    %rcx,%rsi
  400cc8:	48 89 c7             	mov    %rax,%rdi
  400ccb:	e8 52 1f 00 00       	callq  402c22 <execve>
  400cd0:	89 45 d4             	mov    %eax,-0x2c(%rbp)
			if(ret == -1)
  400cd3:	83 7d d4 ff          	cmpl   $0xffffffff,-0x2c(%rbp)
  400cd7:	75 1f                	jne    400cf8 <execute_cmd+0x179>
			{
				strerror(errno);
  400cd9:	48 8b 05 90 34 20 00 	mov    0x203490(%rip),%rax        # 604170 <free+0x201065>
  400ce0:	8b 00                	mov    (%rax),%eax
  400ce2:	89 c7                	mov    %eax,%edi
  400ce4:	e8 fe 18 00 00       	callq  4025e7 <strerror>
				exit(1);
  400ce9:	bf 01 00 00 00       	mov    $0x1,%edi
  400cee:	e8 2b 20 00 00       	callq  402d1e <exit>
  400cf3:	e9 93 02 00 00       	jmpq   400f8b <execute_cmd+0x40c>
  400cf8:	e9 8e 02 00 00       	jmpq   400f8b <execute_cmd+0x40c>
		//printf("\ndone\n");
	}
	else
	{

		pipes=(int*)malloc(2*info->pipeNum*sizeof(int));
  400cfd:	48 8b 85 d8 f7 ff ff 	mov    -0x828(%rbp),%rax
  400d04:	8b 40 50             	mov    0x50(%rax),%eax
  400d07:	48 98                	cltq   
  400d09:	48 c1 e0 03          	shl    $0x3,%rax
  400d0d:	48 89 c7             	mov    %rax,%rdi
  400d10:	e8 89 22 00 00       	callq  402f9e <malloc>
  400d15:	48 89 45 e0          	mov    %rax,-0x20(%rbp)


		for(i=0; i<info->pipeNum; i++)
  400d19:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  400d20:	eb 34                	jmp    400d56 <execute_cmd+0x1d7>
		{
			if(pipe(pipes+i*2) == -1)
  400d22:	8b 45 ec             	mov    -0x14(%rbp),%eax
  400d25:	48 98                	cltq   
  400d27:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  400d2e:	00 
  400d2f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  400d33:	48 01 d0             	add    %rdx,%rax
  400d36:	48 89 c7             	mov    %rax,%rdi
  400d39:	e8 40 20 00 00       	callq  402d7e <pipe>
  400d3e:	83 f8 ff             	cmp    $0xffffffff,%eax
  400d41:	75 10                	jne    400d53 <execute_cmd+0x1d4>
				strerror(errno);
  400d43:	48 8b 05 26 34 20 00 	mov    0x203426(%rip),%rax        # 604170 <free+0x201065>
  400d4a:	8b 00                	mov    (%rax),%eax
  400d4c:	89 c7                	mov    %eax,%edi
  400d4e:	e8 94 18 00 00       	callq  4025e7 <strerror>
	{

		pipes=(int*)malloc(2*info->pipeNum*sizeof(int));


		for(i=0; i<info->pipeNum; i++)
  400d53:	ff 45 ec             	incl   -0x14(%rbp)
  400d56:	48 8b 85 d8 f7 ff ff 	mov    -0x828(%rbp),%rax
  400d5d:	8b 40 50             	mov    0x50(%rax),%eax
  400d60:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  400d63:	7f bd                	jg     400d22 <execute_cmd+0x1a3>
		{
			if(pipe(pipes+i*2) == -1)
				strerror(errno);
		}
		//printf("Multiple Commands");
		for(i=0; i<=info->pipeNum;i++)
  400d65:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  400d6c:	e9 b2 01 00 00       	jmpq   400f23 <execute_cmd+0x3a4>
		{
			proc_ids[i]=fork();
  400d71:	8b 45 ec             	mov    -0x14(%rbp),%eax
  400d74:	48 98                	cltq   
  400d76:	48 8d 14 85 00 00 00 	lea    0x0(,%rax,4),%rdx
  400d7d:	00 
  400d7e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  400d82:	48 8d 1c 02          	lea    (%rdx,%rax,1),%rbx
  400d86:	e8 67 1c 00 00       	callq  4029f2 <fork>
  400d8b:	89 03                	mov    %eax,(%rbx)
			if (proc_ids[i] < 0)
  400d8d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  400d90:	48 98                	cltq   
  400d92:	48 8d 14 85 00 00 00 	lea    0x0(,%rax,4),%rdx
  400d99:	00 
  400d9a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  400d9e:	48 01 d0             	add    %rdx,%rax
  400da1:	8b 00                	mov    (%rax),%eax
  400da3:	85 c0                	test   %eax,%eax
  400da5:	79 1a                	jns    400dc1 <execute_cmd+0x242>
			{
				strerror(errno);
  400da7:	48 8b 05 c2 33 20 00 	mov    0x2033c2(%rip),%rax        # 604170 <free+0x201065>
  400dae:	8b 00                	mov    (%rax),%eax
  400db0:	89 c7                	mov    %eax,%edi
  400db2:	e8 30 18 00 00       	callq  4025e7 <strerror>
				exit(1);
  400db7:	bf 01 00 00 00       	mov    $0x1,%edi
  400dbc:	e8 5d 1f 00 00       	callq  402d1e <exit>
			}
			//printf("pid=%d",proc_ids[i]);
			if(proc_ids[i]==0)
  400dc1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  400dc4:	48 98                	cltq   
  400dc6:	48 8d 14 85 00 00 00 	lea    0x0(,%rax,4),%rdx
  400dcd:	00 
  400dce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  400dd2:	48 01 d0             	add    %rdx,%rax
  400dd5:	8b 00                	mov    (%rax),%eax
  400dd7:	85 c0                	test   %eax,%eax
  400dd9:	0f 85 41 01 00 00    	jne    400f20 <execute_cmd+0x3a1>
			{
				//printf("in child%d",i);

				if(i!=0)
  400ddf:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  400de3:	74 37                	je     400e1c <execute_cmd+0x29d>
				{
					if(dup2(pipes[i*2-2],0)==-1)
  400de5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  400de8:	48 98                	cltq   
  400dea:	48 c1 e0 03          	shl    $0x3,%rax
  400dee:	48 8d 50 f8          	lea    -0x8(%rax),%rdx
  400df2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  400df6:	48 01 d0             	add    %rdx,%rax
  400df9:	8b 00                	mov    (%rax),%eax
  400dfb:	be 00 00 00 00       	mov    $0x0,%esi
  400e00:	89 c7                	mov    %eax,%edi
  400e02:	e8 e2 12 00 00       	callq  4020e9 <dup2>
  400e07:	83 f8 ff             	cmp    $0xffffffff,%eax
  400e0a:	75 10                	jne    400e1c <execute_cmd+0x29d>
						strerror(errno);
  400e0c:	48 8b 05 5d 33 20 00 	mov    0x20335d(%rip),%rax        # 604170 <free+0x201065>
  400e13:	8b 00                	mov    (%rax),%eax
  400e15:	89 c7                	mov    %eax,%edi
  400e17:	e8 cb 17 00 00       	callq  4025e7 <strerror>
				}
				if(i!=info->pipeNum)
  400e1c:	48 8b 85 d8 f7 ff ff 	mov    -0x828(%rbp),%rax
  400e23:	8b 40 50             	mov    0x50(%rax),%eax
  400e26:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  400e29:	74 37                	je     400e62 <execute_cmd+0x2e3>
				{

					if(dup2(pipes[i*2+1],1)==-1)
  400e2b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  400e2e:	48 98                	cltq   
  400e30:	48 c1 e0 03          	shl    $0x3,%rax
  400e34:	48 8d 50 04          	lea    0x4(%rax),%rdx
  400e38:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  400e3c:	48 01 d0             	add    %rdx,%rax
  400e3f:	8b 00                	mov    (%rax),%eax
  400e41:	be 01 00 00 00       	mov    $0x1,%esi
  400e46:	89 c7                	mov    %eax,%edi
  400e48:	e8 9c 12 00 00       	callq  4020e9 <dup2>
  400e4d:	83 f8 ff             	cmp    $0xffffffff,%eax
  400e50:	75 10                	jne    400e62 <execute_cmd+0x2e3>
						strerror(errno);
  400e52:	48 8b 05 17 33 20 00 	mov    0x203317(%rip),%rax        # 604170 <free+0x201065>
  400e59:	8b 00                	mov    (%rax),%eax
  400e5b:	89 c7                	mov    %eax,%edi
  400e5d:	e8 85 17 00 00       	callq  4025e7 <strerror>
				}

				for(j=0;j<info->pipeNum;j++)
  400e62:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%rbp)
  400e69:	eb 3d                	jmp    400ea8 <execute_cmd+0x329>
				{
					close(pipes[j*2]);
  400e6b:	8b 45 e8             	mov    -0x18(%rbp),%eax
  400e6e:	48 98                	cltq   
  400e70:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  400e77:	00 
  400e78:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  400e7c:	48 01 d0             	add    %rdx,%rax
  400e7f:	8b 00                	mov    (%rax),%eax
  400e81:	89 c7                	mov    %eax,%edi
  400e83:	e8 19 1b 00 00       	callq  4029a1 <close>
					close(pipes[j*2+1]);
  400e88:	8b 45 e8             	mov    -0x18(%rbp),%eax
  400e8b:	48 98                	cltq   
  400e8d:	48 c1 e0 03          	shl    $0x3,%rax
  400e91:	48 8d 50 04          	lea    0x4(%rax),%rdx
  400e95:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  400e99:	48 01 d0             	add    %rdx,%rax
  400e9c:	8b 00                	mov    (%rax),%eax
  400e9e:	89 c7                	mov    %eax,%edi
  400ea0:	e8 fc 1a 00 00       	callq  4029a1 <close>

					if(dup2(pipes[i*2+1],1)==-1)
						strerror(errno);
				}

				for(j=0;j<info->pipeNum;j++)
  400ea5:	ff 45 e8             	incl   -0x18(%rbp)
  400ea8:	48 8b 85 d8 f7 ff ff 	mov    -0x828(%rbp),%rax
  400eaf:	8b 40 50             	mov    0x50(%rax),%eax
  400eb2:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  400eb5:	7f b4                	jg     400e6b <execute_cmd+0x2ec>
				//printf("debug:%s ", cmd[i]);


				//printf("Executing Command %s\n",cmd[i]);

				char* envpChildProcess[]={NULL};
  400eb7:	48 c7 85 e8 f7 ff ff 	movq   $0x0,-0x818(%rbp)
  400ebe:	00 00 00 00 
				int ret=execve(cmd[i],info->CommArray[i]->VarList,envpChildProcess);
  400ec2:	48 8b 85 d8 f7 ff ff 	mov    -0x828(%rbp),%rax
  400ec9:	8b 55 ec             	mov    -0x14(%rbp),%edx
  400ecc:	48 63 d2             	movslq %edx,%rdx
  400ecf:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  400ed3:	48 8d 70 08          	lea    0x8(%rax),%rsi
  400ed7:	48 8d 95 fc f7 ff ff 	lea    -0x804(%rbp),%rdx
  400ede:	8b 45 ec             	mov    -0x14(%rbp),%eax
  400ee1:	48 98                	cltq   
  400ee3:	48 6b c0 64          	imul   $0x64,%rax,%rax
  400ee7:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  400eeb:	48 8d 85 e8 f7 ff ff 	lea    -0x818(%rbp),%rax
  400ef2:	48 89 c2             	mov    %rax,%rdx
  400ef5:	48 89 cf             	mov    %rcx,%rdi
  400ef8:	e8 25 1d 00 00       	callq  402c22 <execve>
  400efd:	89 45 d0             	mov    %eax,-0x30(%rbp)
				if(ret == -1)
  400f00:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%rbp)
  400f04:	75 1a                	jne    400f20 <execute_cmd+0x3a1>
				{
					strerror(errno);
  400f06:	48 8b 05 63 32 20 00 	mov    0x203263(%rip),%rax        # 604170 <free+0x201065>
  400f0d:	8b 00                	mov    (%rax),%eax
  400f0f:	89 c7                	mov    %eax,%edi
  400f11:	e8 d1 16 00 00       	callq  4025e7 <strerror>
					exit(1);
  400f16:	bf 01 00 00 00       	mov    $0x1,%edi
  400f1b:	e8 fe 1d 00 00       	callq  402d1e <exit>
		{
			if(pipe(pipes+i*2) == -1)
				strerror(errno);
		}
		//printf("Multiple Commands");
		for(i=0; i<=info->pipeNum;i++)
  400f20:	ff 45 ec             	incl   -0x14(%rbp)
  400f23:	48 8b 85 d8 f7 ff ff 	mov    -0x828(%rbp),%rax
  400f2a:	8b 40 50             	mov    0x50(%rax),%eax
  400f2d:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  400f30:	0f 8d 3b fe ff ff    	jge    400d71 <execute_cmd+0x1f2>
				}
			}
		}
		//printf("\nin multiple's parent\n");

		for(i=0;i<info->pipeNum;i++)
  400f36:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  400f3d:	eb 3d                	jmp    400f7c <execute_cmd+0x3fd>
		{
			close(pipes[i*2]);
  400f3f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  400f42:	48 98                	cltq   
  400f44:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  400f4b:	00 
  400f4c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  400f50:	48 01 d0             	add    %rdx,%rax
  400f53:	8b 00                	mov    (%rax),%eax
  400f55:	89 c7                	mov    %eax,%edi
  400f57:	e8 45 1a 00 00       	callq  4029a1 <close>
			close(pipes[i*2+1]);
  400f5c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  400f5f:	48 98                	cltq   
  400f61:	48 c1 e0 03          	shl    $0x3,%rax
  400f65:	48 8d 50 04          	lea    0x4(%rax),%rdx
  400f69:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  400f6d:	48 01 d0             	add    %rdx,%rax
  400f70:	8b 00                	mov    (%rax),%eax
  400f72:	89 c7                	mov    %eax,%edi
  400f74:	e8 28 1a 00 00       	callq  4029a1 <close>
				}
			}
		}
		//printf("\nin multiple's parent\n");

		for(i=0;i<info->pipeNum;i++)
  400f79:	ff 45 ec             	incl   -0x14(%rbp)
  400f7c:	48 8b 85 d8 f7 ff ff 	mov    -0x828(%rbp),%rax
  400f83:	8b 40 50             	mov    0x50(%rax),%eax
  400f86:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  400f89:	7f b4                	jg     400f3f <execute_cmd+0x3c0>
			close(pipes[i*2+1]);
			//printf("closed");
		}
	}
	//printf("\nin singles's parent\n");
	for (i = 0; i <= info->pipeNum; i++)
  400f8b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  400f92:	eb 2c                	jmp    400fc0 <execute_cmd+0x441>
		waitpid(proc_ids[i], &status, 0);
  400f94:	8b 45 ec             	mov    -0x14(%rbp),%eax
  400f97:	48 98                	cltq   
  400f99:	48 8d 14 85 00 00 00 	lea    0x0(,%rax,4),%rdx
  400fa0:	00 
  400fa1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  400fa5:	48 01 d0             	add    %rdx,%rax
  400fa8:	8b 00                	mov    (%rax),%eax
  400faa:	48 8d 4d cc          	lea    -0x34(%rbp),%rcx
  400fae:	ba 00 00 00 00       	mov    $0x0,%edx
  400fb3:	48 89 ce             	mov    %rcx,%rsi
  400fb6:	89 c7                	mov    %eax,%edi
  400fb8:	e8 c2 13 00 00       	callq  40237f <waitpid>
			close(pipes[i*2+1]);
			//printf("closed");
		}
	}
	//printf("\nin singles's parent\n");
	for (i = 0; i <= info->pipeNum; i++)
  400fbd:	ff 45 ec             	incl   -0x14(%rbp)
  400fc0:	48 8b 85 d8 f7 ff ff 	mov    -0x828(%rbp),%rax
  400fc7:	8b 40 50             	mov    0x50(%rax),%eax
  400fca:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  400fcd:	7d c5                	jge    400f94 <execute_cmd+0x415>
		waitpid(proc_ids[i], &status, 0);
	//printf("child returned:%d\n",waitpid(proc_ids[i], &status, 0));

}
  400fcf:	48 81 c4 28 08 00 00 	add    $0x828,%rsp
  400fd6:	5b                   	pop    %rbx
  400fd7:	5d                   	pop    %rbp
  400fd8:	c3                   	retq   

0000000000400fd9 <find_file_in_dir>:




char* find_file_in_dir (char *path, char *file)
{
  400fd9:	55                   	push   %rbp
  400fda:	48 89 e5             	mov    %rsp,%rbp
  400fdd:	48 83 ec 30          	sub    $0x30,%rsp
  400fe1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  400fe5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	struct dirent *entry=NULL;
  400fe9:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  400ff0:	00 
	char* ret = NULL;
  400ff1:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  400ff8:	00 
	//ret=NULL;
	void *dir;
	dir = opendir (path);
  400ff9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  400ffd:	48 89 c7             	mov    %rax,%rdi
  401000:	e8 81 12 00 00       	callq  402286 <opendir>
  401005:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	// if(dir == NULL)
	// 	return (char *)NULL;

	errno = 0;
  401009:	48 8b 05 60 31 20 00 	mov    0x203160(%rip),%rax        # 604170 <free+0x201065>
  401010:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	printf("dir = %d",(uint64_t)dir);
  401016:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  40101a:	48 89 c6             	mov    %rax,%rsi
  40101d:	48 8d 3d 0c 23 00 00 	lea    0x230c(%rip),%rdi        # 403330 <free+0x225>
  401024:	b8 00 00 00 00       	mov    $0x0,%eax
  401029:	e8 da 0c 00 00       	callq  401d08 <printf>
	while ((entry = readdir (dir)) != NULL) {
  40102e:	eb 3c                	jmp    40106c <find_file_in_dir+0x93>
		//printf("File = %s Searching = %s",entry->d_name, file);
		if (!strcmp(entry->d_name, file)) {
  401030:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  401034:	48 8d 50 12          	lea    0x12(%rax),%rdx
  401038:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  40103c:	48 89 c6             	mov    %rax,%rsi
  40103f:	48 89 d7             	mov    %rdx,%rdi
  401042:	e8 00 14 00 00       	callq  402447 <strcmp>
  401047:	85 c0                	test   %eax,%eax
  401049:	75 21                	jne    40106c <find_file_in_dir+0x93>
			
			ret=malloc(sizeof(strlen(path)+1));
  40104b:	bf 04 00 00 00       	mov    $0x4,%edi
  401050:	e8 49 1f 00 00       	callq  402f9e <malloc>
  401055:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
			strcpy(ret,path);
  401059:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  40105d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  401061:	48 89 d6             	mov    %rdx,%rsi
  401064:	48 89 c7             	mov    %rax,%rdi
  401067:	e8 7c 13 00 00       	callq  4023e8 <strcpy>
	// if(dir == NULL)
	// 	return (char *)NULL;

	errno = 0;
	printf("dir = %d",(uint64_t)dir);
	while ((entry = readdir (dir)) != NULL) {
  40106c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  401070:	48 89 c7             	mov    %rax,%rdi
  401073:	e8 42 1a 00 00       	callq  402aba <readdir>
  401078:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  40107c:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
  401081:	75 ad                	jne    401030 <find_file_in_dir+0x57>
			//break;
		}
	}


	printf("After finding file");
  401083:	48 8d 3d af 22 00 00 	lea    0x22af(%rip),%rdi        # 403339 <free+0x22e>
  40108a:	b8 00 00 00 00       	mov    $0x0,%eax
  40108f:	e8 74 0c 00 00       	callq  401d08 <printf>
	
	closedir(dir);
  401094:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  401098:	48 89 c7             	mov    %rax,%rdi
  40109b:	e8 45 11 00 00       	callq  4021e5 <closedir>


	//printf("In find_file_in_dir....returning %s\n",ret);
	return ret;
  4010a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  4010a4:	c9                   	leaveq 
  4010a5:	c3                   	retq   

00000000004010a6 <findBinaryFullPath>:


char* findBinaryFullPath(char* srchPath,char* binaryName){
  4010a6:	55                   	push   %rbp
  4010a7:	48 89 e5             	mov    %rsp,%rbp
  4010aa:	48 83 ec 60          	sub    $0x60,%rsp
  4010ae:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  4010b2:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
	 * Else if none of the above are there then find the full path
	 *
	 */

	int i;
	char* x=NULL;
  4010b6:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  4010bd:	00 
	//printf("In find full binary path\n");


	//printf("After strstr call. Search Path is :%s \n",srchPath);

	Token* dirToSearch = tokenize(srchPath,":");
  4010be:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  4010c2:	48 8d 35 83 22 00 00 	lea    0x2283(%rip),%rsi        # 40334c <free+0x241>
  4010c9:	48 89 c7             	mov    %rax,%rdi
  4010cc:	e8 ec 08 00 00       	callq  4019bd <tokenize>
  4010d1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)

	//printf("After tokenize on : Number of tokens %d\n",dirToSearch->numOfTokens);

	for(i=0;i<dirToSearch->numOfTokens;i++){
  4010d5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  4010dc:	eb 5d                	jmp    40113b <findBinaryFullPath+0x95>

		//printf("Calling find_file_in_dir token number %d of %d",i,dirToSearch->numOfTokens);
		//printf("\n\npath component 1 %s\n\n",dirToSearch->tokenArr[i]);
		strcpy(temp,dirToSearch->tokenArr[i]);
  4010de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  4010e2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  4010e5:	48 63 d2             	movslq %edx,%rdx
  4010e8:	48 8b 54 d0 08       	mov    0x8(%rax,%rdx,8),%rdx
  4010ed:	48 8d 45 b6          	lea    -0x4a(%rbp),%rax
  4010f1:	48 89 d6             	mov    %rdx,%rsi
  4010f4:	48 89 c7             	mov    %rax,%rdi
  4010f7:	e8 ec 12 00 00       	callq  4023e8 <strcpy>
		printf("\n\nBefore calling find_file_in_dir %s binary=%s\n",temp, binaryName);
  4010fc:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  401100:	48 8d 45 b6          	lea    -0x4a(%rbp),%rax
  401104:	48 89 c6             	mov    %rax,%rsi
  401107:	48 8d 3d 42 22 00 00 	lea    0x2242(%rip),%rdi        # 403350 <free+0x245>
  40110e:	b8 00 00 00 00       	mov    $0x0,%eax
  401113:	e8 f0 0b 00 00       	callq  401d08 <printf>

		x=find_file_in_dir(temp,binaryName);
  401118:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  40111c:	48 8d 45 b6          	lea    -0x4a(%rbp),%rax
  401120:	48 89 d6             	mov    %rdx,%rsi
  401123:	48 89 c7             	mov    %rax,%rdi
  401126:	e8 ae fe ff ff       	callq  400fd9 <find_file_in_dir>
  40112b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

		//while(1);

		if(x!=NULL){
  40112f:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
  401134:	74 02                	je     401138 <findBinaryFullPath+0x92>

			break;
  401136:	eb 0e                	jmp    401146 <findBinaryFullPath+0xa0>

	Token* dirToSearch = tokenize(srchPath,":");

	//printf("After tokenize on : Number of tokens %d\n",dirToSearch->numOfTokens);

	for(i=0;i<dirToSearch->numOfTokens;i++){
  401138:	ff 45 fc             	incl   -0x4(%rbp)
  40113b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  40113f:	8b 00                	mov    (%rax),%eax
  401141:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  401144:	7f 98                	jg     4010de <findBinaryFullPath+0x38>

		}
	}


	return x;
  401146:	48 8b 45 f0          	mov    -0x10(%rbp),%rax


}
  40114a:	c9                   	leaveq 
  40114b:	c3                   	retq   

000000000040114c <findEnvVar>:
#include <parser.h>
#include <errno.h>
#include <string.h>
#include <shell.h>

char** findEnvVar(char* envVar, char* envp[]){
  40114c:	55                   	push   %rbp
  40114d:	48 89 e5             	mov    %rsp,%rbp
  401150:	48 83 ec 20          	sub    $0x20,%rsp
  401154:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  401158:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	 * envVar in the evnp[]. It returns a pointer, which is a pointer to the array
	 * envp[] that contains a the pointer to the envVar string.
	 * If not found returns null.
	 */

	int count=0;
  40115c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	Token* tokens;

	//printf("Inside findEnv var\n");
    
	while(envp[count]!= NULL){
  401163:	eb 6a                	jmp    4011cf <findEnvVar+0x83>

		tokens = tokenize(envp[count],"=");
  401165:	8b 45 fc             	mov    -0x4(%rbp),%eax
  401168:	48 98                	cltq   
  40116a:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  401171:	00 
  401172:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  401176:	48 01 d0             	add    %rdx,%rax
  401179:	48 8b 00             	mov    (%rax),%rax
  40117c:	48 8d 35 fd 21 00 00 	lea    0x21fd(%rip),%rsi        # 403380 <free+0x275>
  401183:	48 89 c7             	mov    %rax,%rdi
  401186:	e8 32 08 00 00       	callq  4019bd <tokenize>
  40118b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

		//printf("%s\n",envp[count]);

		if(strcmp(tokens->tokenArr[0],envVar)==0){
  40118f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  401193:	48 8b 40 08          	mov    0x8(%rax),%rax
  401197:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  40119b:	48 89 d6             	mov    %rdx,%rsi
  40119e:	48 89 c7             	mov    %rax,%rdi
  4011a1:	e8 a1 12 00 00       	callq  402447 <strcmp>
  4011a6:	85 c0                	test   %eax,%eax
  4011a8:	75 16                	jne    4011c0 <findEnvVar+0x74>
			return(envp+count);
  4011aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  4011ad:	48 98                	cltq   
  4011af:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  4011b6:	00 
  4011b7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  4011bb:	48 01 d0             	add    %rdx,%rax
  4011be:	eb 34                	jmp    4011f4 <findEnvVar+0xa8>
		}
		free(tokens);
  4011c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  4011c4:	48 89 c7             	mov    %rax,%rdi
  4011c7:	e8 3f 1f 00 00       	callq  40310b <free>
		count++;
  4011cc:	ff 45 fc             	incl   -0x4(%rbp)
	int count=0;
	Token* tokens;

	//printf("Inside findEnv var\n");
    
	while(envp[count]!= NULL){
  4011cf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  4011d2:	48 98                	cltq   
  4011d4:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  4011db:	00 
  4011dc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  4011e0:	48 01 d0             	add    %rdx,%rax
  4011e3:	48 8b 00             	mov    (%rax),%rax
  4011e6:	48 85 c0             	test   %rax,%rax
  4011e9:	0f 85 76 ff ff ff    	jne    401165 <findEnvVar+0x19>
			return(envp+count);
		}
		free(tokens);
		count++;
	}
	return (char**)NULL;
  4011ef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  4011f4:	c9                   	leaveq 
  4011f5:	c3                   	retq   

00000000004011f6 <main1>:
#include <stdio.h>

int main1(int argc, char* argv[], char* envp[]) {
  4011f6:	55                   	push   %rbp
  4011f7:	48 89 e5             	mov    %rsp,%rbp
  4011fa:	48 83 ec 20          	sub    $0x20,%rsp
  4011fe:	89 7d fc             	mov    %edi,-0x4(%rbp)
  401201:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  401205:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	printf("Hello World!\n");
  401209:	48 8d 3d 72 21 00 00 	lea    0x2172(%rip),%rdi        # 403382 <free+0x277>
  401210:	b8 00 00 00 00       	mov    $0x0,%eax
  401215:	e8 ee 0a 00 00       	callq  401d08 <printf>
	return 0;
  40121a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  40121f:	c9                   	leaveq 
  401220:	c3                   	retq   

0000000000401221 <print_info>:
#include <shell.h>




void print_info (parseInfo *info) {
  401221:	55                   	push   %rbp
  401222:	48 89 e5             	mov    %rsp,%rbp
  401225:	48 83 ec 20          	sub    $0x20,%rsp
  401229:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	printf("print_info: printing info about parseInfo struct\n");
  40122d:	48 8d 3d 5c 21 00 00 	lea    0x215c(%rip),%rdi        # 403390 <free+0x285>
  401234:	b8 00 00 00 00       	mov    $0x0,%eax
  401239:	e8 ca 0a 00 00       	callq  401d08 <printf>
	//printf("Number of pipe separated commands %d\n",info->pipeNum);


	int i,j;

	for(i=0;i<=info->pipeNum;i++){
  40123e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  401245:	eb 4a                	jmp    401291 <print_info+0x70>

		printf("Command Name : %s\n",info->CommArray[i]->commandName);
  401247:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  40124b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  40124e:	48 63 d2             	movslq %edx,%rdx
  401251:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  401255:	48 8b 00             	mov    (%rax),%rax
  401258:	48 89 c6             	mov    %rax,%rsi
  40125b:	48 8d 3d 60 21 00 00 	lea    0x2160(%rip),%rdi        # 4033c2 <free+0x2b7>
  401262:	b8 00 00 00 00       	mov    $0x0,%eax
  401267:	e8 9c 0a 00 00       	callq  401d08 <printf>

		//printf("Command Arguments :\n");
		//printf("Number of arguments %d\n",info->CommArray[i]->VarNum);

		for(j=0;j<info->CommArray[i]->VarNum;j++){
  40126c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  401273:	eb 03                	jmp    401278 <print_info+0x57>
  401275:	ff 45 f8             	incl   -0x8(%rbp)
  401278:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  40127c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  40127f:	48 63 d2             	movslq %edx,%rdx
  401282:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  401286:	8b 40 58             	mov    0x58(%rax),%eax
  401289:	3b 45 f8             	cmp    -0x8(%rbp),%eax
  40128c:	7f e7                	jg     401275 <print_info+0x54>
	//printf("Number of pipe separated commands %d\n",info->pipeNum);


	int i,j;

	for(i=0;i<=info->pipeNum;i++){
  40128e:	ff 45 fc             	incl   -0x4(%rbp)
  401291:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  401295:	8b 40 50             	mov    0x50(%rax),%eax
  401298:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  40129b:	7d aa                	jge    401247 <print_info+0x26>
			//printf("Argument %d : %s \n", j,info->CommArray[i]->VarList[j]);
		}

	}

	return;
  40129d:	90                   	nop
}
  40129e:	c9                   	leaveq 
  40129f:	c3                   	retq   

00000000004012a0 <free_info>:

void free_info (parseInfo *info) {
  4012a0:	55                   	push   %rbp
  4012a1:	48 89 e5             	mov    %rsp,%rbp
  4012a4:	48 83 ec 10          	sub    $0x10,%rsp
  4012a8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	//printf("free_info: freeing memory associated to parseInfo struct\n");
	free(info);
  4012ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  4012b0:	48 89 c7             	mov    %rax,%rdi
  4012b3:	e8 53 1e 00 00       	callq  40310b <free>
}
  4012b8:	c9                   	leaveq 
  4012b9:	c3                   	retq   

00000000004012ba <parseModified>:

parseInfo* parseModified(char *cmd,char* envp[]){
  4012ba:	55                   	push   %rbp
  4012bb:	48 89 e5             	mov    %rsp,%rbp
  4012be:	48 81 ec 40 02 00 00 	sub    $0x240,%rsp
  4012c5:	48 89 bd c8 fd ff ff 	mov    %rdi,-0x238(%rbp)
  4012cc:	48 89 b5 c0 fd ff ff 	mov    %rsi,-0x240(%rbp)

	parseInfo *Result;
	Token* tokenPipe;
	Token* tokenSpace;
	//Token* path;
	singleCommand* sc = NULL;
  4012d3:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  4012da:	00 
//	char** envVar=NULL;
	char *fullPath=NULL;
  4012db:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  4012e2:	00 
	int i=0,j=0;
  4012e3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  4012ea:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
	char srchPath[500];
	//printf("In PARSE MODIFIED");
	Result = (parseInfo*)malloc(sizeof(parseInfo));
  4012f1:	bf 58 00 00 00       	mov    $0x58,%edi
  4012f6:	e8 a3 1c 00 00       	callq  402f9e <malloc>
  4012fb:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
//		printf("PATH is ---> %s",path->tokenArr[1]);

    

	//strcpy(srchPath,path->tokenArr[1]);
	strcpy(srchPath,"/bin");
  4012ff:	48 8d 85 dc fd ff ff 	lea    -0x224(%rbp),%rax
  401306:	48 8d 35 c8 20 00 00 	lea    0x20c8(%rip),%rsi        # 4033d5 <free+0x2ca>
  40130d:	48 89 c7             	mov    %rax,%rdi
  401310:	e8 d3 10 00 00       	callq  4023e8 <strcpy>

	printf("Seatch PAth is %s",srchPath);
  401315:	48 8d 85 dc fd ff ff 	lea    -0x224(%rbp),%rax
  40131c:	48 89 c6             	mov    %rax,%rsi
  40131f:	48 8d 3d b4 20 00 00 	lea    0x20b4(%rip),%rdi        # 4033da <free+0x2cf>
  401326:	b8 00 00 00 00       	mov    $0x0,%eax
  40132b:	e8 d8 09 00 00       	callq  401d08 <printf>

	tokenPipe = tokenize(cmd,"|");
  401330:	48 8b 85 c8 fd ff ff 	mov    -0x238(%rbp),%rax
  401337:	48 8d 35 ae 20 00 00 	lea    0x20ae(%rip),%rsi        # 4033ec <free+0x2e1>
  40133e:	48 89 c7             	mov    %rax,%rdi
  401341:	e8 77 06 00 00       	callq  4019bd <tokenize>
  401346:	48 89 45 d8          	mov    %rax,-0x28(%rbp)

	//printf("In PARSE MODIFIED%d\n",tokenPipe->numOfTokens);
	for(i=0;i<tokenPipe->numOfTokens;i++){
  40134a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  401351:	e9 e5 01 00 00       	jmpq   40153b <parseModified+0x281>

		//for each pipe separated token find space separated tokens
		tokenSpace=tokenize(tokenPipe->tokenArr[i]," ");
  401356:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  40135a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  40135d:	48 63 d2             	movslq %edx,%rdx
  401360:	48 8b 44 d0 08       	mov    0x8(%rax,%rdx,8),%rax
  401365:	48 8d 35 82 20 00 00 	lea    0x2082(%rip),%rsi        # 4033ee <free+0x2e3>
  40136c:	48 89 c7             	mov    %rax,%rdi
  40136f:	e8 49 06 00 00       	callq  4019bd <tokenize>
  401374:	48 89 45 d0          	mov    %rax,-0x30(%rbp)

		//initialize the singleCommand Structure
		sc = (singleCommand*)malloc(sizeof(singleCommand));
  401378:	bf 60 00 00 00       	mov    $0x60,%edi
  40137d:	e8 1c 1c 00 00       	callq  402f9e <malloc>
  401382:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		sc->commandName=(char*)malloc(100);
  401386:	bf 64 00 00 00       	mov    $0x64,%edi
  40138b:	e8 0e 1c 00 00       	callq  402f9e <malloc>
  401390:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  401394:	48 89 02             	mov    %rax,(%rdx)
		sc->commandName[0]='\0';
  401397:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  40139b:	48 8b 00             	mov    (%rax),%rax
  40139e:	c6 00 00             	movb   $0x0,(%rax)
		//printf("Before find full binary path\n\n\n");
		sc->commandName=tokenSpace->tokenArr[0];
  4013a1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  4013a5:	48 8b 50 08          	mov    0x8(%rax),%rdx
  4013a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  4013ad:	48 89 10             	mov    %rdx,(%rax)
		if(strcmp(tokenSpace->tokenArr[0],"set") && strcmp(tokenSpace->tokenArr[0],"cd") && strcmp(tokenSpace->tokenArr[0],"exit") )
  4013b0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  4013b4:	48 8b 40 08          	mov    0x8(%rax),%rax
  4013b8:	48 8d 35 31 20 00 00 	lea    0x2031(%rip),%rsi        # 4033f0 <free+0x2e5>
  4013bf:	48 89 c7             	mov    %rax,%rdi
  4013c2:	e8 80 10 00 00       	callq  402447 <strcmp>
  4013c7:	85 c0                	test   %eax,%eax
  4013c9:	0f 84 e7 00 00 00    	je     4014b6 <parseModified+0x1fc>
  4013cf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  4013d3:	48 8b 40 08          	mov    0x8(%rax),%rax
  4013d7:	48 8d 35 16 20 00 00 	lea    0x2016(%rip),%rsi        # 4033f4 <free+0x2e9>
  4013de:	48 89 c7             	mov    %rax,%rdi
  4013e1:	e8 61 10 00 00       	callq  402447 <strcmp>
  4013e6:	85 c0                	test   %eax,%eax
  4013e8:	0f 84 c8 00 00 00    	je     4014b6 <parseModified+0x1fc>
  4013ee:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  4013f2:	48 8b 40 08          	mov    0x8(%rax),%rax
  4013f6:	48 8d 35 fa 1f 00 00 	lea    0x1ffa(%rip),%rsi        # 4033f7 <free+0x2ec>
  4013fd:	48 89 c7             	mov    %rax,%rdi
  401400:	e8 42 10 00 00       	callq  402447 <strcmp>
  401405:	85 c0                	test   %eax,%eax
  401407:	0f 84 a9 00 00 00    	je     4014b6 <parseModified+0x1fc>
		{
			//printf("Loop %d cmd: %s\n\n",i,tokenSpace->tokenArr[0] );

			if(strstr(tokenSpace->tokenArr[0],"/")==NULL){
  40140d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  401411:	48 8b 40 08          	mov    0x8(%rax),%rax
  401415:	48 8d 35 e0 1f 00 00 	lea    0x1fe0(%rip),%rsi        # 4033fc <free+0x2f1>
  40141c:	48 89 c7             	mov    %rax,%rdi
  40141f:	e8 aa 10 00 00       	callq  4024ce <strstr>
  401424:	48 85 c0             	test   %rax,%rax
  401427:	0f 85 89 00 00 00    	jne    4014b6 <parseModified+0x1fc>

				fullPath=findBinaryFullPath(srchPath,tokenSpace->tokenArr[0]);
  40142d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  401431:	48 8b 50 08          	mov    0x8(%rax),%rdx
  401435:	48 8d 85 dc fd ff ff 	lea    -0x224(%rbp),%rax
  40143c:	48 89 d6             	mov    %rdx,%rsi
  40143f:	48 89 c7             	mov    %rax,%rdi
  401442:	e8 5f fc ff ff       	callq  4010a6 <findBinaryFullPath>
  401447:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				if(fullPath==NULL)
  40144b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  401450:	75 1b                	jne    40146d <parseModified+0x1b3>
				{
					printf("Error:Command Not found.\n");
  401452:	48 8d 3d a5 1f 00 00 	lea    0x1fa5(%rip),%rdi        # 4033fe <free+0x2f3>
  401459:	b8 00 00 00 00       	mov    $0x0,%eax
  40145e:	e8 a5 08 00 00       	callq  401d08 <printf>
					return NULL;
  401463:	b8 00 00 00 00       	mov    $0x0,%eax
  401468:	e9 f1 00 00 00       	jmpq   40155e <parseModified+0x2a4>
				}
				sc->commandName = fullPath;
  40146d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  401471:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  401475:	48 89 10             	mov    %rdx,(%rax)
				sc->commandName = strcat(sc->commandName,"/");
  401478:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  40147c:	48 8b 00             	mov    (%rax),%rax
  40147f:	48 8d 35 76 1f 00 00 	lea    0x1f76(%rip),%rsi        # 4033fc <free+0x2f1>
  401486:	48 89 c7             	mov    %rax,%rdi
  401489:	e8 1e 11 00 00       	callq  4025ac <strcat>
  40148e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  401492:	48 89 02             	mov    %rax,(%rdx)
				sc->commandName = strcat(sc->commandName,tokenSpace->tokenArr[0]);
  401495:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  401499:	48 8b 50 08          	mov    0x8(%rax),%rdx
  40149d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  4014a1:	48 8b 00             	mov    (%rax),%rax
  4014a4:	48 89 d6             	mov    %rdx,%rsi
  4014a7:	48 89 c7             	mov    %rax,%rdi
  4014aa:	e8 fd 10 00 00       	callq  4025ac <strcat>
  4014af:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  4014b3:	48 89 02             	mov    %rax,(%rdx)
		}

		//printf("In parser..fullpath for %s is %s\n",tokenSpace->tokenArr[0],fullPath);


		printf("COMMAND NAME=%s\n",sc->commandName);
  4014b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  4014ba:	48 8b 00             	mov    (%rax),%rax
  4014bd:	48 89 c6             	mov    %rax,%rsi
  4014c0:	48 8d 3d 51 1f 00 00 	lea    0x1f51(%rip),%rdi        # 403418 <free+0x30d>
  4014c7:	b8 00 00 00 00       	mov    $0x0,%eax
  4014cc:	e8 37 08 00 00       	callq  401d08 <printf>
		//sc->VarList[0]=fullPath;
		sc->VarNum = tokenSpace->numOfTokens;
  4014d1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  4014d5:	8b 10                	mov    (%rax),%edx
  4014d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  4014db:	89 50 58             	mov    %edx,0x58(%rax)
		for(j=0;j<tokenSpace->numOfTokens;j++){
  4014de:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  4014e5:	eb 21                	jmp    401508 <parseModified+0x24e>
			sc->VarList[j]=tokenSpace->tokenArr[j];
  4014e7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  4014eb:	8b 55 f8             	mov    -0x8(%rbp),%edx
  4014ee:	48 63 d2             	movslq %edx,%rdx
  4014f1:	48 8b 4c d0 08       	mov    0x8(%rax,%rdx,8),%rcx
  4014f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  4014fa:	8b 55 f8             	mov    -0x8(%rbp),%edx
  4014fd:	48 63 d2             	movslq %edx,%rdx
  401500:	48 89 4c d0 08       	mov    %rcx,0x8(%rax,%rdx,8)


		printf("COMMAND NAME=%s\n",sc->commandName);
		//sc->VarList[0]=fullPath;
		sc->VarNum = tokenSpace->numOfTokens;
		for(j=0;j<tokenSpace->numOfTokens;j++){
  401505:	ff 45 f8             	incl   -0x8(%rbp)
  401508:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  40150c:	8b 00                	mov    (%rax),%eax
  40150e:	3b 45 f8             	cmp    -0x8(%rbp),%eax
  401511:	7f d4                	jg     4014e7 <parseModified+0x22d>
			sc->VarList[j]=tokenSpace->tokenArr[j];
		}
		sc->VarList[j]=NULL;
  401513:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  401517:	8b 55 f8             	mov    -0x8(%rbp),%edx
  40151a:	48 63 d2             	movslq %edx,%rdx
  40151d:	48 c7 44 d0 08 00 00 	movq   $0x0,0x8(%rax,%rdx,8)
  401524:	00 00 

		Result->CommArray[i]=sc;
  401526:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  40152a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  40152d:	48 63 d2             	movslq %edx,%rdx
  401530:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  401534:	48 89 0c d0          	mov    %rcx,(%rax,%rdx,8)
	printf("Seatch PAth is %s",srchPath);

	tokenPipe = tokenize(cmd,"|");

	//printf("In PARSE MODIFIED%d\n",tokenPipe->numOfTokens);
	for(i=0;i<tokenPipe->numOfTokens;i++){
  401538:	ff 45 fc             	incl   -0x4(%rbp)
  40153b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  40153f:	8b 00                	mov    (%rax),%eax
  401541:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  401544:	0f 8f 0c fe ff ff    	jg     401356 <parseModified+0x9c>

		Result->CommArray[i]=sc;

	}

	Result->pipeNum=tokenPipe->numOfTokens-1; //set the number of pipe separated commands
  40154a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  40154e:	8b 00                	mov    (%rax),%eax
  401550:	8d 50 ff             	lea    -0x1(%rax),%edx
  401553:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  401557:	89 50 50             	mov    %edx,0x50(%rax)

	return Result;
  40155a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
}
  40155e:	c9                   	leaveq 
  40155f:	c3                   	retq   

0000000000401560 <read_line>:

int read_line(int fd, char* buf)
{
  401560:	55                   	push   %rbp
  401561:	48 89 e5             	mov    %rsp,%rbp
  401564:	48 83 ec 10          	sub    $0x10,%rsp
  401568:	89 7d fc             	mov    %edi,-0x4(%rbp)
  40156b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
		//printf("read: %c ",*byte);
		if (ret == -1)
			return -1;
	}
	*(byte-1)='\0';*/
    read(0,buf,MAXLINE);
  40156f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  401573:	ba 00 01 00 00       	mov    $0x100,%edx
  401578:	48 89 c6             	mov    %rax,%rsi
  40157b:	bf 00 00 00 00       	mov    $0x0,%edi
  401580:	e8 0f 16 00 00       	callq  402b94 <read>
	return 1;
  401585:	b8 01 00 00 00       	mov    $0x1,%eax
}
  40158a:	c9                   	leaveq 
  40158b:	c3                   	retq   

000000000040158c <changePS1>:
#include <parser.h>
#include <errno.h>
#include <string.h>
#include <shell.h>

void changePS1(char*str){
  40158c:	55                   	push   %rbp
  40158d:	48 89 e5             	mov    %rsp,%rbp
  401590:	48 83 ec 20          	sub    $0x20,%rsp
  401594:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	 * The PS1 is a shell variable
	 *
	 */

	Token* tokenEqulas;
	tokenEqulas = tokenize(str,"=");
  401598:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  40159c:	48 8d 35 8d 1e 00 00 	lea    0x1e8d(%rip),%rsi        # 403430 <free+0x325>
  4015a3:	48 89 c7             	mov    %rax,%rdi
  4015a6:	e8 12 04 00 00       	callq  4019bd <tokenize>
  4015ab:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	//printf("no:%d\n\n",tokenEqulas->numOfTokens);

	if(tokenEqulas->numOfTokens < 2)
  4015af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  4015b3:	8b 00                	mov    (%rax),%eax
  4015b5:	83 f8 01             	cmp    $0x1,%eax
  4015b8:	7f 13                	jg     4015cd <changePS1+0x41>
	{
		printf("Error:Invalid PS1\n");
  4015ba:	48 8d 3d 71 1e 00 00 	lea    0x1e71(%rip),%rdi        # 403432 <free+0x327>
  4015c1:	b8 00 00 00 00       	mov    $0x0,%eax
  4015c6:	e8 3d 07 00 00       	callq  401d08 <printf>
  4015cb:	eb 5d                	jmp    40162a <changePS1+0x9e>
	}
	else if(strlen(tokenEqulas->tokenArr[1])>100){
  4015cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  4015d1:	48 8b 40 10          	mov    0x10(%rax),%rax
  4015d5:	48 89 c7             	mov    %rax,%rdi
  4015d8:	e8 d6 0d 00 00       	callq  4023b3 <strlen>
  4015dd:	83 f8 64             	cmp    $0x64,%eax
  4015e0:	7e 13                	jle    4015f5 <changePS1+0x69>
		printf("Too long a prompt name.Pleasee try again\n");
  4015e2:	48 8d 3d 5f 1e 00 00 	lea    0x1e5f(%rip),%rdi        # 403448 <free+0x33d>
  4015e9:	b8 00 00 00 00       	mov    $0x0,%eax
  4015ee:	e8 15 07 00 00       	callq  401d08 <printf>
  4015f3:	eb 35                	jmp    40162a <changePS1+0x9e>
	}


	else{

		strcpy(PS1,tokenEqulas->tokenArr[1]);
  4015f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  4015f9:	48 8b 40 10          	mov    0x10(%rax),%rax
  4015fd:	48 89 c6             	mov    %rax,%rsi
  401600:	48 8d 05 99 2b 20 00 	lea    0x202b99(%rip),%rax        # 6041a0 <PS1>
  401607:	48 89 c7             	mov    %rax,%rdi
  40160a:	e8 d9 0d 00 00       	callq  4023e8 <strcpy>
		printf("PS1 after change %s\n",PS1);
  40160f:	48 8d 05 8a 2b 20 00 	lea    0x202b8a(%rip),%rax        # 6041a0 <PS1>
  401616:	48 89 c6             	mov    %rax,%rsi
  401619:	48 8d 3d 52 1e 00 00 	lea    0x1e52(%rip),%rdi        # 403472 <free+0x367>
  401620:	b8 00 00 00 00       	mov    $0x0,%eax
  401625:	e8 de 06 00 00       	callq  401d08 <printf>
	}

}
  40162a:	c9                   	leaveq 
  40162b:	c3                   	retq   

000000000040162c <removeSpaces>:
#include<stdio.h>
#include<string.h>
#include<stdlib.h>


char* removeSpaces(char*str){
  40162c:	55                   	push   %rbp
  40162d:	48 89 e5             	mov    %rsp,%rbp
  401630:	48 81 ec 90 00 00 00 	sub    $0x90,%rsp
  401637:	48 89 bd 78 ff ff ff 	mov    %rdi,-0x88(%rbp)
	/*
	 * This function removes spaces from str without modifying it
	 * The string returned must be malloced
	 */

	int i=0,j=0;
  40163e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  401645:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
	char *noSpaceStr=NULL;
  40164c:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  401653:	00 
	char temp[100];


	for(i=0;i<strlen(str);i++){
  401654:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  40165b:	eb 3c                	jmp    401699 <removeSpaces+0x6d>

		if(str[i]!=' '){
  40165d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  401660:	48 63 d0             	movslq %eax,%rdx
  401663:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  40166a:	48 01 d0             	add    %rdx,%rax
  40166d:	0f b6 00             	movzbl (%rax),%eax
  401670:	3c 20                	cmp    $0x20,%al
  401672:	74 22                	je     401696 <removeSpaces+0x6a>
			temp[j++]=str[i];
  401674:	8b 45 f8             	mov    -0x8(%rbp),%eax
  401677:	8d 50 01             	lea    0x1(%rax),%edx
  40167a:	89 55 f8             	mov    %edx,-0x8(%rbp)
  40167d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  401680:	48 63 ca             	movslq %edx,%rcx
  401683:	48 8b 95 78 ff ff ff 	mov    -0x88(%rbp),%rdx
  40168a:	48 01 ca             	add    %rcx,%rdx
  40168d:	0f b6 12             	movzbl (%rdx),%edx
  401690:	48 98                	cltq   
  401692:	88 54 05 8c          	mov    %dl,-0x74(%rbp,%rax,1)
	int i=0,j=0;
	char *noSpaceStr=NULL;
	char temp[100];


	for(i=0;i<strlen(str);i++){
  401696:	ff 45 fc             	incl   -0x4(%rbp)
  401699:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  4016a0:	48 89 c7             	mov    %rax,%rdi
  4016a3:	e8 0b 0d 00 00       	callq  4023b3 <strlen>
  4016a8:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  4016ab:	7f b0                	jg     40165d <removeSpaces+0x31>
		if(str[i]!=' '){
			temp[j++]=str[i];
		}

	}
	temp[j]='\0';
  4016ad:	8b 45 f8             	mov    -0x8(%rbp),%eax
  4016b0:	48 98                	cltq   
  4016b2:	c6 44 05 8c 00       	movb   $0x0,-0x74(%rbp,%rax,1)

	noSpaceStr = malloc(sizeof(char)*(strlen(temp)));
  4016b7:	48 8d 45 8c          	lea    -0x74(%rbp),%rax
  4016bb:	48 89 c7             	mov    %rax,%rdi
  4016be:	e8 f0 0c 00 00       	callq  4023b3 <strlen>
  4016c3:	48 98                	cltq   
  4016c5:	48 89 c7             	mov    %rax,%rdi
  4016c8:	e8 d1 18 00 00       	callq  402f9e <malloc>
  4016cd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	strcpy(noSpaceStr,temp);
  4016d1:	48 8d 55 8c          	lea    -0x74(%rbp),%rdx
  4016d5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  4016d9:	48 89 d6             	mov    %rdx,%rsi
  4016dc:	48 89 c7             	mov    %rax,%rdi
  4016df:	e8 04 0d 00 00       	callq  4023e8 <strcpy>

	return noSpaceStr;
  4016e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax

}
  4016e8:	c9                   	leaveq 
  4016e9:	c3                   	retq   

00000000004016ea <main>:


char PS1[200]="SBUSH";

int main (int argc, char *argv[], char* envp[])
{
  4016ea:	55                   	push   %rbp
  4016eb:	48 89 e5             	mov    %rsp,%rbp
  4016ee:	48 81 ec 50 01 00 00 	sub    $0x150,%rsp
  4016f5:	89 bd cc fe ff ff    	mov    %edi,-0x134(%rbp)
  4016fb:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
  401702:	48 89 95 b8 fe ff ff 	mov    %rdx,-0x148(%rbp)
	printf("Argv[0] = %s\n",argv[0]);
	printf("Envp[0] = %s\n\n",envp[0]);
	printf("Starting shell\n");*/


    printf("argc=%d %p %p ",argc,argv,envp);
  401709:	48 8b 8d b8 fe ff ff 	mov    -0x148(%rbp),%rcx
  401710:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  401717:	8b 85 cc fe ff ff    	mov    -0x134(%rbp),%eax
  40171d:	89 c6                	mov    %eax,%esi
  40171f:	48 8d 3d 61 1d 00 00 	lea    0x1d61(%rip),%rdi        # 403487 <free+0x37c>
  401726:	b8 00 00 00 00       	mov    $0x0,%eax
  40172b:	e8 d8 05 00 00       	callq  401d08 <printf>
//    printf("argv=%s",envp[0]);
char cmdLine[MAXLINE];


	int fd=0,ret;
  401730:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	{
		//cmdLine = "Santosh 1 2 3 | ls -l";

		if(1 || argv[1] == NULL)
		{
			printf("%s> ",PS1);
  401737:	48 8d 05 62 2a 20 00 	lea    0x202a62(%rip),%rax        # 6041a0 <PS1>
  40173e:	48 89 c6             	mov    %rax,%rsi
  401741:	48 8d 3d 4e 1d 00 00 	lea    0x1d4e(%rip),%rdi        # 403496 <free+0x38b>
  401748:	b8 00 00 00 00       	mov    $0x0,%eax
  40174d:	e8 b6 05 00 00       	callq  401d08 <printf>
			read_line(0,cmdLine);
  401752:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  401759:	48 89 c6             	mov    %rax,%rsi
  40175c:	bf 00 00 00 00       	mov    $0x0,%edi
  401761:	e8 fa fd ff ff       	callq  401560 <read_line>
		if (cmdLine == NULL) {
			printf("Unable to read last command\n");
			continue;
		}

		if(!(*cmdLine)){
  401766:	0f b6 85 f0 fe ff ff 	movzbl -0x110(%rbp),%eax
  40176d:	84 c0                	test   %al,%al
  40176f:	75 05                	jne    401776 <main+0x8c>
			//printf("No command entered\n");
			continue;
  401771:	e9 05 01 00 00       	jmpq   40187b <main+0x191>
		}

		//printf("Calling parser%s",cmdLine);
		info = parseModified(cmdLine,envp);
  401776:	48 8b 95 b8 fe ff ff 	mov    -0x148(%rbp),%rdx
  40177d:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  401784:	48 89 d6             	mov    %rdx,%rsi
  401787:	48 89 c7             	mov    %rax,%rdi
  40178a:	e8 2b fb ff ff       	callq  4012ba <parseModified>
  40178f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if (info == NULL){
  401793:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
  401798:	75 14                	jne    4017ae <main+0xc4>
			free(cmdLine);
  40179a:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  4017a1:	48 89 c7             	mov    %rax,%rdi
  4017a4:	e8 62 19 00 00       	callq  40310b <free>
			continue;
  4017a9:	e9 cd 00 00 00       	jmpq   40187b <main+0x191>
		}

		//prints the info struct
		//print_info(info);

		strcpy(temp,info->CommArray[0]->commandName);
  4017ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  4017b2:	48 8b 00             	mov    (%rax),%rax
  4017b5:	48 8b 10             	mov    (%rax),%rdx
  4017b8:	48 8d 85 dc fe ff ff 	lea    -0x124(%rbp),%rax
  4017bf:	48 89 d6             	mov    %rdx,%rsi
  4017c2:	48 89 c7             	mov    %rax,%rdi
  4017c5:	e8 1e 0c 00 00       	callq  4023e8 <strcpy>

		if(strcmp(temp,"set")==0||strcmp(temp,"cd")==0 || strcmp(temp,"exit")==0){
  4017ca:	48 8d 85 dc fe ff ff 	lea    -0x124(%rbp),%rax
  4017d1:	48 8d 35 c3 1c 00 00 	lea    0x1cc3(%rip),%rsi        # 40349b <free+0x390>
  4017d8:	48 89 c7             	mov    %rax,%rdi
  4017db:	e8 67 0c 00 00       	callq  402447 <strcmp>
  4017e0:	85 c0                	test   %eax,%eax
  4017e2:	74 34                	je     401818 <main+0x12e>
  4017e4:	48 8d 85 dc fe ff ff 	lea    -0x124(%rbp),%rax
  4017eb:	48 8d 35 ad 1c 00 00 	lea    0x1cad(%rip),%rsi        # 40349f <free+0x394>
  4017f2:	48 89 c7             	mov    %rax,%rdi
  4017f5:	e8 4d 0c 00 00       	callq  402447 <strcmp>
  4017fa:	85 c0                	test   %eax,%eax
  4017fc:	74 1a                	je     401818 <main+0x12e>
  4017fe:	48 8d 85 dc fe ff ff 	lea    -0x124(%rbp),%rax
  401805:	48 8d 35 96 1c 00 00 	lea    0x1c96(%rip),%rsi        # 4034a2 <free+0x397>
  40180c:	48 89 c7             	mov    %rax,%rdi
  40180f:	e8 33 0c 00 00       	callq  402447 <strcmp>
  401814:	85 c0                	test   %eax,%eax
  401816:	75 29                	jne    401841 <main+0x157>

			printf("Executing Builtin command\n");
  401818:	48 8d 3d 88 1c 00 00 	lea    0x1c88(%rip),%rdi        # 4034a7 <free+0x39c>
  40181f:	b8 00 00 00 00       	mov    $0x0,%eax
  401824:	e8 df 04 00 00       	callq  401d08 <printf>
			executeBuiltins(info,envp);
  401829:	48 8b 95 b8 fe ff ff 	mov    -0x148(%rbp),%rdx
  401830:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  401834:	48 89 d6             	mov    %rdx,%rsi
  401837:	48 89 c7             	mov    %rax,%rdi
  40183a:	e8 73 f1 ff ff       	callq  4009b2 <executeBuiltins>
  40183f:	eb 27                	jmp    401868 <main+0x17e>
		}

		else{
            printf("Calling Execute");
  401841:	48 8d 3d 7a 1c 00 00 	lea    0x1c7a(%rip),%rdi        # 4034c2 <free+0x3b7>
  401848:	b8 00 00 00 00       	mov    $0x0,%eax
  40184d:	e8 b6 04 00 00       	callq  401d08 <printf>
			execute_cmd(info,envp);
  401852:	48 8b 95 b8 fe ff ff 	mov    -0x148(%rbp),%rdx
  401859:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  40185d:	48 89 d6             	mov    %rdx,%rsi
  401860:	48 89 c7             	mov    %rax,%rdi
  401863:	e8 17 f3 ff ff       	callq  400b7f <execute_cmd>
		}



		static int loop=0;
		loop++;
  401868:	8b 05 12 2a 20 00    	mov    0x202a12(%rip),%eax        # 604280 <loop.1277>
  40186e:	ff c0                	inc    %eax
  401870:	89 05 0a 2a 20 00    	mov    %eax,0x202a0a(%rip)        # 604280 <loop.1277>
		//printf("Out of execute%d\n",loop++);
		//exit(0);
	}/* while(1) */
  401876:	e9 bc fe ff ff       	jmpq   401737 <main+0x4d>
  40187b:	e9 b7 fe ff ff       	jmpq   401737 <main+0x4d>

0000000000401880 <onlyWhiteSpace>:
#include <string.h>
#include <shell.h>



int onlyWhiteSpace(char *str){
  401880:	55                   	push   %rbp
  401881:	48 89 e5             	mov    %rsp,%rbp
  401884:	48 83 ec 18          	sub    $0x18,%rsp
  401888:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)

	//checks if a token is solely composed of white space.
	//if yes returns 1 else returns 0.So that token is not added to the array.

	int i=0;
  40188c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)

	while(str[i]!='\0'){
  401893:	eb 32                	jmp    4018c7 <onlyWhiteSpace+0x47>

		if(!((str[i]=='\t') || (str[i]==' '))){
  401895:	8b 45 fc             	mov    -0x4(%rbp),%eax
  401898:	48 63 d0             	movslq %eax,%rdx
  40189b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  40189f:	48 01 d0             	add    %rdx,%rax
  4018a2:	0f b6 00             	movzbl (%rax),%eax
  4018a5:	3c 09                	cmp    $0x9,%al
  4018a7:	74 1b                	je     4018c4 <onlyWhiteSpace+0x44>
  4018a9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  4018ac:	48 63 d0             	movslq %eax,%rdx
  4018af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  4018b3:	48 01 d0             	add    %rdx,%rax
  4018b6:	0f b6 00             	movzbl (%rax),%eax
  4018b9:	3c 20                	cmp    $0x20,%al
  4018bb:	74 07                	je     4018c4 <onlyWhiteSpace+0x44>

			return 0;
  4018bd:	b8 00 00 00 00       	mov    $0x0,%eax
  4018c2:	eb 1c                	jmp    4018e0 <onlyWhiteSpace+0x60>
		}
		i++;
  4018c4:	ff 45 fc             	incl   -0x4(%rbp)
	//checks if a token is solely composed of white space.
	//if yes returns 1 else returns 0.So that token is not added to the array.

	int i=0;

	while(str[i]!='\0'){
  4018c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  4018ca:	48 63 d0             	movslq %eax,%rdx
  4018cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  4018d1:	48 01 d0             	add    %rdx,%rax
  4018d4:	0f b6 00             	movzbl (%rax),%eax
  4018d7:	84 c0                	test   %al,%al
  4018d9:	75 ba                	jne    401895 <onlyWhiteSpace+0x15>
			return 0;
		}
		i++;
	}

	return 1;
  4018db:	b8 01 00 00 00       	mov    $0x1,%eax

}
  4018e0:	c9                   	leaveq 
  4018e1:	c3                   	retq   

00000000004018e2 <substring>:


char * substring(char* str, int front, int back){
  4018e2:	55                   	push   %rbp
  4018e3:	48 89 e5             	mov    %rsp,%rbp
  4018e6:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  4018ed:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  4018f4:	89 b5 e4 fd ff ff    	mov    %esi,-0x21c(%rbp)
  4018fa:	89 95 e0 fd ff ff    	mov    %edx,-0x220(%rbp)

	//temporary buffer to hold the token;
	char n[500];
	char *p;
	int i=0;
  401900:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)

	//Must handle condition of consequtive delims, delim at the end.Not done till now.

	if(back==front){
  401907:	8b 85 e0 fd ff ff    	mov    -0x220(%rbp),%eax
  40190d:	3b 85 e4 fd ff ff    	cmp    -0x21c(%rbp),%eax
  401913:	75 0a                	jne    40191f <substring+0x3d>

		return (char*)NULL;
  401915:	b8 00 00 00 00       	mov    $0x0,%eax
  40191a:	e9 9c 00 00 00       	jmpq   4019bb <substring+0xd9>

	}

	while(back < front){
  40191f:	eb 31                	jmp    401952 <substring+0x70>
		n[i++]=str[back++];
  401921:	8b 45 fc             	mov    -0x4(%rbp),%eax
  401924:	8d 50 01             	lea    0x1(%rax),%edx
  401927:	89 55 fc             	mov    %edx,-0x4(%rbp)
  40192a:	8b 95 e0 fd ff ff    	mov    -0x220(%rbp),%edx
  401930:	8d 4a 01             	lea    0x1(%rdx),%ecx
  401933:	89 8d e0 fd ff ff    	mov    %ecx,-0x220(%rbp)
  401939:	48 63 ca             	movslq %edx,%rcx
  40193c:	48 8b 95 e8 fd ff ff 	mov    -0x218(%rbp),%rdx
  401943:	48 01 ca             	add    %rcx,%rdx
  401946:	0f b6 12             	movzbl (%rdx),%edx
  401949:	48 98                	cltq   
  40194b:	88 94 05 fc fd ff ff 	mov    %dl,-0x204(%rbp,%rax,1)

		return (char*)NULL;

	}

	while(back < front){
  401952:	8b 85 e0 fd ff ff    	mov    -0x220(%rbp),%eax
  401958:	3b 85 e4 fd ff ff    	cmp    -0x21c(%rbp),%eax
  40195e:	7c c1                	jl     401921 <substring+0x3f>
		n[i++]=str[back++];
	}
	n[i] = '\0';
  401960:	8b 45 fc             	mov    -0x4(%rbp),%eax
  401963:	48 98                	cltq   
  401965:	c6 84 05 fc fd ff ff 	movb   $0x0,-0x204(%rbp,%rax,1)
  40196c:	00 
	//printf("nIn substring... %s\n",n);

	if(onlyWhiteSpace(n)==0){
  40196d:	48 8d 85 fc fd ff ff 	lea    -0x204(%rbp),%rax
  401974:	48 89 c7             	mov    %rax,%rdi
  401977:	e8 04 ff ff ff       	callq  401880 <onlyWhiteSpace>
  40197c:	85 c0                	test   %eax,%eax
  40197e:	75 2f                	jne    4019af <substring+0xcd>
		p = (char*)malloc(sizeof(char)*(i+1));
  401980:	8b 45 fc             	mov    -0x4(%rbp),%eax
  401983:	ff c0                	inc    %eax
  401985:	48 98                	cltq   
  401987:	48 89 c7             	mov    %rax,%rdi
  40198a:	e8 0f 16 00 00       	callq  402f9e <malloc>
  40198f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

		strcpy(p,n);
  401993:	48 8d 95 fc fd ff ff 	lea    -0x204(%rbp),%rdx
  40199a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  40199e:	48 89 d6             	mov    %rdx,%rsi
  4019a1:	48 89 c7             	mov    %rax,%rdi
  4019a4:	e8 3f 0a 00 00       	callq  4023e8 <strcpy>
		//printf("After white space p=  ");
        return p;
  4019a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  4019ad:	eb 0c                	jmp    4019bb <substring+0xd9>
	}
	else
		p = (char*)NULL;
  4019af:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  4019b6:	00 

    //printf("Returning %s from substring");
	return p;
  4019b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax

}
  4019bb:	c9                   	leaveq 
  4019bc:	c3                   	retq   

00000000004019bd <tokenize>:


Token* tokenize(char *str,char* delim){
  4019bd:	55                   	push   %rbp
  4019be:	48 89 e5             	mov    %rsp,%rbp
  4019c1:	48 83 ec 30          	sub    $0x30,%rsp
  4019c5:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  4019c9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)

	Token* token=(Token*)malloc(sizeof(Token));
  4019cd:	bf 98 01 00 00       	mov    $0x198,%edi
  4019d2:	e8 c7 15 00 00       	callq  402f9e <malloc>
  4019d7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	//printf("In Tokenize Printing str %s\n",str);
	int tokenCount=0;
  4019db:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	int front=0,back=0;
  4019e2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  4019e9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	//int i=0;
	char *p;

	//printf("IN TOKENIZER %s %s",str,delim);

	while(str[front]!='\0'){
  4019f0:	eb 7a                	jmp    401a6c <tokenize+0xaf>

		if(str[front]== *delim){
  4019f2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  4019f5:	48 63 d0             	movslq %eax,%rdx
  4019f8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  4019fc:	48 01 d0             	add    %rdx,%rax
  4019ff:	0f b6 10             	movzbl (%rax),%edx
  401a02:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  401a06:	0f b6 00             	movzbl (%rax),%eax
  401a09:	38 c2                	cmp    %al,%dl
  401a0b:	75 5c                	jne    401a69 <tokenize+0xac>
			//delimiter found. Extract substring.
			p=substring(str,front,back);
  401a0d:	8b 55 f4             	mov    -0xc(%rbp),%edx
  401a10:	8b 4d f8             	mov    -0x8(%rbp),%ecx
  401a13:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  401a17:	89 ce                	mov    %ecx,%esi
  401a19:	48 89 c7             	mov    %rax,%rdi
  401a1c:	e8 c1 fe ff ff       	callq  4018e2 <substring>
  401a21:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
            //printf("Back in token %s %d ",p,p);
            
            if(p==NULL)
  401a25:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  401a2a:	75 11                	jne    401a3d <tokenize+0x80>
                printf("p is null");
  401a2c:	48 8d 3d 9f 1a 00 00 	lea    0x1a9f(%rip),%rdi        # 4034d2 <free+0x3c7>
  401a33:	b8 00 00 00 00       	mov    $0x0,%eax
  401a38:	e8 cb 02 00 00       	callq  401d08 <printf>

			if(p != NULL){
  401a3d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  401a42:	74 18                	je     401a5c <tokenize+0x9f>
				token->tokenArr[tokenCount++]=p;
  401a44:	8b 45 fc             	mov    -0x4(%rbp),%eax
  401a47:	8d 50 01             	lea    0x1(%rax),%edx
  401a4a:	89 55 fc             	mov    %edx,-0x4(%rbp)
  401a4d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  401a51:	48 98                	cltq   
  401a53:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  401a57:	48 89 4c c2 08       	mov    %rcx,0x8(%rdx,%rax,8)
				//printf("\nIn tokenizer..appending %s\n",token->tokenArr[tokenCount-1]);
			}

			back = front +1;
  401a5c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  401a5f:	ff c0                	inc    %eax
  401a61:	89 45 f4             	mov    %eax,-0xc(%rbp)
			front++;
  401a64:	ff 45 f8             	incl   -0x8(%rbp)
  401a67:	eb 03                	jmp    401a6c <tokenize+0xaf>
			//continue;
		}

		else{
			front++;
  401a69:	ff 45 f8             	incl   -0x8(%rbp)
	//int i=0;
	char *p;

	//printf("IN TOKENIZER %s %s",str,delim);

	while(str[front]!='\0'){
  401a6c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  401a6f:	48 63 d0             	movslq %eax,%rdx
  401a72:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  401a76:	48 01 d0             	add    %rdx,%rax
  401a79:	0f b6 00             	movzbl (%rax),%eax
  401a7c:	84 c0                	test   %al,%al
  401a7e:	0f 85 6e ff ff ff    	jne    4019f2 <tokenize+0x35>
		else{
			front++;
		}
	}//end while

	p = substring(str,front,back);
  401a84:	8b 55 f4             	mov    -0xc(%rbp),%edx
  401a87:	8b 4d f8             	mov    -0x8(%rbp),%ecx
  401a8a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  401a8e:	89 ce                	mov    %ecx,%esi
  401a90:	48 89 c7             	mov    %rax,%rdi
  401a93:	e8 4a fe ff ff       	callq  4018e2 <substring>
  401a98:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if(p != NULL){
  401a9c:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  401aa1:	74 18                	je     401abb <tokenize+0xfe>
		token->tokenArr[tokenCount++]=p;
  401aa3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  401aa6:	8d 50 01             	lea    0x1(%rax),%edx
  401aa9:	89 55 fc             	mov    %edx,-0x4(%rbp)
  401aac:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  401ab0:	48 98                	cltq   
  401ab2:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  401ab6:	48 89 4c c2 08       	mov    %rcx,0x8(%rdx,%rax,8)
	}
	token->numOfTokens=tokenCount;
  401abb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  401abf:	8b 55 fc             	mov    -0x4(%rbp),%edx
  401ac2:	89 10                	mov    %edx,(%rax)

	// 	printf("Token %d : %s %d\n",i,token->tokenArr[i],token->numOfTokens);
	// }


	return token;
  401ac4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax

}
  401ac8:	c9                   	leaveq 
  401ac9:	c3                   	retq   

0000000000401aca <main2>:
#include<stdlib.h>
#include<stdio.h>
int main2 (int argc, char *argv[], char* envp[])
{
  401aca:	55                   	push   %rbp
  401acb:	48 89 e5             	mov    %rsp,%rbp
  401ace:	48 83 ec 30          	sub    $0x30,%rsp
  401ad2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  401ad5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  401ad9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
char* s=(char*)malloc(10);
  401add:	bf 0a 00 00 00       	mov    $0xa,%edi
  401ae2:	e8 b7 14 00 00       	callq  402f9e <malloc>
  401ae7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

printf("s=%d",s);
  401aeb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  401aef:	48 89 c6             	mov    %rax,%rsi
  401af2:	48 8d 3d e3 19 00 00 	lea    0x19e3(%rip),%rdi        # 4034dc <free+0x3d1>
  401af9:	b8 00 00 00 00       	mov    $0x0,%eax
  401afe:	e8 05 02 00 00       	callq  401d08 <printf>
return 0;
  401b03:	b8 00 00 00 00       	mov    $0x0,%eax
}
  401b08:	c9                   	leaveq 
  401b09:	c3                   	retq   

0000000000401b0a <print_num>:

// update errno.
char screen[1024];
int screen_ctr;
void print_num(int num, int base)
{
  401b0a:	55                   	push   %rbp
  401b0b:	48 89 e5             	mov    %rsp,%rbp
  401b0e:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  401b15:	89 bd 6c ff ff ff    	mov    %edi,-0x94(%rbp)
  401b1b:	89 b5 68 ff ff ff    	mov    %esi,-0x98(%rbp)
	int number[32];
	int i=0;
  401b21:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)

	if(base == 16)
  401b28:	83 bd 68 ff ff ff 10 	cmpl   $0x10,-0x98(%rbp)
  401b2f:	75 44                	jne    401b75 <print_num+0x6b>
	{
		screen[screen_ctr++] = '0';
  401b31:	48 8b 05 40 26 20 00 	mov    0x202640(%rip),%rax        # 604178 <free+0x20106d>
  401b38:	8b 00                	mov    (%rax),%eax
  401b3a:	8d 48 01             	lea    0x1(%rax),%ecx
  401b3d:	48 8b 15 34 26 20 00 	mov    0x202634(%rip),%rdx        # 604178 <free+0x20106d>
  401b44:	89 0a                	mov    %ecx,(%rdx)
  401b46:	48 8b 15 33 26 20 00 	mov    0x202633(%rip),%rdx        # 604180 <free+0x201075>
  401b4d:	48 98                	cltq   
  401b4f:	c6 04 02 30          	movb   $0x30,(%rdx,%rax,1)
		screen[screen_ctr++] = 'x';
  401b53:	48 8b 05 1e 26 20 00 	mov    0x20261e(%rip),%rax        # 604178 <free+0x20106d>
  401b5a:	8b 00                	mov    (%rax),%eax
  401b5c:	8d 48 01             	lea    0x1(%rax),%ecx
  401b5f:	48 8b 15 12 26 20 00 	mov    0x202612(%rip),%rdx        # 604178 <free+0x20106d>
  401b66:	89 0a                	mov    %ecx,(%rdx)
  401b68:	48 8b 15 11 26 20 00 	mov    0x202611(%rip),%rdx        # 604180 <free+0x201075>
  401b6f:	48 98                	cltq   
  401b71:	c6 04 02 78          	movb   $0x78,(%rdx,%rax,1)
	}
	do
	{
		int rem=num%base;
  401b75:	8b 85 6c ff ff ff    	mov    -0x94(%rbp),%eax
  401b7b:	99                   	cltd   
  401b7c:	f7 bd 68 ff ff ff    	idivl  -0x98(%rbp)
  401b82:	89 55 f8             	mov    %edx,-0x8(%rbp)
		if((rem) >= 10)
  401b85:	83 7d f8 09          	cmpl   $0x9,-0x8(%rbp)
  401b89:	7e 06                	jle    401b91 <print_num+0x87>
		{

			rem = rem-10 + 'a';
  401b8b:	83 45 f8 57          	addl   $0x57,-0x8(%rbp)
  401b8f:	eb 04                	jmp    401b95 <print_num+0x8b>
		}
		else{
			rem = rem + '0';
  401b91:	83 45 f8 30          	addl   $0x30,-0x8(%rbp)
		}
		number[i]= rem;
  401b95:	8b 45 fc             	mov    -0x4(%rbp),%eax
  401b98:	48 98                	cltq   
  401b9a:	8b 55 f8             	mov    -0x8(%rbp),%edx
  401b9d:	89 94 85 78 ff ff ff 	mov    %edx,-0x88(%rbp,%rax,4)
		i++;
  401ba4:	ff 45 fc             	incl   -0x4(%rbp)
	}while((num=num/base) !=0);
  401ba7:	8b 85 6c ff ff ff    	mov    -0x94(%rbp),%eax
  401bad:	99                   	cltd   
  401bae:	f7 bd 68 ff ff ff    	idivl  -0x98(%rbp)
  401bb4:	89 85 6c ff ff ff    	mov    %eax,-0x94(%rbp)
  401bba:	83 bd 6c ff ff ff 00 	cmpl   $0x0,-0x94(%rbp)
  401bc1:	75 b2                	jne    401b75 <print_num+0x6b>


	while(i-- != 0)
  401bc3:	eb 2e                	jmp    401bf3 <print_num+0xe9>
	{

		screen[screen_ctr++] = number[i];
  401bc5:	48 8b 05 ac 25 20 00 	mov    0x2025ac(%rip),%rax        # 604178 <free+0x20106d>
  401bcc:	8b 00                	mov    (%rax),%eax
  401bce:	8d 48 01             	lea    0x1(%rax),%ecx
  401bd1:	48 8b 15 a0 25 20 00 	mov    0x2025a0(%rip),%rdx        # 604178 <free+0x20106d>
  401bd8:	89 0a                	mov    %ecx,(%rdx)
  401bda:	8b 55 fc             	mov    -0x4(%rbp),%edx
  401bdd:	48 63 d2             	movslq %edx,%rdx
  401be0:	8b 94 95 78 ff ff ff 	mov    -0x88(%rbp,%rdx,4),%edx
  401be7:	48 8b 0d 92 25 20 00 	mov    0x202592(%rip),%rcx        # 604180 <free+0x201075>
  401bee:	48 98                	cltq   
  401bf0:	88 14 01             	mov    %dl,(%rcx,%rax,1)
		number[i]= rem;
		i++;
	}while((num=num/base) !=0);


	while(i-- != 0)
  401bf3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  401bf6:	8d 50 ff             	lea    -0x1(%rax),%edx
  401bf9:	89 55 fc             	mov    %edx,-0x4(%rbp)
  401bfc:	85 c0                	test   %eax,%eax
  401bfe:	75 c5                	jne    401bc5 <print_num+0xbb>
	{

		screen[screen_ctr++] = number[i];
	}
}
  401c00:	c9                   	leaveq 
  401c01:	c3                   	retq   

0000000000401c02 <print_ptr>:



void print_ptr(long unsigned int num, long unsigned int base)
{
  401c02:	55                   	push   %rbp
  401c03:	48 89 e5             	mov    %rsp,%rbp
  401c06:	48 81 ec 20 01 00 00 	sub    $0x120,%rsp
  401c0d:	48 89 bd e8 fe ff ff 	mov    %rdi,-0x118(%rbp)
  401c14:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
	long unsigned int number[32];
	int i=0;
  401c1b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)

		screen[screen_ctr++] = '0';
  401c22:	48 8b 05 4f 25 20 00 	mov    0x20254f(%rip),%rax        # 604178 <free+0x20106d>
  401c29:	8b 00                	mov    (%rax),%eax
  401c2b:	8d 48 01             	lea    0x1(%rax),%ecx
  401c2e:	48 8b 15 43 25 20 00 	mov    0x202543(%rip),%rdx        # 604178 <free+0x20106d>
  401c35:	89 0a                	mov    %ecx,(%rdx)
  401c37:	48 8b 15 42 25 20 00 	mov    0x202542(%rip),%rdx        # 604180 <free+0x201075>
  401c3e:	48 98                	cltq   
  401c40:	c6 04 02 30          	movb   $0x30,(%rdx,%rax,1)
		screen[screen_ctr++] = 'x';
  401c44:	48 8b 05 2d 25 20 00 	mov    0x20252d(%rip),%rax        # 604178 <free+0x20106d>
  401c4b:	8b 00                	mov    (%rax),%eax
  401c4d:	8d 48 01             	lea    0x1(%rax),%ecx
  401c50:	48 8b 15 21 25 20 00 	mov    0x202521(%rip),%rdx        # 604178 <free+0x20106d>
  401c57:	89 0a                	mov    %ecx,(%rdx)
  401c59:	48 8b 15 20 25 20 00 	mov    0x202520(%rip),%rdx        # 604180 <free+0x201075>
  401c60:	48 98                	cltq   
  401c62:	c6 04 02 78          	movb   $0x78,(%rdx,%rax,1)
	
	do
	{
		long unsigned int rem=num%base;
  401c66:	48 8b 85 e8 fe ff ff 	mov    -0x118(%rbp),%rax
  401c6d:	ba 00 00 00 00       	mov    $0x0,%edx
  401c72:	48 f7 b5 e0 fe ff ff 	divq   -0x120(%rbp)
  401c79:	48 89 55 f0          	mov    %rdx,-0x10(%rbp)
		if((rem) >= 10)
  401c7d:	48 83 7d f0 09       	cmpq   $0x9,-0x10(%rbp)
  401c82:	76 07                	jbe    401c8b <print_ptr+0x89>
		{
			rem = rem-10 + 'a';
  401c84:	48 83 45 f0 57       	addq   $0x57,-0x10(%rbp)
  401c89:	eb 05                	jmp    401c90 <print_ptr+0x8e>
		}
		else{
			rem = rem + '0';
  401c8b:	48 83 45 f0 30       	addq   $0x30,-0x10(%rbp)
		}
		number[i]= rem;
  401c90:	8b 45 fc             	mov    -0x4(%rbp),%eax
  401c93:	48 98                	cltq   
  401c95:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  401c99:	48 89 94 c5 f0 fe ff 	mov    %rdx,-0x110(%rbp,%rax,8)
  401ca0:	ff 
		i++;
  401ca1:	ff 45 fc             	incl   -0x4(%rbp)
	}while((num=num/base) !=0);
  401ca4:	48 8b 85 e8 fe ff ff 	mov    -0x118(%rbp),%rax
  401cab:	ba 00 00 00 00       	mov    $0x0,%edx
  401cb0:	48 f7 b5 e0 fe ff ff 	divq   -0x120(%rbp)
  401cb7:	48 89 85 e8 fe ff ff 	mov    %rax,-0x118(%rbp)
  401cbe:	48 83 bd e8 fe ff ff 	cmpq   $0x0,-0x118(%rbp)
  401cc5:	00 
  401cc6:	75 9e                	jne    401c66 <print_ptr+0x64>


	while(i-- != 0)
  401cc8:	eb 2f                	jmp    401cf9 <print_ptr+0xf7>
	{

		screen[screen_ctr++] = number[i];
  401cca:	48 8b 05 a7 24 20 00 	mov    0x2024a7(%rip),%rax        # 604178 <free+0x20106d>
  401cd1:	8b 00                	mov    (%rax),%eax
  401cd3:	8d 48 01             	lea    0x1(%rax),%ecx
  401cd6:	48 8b 15 9b 24 20 00 	mov    0x20249b(%rip),%rdx        # 604178 <free+0x20106d>
  401cdd:	89 0a                	mov    %ecx,(%rdx)
  401cdf:	8b 55 fc             	mov    -0x4(%rbp),%edx
  401ce2:	48 63 d2             	movslq %edx,%rdx
  401ce5:	48 8b 94 d5 f0 fe ff 	mov    -0x110(%rbp,%rdx,8),%rdx
  401cec:	ff 
  401ced:	48 8b 0d 8c 24 20 00 	mov    0x20248c(%rip),%rcx        # 604180 <free+0x201075>
  401cf4:	48 98                	cltq   
  401cf6:	88 14 01             	mov    %dl,(%rcx,%rax,1)
		number[i]= rem;
		i++;
	}while((num=num/base) !=0);


	while(i-- != 0)
  401cf9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  401cfc:	8d 50 ff             	lea    -0x1(%rax),%edx
  401cff:	89 55 fc             	mov    %edx,-0x4(%rbp)
  401d02:	85 c0                	test   %eax,%eax
  401d04:	75 c4                	jne    401cca <print_ptr+0xc8>
	{

		screen[screen_ctr++] = number[i];
    }
}
  401d06:	c9                   	leaveq 
  401d07:	c3                   	retq   

0000000000401d08 <printf>:





int printf(const char *format, ...) {
  401d08:	55                   	push   %rbp
  401d09:	48 89 e5             	mov    %rsp,%rbp
  401d0c:	48 81 ec 90 00 00 00 	sub    $0x90,%rsp
  401d13:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  401d17:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  401d1b:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  401d1f:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  401d23:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
  401d27:	48 89 bd 78 ff ff ff 	mov    %rdi,-0x88(%rbp)
	va_list val;
	int printed = 0;
  401d2e:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
	screen_ctr=0;
  401d35:	48 8b 05 3c 24 20 00 	mov    0x20243c(%rip),%rax        # 604178 <free+0x20106d>
  401d3c:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	va_start(val, format);
  401d42:	c7 45 88 08 00 00 00 	movl   $0x8,-0x78(%rbp)
  401d49:	48 8d 45 10          	lea    0x10(%rbp),%rax
  401d4d:	48 89 45 90          	mov    %rax,-0x70(%rbp)
  401d51:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  401d55:	48 89 45 98          	mov    %rax,-0x68(%rbp)

	while(*format)
  401d59:	e9 0d 03 00 00       	jmpq   40206b <printf+0x363>
	{
		if(*format == '%')
  401d5e:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  401d65:	0f b6 00             	movzbl (%rax),%eax
  401d68:	3c 25                	cmp    $0x25,%al
  401d6a:	0f 85 c6 02 00 00    	jne    402036 <printf+0x32e>
		{
			switch(*(++format))
  401d70:	48 ff 85 78 ff ff ff 	incq   -0x88(%rbp)
  401d77:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  401d7e:	0f b6 00             	movzbl (%rax),%eax
  401d81:	0f be c0             	movsbl %al,%eax
  401d84:	83 f8 64             	cmp    $0x64,%eax
  401d87:	74 3c                	je     401dc5 <printf+0xbd>
  401d89:	83 f8 64             	cmp    $0x64,%eax
  401d8c:	7f 17                	jg     401da5 <printf+0x9d>
  401d8e:	83 f8 25             	cmp    $0x25,%eax
  401d91:	0f 84 73 02 00 00    	je     40200a <printf+0x302>
  401d97:	83 f8 63             	cmp    $0x63,%eax
  401d9a:	0f 84 ae 00 00 00    	je     401e4e <printf+0x146>
  401da0:	e9 c6 02 00 00       	jmpq   40206b <printf+0x363>
  401da5:	83 f8 73             	cmp    $0x73,%eax
  401da8:	0f 84 03 01 00 00    	je     401eb1 <printf+0x1a9>
  401dae:	83 f8 78             	cmp    $0x78,%eax
  401db1:	0f 84 7b 01 00 00    	je     401f32 <printf+0x22a>
  401db7:	83 f8 70             	cmp    $0x70,%eax
  401dba:	0f 84 fb 01 00 00    	je     401fbb <printf+0x2b3>
  401dc0:	e9 a6 02 00 00       	jmpq   40206b <printf+0x363>
			{
			case 'd':
				printed=printed;
				int num = va_arg(val, int);
  401dc5:	8b 45 88             	mov    -0x78(%rbp),%eax
  401dc8:	83 f8 30             	cmp    $0x30,%eax
  401dcb:	73 17                	jae    401de4 <printf+0xdc>
  401dcd:	48 8b 55 98          	mov    -0x68(%rbp),%rdx
  401dd1:	8b 45 88             	mov    -0x78(%rbp),%eax
  401dd4:	89 c0                	mov    %eax,%eax
  401dd6:	48 01 d0             	add    %rdx,%rax
  401dd9:	8b 55 88             	mov    -0x78(%rbp),%edx
  401ddc:	83 c2 08             	add    $0x8,%edx
  401ddf:	89 55 88             	mov    %edx,-0x78(%rbp)
  401de2:	eb 0f                	jmp    401df3 <printf+0xeb>
  401de4:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  401de8:	48 89 d0             	mov    %rdx,%rax
  401deb:	48 83 c2 08          	add    $0x8,%rdx
  401def:	48 89 55 90          	mov    %rdx,-0x70(%rbp)
  401df3:	8b 00                	mov    (%rax),%eax
  401df5:	89 45 bc             	mov    %eax,-0x44(%rbp)
				if(num<0)
  401df8:	83 7d bc 00          	cmpl   $0x0,-0x44(%rbp)
  401dfc:	79 35                	jns    401e33 <printf+0x12b>
				{
					screen[screen_ctr++]='-';
  401dfe:	48 8b 05 73 23 20 00 	mov    0x202373(%rip),%rax        # 604178 <free+0x20106d>
  401e05:	8b 00                	mov    (%rax),%eax
  401e07:	8d 48 01             	lea    0x1(%rax),%ecx
  401e0a:	48 8b 15 67 23 20 00 	mov    0x202367(%rip),%rdx        # 604178 <free+0x20106d>
  401e11:	89 0a                	mov    %ecx,(%rdx)
  401e13:	48 8b 15 66 23 20 00 	mov    0x202366(%rip),%rdx        # 604180 <free+0x201075>
  401e1a:	48 98                	cltq   
  401e1c:	c6 04 02 2d          	movb   $0x2d,(%rdx,%rax,1)
					print_num(-num,10);
  401e20:	8b 45 bc             	mov    -0x44(%rbp),%eax
  401e23:	f7 d8                	neg    %eax
  401e25:	be 0a 00 00 00       	mov    $0xa,%esi
  401e2a:	89 c7                	mov    %eax,%edi
  401e2c:	e8 d9 fc ff ff       	callq  401b0a <print_num>
  401e31:	eb 0f                	jmp    401e42 <printf+0x13a>
				}
				else
					print_num(num,10);
  401e33:	8b 45 bc             	mov    -0x44(%rbp),%eax
  401e36:	be 0a 00 00 00       	mov    $0xa,%esi
  401e3b:	89 c7                	mov    %eax,%edi
  401e3d:	e8 c8 fc ff ff       	callq  401b0a <print_num>
				format++;
  401e42:	48 ff 85 78 ff ff ff 	incq   -0x88(%rbp)
				continue;
  401e49:	e9 1d 02 00 00       	jmpq   40206b <printf+0x363>

			case 'c':
				printed=printed;;
				int chr = va_arg(val, int);
  401e4e:	8b 45 88             	mov    -0x78(%rbp),%eax
  401e51:	83 f8 30             	cmp    $0x30,%eax
  401e54:	73 17                	jae    401e6d <printf+0x165>
  401e56:	48 8b 55 98          	mov    -0x68(%rbp),%rdx
  401e5a:	8b 45 88             	mov    -0x78(%rbp),%eax
  401e5d:	89 c0                	mov    %eax,%eax
  401e5f:	48 01 d0             	add    %rdx,%rax
  401e62:	8b 55 88             	mov    -0x78(%rbp),%edx
  401e65:	83 c2 08             	add    $0x8,%edx
  401e68:	89 55 88             	mov    %edx,-0x78(%rbp)
  401e6b:	eb 0f                	jmp    401e7c <printf+0x174>
  401e6d:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  401e71:	48 89 d0             	mov    %rdx,%rax
  401e74:	48 83 c2 08          	add    $0x8,%rdx
  401e78:	48 89 55 90          	mov    %rdx,-0x70(%rbp)
  401e7c:	8b 00                	mov    (%rax),%eax
  401e7e:	89 45 b8             	mov    %eax,-0x48(%rbp)
				screen[screen_ctr++] = chr;
  401e81:	48 8b 05 f0 22 20 00 	mov    0x2022f0(%rip),%rax        # 604178 <free+0x20106d>
  401e88:	8b 00                	mov    (%rax),%eax
  401e8a:	8d 48 01             	lea    0x1(%rax),%ecx
  401e8d:	48 8b 15 e4 22 20 00 	mov    0x2022e4(%rip),%rdx        # 604178 <free+0x20106d>
  401e94:	89 0a                	mov    %ecx,(%rdx)
  401e96:	8b 55 b8             	mov    -0x48(%rbp),%edx
  401e99:	48 8b 0d e0 22 20 00 	mov    0x2022e0(%rip),%rcx        # 604180 <free+0x201075>
  401ea0:	48 98                	cltq   
  401ea2:	88 14 01             	mov    %dl,(%rcx,%rax,1)
				format++;
  401ea5:	48 ff 85 78 ff ff ff 	incq   -0x88(%rbp)
				continue;
  401eac:	e9 ba 01 00 00       	jmpq   40206b <printf+0x363>

			case 's':
				printed=printed;
				char* str = va_arg(val, char*);
  401eb1:	8b 45 88             	mov    -0x78(%rbp),%eax
  401eb4:	83 f8 30             	cmp    $0x30,%eax
  401eb7:	73 17                	jae    401ed0 <printf+0x1c8>
  401eb9:	48 8b 55 98          	mov    -0x68(%rbp),%rdx
  401ebd:	8b 45 88             	mov    -0x78(%rbp),%eax
  401ec0:	89 c0                	mov    %eax,%eax
  401ec2:	48 01 d0             	add    %rdx,%rax
  401ec5:	8b 55 88             	mov    -0x78(%rbp),%edx
  401ec8:	83 c2 08             	add    $0x8,%edx
  401ecb:	89 55 88             	mov    %edx,-0x78(%rbp)
  401ece:	eb 0f                	jmp    401edf <printf+0x1d7>
  401ed0:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  401ed4:	48 89 d0             	mov    %rdx,%rax
  401ed7:	48 83 c2 08          	add    $0x8,%rdx
  401edb:	48 89 55 90          	mov    %rdx,-0x70(%rbp)
  401edf:	48 8b 00             	mov    (%rax),%rax
  401ee2:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
				while(*(str) != '\0')
  401ee6:	eb 33                	jmp    401f1b <printf+0x213>
					screen[screen_ctr++] = *str++;
  401ee8:	48 8b 05 89 22 20 00 	mov    0x202289(%rip),%rax        # 604178 <free+0x20106d>
  401eef:	8b 00                	mov    (%rax),%eax
  401ef1:	89 c2                	mov    %eax,%edx
  401ef3:	8d 4a 01             	lea    0x1(%rdx),%ecx
  401ef6:	48 8b 05 7b 22 20 00 	mov    0x20227b(%rip),%rax        # 604178 <free+0x20106d>
  401efd:	89 08                	mov    %ecx,(%rax)
  401eff:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  401f03:	48 8d 48 01          	lea    0x1(%rax),%rcx
  401f07:	48 89 4d c0          	mov    %rcx,-0x40(%rbp)
  401f0b:	0f b6 00             	movzbl (%rax),%eax
  401f0e:	48 8b 0d 6b 22 20 00 	mov    0x20226b(%rip),%rcx        # 604180 <free+0x201075>
  401f15:	48 63 d2             	movslq %edx,%rdx
  401f18:	88 04 11             	mov    %al,(%rcx,%rdx,1)
				continue;

			case 's':
				printed=printed;
				char* str = va_arg(val, char*);
				while(*(str) != '\0')
  401f1b:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  401f1f:	0f b6 00             	movzbl (%rax),%eax
  401f22:	84 c0                	test   %al,%al
  401f24:	75 c2                	jne    401ee8 <printf+0x1e0>
					screen[screen_ctr++] = *str++;
				format++;
  401f26:	48 ff 85 78 ff ff ff 	incq   -0x88(%rbp)
				continue;
  401f2d:	e9 39 01 00 00       	jmpq   40206b <printf+0x363>

			case 'x':
				printed=printed;
				int hex = va_arg(val, int);
  401f32:	8b 45 88             	mov    -0x78(%rbp),%eax
  401f35:	83 f8 30             	cmp    $0x30,%eax
  401f38:	73 17                	jae    401f51 <printf+0x249>
  401f3a:	48 8b 55 98          	mov    -0x68(%rbp),%rdx
  401f3e:	8b 45 88             	mov    -0x78(%rbp),%eax
  401f41:	89 c0                	mov    %eax,%eax
  401f43:	48 01 d0             	add    %rdx,%rax
  401f46:	8b 55 88             	mov    -0x78(%rbp),%edx
  401f49:	83 c2 08             	add    $0x8,%edx
  401f4c:	89 55 88             	mov    %edx,-0x78(%rbp)
  401f4f:	eb 0f                	jmp    401f60 <printf+0x258>
  401f51:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  401f55:	48 89 d0             	mov    %rdx,%rax
  401f58:	48 83 c2 08          	add    $0x8,%rdx
  401f5c:	48 89 55 90          	mov    %rdx,-0x70(%rbp)
  401f60:	8b 00                	mov    (%rax),%eax
  401f62:	89 45 b4             	mov    %eax,-0x4c(%rbp)
				if(hex<0)
  401f65:	83 7d b4 00          	cmpl   $0x0,-0x4c(%rbp)
  401f69:	79 35                	jns    401fa0 <printf+0x298>
				{
					screen[screen_ctr++]='-';
  401f6b:	48 8b 05 06 22 20 00 	mov    0x202206(%rip),%rax        # 604178 <free+0x20106d>
  401f72:	8b 00                	mov    (%rax),%eax
  401f74:	8d 48 01             	lea    0x1(%rax),%ecx
  401f77:	48 8b 15 fa 21 20 00 	mov    0x2021fa(%rip),%rdx        # 604178 <free+0x20106d>
  401f7e:	89 0a                	mov    %ecx,(%rdx)
  401f80:	48 8b 15 f9 21 20 00 	mov    0x2021f9(%rip),%rdx        # 604180 <free+0x201075>
  401f87:	48 98                	cltq   
  401f89:	c6 04 02 2d          	movb   $0x2d,(%rdx,%rax,1)
					print_num(-hex,16);
  401f8d:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  401f90:	f7 d8                	neg    %eax
  401f92:	be 10 00 00 00       	mov    $0x10,%esi
  401f97:	89 c7                	mov    %eax,%edi
  401f99:	e8 6c fb ff ff       	callq  401b0a <print_num>
  401f9e:	eb 0f                	jmp    401faf <printf+0x2a7>
				}
				else
					print_num(hex,16);
  401fa0:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  401fa3:	be 10 00 00 00       	mov    $0x10,%esi
  401fa8:	89 c7                	mov    %eax,%edi
  401faa:	e8 5b fb ff ff       	callq  401b0a <print_num>

				format++;
  401faf:	48 ff 85 78 ff ff ff 	incq   -0x88(%rbp)
				continue;
  401fb6:	e9 b0 00 00 00       	jmpq   40206b <printf+0x363>

			case 'p':
				printed=printed;
				long unsigned int ptr =(unsigned long int) va_arg(val, long int );
  401fbb:	8b 45 88             	mov    -0x78(%rbp),%eax
  401fbe:	83 f8 30             	cmp    $0x30,%eax
  401fc1:	73 17                	jae    401fda <printf+0x2d2>
  401fc3:	48 8b 55 98          	mov    -0x68(%rbp),%rdx
  401fc7:	8b 45 88             	mov    -0x78(%rbp),%eax
  401fca:	89 c0                	mov    %eax,%eax
  401fcc:	48 01 d0             	add    %rdx,%rax
  401fcf:	8b 55 88             	mov    -0x78(%rbp),%edx
  401fd2:	83 c2 08             	add    $0x8,%edx
  401fd5:	89 55 88             	mov    %edx,-0x78(%rbp)
  401fd8:	eb 0f                	jmp    401fe9 <printf+0x2e1>
  401fda:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  401fde:	48 89 d0             	mov    %rdx,%rax
  401fe1:	48 83 c2 08          	add    $0x8,%rdx
  401fe5:	48 89 55 90          	mov    %rdx,-0x70(%rbp)
  401fe9:	48 8b 00             	mov    (%rax),%rax
  401fec:	48 89 45 a8          	mov    %rax,-0x58(%rbp)
				print_ptr(ptr,16);
  401ff0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  401ff4:	be 10 00 00 00       	mov    $0x10,%esi
  401ff9:	48 89 c7             	mov    %rax,%rdi
  401ffc:	e8 01 fc ff ff       	callq  401c02 <print_ptr>

				format++;
  402001:	48 ff 85 78 ff ff ff 	incq   -0x88(%rbp)
				continue;
  402008:	eb 61                	jmp    40206b <printf+0x363>


			case '%':
				printed=printed;
				char c='%';
  40200a:	c6 45 a7 25          	movb   $0x25,-0x59(%rbp)

				screen[screen_ctr++] = c;
  40200e:	48 8b 05 63 21 20 00 	mov    0x202163(%rip),%rax        # 604178 <free+0x20106d>
  402015:	8b 00                	mov    (%rax),%eax
  402017:	8d 48 01             	lea    0x1(%rax),%ecx
  40201a:	48 8b 15 57 21 20 00 	mov    0x202157(%rip),%rdx        # 604178 <free+0x20106d>
  402021:	89 0a                	mov    %ecx,(%rdx)
  402023:	48 8b 0d 56 21 20 00 	mov    0x202156(%rip),%rcx        # 604180 <free+0x201075>
  40202a:	48 63 d0             	movslq %eax,%rdx
  40202d:	0f b6 45 a7          	movzbl -0x59(%rbp),%eax
  402031:	88 04 11             	mov    %al,(%rcx,%rdx,1)
  402034:	eb 35                	jmp    40206b <printf+0x363>
			}
		}
		else
		{

			screen[screen_ctr++] = *format;
  402036:	48 8b 05 3b 21 20 00 	mov    0x20213b(%rip),%rax        # 604178 <free+0x20106d>
  40203d:	8b 00                	mov    (%rax),%eax
  40203f:	8d 48 01             	lea    0x1(%rax),%ecx
  402042:	48 8b 15 2f 21 20 00 	mov    0x20212f(%rip),%rdx        # 604178 <free+0x20106d>
  402049:	89 0a                	mov    %ecx,(%rdx)
  40204b:	48 8b 95 78 ff ff ff 	mov    -0x88(%rbp),%rdx
  402052:	0f b6 12             	movzbl (%rdx),%edx
  402055:	48 8b 0d 24 21 20 00 	mov    0x202124(%rip),%rcx        # 604180 <free+0x201075>
  40205c:	48 98                	cltq   
  40205e:	88 14 01             	mov    %dl,(%rcx,%rax,1)
			++printed;
  402061:	ff 45 cc             	incl   -0x34(%rbp)
			++format;
  402064:	48 ff 85 78 ff ff ff 	incq   -0x88(%rbp)
	va_list val;
	int printed = 0;
	screen_ctr=0;
	va_start(val, format);

	while(*format)
  40206b:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  402072:	0f b6 00             	movzbl (%rax),%eax
  402075:	84 c0                	test   %al,%al
  402077:	0f 85 e1 fc ff ff    	jne    401d5e <printf+0x56>
			++printed;
			++format;
		}
	}

	printed = write(1,screen, screen_ctr);
  40207d:	48 8b 05 f4 20 20 00 	mov    0x2020f4(%rip),%rax        # 604178 <free+0x20106d>
  402084:	8b 00                	mov    (%rax),%eax
  402086:	48 98                	cltq   
  402088:	48 89 c2             	mov    %rax,%rdx
  40208b:	48 8b 05 ee 20 20 00 	mov    0x2020ee(%rip),%rax        # 604180 <free+0x201075>
  402092:	48 89 c6             	mov    %rax,%rsi
  402095:	bf 01 00 00 00       	mov    $0x1,%edi
  40209a:	e8 bc 00 00 00       	callq  40215b <write>
  40209f:	89 45 cc             	mov    %eax,-0x34(%rbp)
	if(printed < 0)
  4020a2:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  4020a6:	79 07                	jns    4020af <printf+0x3a7>
		return -1;
  4020a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  4020ad:	eb 09                	jmp    4020b8 <printf+0x3b0>
	return screen_ctr;
  4020af:	48 8b 05 c2 20 20 00 	mov    0x2020c2(%rip),%rax        # 604178 <free+0x20106d>
  4020b6:	8b 00                	mov    (%rax),%eax

}
  4020b8:	c9                   	leaveq 
  4020b9:	c3                   	retq   

00000000004020ba <syscall_2>:
				:"=r"(ret):"m"(n),"m"(a1));
	}
	return ret;
}

static __inline uint64_t syscall_2(uint64_t n, uint64_t a1, uint64_t a2) {
  4020ba:	55                   	push   %rbp
  4020bb:	48 89 e5             	mov    %rsp,%rbp
  4020be:	48 83 ec 28          	sub    $0x28,%rsp
  4020c2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  4020c6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  4020ca:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	uint64_t ret;
	__asm__("movq %1,%%rax;"
  4020ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  4020d2:	48 8b 7d e0          	mov    -0x20(%rbp),%rdi
  4020d6:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  4020da:	cd 80                	int    $0x80
  4020dc:	48 89 c0             	mov    %rax,%rax
  4020df:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
			"movq %2,%%rdi;"
			"movq %3,%%rsi;"
			"int $0x80;"
			"movq %%rax,%0;"
			:"=r"(ret):"m"(n),"m"(a1),"m"(a2));
	return ret;
  4020e3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  4020e7:	c9                   	leaveq 
  4020e8:	c3                   	retq   

00000000004020e9 <dup2>:
#include<sys/syscall.h>
#include<syscall.h>
#include<stdlib.h>

int dup2(int oldfd, int newfd)
{
  4020e9:	55                   	push   %rbp
  4020ea:	48 89 e5             	mov    %rsp,%rbp
  4020ed:	48 83 ec 18          	sub    $0x18,%rsp
  4020f1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  4020f4:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int retvalue;
	retvalue = syscall_2(SYS_dup2, oldfd, newfd);
  4020f7:	8b 45 e8             	mov    -0x18(%rbp),%eax
  4020fa:	48 63 d0             	movslq %eax,%rdx
  4020fd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  402100:	48 98                	cltq   
  402102:	48 89 c6             	mov    %rax,%rsi
  402105:	bf 21 00 00 00       	mov    $0x21,%edi
  40210a:	e8 ab ff ff ff       	callq  4020ba <syscall_2>
  40210f:	89 45 fc             	mov    %eax,-0x4(%rbp)

	if(retvalue >=0){
  402112:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  402116:	78 05                	js     40211d <dup2+0x34>
		return retvalue;
  402118:	8b 45 fc             	mov    -0x4(%rbp),%eax
  40211b:	eb 05                	jmp    402122 <dup2+0x39>
	}
	return -1;
  40211d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax


}
  402122:	c9                   	leaveq 
  402123:	c3                   	retq   

0000000000402124 <syscall_3>:

static __inline uint64_t syscall_3(uint64_t n, uint64_t a1, uint64_t a2, uint64_t a3) {
  402124:	55                   	push   %rbp
  402125:	48 89 e5             	mov    %rsp,%rbp
  402128:	48 83 ec 30          	sub    $0x30,%rsp
  40212c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  402130:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  402134:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  402138:	48 89 4d d0          	mov    %rcx,-0x30(%rbp)

	uint64_t ret;
    
	__asm__("movq %1,%%rax;"
  40213c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  402140:	48 8b 7d e0          	mov    -0x20(%rbp),%rdi
  402144:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  402148:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  40214c:	cd 80                	int    $0x80
  40214e:	48 89 c0             	mov    %rax,%rax
  402151:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
			"movq %3, %%rsi;"
			"movq %4, %%rdx;"
			"int $0x80;"
			"movq %%rax,%0;"
			:"=r"(ret):"m"(n),"m"(a1),"m"(a2),"m"(a3));
	return ret;
  402155:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  402159:	c9                   	leaveq 
  40215a:	c3                   	retq   

000000000040215b <write>:
#include <stdlib.h>
#include <stdio.h>
#include <errno.h>


ssize_t write(int fd, const void *buf, size_t count){
  40215b:	55                   	push   %rbp
  40215c:	48 89 e5             	mov    %rsp,%rbp
  40215f:	48 83 ec 28          	sub    $0x28,%rsp
  402163:	89 7d ec             	mov    %edi,-0x14(%rbp)
  402166:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  40216a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	int retvalue=syscall_3(SYS_write,fd,(uint64_t)buf,(uint64_t)count);
  40216e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  402172:	8b 45 ec             	mov    -0x14(%rbp),%eax
  402175:	48 98                	cltq   
  402177:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  40217b:	48 89 c6             	mov    %rax,%rsi
  40217e:	bf 01 00 00 00       	mov    $0x1,%edi
  402183:	e8 9c ff ff ff       	callq  402124 <syscall_3>
  402188:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(retvalue >=0){
  40218b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  40218f:	78 07                	js     402198 <write+0x3d>
		return retvalue;
  402191:	8b 45 fc             	mov    -0x4(%rbp),%eax
  402194:	48 98                	cltq   
  402196:	eb 07                	jmp    40219f <write+0x44>
	}
	return -1;
  402198:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
}
  40219f:	c9                   	leaveq 
  4021a0:	c3                   	retq   

00000000004021a1 <syscall_1>:
			:"=r"(ret):"m"(n));

	return ret;
}

static __inline int64_t syscall_1(uint64_t n, uint64_t a1) {
  4021a1:	55                   	push   %rbp
  4021a2:	48 89 e5             	mov    %rsp,%rbp
  4021a5:	48 83 ec 20          	sub    $0x20,%rsp
  4021a9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  4021ad:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)

	int64_t ret;

	__asm__("movq $78,%r15");
  4021b1:	49 c7 c7 4e 00 00 00 	mov    $0x4e,%r15
	//__asm__("movq %0,%%rax;"
	//		::"m"(n));

	//while(1);

	if(n==60){
  4021b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  4021bc:	48 83 f8 3c          	cmp    $0x3c,%rax
  4021c0:	75 0c                	jne    4021ce <syscall_1+0x2d>
		__asm__("movq %0,%%rax;"
  4021c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  4021c6:	48 8b 7d e0          	mov    -0x20(%rbp),%rdi
  4021ca:	cd 80                	int    $0x80
  4021cc:	eb 11                	jmp    4021df <syscall_1+0x3e>

		//while(1);
	}
	else{

		__asm__("movq %1,%%rax;"
  4021ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  4021d2:	48 8b 7d e0          	mov    -0x20(%rbp),%rdi
  4021d6:	cd 80                	int    $0x80
  4021d8:	48 89 c0             	mov    %rax,%rax
  4021db:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
				"movq %2,%%rdi;"
				"int $0x80;"
				"movq %%rax,%0;"
				:"=r"(ret):"m"(n),"m"(a1));
	}
	return ret;
  4021df:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  4021e3:	c9                   	leaveq 
  4021e4:	c3                   	retq   

00000000004021e5 <closedir>:
#include<sys/defs.h>
#include<stdlib.h>
#include<errno.h>


int closedir(void *dir){
  4021e5:	55                   	push   %rbp
  4021e6:	48 89 e5             	mov    %rsp,%rbp
  4021e9:	48 83 ec 20          	sub    $0x20,%rsp
  4021ed:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)


	if((uint64_t)dir == -1){
  4021f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  4021f5:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  4021f9:	75 18                	jne    402213 <closedir+0x2e>

		printf("Cannot close bad directory stream\n");
  4021fb:	48 8d 3d e6 12 00 00 	lea    0x12e6(%rip),%rdi        # 4034e8 <free+0x3dd>
  402202:	b8 00 00 00 00       	mov    $0x0,%eax
  402207:	e8 fc fa ff ff       	callq  401d08 <printf>
		return -1;
  40220c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  402211:	eb 42                	jmp    402255 <closedir+0x70>
	}
	int fd = (uint64_t)dir;
  402213:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  402217:	89 45 fc             	mov    %eax,-0x4(%rbp)


	printf("Check fd %d",fd);
  40221a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  40221d:	89 c6                	mov    %eax,%esi
  40221f:	48 8d 3d e5 12 00 00 	lea    0x12e5(%rip),%rdi        # 40350b <free+0x400>
  402226:	b8 00 00 00 00       	mov    $0x0,%eax
  40222b:	e8 d8 fa ff ff       	callq  401d08 <printf>
	int retvalue;
	retvalue = syscall_1(SYS_close,(uint64_t)fd);
  402230:	8b 45 fc             	mov    -0x4(%rbp),%eax
  402233:	48 98                	cltq   
  402235:	48 89 c6             	mov    %rax,%rsi
  402238:	bf 03 00 00 00       	mov    $0x3,%edi
  40223d:	e8 5f ff ff ff       	callq  4021a1 <syscall_1>
  402242:	89 45 f8             	mov    %eax,-0x8(%rbp)

	//printf("closedir syscall returned %d\n",retvalue );

	if(retvalue<0){
  402245:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  402249:	79 07                	jns    402252 <closedir+0x6d>
		
		return -1;
  40224b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  402250:	eb 03                	jmp    402255 <closedir+0x70>

	}
	return retvalue;
  402252:	8b 45 f8             	mov    -0x8(%rbp),%eax


}
  402255:	c9                   	leaveq 
  402256:	c3                   	retq   

0000000000402257 <syscall_2>:

static __inline uint64_t syscall_2(uint64_t n, uint64_t a1, uint64_t a2) {
  402257:	55                   	push   %rbp
  402258:	48 89 e5             	mov    %rsp,%rbp
  40225b:	48 83 ec 28          	sub    $0x28,%rsp
  40225f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  402263:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  402267:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	uint64_t ret;
	__asm__("movq %1,%%rax;"
  40226b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  40226f:	48 8b 7d e0          	mov    -0x20(%rbp),%rdi
  402273:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  402277:	cd 80                	int    $0x80
  402279:	48 89 c0             	mov    %rax,%rax
  40227c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
			"movq %2,%%rdi;"
			"movq %3,%%rsi;"
			"int $0x80;"
			"movq %%rax,%0;"
			:"=r"(ret):"m"(n),"m"(a1),"m"(a2));
	return ret;
  402280:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  402284:	c9                   	leaveq 
  402285:	c3                   	retq   

0000000000402286 <opendir>:
#include<syscall.h>
#include<string.h>


void *opendir(const char *name)
{
  402286:	55                   	push   %rbp
  402287:	48 89 e5             	mov    %rsp,%rbp
  40228a:	48 83 ec 20          	sub    $0x20,%rsp
  40228e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)

	
	uint64_t fd=0;
  402292:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  402299:	00 

	//WARNING THIS IS A HACK MUST ALLOCATE SPACE FR FD and return it

	fd = (uint64_t)syscall_2(SYS_open, (uint64_t) name, O_DIRECTORY | O_RDONLY);
  40229a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  40229e:	ba 00 00 01 00       	mov    $0x10000,%edx
  4022a3:	48 89 c6             	mov    %rax,%rsi
  4022a6:	bf 02 00 00 00       	mov    $0x2,%edi
  4022ab:	e8 a7 ff ff ff       	callq  402257 <syscall_2>
  4022b0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	


	if(fd == -1){
  4022b4:	48 83 7d f8 ff       	cmpq   $0xffffffffffffffff,-0x8(%rbp)
  4022b9:	75 1a                	jne    4022d5 <opendir+0x4f>
		printf("No such file or directory\n");
  4022bb:	48 8d 3d 55 12 00 00 	lea    0x1255(%rip),%rdi        # 403517 <free+0x40c>
  4022c2:	b8 00 00 00 00       	mov    $0x0,%eax
  4022c7:	e8 3c fa ff ff       	callq  401d08 <printf>
		return (void*)-1;
  4022cc:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
  4022d3:	eb 04                	jmp    4022d9 <opendir+0x53>
	}

	return (void*)fd;
  4022d5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  4022d9:	c9                   	leaveq 
  4022da:	c3                   	retq   

00000000004022db <syscall_0>:
#define _SYSCALL_H

#include <sys/defs.h>
#include <sys/syscall.h>

static __inline uint64_t syscall_0(uint64_t n) {
  4022db:	55                   	push   %rbp
  4022dc:	48 89 e5             	mov    %rsp,%rbp
  4022df:	48 83 ec 18          	sub    $0x18,%rsp
  4022e3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)

	uint64_t ret;
	__asm__("movq %1,%%rax;"
  4022e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  4022eb:	cd 80                	int    $0x80
  4022ed:	48 89 c0             	mov    %rax,%rax
  4022f0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
			"int $0x80;"
			"movq %%rax,%0;"
			:"=r"(ret):"m"(n));

	return ret;
  4022f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  4022f8:	c9                   	leaveq 
  4022f9:	c3                   	retq   

00000000004022fa <syscall_3>:
			"movq %%rax,%0;"
			:"=r"(ret):"m"(n),"m"(a1),"m"(a2));
	return ret;
}

static __inline uint64_t syscall_3(uint64_t n, uint64_t a1, uint64_t a2, uint64_t a3) {
  4022fa:	55                   	push   %rbp
  4022fb:	48 89 e5             	mov    %rsp,%rbp
  4022fe:	48 83 ec 30          	sub    $0x30,%rsp
  402302:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  402306:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  40230a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  40230e:	48 89 4d d0          	mov    %rcx,-0x30(%rbp)

	uint64_t ret;
    
	__asm__("movq %1,%%rax;"
  402312:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  402316:	48 8b 7d e0          	mov    -0x20(%rbp),%rdi
  40231a:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  40231e:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  402322:	cd 80                	int    $0x80
  402324:	48 89 c0             	mov    %rax,%rax
  402327:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
			"movq %3, %%rsi;"
			"movq %4, %%rdx;"
			"int $0x80;"
			"movq %%rax,%0;"
			:"=r"(ret):"m"(n),"m"(a1),"m"(a2),"m"(a3));
	return ret;
  40232b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  40232f:	c9                   	leaveq 
  402330:	c3                   	retq   

0000000000402331 <getpid>:
#include <sys/defs.h>
#include <stdlib.h>
#include <sys/syscall.h>

pid_t getpid()
{
  402331:	55                   	push   %rbp
  402332:	48 89 e5             	mov    %rsp,%rbp
  402335:	48 83 ec 10          	sub    $0x10,%rsp
	int retvalue;
	retvalue = syscall_0(SYS_getpid);
  402339:	bf 27 00 00 00       	mov    $0x27,%edi
  40233e:	e8 98 ff ff ff       	callq  4022db <syscall_0>
  402343:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(retvalue >=0){
  402346:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  40234a:	78 05                	js     402351 <getpid+0x20>
		return retvalue;
  40234c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  40234f:	eb 05                	jmp    402356 <getpid+0x25>
	}
	return -1;
  402351:	b8 ff ff ff ff       	mov    $0xffffffff,%eax


}
  402356:	c9                   	leaveq 
  402357:	c3                   	retq   

0000000000402358 <getppid>:

pid_t getppid()
{
  402358:	55                   	push   %rbp
  402359:	48 89 e5             	mov    %rsp,%rbp
  40235c:	48 83 ec 10          	sub    $0x10,%rsp
	int retvalue;
	retvalue = syscall_0(SYS_getppid);
  402360:	bf 6e 00 00 00       	mov    $0x6e,%edi
  402365:	e8 71 ff ff ff       	callq  4022db <syscall_0>
  40236a:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(retvalue >=0){
  40236d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  402371:	78 05                	js     402378 <getppid+0x20>
		return retvalue;
  402373:	8b 45 fc             	mov    -0x4(%rbp),%eax
  402376:	eb 05                	jmp    40237d <getppid+0x25>
	}

	return -1;
  402378:	b8 ff ff ff ff       	mov    $0xffffffff,%eax


}
  40237d:	c9                   	leaveq 
  40237e:	c3                   	retq   

000000000040237f <waitpid>:

pid_t waitpid(pid_t pid, int *status, int options)
{
  40237f:	55                   	push   %rbp
  402380:	48 89 e5             	mov    %rsp,%rbp
  402383:	48 83 ec 20          	sub    $0x20,%rsp
  402387:	89 7d ec             	mov    %edi,-0x14(%rbp)
  40238a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  40238e:	89 55 e8             	mov    %edx,-0x18(%rbp)
	pid_t retvalue;
	retvalue = syscall_3(SYS_wait4,(uint64_t)pid,(uint64_t)status,(uint64_t)options);
  402391:	8b 45 e8             	mov    -0x18(%rbp),%eax
  402394:	48 63 c8             	movslq %eax,%rcx
  402397:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  40239b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  40239e:	48 89 c6             	mov    %rax,%rsi
  4023a1:	bf 3d 00 00 00       	mov    $0x3d,%edi
  4023a6:	e8 4f ff ff ff       	callq  4022fa <syscall_3>
  4023ab:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(retvalue >=0){
		return retvalue;
  4023ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
	}

	return -1;

}
  4023b1:	c9                   	leaveq 
  4023b2:	c3                   	retq   

00000000004023b3 <strlen>:
#include <errno.h>



int strlen(const char *str)
{
  4023b3:	55                   	push   %rbp
  4023b4:	48 89 e5             	mov    %rsp,%rbp
  4023b7:	48 83 ec 18          	sub    $0x18,%rsp
  4023bb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	const char *ptr=str;
  4023bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  4023c3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for(;*ptr != '\0'; ptr++);
  4023c7:	eb 04                	jmp    4023cd <strlen+0x1a>
  4023c9:	48 ff 45 f8          	incq   -0x8(%rbp)
  4023cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  4023d1:	0f b6 00             	movzbl (%rax),%eax
  4023d4:	84 c0                	test   %al,%al
  4023d6:	75 f1                	jne    4023c9 <strlen+0x16>

	return ptr-str;
  4023d8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  4023dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  4023e0:	48 29 c2             	sub    %rax,%rdx
  4023e3:	48 89 d0             	mov    %rdx,%rax
}
  4023e6:	c9                   	leaveq 
  4023e7:	c3                   	retq   

00000000004023e8 <strcpy>:

char* strcpy(char* dst, const char* src)
{
  4023e8:	55                   	push   %rbp
  4023e9:	48 89 e5             	mov    %rsp,%rbp
  4023ec:	48 83 ec 30          	sub    $0x30,%rsp
  4023f0:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  4023f4:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	////printf("In strcpy\n");
	int i, len=strlen(src);
  4023f8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  4023fc:	48 89 c7             	mov    %rax,%rdi
  4023ff:	e8 af ff ff ff       	callq  4023b3 <strlen>
  402404:	89 45 ec             	mov    %eax,-0x14(%rbp)
	//printf("In strlen.... length of src %d\n",len);
	char* ptr=dst;
  402407:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  40240b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	for(i=0; i<=len; i++)
  40240f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  402416:	eb 21                	jmp    402439 <strcpy+0x51>
	{
		*ptr++ = src[i];
  402418:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  40241c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  402420:	48 89 55 f0          	mov    %rdx,-0x10(%rbp)
  402424:	8b 55 fc             	mov    -0x4(%rbp),%edx
  402427:	48 63 ca             	movslq %edx,%rcx
  40242a:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  40242e:	48 01 ca             	add    %rcx,%rdx
  402431:	0f b6 12             	movzbl (%rdx),%edx
  402434:	88 10                	mov    %dl,(%rax)
	////printf("In strcpy\n");
	int i, len=strlen(src);
	//printf("In strlen.... length of src %d\n",len);
	char* ptr=dst;

	for(i=0; i<=len; i++)
  402436:	ff 45 fc             	incl   -0x4(%rbp)
  402439:	8b 45 fc             	mov    -0x4(%rbp),%eax
  40243c:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  40243f:	7e d7                	jle    402418 <strcpy+0x30>
	{
		*ptr++ = src[i];
	}
	return dst;
  402441:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
}
  402445:	c9                   	leaveq 
  402446:	c3                   	retq   

0000000000402447 <strcmp>:


int strcmp(const char *str1, const char *str2)
{
  402447:	55                   	push   %rbp
  402448:	48 89 e5             	mov    %rsp,%rbp
  40244b:	48 83 ec 10          	sub    $0x10,%rsp
  40244f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  402453:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)

	while(1)
	{
		////printf("In strcmp\n");

		if(*str1 != *str2)
  402457:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  40245b:	0f b6 10             	movzbl (%rax),%edx
  40245e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  402462:	0f b6 00             	movzbl (%rax),%eax
  402465:	38 c2                	cmp    %al,%dl
  402467:	74 1a                	je     402483 <strcmp+0x3c>
			return (*str1 - *str2);
  402469:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  40246d:	0f b6 00             	movzbl (%rax),%eax
  402470:	0f be d0             	movsbl %al,%edx
  402473:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  402477:	0f b6 00             	movzbl (%rax),%eax
  40247a:	0f be c0             	movsbl %al,%eax
  40247d:	29 c2                	sub    %eax,%edx
  40247f:	89 d0                	mov    %edx,%eax
  402481:	eb 49                	jmp    4024cc <strcmp+0x85>

		else if((*str1 == *str2) && (*(str1+1) == *(str2 + 1)) && (*(str1 + 1) == '\0'))
  402483:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  402487:	0f b6 10             	movzbl (%rax),%edx
  40248a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  40248e:	0f b6 00             	movzbl (%rax),%eax
  402491:	38 c2                	cmp    %al,%dl
  402493:	75 2d                	jne    4024c2 <strcmp+0x7b>
  402495:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  402499:	48 ff c0             	inc    %rax
  40249c:	0f b6 10             	movzbl (%rax),%edx
  40249f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  4024a3:	48 ff c0             	inc    %rax
  4024a6:	0f b6 00             	movzbl (%rax),%eax
  4024a9:	38 c2                	cmp    %al,%dl
  4024ab:	75 15                	jne    4024c2 <strcmp+0x7b>
  4024ad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  4024b1:	48 ff c0             	inc    %rax
  4024b4:	0f b6 00             	movzbl (%rax),%eax
  4024b7:	84 c0                	test   %al,%al
  4024b9:	75 07                	jne    4024c2 <strcmp+0x7b>
			return 0;
  4024bb:	b8 00 00 00 00       	mov    $0x0,%eax
  4024c0:	eb 0a                	jmp    4024cc <strcmp+0x85>


		str1++;
  4024c2:	48 ff 45 f8          	incq   -0x8(%rbp)
		str2++;
  4024c6:	48 ff 45 f0          	incq   -0x10(%rbp)

	}
  4024ca:	eb 8b                	jmp    402457 <strcmp+0x10>

	return 0;
}
  4024cc:	c9                   	leaveq 
  4024cd:	c3                   	retq   

00000000004024ce <strstr>:

const char *strstr(const char *haystack, const char *needle)
{
  4024ce:	55                   	push   %rbp
  4024cf:	48 89 e5             	mov    %rsp,%rbp
  4024d2:	48 83 ec 20          	sub    $0x20,%rsp
  4024d6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  4024da:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)

	//printf("In strstrt\n %s %s\n\n", haystack,  needle);
	int len = strlen(haystack), i, j;
  4024de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  4024e2:	48 89 c7             	mov    %rax,%rdi
  4024e5:	e8 c9 fe ff ff       	callq  4023b3 <strlen>
  4024ea:	89 45 f4             	mov    %eax,-0xc(%rbp)
	for(i=0; i< len; i++)
  4024ed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  4024f4:	e9 a0 00 00 00       	jmpq   402599 <strstr+0xcb>
	{
		for(j = i; j< strlen(needle); j++)
  4024f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  4024fc:	89 45 f8             	mov    %eax,-0x8(%rbp)
  4024ff:	eb 31                	jmp    402532 <strstr+0x64>
		{
			if(*(haystack+i+j) != *(needle+j))
  402501:	8b 45 fc             	mov    -0x4(%rbp),%eax
  402504:	48 63 d0             	movslq %eax,%rdx
  402507:	8b 45 f8             	mov    -0x8(%rbp),%eax
  40250a:	48 98                	cltq   
  40250c:	48 01 c2             	add    %rax,%rdx
  40250f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  402513:	48 01 d0             	add    %rdx,%rax
  402516:	0f b6 10             	movzbl (%rax),%edx
  402519:	8b 45 f8             	mov    -0x8(%rbp),%eax
  40251c:	48 63 c8             	movslq %eax,%rcx
  40251f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  402523:	48 01 c8             	add    %rcx,%rax
  402526:	0f b6 00             	movzbl (%rax),%eax
  402529:	38 c2                	cmp    %al,%dl
  40252b:	74 02                	je     40252f <strstr+0x61>
				break;
  40252d:	eb 14                	jmp    402543 <strstr+0x75>

	//printf("In strstrt\n %s %s\n\n", haystack,  needle);
	int len = strlen(haystack), i, j;
	for(i=0; i< len; i++)
	{
		for(j = i; j< strlen(needle); j++)
  40252f:	ff 45 f8             	incl   -0x8(%rbp)
  402532:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  402536:	48 89 c7             	mov    %rax,%rdi
  402539:	e8 75 fe ff ff       	callq  4023b3 <strlen>
  40253e:	3b 45 f8             	cmp    -0x8(%rbp),%eax
  402541:	7f be                	jg     402501 <strstr+0x33>
		{
			if(*(haystack+i+j) != *(needle+j))
				break;
		}	

		if( (j == strlen(needle) ) && (*(haystack+i+j-1) == *(needle+j-1)))
  402543:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  402547:	48 89 c7             	mov    %rax,%rdi
  40254a:	e8 64 fe ff ff       	callq  4023b3 <strlen>
  40254f:	3b 45 f8             	cmp    -0x8(%rbp),%eax
  402552:	75 42                	jne    402596 <strstr+0xc8>
  402554:	8b 45 fc             	mov    -0x4(%rbp),%eax
  402557:	48 63 d0             	movslq %eax,%rdx
  40255a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  40255d:	48 98                	cltq   
  40255f:	48 01 d0             	add    %rdx,%rax
  402562:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  402566:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  40256a:	48 01 d0             	add    %rdx,%rax
  40256d:	0f b6 10             	movzbl (%rax),%edx
  402570:	8b 45 f8             	mov    -0x8(%rbp),%eax
  402573:	48 98                	cltq   
  402575:	48 8d 48 ff          	lea    -0x1(%rax),%rcx
  402579:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  40257d:	48 01 c8             	add    %rcx,%rax
  402580:	0f b6 00             	movzbl (%rax),%eax
  402583:	38 c2                	cmp    %al,%dl
  402585:	75 0f                	jne    402596 <strstr+0xc8>
		{
			return (haystack + i);
  402587:	8b 45 fc             	mov    -0x4(%rbp),%eax
  40258a:	48 63 d0             	movslq %eax,%rdx
  40258d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  402591:	48 01 d0             	add    %rdx,%rax
  402594:	eb 14                	jmp    4025aa <strstr+0xdc>
const char *strstr(const char *haystack, const char *needle)
{

	//printf("In strstrt\n %s %s\n\n", haystack,  needle);
	int len = strlen(haystack), i, j;
	for(i=0; i< len; i++)
  402596:	ff 45 fc             	incl   -0x4(%rbp)
  402599:	8b 45 fc             	mov    -0x4(%rbp),%eax
  40259c:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  40259f:	0f 8c 54 ff ff ff    	jl     4024f9 <strstr+0x2b>
		{
			return (haystack + i);
		}
	}

	return NULL;
  4025a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  4025aa:	c9                   	leaveq 
  4025ab:	c3                   	retq   

00000000004025ac <strcat>:

char *strcat(char *dst, const char *src)
{
  4025ac:	55                   	push   %rbp
  4025ad:	48 89 e5             	mov    %rsp,%rbp
  4025b0:	48 83 ec 10          	sub    $0x10,%rsp
  4025b4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  4025b8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(&dst[strlen(dst)],src);
  4025bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  4025c0:	48 89 c7             	mov    %rax,%rdi
  4025c3:	e8 eb fd ff ff       	callq  4023b3 <strlen>
  4025c8:	48 63 d0             	movslq %eax,%rdx
  4025cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  4025cf:	48 01 c2             	add    %rax,%rdx
  4025d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  4025d6:	48 89 c6             	mov    %rax,%rsi
  4025d9:	48 89 d7             	mov    %rdx,%rdi
  4025dc:	e8 07 fe ff ff       	callq  4023e8 <strcpy>
	//printf("after cat: %s\n\n\n",dst);
	return dst;
  4025e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  4025e5:	c9                   	leaveq 
  4025e6:	c3                   	retq   

00000000004025e7 <strerror>:

uint64_t strerror(int err)
{
  4025e7:	55                   	push   %rbp
  4025e8:	48 89 e5             	mov    %rsp,%rbp
  4025eb:	48 83 ec 10          	sub    $0x10,%rsp
  4025ef:	89 7d fc             	mov    %edi,-0x4(%rbp)

	switch(err)
  4025f2:	83 7d fc 24          	cmpl   $0x24,-0x4(%rbp)
  4025f6:	0f 87 5a 03 00 00    	ja     402956 <strerror+0x36f>
  4025fc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  4025ff:	48 8d 14 85 00 00 00 	lea    0x0(,%rax,4),%rdx
  402606:	00 
  402607:	48 8d 05 0e 12 00 00 	lea    0x120e(%rip),%rax        # 40381c <free+0x711>
  40260e:	8b 04 02             	mov    (%rdx,%rax,1),%eax
  402611:	48 63 d0             	movslq %eax,%rdx
  402614:	48 8d 05 01 12 00 00 	lea    0x1201(%rip),%rax        # 40381c <free+0x711>
  40261b:	48 01 d0             	add    %rdx,%rax
  40261e:	ff e0                	jmpq   *%rax
	{

	case EPERM    : {return  printf("Operation not permitted \n");break;}
  402620:	48 8d 3d 11 0f 00 00 	lea    0xf11(%rip),%rdi        # 403538 <free+0x42d>
  402627:	b8 00 00 00 00       	mov    $0x0,%eax
  40262c:	e8 d7 f6 ff ff       	callq  401d08 <printf>
  402631:	48 98                	cltq   
  402633:	e9 23 03 00 00       	jmpq   40295b <strerror+0x374>
	case ENOENT   : {return  printf("No such file or directory \n");break;}
  402638:	48 8d 3d 13 0f 00 00 	lea    0xf13(%rip),%rdi        # 403552 <free+0x447>
  40263f:	b8 00 00 00 00       	mov    $0x0,%eax
  402644:	e8 bf f6 ff ff       	callq  401d08 <printf>
  402649:	48 98                	cltq   
  40264b:	e9 0b 03 00 00       	jmpq   40295b <strerror+0x374>
	case ESRCH    : {return  printf("No such process \n");;break;}
  402650:	48 8d 3d 17 0f 00 00 	lea    0xf17(%rip),%rdi        # 40356e <free+0x463>
  402657:	b8 00 00 00 00       	mov    $0x0,%eax
  40265c:	e8 a7 f6 ff ff       	callq  401d08 <printf>
  402661:	48 98                	cltq   
  402663:	e9 f3 02 00 00       	jmpq   40295b <strerror+0x374>
	case EINTR    : {return  printf("Interrupted system call \n");break;}
  402668:	48 8d 3d 11 0f 00 00 	lea    0xf11(%rip),%rdi        # 403580 <free+0x475>
  40266f:	b8 00 00 00 00       	mov    $0x0,%eax
  402674:	e8 8f f6 ff ff       	callq  401d08 <printf>
  402679:	48 98                	cltq   
  40267b:	e9 db 02 00 00       	jmpq   40295b <strerror+0x374>
	case EIO      : {return  printf("error \n");;break;}
  402680:	48 8d 3d 13 0f 00 00 	lea    0xf13(%rip),%rdi        # 40359a <free+0x48f>
  402687:	b8 00 00 00 00       	mov    $0x0,%eax
  40268c:	e8 77 f6 ff ff       	callq  401d08 <printf>
  402691:	48 98                	cltq   
  402693:	e9 c3 02 00 00       	jmpq   40295b <strerror+0x374>
	case ENXIO    : {return  printf("No such device or address \n");break;}
  402698:	48 8d 3d 03 0f 00 00 	lea    0xf03(%rip),%rdi        # 4035a2 <free+0x497>
  40269f:	b8 00 00 00 00       	mov    $0x0,%eax
  4026a4:	e8 5f f6 ff ff       	callq  401d08 <printf>
  4026a9:	48 98                	cltq   
  4026ab:	e9 ab 02 00 00       	jmpq   40295b <strerror+0x374>
	case E2BIG    : {return  printf("Argument list too long \n");break;}
  4026b0:	48 8d 3d 07 0f 00 00 	lea    0xf07(%rip),%rdi        # 4035be <free+0x4b3>
  4026b7:	b8 00 00 00 00       	mov    $0x0,%eax
  4026bc:	e8 47 f6 ff ff       	callq  401d08 <printf>
  4026c1:	48 98                	cltq   
  4026c3:	e9 93 02 00 00       	jmpq   40295b <strerror+0x374>
	case ENOEXEC  : {return  printf("Exec format error \n");break;}
  4026c8:	48 8d 3d 08 0f 00 00 	lea    0xf08(%rip),%rdi        # 4035d7 <free+0x4cc>
  4026cf:	b8 00 00 00 00       	mov    $0x0,%eax
  4026d4:	e8 2f f6 ff ff       	callq  401d08 <printf>
  4026d9:	48 98                	cltq   
  4026db:	e9 7b 02 00 00       	jmpq   40295b <strerror+0x374>
	case EBADF    : {return  printf("Bad file number \n");break;}
  4026e0:	48 8d 3d 04 0f 00 00 	lea    0xf04(%rip),%rdi        # 4035eb <free+0x4e0>
  4026e7:	b8 00 00 00 00       	mov    $0x0,%eax
  4026ec:	e8 17 f6 ff ff       	callq  401d08 <printf>
  4026f1:	48 98                	cltq   
  4026f3:	e9 63 02 00 00       	jmpq   40295b <strerror+0x374>
	case ECHILD   : {return  printf("No child processes \n");break;}
  4026f8:	48 8d 3d fe 0e 00 00 	lea    0xefe(%rip),%rdi        # 4035fd <free+0x4f2>
  4026ff:	b8 00 00 00 00       	mov    $0x0,%eax
  402704:	e8 ff f5 ff ff       	callq  401d08 <printf>
  402709:	48 98                	cltq   
  40270b:	e9 4b 02 00 00       	jmpq   40295b <strerror+0x374>
	case EAGAIN   : {return  printf("Try again \n");;break;}
  402710:	48 8d 3d fb 0e 00 00 	lea    0xefb(%rip),%rdi        # 403612 <free+0x507>
  402717:	b8 00 00 00 00       	mov    $0x0,%eax
  40271c:	e8 e7 f5 ff ff       	callq  401d08 <printf>
  402721:	48 98                	cltq   
  402723:	e9 33 02 00 00       	jmpq   40295b <strerror+0x374>
	case ENOMEM   : {return  printf("Out of memory \n");;break;}
  402728:	48 8d 3d ef 0e 00 00 	lea    0xeef(%rip),%rdi        # 40361e <free+0x513>
  40272f:	b8 00 00 00 00       	mov    $0x0,%eax
  402734:	e8 cf f5 ff ff       	callq  401d08 <printf>
  402739:	48 98                	cltq   
  40273b:	e9 1b 02 00 00       	jmpq   40295b <strerror+0x374>
	case EACCES   : {return  printf("Permission denied \n");break;}
  402740:	48 8d 3d e7 0e 00 00 	lea    0xee7(%rip),%rdi        # 40362e <free+0x523>
  402747:	b8 00 00 00 00       	mov    $0x0,%eax
  40274c:	e8 b7 f5 ff ff       	callq  401d08 <printf>
  402751:	48 98                	cltq   
  402753:	e9 03 02 00 00       	jmpq   40295b <strerror+0x374>
	case EFAULT   : {return  printf("Bad address \n");;break;}
  402758:	48 8d 3d e3 0e 00 00 	lea    0xee3(%rip),%rdi        # 403642 <free+0x537>
  40275f:	b8 00 00 00 00       	mov    $0x0,%eax
  402764:	e8 9f f5 ff ff       	callq  401d08 <printf>
  402769:	48 98                	cltq   
  40276b:	e9 eb 01 00 00       	jmpq   40295b <strerror+0x374>
	case ENOTBLK  : {return  printf("Block device required \n");break;}
  402770:	48 8d 3d d9 0e 00 00 	lea    0xed9(%rip),%rdi        # 403650 <free+0x545>
  402777:	b8 00 00 00 00       	mov    $0x0,%eax
  40277c:	e8 87 f5 ff ff       	callq  401d08 <printf>
  402781:	48 98                	cltq   
  402783:	e9 d3 01 00 00       	jmpq   40295b <strerror+0x374>
	case EBUSY    : {return  printf("Device or resource busy \n");break;}
  402788:	48 8d 3d d9 0e 00 00 	lea    0xed9(%rip),%rdi        # 403668 <free+0x55d>
  40278f:	b8 00 00 00 00       	mov    $0x0,%eax
  402794:	e8 6f f5 ff ff       	callq  401d08 <printf>
  402799:	48 98                	cltq   
  40279b:	e9 bb 01 00 00       	jmpq   40295b <strerror+0x374>
	case EEXIST   : {return  printf("File exists \n");;break;}
  4027a0:	48 8d 3d db 0e 00 00 	lea    0xedb(%rip),%rdi        # 403682 <free+0x577>
  4027a7:	b8 00 00 00 00       	mov    $0x0,%eax
  4027ac:	e8 57 f5 ff ff       	callq  401d08 <printf>
  4027b1:	48 98                	cltq   
  4027b3:	e9 a3 01 00 00       	jmpq   40295b <strerror+0x374>
	case EXDEV    : {return  printf("Cross-device link \n");break;}
  4027b8:	48 8d 3d d1 0e 00 00 	lea    0xed1(%rip),%rdi        # 403690 <free+0x585>
  4027bf:	b8 00 00 00 00       	mov    $0x0,%eax
  4027c4:	e8 3f f5 ff ff       	callq  401d08 <printf>
  4027c9:	48 98                	cltq   
  4027cb:	e9 8b 01 00 00       	jmpq   40295b <strerror+0x374>
	case ENODEV   : {return  printf("No such device \n");break;}
  4027d0:	48 8d 3d cd 0e 00 00 	lea    0xecd(%rip),%rdi        # 4036a4 <free+0x599>
  4027d7:	b8 00 00 00 00       	mov    $0x0,%eax
  4027dc:	e8 27 f5 ff ff       	callq  401d08 <printf>
  4027e1:	48 98                	cltq   
  4027e3:	e9 73 01 00 00       	jmpq   40295b <strerror+0x374>
	case ENOTDIR  : {return  printf("Not a directory \n");break;}
  4027e8:	48 8d 3d c6 0e 00 00 	lea    0xec6(%rip),%rdi        # 4036b5 <free+0x5aa>
  4027ef:	b8 00 00 00 00       	mov    $0x0,%eax
  4027f4:	e8 0f f5 ff ff       	callq  401d08 <printf>
  4027f9:	48 98                	cltq   
  4027fb:	e9 5b 01 00 00       	jmpq   40295b <strerror+0x374>
	case EISDIR   : {return  printf("Is a directory \n");break;}
  402800:	48 8d 3d c0 0e 00 00 	lea    0xec0(%rip),%rdi        # 4036c7 <free+0x5bc>
  402807:	b8 00 00 00 00       	mov    $0x0,%eax
  40280c:	e8 f7 f4 ff ff       	callq  401d08 <printf>
  402811:	48 98                	cltq   
  402813:	e9 43 01 00 00       	jmpq   40295b <strerror+0x374>
	case EINVAL   : {return  printf("Invalid argument \n");break;}
  402818:	48 8d 3d b9 0e 00 00 	lea    0xeb9(%rip),%rdi        # 4036d8 <free+0x5cd>
  40281f:	b8 00 00 00 00       	mov    $0x0,%eax
  402824:	e8 df f4 ff ff       	callq  401d08 <printf>
  402829:	48 98                	cltq   
  40282b:	e9 2b 01 00 00       	jmpq   40295b <strerror+0x374>
	case ENFILE   : {return  printf("File table overflow \n");break;}
  402830:	48 8d 3d b4 0e 00 00 	lea    0xeb4(%rip),%rdi        # 4036eb <free+0x5e0>
  402837:	b8 00 00 00 00       	mov    $0x0,%eax
  40283c:	e8 c7 f4 ff ff       	callq  401d08 <printf>
  402841:	48 98                	cltq   
  402843:	e9 13 01 00 00       	jmpq   40295b <strerror+0x374>
	case EMFILE   : {return  printf("Too many open files \n");break;}
  402848:	48 8d 3d b2 0e 00 00 	lea    0xeb2(%rip),%rdi        # 403701 <free+0x5f6>
  40284f:	b8 00 00 00 00       	mov    $0x0,%eax
  402854:	e8 af f4 ff ff       	callq  401d08 <printf>
  402859:	48 98                	cltq   
  40285b:	e9 fb 00 00 00       	jmpq   40295b <strerror+0x374>
	case ENOTTY   : {return  printf("Not a typewriter \n");break;}
  402860:	48 8d 3d b0 0e 00 00 	lea    0xeb0(%rip),%rdi        # 403717 <free+0x60c>
  402867:	b8 00 00 00 00       	mov    $0x0,%eax
  40286c:	e8 97 f4 ff ff       	callq  401d08 <printf>
  402871:	48 98                	cltq   
  402873:	e9 e3 00 00 00       	jmpq   40295b <strerror+0x374>
	case ETXTBSY  : {return  printf("Text file busy \n");break;}
  402878:	48 8d 3d ab 0e 00 00 	lea    0xeab(%rip),%rdi        # 40372a <free+0x61f>
  40287f:	b8 00 00 00 00       	mov    $0x0,%eax
  402884:	e8 7f f4 ff ff       	callq  401d08 <printf>
  402889:	48 98                	cltq   
  40288b:	e9 cb 00 00 00       	jmpq   40295b <strerror+0x374>
	case EFBIG    : {return  printf("File too large \n");break;}
  402890:	48 8d 3d a4 0e 00 00 	lea    0xea4(%rip),%rdi        # 40373b <free+0x630>
  402897:	b8 00 00 00 00       	mov    $0x0,%eax
  40289c:	e8 67 f4 ff ff       	callq  401d08 <printf>
  4028a1:	48 98                	cltq   
  4028a3:	e9 b3 00 00 00       	jmpq   40295b <strerror+0x374>
	case ENOSPC   : {return  printf("No space left on device \n");break;}
  4028a8:	48 8d 3d 9d 0e 00 00 	lea    0xe9d(%rip),%rdi        # 40374c <free+0x641>
  4028af:	b8 00 00 00 00       	mov    $0x0,%eax
  4028b4:	e8 4f f4 ff ff       	callq  401d08 <printf>
  4028b9:	48 98                	cltq   
  4028bb:	e9 9b 00 00 00       	jmpq   40295b <strerror+0x374>
	case ESPIPE   : {return  printf("Illegal seek \n");break;}
  4028c0:	48 8d 3d 9f 0e 00 00 	lea    0xe9f(%rip),%rdi        # 403766 <free+0x65b>
  4028c7:	b8 00 00 00 00       	mov    $0x0,%eax
  4028cc:	e8 37 f4 ff ff       	callq  401d08 <printf>
  4028d1:	48 98                	cltq   
  4028d3:	e9 83 00 00 00       	jmpq   40295b <strerror+0x374>
	case EROFS    : {return  printf("Read-only file system \n");break;}
  4028d8:	48 8d 3d 96 0e 00 00 	lea    0xe96(%rip),%rdi        # 403775 <free+0x66a>
  4028df:	b8 00 00 00 00       	mov    $0x0,%eax
  4028e4:	e8 1f f4 ff ff       	callq  401d08 <printf>
  4028e9:	48 98                	cltq   
  4028eb:	eb 6e                	jmp    40295b <strerror+0x374>
	case EMLINK   : {return  printf("Too many links \n");break;}
  4028ed:	48 8d 3d 99 0e 00 00 	lea    0xe99(%rip),%rdi        # 40378d <free+0x682>
  4028f4:	b8 00 00 00 00       	mov    $0x0,%eax
  4028f9:	e8 0a f4 ff ff       	callq  401d08 <printf>
  4028fe:	48 98                	cltq   
  402900:	eb 59                	jmp    40295b <strerror+0x374>
	case EPIPE    : {return  printf("Broken pipe \n");break;}
  402902:	48 8d 3d 95 0e 00 00 	lea    0xe95(%rip),%rdi        # 40379e <free+0x693>
  402909:	b8 00 00 00 00       	mov    $0x0,%eax
  40290e:	e8 f5 f3 ff ff       	callq  401d08 <printf>
  402913:	48 98                	cltq   
  402915:	eb 44                	jmp    40295b <strerror+0x374>
	case EDOM     : {return  printf("Math argument out of domain of func \n");break;}
  402917:	48 8d 3d 92 0e 00 00 	lea    0xe92(%rip),%rdi        # 4037b0 <free+0x6a5>
  40291e:	b8 00 00 00 00       	mov    $0x0,%eax
  402923:	e8 e0 f3 ff ff       	callq  401d08 <printf>
  402928:	48 98                	cltq   
  40292a:	eb 2f                	jmp    40295b <strerror+0x374>
	case ERANGE   : {return  printf("Math result not representable \n");break;}
  40292c:	48 8d 3d a5 0e 00 00 	lea    0xea5(%rip),%rdi        # 4037d8 <free+0x6cd>
  402933:	b8 00 00 00 00       	mov    $0x0,%eax
  402938:	e8 cb f3 ff ff       	callq  401d08 <printf>
  40293d:	48 98                	cltq   
  40293f:	eb 1a                	jmp    40295b <strerror+0x374>
	case ENAMETOOLONG:	{return printf(" The path is too long to search \n");break;}
  402941:	48 8d 3d b0 0e 00 00 	lea    0xeb0(%rip),%rdi        # 4037f8 <free+0x6ed>
  402948:	b8 00 00 00 00       	mov    $0x0,%eax
  40294d:	e8 b6 f3 ff ff       	callq  401d08 <printf>
  402952:	48 98                	cltq   
  402954:	eb 05                	jmp    40295b <strerror+0x374>
	
	//return printf("error occured.\n");
	}
return 0;
  402956:	b8 00 00 00 00       	mov    $0x0,%eax
  40295b:	c9                   	leaveq 
  40295c:	c3                   	retq   

000000000040295d <syscall_1>:
			:"=r"(ret):"m"(n));

	return ret;
}

static __inline int64_t syscall_1(uint64_t n, uint64_t a1) {
  40295d:	55                   	push   %rbp
  40295e:	48 89 e5             	mov    %rsp,%rbp
  402961:	48 83 ec 20          	sub    $0x20,%rsp
  402965:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  402969:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)

	int64_t ret;

	__asm__("movq $78,%r15");
  40296d:	49 c7 c7 4e 00 00 00 	mov    $0x4e,%r15
	//__asm__("movq %0,%%rax;"
	//		::"m"(n));

	//while(1);

	if(n==60){
  402974:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  402978:	48 83 f8 3c          	cmp    $0x3c,%rax
  40297c:	75 0c                	jne    40298a <syscall_1+0x2d>
		__asm__("movq %0,%%rax;"
  40297e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  402982:	48 8b 7d e0          	mov    -0x20(%rbp),%rdi
  402986:	cd 80                	int    $0x80
  402988:	eb 11                	jmp    40299b <syscall_1+0x3e>

		//while(1);
	}
	else{

		__asm__("movq %1,%%rax;"
  40298a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  40298e:	48 8b 7d e0          	mov    -0x20(%rbp),%rdi
  402992:	cd 80                	int    $0x80
  402994:	48 89 c0             	mov    %rax,%rax
  402997:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
				"movq %2,%%rdi;"
				"int $0x80;"
				"movq %%rax,%0;"
				:"=r"(ret):"m"(n),"m"(a1));
	}
	return ret;
  40299b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  40299f:	c9                   	leaveq 
  4029a0:	c3                   	retq   

00000000004029a1 <close>:
#include<sys/syscall.h>
#include<syscall.h>
#include <stdlib.h>

int close(int fd)
{
  4029a1:	55                   	push   %rbp
  4029a2:	48 89 e5             	mov    %rsp,%rbp
  4029a5:	48 83 ec 18          	sub    $0x18,%rsp
  4029a9:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int retvalue;
	retvalue = syscall_1(SYS_close, fd);
  4029ac:	8b 45 ec             	mov    -0x14(%rbp),%eax
  4029af:	48 98                	cltq   
  4029b1:	48 89 c6             	mov    %rax,%rsi
  4029b4:	bf 03 00 00 00       	mov    $0x3,%edi
  4029b9:	e8 9f ff ff ff       	callq  40295d <syscall_1>
  4029be:	89 45 fc             	mov    %eax,-0x4(%rbp)

	if(retvalue >=0){
  4029c1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  4029c5:	78 05                	js     4029cc <close+0x2b>
		return retvalue;
  4029c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  4029ca:	eb 05                	jmp    4029d1 <close+0x30>
	}
	return -1;
  4029cc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax

}
  4029d1:	c9                   	leaveq 
  4029d2:	c3                   	retq   

00000000004029d3 <syscall_0>:
#define _SYSCALL_H

#include <sys/defs.h>
#include <sys/syscall.h>

static __inline uint64_t syscall_0(uint64_t n) {
  4029d3:	55                   	push   %rbp
  4029d4:	48 89 e5             	mov    %rsp,%rbp
  4029d7:	48 83 ec 18          	sub    $0x18,%rsp
  4029db:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)

	uint64_t ret;
	__asm__("movq %1,%%rax;"
  4029df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  4029e3:	cd 80                	int    $0x80
  4029e5:	48 89 c0             	mov    %rax,%rax
  4029e8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
			"int $0x80;"
			"movq %%rax,%0;"
			:"=r"(ret):"m"(n));

	return ret;
  4029ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  4029f0:	c9                   	leaveq 
  4029f1:	c3                   	retq   

00000000004029f2 <fork>:
#include <stdio.h>
#include <errno.h>


pid_t fork()
{
  4029f2:	55                   	push   %rbp
  4029f3:	48 89 e5             	mov    %rsp,%rbp
  4029f6:	48 83 ec 10          	sub    $0x10,%rsp
	int retvalue;

	retvalue = syscall_0(SYS_fork);
  4029fa:	bf 39 00 00 00       	mov    $0x39,%edi
  4029ff:	e8 cf ff ff ff       	callq  4029d3 <syscall_0>
  402a04:	89 45 fc             	mov    %eax,-0x4(%rbp)

	if(retvalue >=0){
  402a07:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  402a0b:	78 05                	js     402a12 <fork+0x20>
		return retvalue;
  402a0d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  402a10:	eb 05                	jmp    402a17 <fork+0x25>
	}
	return -1;
  402a12:	b8 ff ff ff ff       	mov    $0xffffffff,%eax

}
  402a17:	c9                   	leaveq 
  402a18:	c3                   	retq   

0000000000402a19 <syscall_2>:
				:"=r"(ret):"m"(n),"m"(a1));
	}
	return ret;
}

static __inline uint64_t syscall_2(uint64_t n, uint64_t a1, uint64_t a2) {
  402a19:	55                   	push   %rbp
  402a1a:	48 89 e5             	mov    %rsp,%rbp
  402a1d:	48 83 ec 28          	sub    $0x28,%rsp
  402a21:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  402a25:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  402a29:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	uint64_t ret;
	__asm__("movq %1,%%rax;"
  402a2d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  402a31:	48 8b 7d e0          	mov    -0x20(%rbp),%rdi
  402a35:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  402a39:	cd 80                	int    $0x80
  402a3b:	48 89 c0             	mov    %rax,%rax
  402a3e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
			"movq %2,%%rdi;"
			"movq %3,%%rsi;"
			"int $0x80;"
			"movq %%rax,%0;"
			:"=r"(ret):"m"(n),"m"(a1),"m"(a2));
	return ret;
  402a42:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  402a46:	c9                   	leaveq 
  402a47:	c3                   	retq   

0000000000402a48 <getcwd>:
#include <stdlib.h>
#include <errno.h>

//int errno=0; //Only define here. declaration seeps through to the files via stdlib.h

char* getcwd(char *buf, size_t size){
  402a48:	55                   	push   %rbp
  402a49:	48 89 e5             	mov    %rsp,%rbp
  402a4c:	48 83 ec 20          	sub    $0x20,%rsp
  402a50:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  402a54:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)

	int retvalue;
	retvalue=syscall_2(SYS_getcwd,(uint64_t)buf,(uint64_t)size);
  402a58:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  402a5c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  402a60:	48 89 c6             	mov    %rax,%rsi
  402a63:	bf 4f 00 00 00       	mov    $0x4f,%edi
  402a68:	e8 ac ff ff ff       	callq  402a19 <syscall_2>
  402a6d:	89 45 fc             	mov    %eax,-0x4(%rbp)

	if(retvalue >=0){
  402a70:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  402a74:	78 06                	js     402a7c <getcwd+0x34>
		return buf;
  402a76:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  402a7a:	eb 05                	jmp    402a81 <getcwd+0x39>
	}
	return NULL;
  402a7c:	b8 00 00 00 00       	mov    $0x0,%eax

}
  402a81:	c9                   	leaveq 
  402a82:	c3                   	retq   

0000000000402a83 <test>:
#include <stdlib.h>
#include <string.h>


	
uint64_t test(uint64_t n, uint64_t a1, uint64_t a2, uint64_t a3){
  402a83:	55                   	push   %rbp
  402a84:	48 89 e5             	mov    %rsp,%rbp
  402a87:	48 83 ec 30          	sub    $0x30,%rsp
  402a8b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  402a8f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  402a93:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  402a97:	48 89 4d d0          	mov    %rcx,-0x30(%rbp)

	//printf("Inside test\n");


	uint64_t ret;
	__asm__("movq %1,%%rax;"
  402a9b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  402a9f:	48 8b 7d e0          	mov    -0x20(%rbp),%rdi
  402aa3:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  402aa7:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  402aab:	cd 80                	int    $0x80
  402aad:	48 89 c0             	mov    %rax,%rax
  402ab0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
			"movq %3,%%rsi;"
			"movq %4, %%rdx;"
			"int $0x80;"
			"movq %%rax,%0;"
			:"=r"(ret):"m"(n),"m"(a1),"m"(a2),"m"(a3));
	return ret;
  402ab4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax


}
  402ab8:	c9                   	leaveq 
  402ab9:	c3                   	retq   

0000000000402aba <readdir>:




struct dirent* readdir(void *dir){
  402aba:	55                   	push   %rbp
  402abb:	48 89 e5             	mov    %rsp,%rbp
  402abe:	48 81 ec 20 04 00 00 	sub    $0x420,%rsp
  402ac5:	48 89 bd e8 fb ff ff 	mov    %rdi,-0x418(%rbp)

	char buff[1024];

	if((uint64_t)dir == -1){
  402acc:	48 8b 85 e8 fb ff ff 	mov    -0x418(%rbp),%rax
  402ad3:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  402ad7:	75 18                	jne    402af1 <readdir+0x37>

		printf("Bad directory stream\n");
  402ad9:	48 8d 3d d0 0d 00 00 	lea    0xdd0(%rip),%rdi        # 4038b0 <free+0x7a5>
  402ae0:	b8 00 00 00 00       	mov    $0x0,%eax
  402ae5:	e8 1e f2 ff ff       	callq  401d08 <printf>
		return NULL;
  402aea:	b8 00 00 00 00       	mov    $0x0,%eax
  402aef:	eb 6a                	jmp    402b5b <readdir+0xa1>
	}


	int ret = test(78,(uint64_t)dir,(uint64_t)buff,(uint64_t)1024);
  402af1:	48 8d 95 f0 fb ff ff 	lea    -0x410(%rbp),%rdx
  402af8:	48 8b 85 e8 fb ff ff 	mov    -0x418(%rbp),%rax
  402aff:	b9 00 04 00 00       	mov    $0x400,%ecx
  402b04:	48 89 c6             	mov    %rax,%rsi
  402b07:	bf 4e 00 00 00       	mov    $0x4e,%edi
  402b0c:	e8 72 ff ff ff       	callq  402a83 <test>
  402b11:	89 45 fc             	mov    %eax,-0x4(%rbp)

	//printf("Ret value %d\n", ret );

	if(ret == -1){
  402b14:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%rbp)
  402b18:	75 18                	jne    402b32 <readdir+0x78>

		//Error
		printf("Error while reading directory\n");
  402b1a:	48 8d 3d a7 0d 00 00 	lea    0xda7(%rip),%rdi        # 4038c8 <free+0x7bd>
  402b21:	b8 00 00 00 00       	mov    $0x0,%eax
  402b26:	e8 dd f1 ff ff       	callq  401d08 <printf>
		return NULL;
  402b2b:	b8 00 00 00 00       	mov    $0x0,%eax
  402b30:	eb 29                	jmp    402b5b <readdir+0xa1>

	}

	else if (ret == 0){
  402b32:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  402b36:	75 07                	jne    402b3f <readdir+0x85>

		//End of directory stream
		return NULL;
  402b38:	b8 00 00 00 00       	mov    $0x0,%eax
  402b3d:	eb 1c                	jmp    402b5b <readdir+0xa1>

	}

	else if(ret !=0){
  402b3f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  402b43:	74 11                	je     402b56 <readdir+0x9c>

		//There is a valid child
		//printf("Ret of readdir is not 0\n");
		struct dirent* x = (struct dirent*)buff;
  402b45:	48 8d 85 f0 fb ff ff 	lea    -0x410(%rbp),%rax
  402b4c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		//printf("Name of entry dir%s\n",x->d_name );
		return x;
  402b50:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  402b54:	eb 05                	jmp    402b5b <readdir+0xa1>
	}


	return NULL;
  402b56:	b8 00 00 00 00       	mov    $0x0,%eax

}
  402b5b:	c9                   	leaveq 
  402b5c:	c3                   	retq   

0000000000402b5d <syscall_3>:

static __inline uint64_t syscall_3(uint64_t n, uint64_t a1, uint64_t a2, uint64_t a3) {
  402b5d:	55                   	push   %rbp
  402b5e:	48 89 e5             	mov    %rsp,%rbp
  402b61:	48 83 ec 30          	sub    $0x30,%rsp
  402b65:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  402b69:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  402b6d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  402b71:	48 89 4d d0          	mov    %rcx,-0x30(%rbp)

	uint64_t ret;
    
	__asm__("movq %1,%%rax;"
  402b75:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  402b79:	48 8b 7d e0          	mov    -0x20(%rbp),%rdi
  402b7d:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  402b81:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  402b85:	cd 80                	int    $0x80
  402b87:	48 89 c0             	mov    %rax,%rax
  402b8a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
			"movq %3, %%rsi;"
			"movq %4, %%rdx;"
			"int $0x80;"
			"movq %%rax,%0;"
			:"=r"(ret):"m"(n),"m"(a1),"m"(a2),"m"(a3));
	return ret;
  402b8e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  402b92:	c9                   	leaveq 
  402b93:	c3                   	retq   

0000000000402b94 <read>:
#include <sys/syscall.h>
#include <stdlib.h>
#include <stdio.h>
#include <errno.h>

ssize_t read(int fd, void *buf, size_t count){
  402b94:	55                   	push   %rbp
  402b95:	48 89 e5             	mov    %rsp,%rbp
  402b98:	48 83 ec 30          	sub    $0x30,%rsp
  402b9c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  402b9f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  402ba3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	int retvalue;
	retvalue =syscall_3(SYS_read,fd,(uint64_t)buf,(uint64_t)count);
  402ba7:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  402bab:	8b 45 ec             	mov    -0x14(%rbp),%eax
  402bae:	48 98                	cltq   
  402bb0:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  402bb4:	48 89 c6             	mov    %rax,%rsi
  402bb7:	bf 00 00 00 00       	mov    $0x0,%edi
  402bbc:	e8 9c ff ff ff       	callq  402b5d <syscall_3>
  402bc1:	89 45 fc             	mov    %eax,-0x4(%rbp)
	
	if(retvalue < 0 ){
  402bc4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  402bc8:	79 1a                	jns    402be4 <read+0x50>
		printf("Error in reading File\n");
  402bca:	48 8d 3d 16 0d 00 00 	lea    0xd16(%rip),%rdi        # 4038e7 <free+0x7dc>
  402bd1:	b8 00 00 00 00       	mov    $0x0,%eax
  402bd6:	e8 2d f1 ff ff       	callq  401d08 <printf>
		return -1;
  402bdb:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
  402be2:	eb 05                	jmp    402be9 <read+0x55>
	}
	
	return retvalue;
  402be4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  402be7:	48 98                	cltq   

}
  402be9:	c9                   	leaveq 
  402bea:	c3                   	retq   

0000000000402beb <syscall_3>:
			"movq %%rax,%0;"
			:"=r"(ret):"m"(n),"m"(a1),"m"(a2));
	return ret;
}

static __inline uint64_t syscall_3(uint64_t n, uint64_t a1, uint64_t a2, uint64_t a3) {
  402beb:	55                   	push   %rbp
  402bec:	48 89 e5             	mov    %rsp,%rbp
  402bef:	48 83 ec 30          	sub    $0x30,%rsp
  402bf3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  402bf7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  402bfb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  402bff:	48 89 4d d0          	mov    %rcx,-0x30(%rbp)

	uint64_t ret;
    
	__asm__("movq %1,%%rax;"
  402c03:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  402c07:	48 8b 7d e0          	mov    -0x20(%rbp),%rdi
  402c0b:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  402c0f:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  402c13:	cd 80                	int    $0x80
  402c15:	48 89 c0             	mov    %rax,%rax
  402c18:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
			"movq %3, %%rsi;"
			"movq %4, %%rdx;"
			"int $0x80;"
			"movq %%rax,%0;"
			:"=r"(ret):"m"(n),"m"(a1),"m"(a2),"m"(a3));
	return ret;
  402c1c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  402c20:	c9                   	leaveq 
  402c21:	c3                   	retq   

0000000000402c22 <execve>:
#include<sys/syscall.h>
#include<syscall.h>
#include<stdlib.h>

int execve(const char *filename, char *const argv[], char *const envp[])
{
  402c22:	55                   	push   %rbp
  402c23:	48 89 e5             	mov    %rsp,%rbp
  402c26:	48 83 ec 28          	sub    $0x28,%rsp
  402c2a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  402c2e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  402c32:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
		int retvalue;
		retvalue = syscall_3(SYS_execve, (uint64_t)filename, (uint64_t)argv, (uint64_t)envp);
  402c36:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  402c3a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  402c3e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  402c42:	48 89 c6             	mov    %rax,%rsi
  402c45:	bf 3b 00 00 00       	mov    $0x3b,%edi
  402c4a:	e8 9c ff ff ff       	callq  402beb <syscall_3>
  402c4f:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(retvalue >=0){
  402c52:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  402c56:	78 05                	js     402c5d <execve+0x3b>
			return retvalue;
  402c58:	8b 45 fc             	mov    -0x4(%rbp),%eax
  402c5b:	eb 05                	jmp    402c62 <execve+0x40>
		}
		return -1;
  402c5d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax

}
  402c62:	c9                   	leaveq 
  402c63:	c3                   	retq   

0000000000402c64 <syscall_1>:
			:"=r"(ret):"m"(n));

	return ret;
}

static __inline int64_t syscall_1(uint64_t n, uint64_t a1) {
  402c64:	55                   	push   %rbp
  402c65:	48 89 e5             	mov    %rsp,%rbp
  402c68:	48 83 ec 20          	sub    $0x20,%rsp
  402c6c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  402c70:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)

	int64_t ret;

	__asm__("movq $78,%r15");
  402c74:	49 c7 c7 4e 00 00 00 	mov    $0x4e,%r15
	//__asm__("movq %0,%%rax;"
	//		::"m"(n));

	//while(1);

	if(n==60){
  402c7b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  402c7f:	48 83 f8 3c          	cmp    $0x3c,%rax
  402c83:	75 0c                	jne    402c91 <syscall_1+0x2d>
		__asm__("movq %0,%%rax;"
  402c85:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  402c89:	48 8b 7d e0          	mov    -0x20(%rbp),%rdi
  402c8d:	cd 80                	int    $0x80
  402c8f:	eb 11                	jmp    402ca2 <syscall_1+0x3e>

		//while(1);
	}
	else{

		__asm__("movq %1,%%rax;"
  402c91:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  402c95:	48 8b 7d e0          	mov    -0x20(%rbp),%rdi
  402c99:	cd 80                	int    $0x80
  402c9b:	48 89 c0             	mov    %rax,%rax
  402c9e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
				"movq %2,%%rdi;"
				"int $0x80;"
				"movq %%rax,%0;"
				:"=r"(ret):"m"(n),"m"(a1));
	}
	return ret;
  402ca2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  402ca6:	c9                   	leaveq 
  402ca7:	c3                   	retq   

0000000000402ca8 <chdir>:
#include <errno.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

int chdir(const char *path){
  402ca8:	55                   	push   %rbp
  402ca9:	48 89 e5             	mov    %rsp,%rbp
  402cac:	48 83 ec 18          	sub    $0x18,%rsp
  402cb0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)

    //char pathToSend[100];
    //strcpy(pathToSend,path);

    //printf("In libc PATH: %s\n", pathToSend );
    retvalue=syscall_1(SYS_chdir,(uint64_t)path);
  402cb4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  402cb8:	48 89 c6             	mov    %rax,%rsi
  402cbb:	bf 50 00 00 00       	mov    $0x50,%edi
  402cc0:	e8 9f ff ff ff       	callq  402c64 <syscall_1>
  402cc5:	89 45 fc             	mov    %eax,-0x4(%rbp)

    if(retvalue >=0){
  402cc8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  402ccc:	78 05                	js     402cd3 <chdir+0x2b>
        return retvalue;
  402cce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  402cd1:	eb 05                	jmp    402cd8 <chdir+0x30>
    }
    //errno = -retvalue;
    return -1;
  402cd3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax

}
  402cd8:	c9                   	leaveq 
  402cd9:	c3                   	retq   

0000000000402cda <syscall_1>:
			:"=r"(ret):"m"(n));

	return ret;
}

static __inline int64_t syscall_1(uint64_t n, uint64_t a1) {
  402cda:	55                   	push   %rbp
  402cdb:	48 89 e5             	mov    %rsp,%rbp
  402cde:	48 83 ec 20          	sub    $0x20,%rsp
  402ce2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  402ce6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)

	int64_t ret;

	__asm__("movq $78,%r15");
  402cea:	49 c7 c7 4e 00 00 00 	mov    $0x4e,%r15
	//__asm__("movq %0,%%rax;"
	//		::"m"(n));

	//while(1);

	if(n==60){
  402cf1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  402cf5:	48 83 f8 3c          	cmp    $0x3c,%rax
  402cf9:	75 0c                	jne    402d07 <syscall_1+0x2d>
		__asm__("movq %0,%%rax;"
  402cfb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  402cff:	48 8b 7d e0          	mov    -0x20(%rbp),%rdi
  402d03:	cd 80                	int    $0x80
  402d05:	eb 11                	jmp    402d18 <syscall_1+0x3e>

		//while(1);
	}
	else{

		__asm__("movq %1,%%rax;"
  402d07:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  402d0b:	48 8b 7d e0          	mov    -0x20(%rbp),%rdi
  402d0f:	cd 80                	int    $0x80
  402d11:	48 89 c0             	mov    %rax,%rax
  402d14:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
				"movq %2,%%rdi;"
				"int $0x80;"
				"movq %%rax,%0;"
				:"=r"(ret):"m"(n),"m"(a1));
	}
	return ret;
  402d18:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  402d1c:	c9                   	leaveq 
  402d1d:	c3                   	retq   

0000000000402d1e <exit>:
#include <sys/defs.h>
#include <syscall.h>
#include <stdlib.h>
#include <sys/syscall.h>

void exit(int status){
  402d1e:	55                   	push   %rbp
  402d1f:	48 89 e5             	mov    %rsp,%rbp
  402d22:	48 83 ec 08          	sub    $0x8,%rsp
  402d26:	89 7d fc             	mov    %edi,-0x4(%rbp)

	syscall_1(SYS_exit,44);
  402d29:	be 2c 00 00 00       	mov    $0x2c,%esi
  402d2e:	bf 3c 00 00 00       	mov    $0x3c,%edi
  402d33:	e8 a2 ff ff ff       	callq  402cda <syscall_1>


}
  402d38:	c9                   	leaveq 
  402d39:	c3                   	retq   

0000000000402d3a <syscall_1>:
			:"=r"(ret):"m"(n));

	return ret;
}

static __inline int64_t syscall_1(uint64_t n, uint64_t a1) {
  402d3a:	55                   	push   %rbp
  402d3b:	48 89 e5             	mov    %rsp,%rbp
  402d3e:	48 83 ec 20          	sub    $0x20,%rsp
  402d42:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  402d46:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)

	int64_t ret;

	__asm__("movq $78,%r15");
  402d4a:	49 c7 c7 4e 00 00 00 	mov    $0x4e,%r15
	//__asm__("movq %0,%%rax;"
	//		::"m"(n));

	//while(1);

	if(n==60){
  402d51:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  402d55:	48 83 f8 3c          	cmp    $0x3c,%rax
  402d59:	75 0c                	jne    402d67 <syscall_1+0x2d>
		__asm__("movq %0,%%rax;"
  402d5b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  402d5f:	48 8b 7d e0          	mov    -0x20(%rbp),%rdi
  402d63:	cd 80                	int    $0x80
  402d65:	eb 11                	jmp    402d78 <syscall_1+0x3e>

		//while(1);
	}
	else{

		__asm__("movq %1,%%rax;"
  402d67:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  402d6b:	48 8b 7d e0          	mov    -0x20(%rbp),%rdi
  402d6f:	cd 80                	int    $0x80
  402d71:	48 89 c0             	mov    %rax,%rax
  402d74:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
				"movq %2,%%rdi;"
				"int $0x80;"
				"movq %%rax,%0;"
				:"=r"(ret):"m"(n),"m"(a1));
	}
	return ret;
  402d78:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  402d7c:	c9                   	leaveq 
  402d7d:	c3                   	retq   

0000000000402d7e <pipe>:
#include<sys/defs.h>
#include<sys/syscall.h>
#include<syscall.h>
#include<stdlib.h>
int pipe(int fd[2])
{
  402d7e:	55                   	push   %rbp
  402d7f:	48 89 e5             	mov    %rsp,%rbp
  402d82:	48 83 ec 18          	sub    $0x18,%rsp
  402d86:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int retvalue;
	retvalue = syscall_1(SYS_pipe, (uint64_t)fd);
  402d8a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  402d8e:	48 89 c6             	mov    %rax,%rsi
  402d91:	bf 16 00 00 00       	mov    $0x16,%edi
  402d96:	e8 9f ff ff ff       	callq  402d3a <syscall_1>
  402d9b:	89 45 fc             	mov    %eax,-0x4(%rbp)

	if(retvalue >=0){
  402d9e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  402da2:	78 05                	js     402da9 <pipe+0x2b>
		return retvalue;
  402da4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  402da7:	eb 05                	jmp    402dae <pipe+0x30>
	}

	return -1;
  402da9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  402dae:	c9                   	leaveq 
  402daf:	c3                   	retq   

0000000000402db0 <syscall_1>:
			:"=r"(ret):"m"(n));

	return ret;
}

static __inline int64_t syscall_1(uint64_t n, uint64_t a1) {
  402db0:	55                   	push   %rbp
  402db1:	48 89 e5             	mov    %rsp,%rbp
  402db4:	48 83 ec 20          	sub    $0x20,%rsp
  402db8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  402dbc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)

	int64_t ret;

	__asm__("movq $78,%r15");
  402dc0:	49 c7 c7 4e 00 00 00 	mov    $0x4e,%r15
	//__asm__("movq %0,%%rax;"
	//		::"m"(n));

	//while(1);

	if(n==60){
  402dc7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  402dcb:	48 83 f8 3c          	cmp    $0x3c,%rax
  402dcf:	75 0c                	jne    402ddd <syscall_1+0x2d>
		__asm__("movq %0,%%rax;"
  402dd1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  402dd5:	48 8b 7d e0          	mov    -0x20(%rbp),%rdi
  402dd9:	cd 80                	int    $0x80
  402ddb:	eb 11                	jmp    402dee <syscall_1+0x3e>

		//while(1);
	}
	else{

		__asm__("movq %1,%%rax;"
  402ddd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  402de1:	48 8b 7d e0          	mov    -0x20(%rbp),%rdi
  402de5:	cd 80                	int    $0x80
  402de7:	48 89 c0             	mov    %rax,%rax
  402dea:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
				"movq %2,%%rdi;"
				"int $0x80;"
				"movq %%rax,%0;"
				:"=r"(ret):"m"(n),"m"(a1));
	}
	return ret;
  402dee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  402df2:	c9                   	leaveq 
  402df3:	c3                   	retq   

0000000000402df4 <make_head>:

enum {NEW_MCB, NO_MCB, REUSE_MCB};
enum {FREE, IN_USE};

void make_head(char *addr, int size) 
{
  402df4:	55                   	push   %rbp
  402df5:	48 89 e5             	mov    %rsp,%rbp
  402df8:	48 83 ec 1c          	sub    $0x1c,%rsp
  402dfc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  402e00:	89 75 e4             	mov    %esi,-0x1c(%rbp)
    MCB_P head         = (MCB_P)addr;
  402e03:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  402e07:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    head->is_available = FREE;
  402e0b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  402e0f:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    head->size         = size;
  402e15:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  402e19:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  402e1c:	89 50 04             	mov    %edx,0x4(%rax)
}
  402e1f:	c9                   	leaveq 
  402e20:	c3                   	retq   

0000000000402e21 <alloc_new>:

void *alloc_new(int aligned_size)
{
  402e21:	55                   	push   %rbp
  402e22:	48 89 e5             	mov    %rsp,%rbp
  402e25:	48 83 ec 30          	sub    $0x30,%rsp
  402e29:	89 7d dc             	mov    %edi,-0x24(%rbp)
    char *add;
    uint64_t no_of_pages = 0, sz;    
  402e2c:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  402e33:	00 
    MCB_P p_mcb;
    
    sz          = sizeof(MCB_t);
  402e34:	48 c7 45 f0 08 00 00 	movq   $0x8,-0x10(%rbp)
  402e3b:	00 
    no_of_pages = (aligned_size + sz) /(PAGESIZE + 1) + 1;
  402e3c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  402e3f:	48 63 d0             	movslq %eax,%rdx
  402e42:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  402e46:	48 01 d0             	add    %rdx,%rax
  402e49:	48 ba f1 ff 00 f0 ff 	movabs $0xfff000fff000fff1,%rdx
  402e50:	00 f0 ff 
  402e53:	48 f7 e2             	mul    %rdx
  402e56:	48 89 d0             	mov    %rdx,%rax
  402e59:	48 c1 e8 0c          	shr    $0xc,%rax
  402e5d:	48 ff c0             	inc    %rax
  402e60:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    add = (char*)syscall_1(SYS_brk, (uint64_t)no_of_pages*4096);    
  402e64:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  402e68:	48 c1 e0 0c          	shl    $0xc,%rax
  402e6c:	48 89 c6             	mov    %rax,%rsi
  402e6f:	bf 0c 00 00 00       	mov    $0xc,%edi
  402e74:	e8 37 ff ff ff       	callq  402db0 <syscall_1>
  402e79:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    printf("add=%p",add);
  402e7d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  402e81:	48 89 c6             	mov    %rax,%rsi
  402e84:	48 8d 3d 73 0a 00 00 	lea    0xa73(%rip),%rdi        # 4038fe <free+0x7f3>
  402e8b:	b8 00 00 00 00       	mov    $0x0,%eax
  402e90:	e8 73 ee ff ff       	callq  401d08 <printf>
    if (heap_end == 0) {
  402e95:	48 8b 05 f4 13 20 00 	mov    0x2013f4(%rip),%rax        # 604290 <heap_end>
  402e9c:	48 85 c0             	test   %rax,%rax
  402e9f:	75 2a                	jne    402ecb <alloc_new+0xaa>
        mem_start_p   = add;
  402ea1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  402ea5:	48 89 05 dc 13 20 00 	mov    %rax,0x2013dc(%rip)        # 604288 <mem_start_p>
        mcb_count     = 0;
  402eac:	c7 05 ea 13 20 00 00 	movl   $0x0,0x2013ea(%rip)        # 6042a0 <mcb_count>
  402eb3:	00 00 00 
        allocated_mem = 0;
  402eb6:	c7 05 dc 13 20 00 00 	movl   $0x0,0x2013dc(%rip)        # 60429c <allocated_mem>
  402ebd:	00 00 00 
        heap_end = add; 
  402ec0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  402ec4:	48 89 05 c5 13 20 00 	mov    %rax,0x2013c5(%rip)        # 604290 <heap_end>
    }
    
    heap_end = (char*)((uint64_t)add + (uint64_t)(PAGESIZE * no_of_pages));
  402ecb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  402ecf:	48 c1 e0 0c          	shl    $0xc,%rax
  402ed3:	48 89 c2             	mov    %rax,%rdx
  402ed6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  402eda:	48 01 d0             	add    %rdx,%rax
  402edd:	48 89 05 ac 13 20 00 	mov    %rax,0x2013ac(%rip)        # 604290 <heap_end>
    max_mem += PAGESIZE * no_of_pages; 
  402ee4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  402ee8:	c1 e0 0c             	shl    $0xc,%eax
  402eeb:	89 c2                	mov    %eax,%edx
  402eed:	8b 05 a5 13 20 00    	mov    0x2013a5(%rip),%eax        # 604298 <max_mem>
  402ef3:	01 d0                	add    %edx,%eax
  402ef5:	89 05 9d 13 20 00    	mov    %eax,0x20139d(%rip)        # 604298 <max_mem>
    
    p_mcb               = (MCB_P)add; 
  402efb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  402eff:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    p_mcb->is_available = IN_USE;
  402f03:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  402f07:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
    p_mcb->size         = aligned_size + sz; 
  402f0d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  402f11:	89 c2                	mov    %eax,%edx
  402f13:	8b 45 dc             	mov    -0x24(%rbp),%eax
  402f16:	01 d0                	add    %edx,%eax
  402f18:	89 c2                	mov    %eax,%edx
  402f1a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  402f1e:	89 50 04             	mov    %edx,0x4(%rax)
    mcb_count++;    
  402f21:	8b 05 79 13 20 00    	mov    0x201379(%rip),%eax        # 6042a0 <mcb_count>
  402f27:	ff c0                	inc    %eax
  402f29:	89 05 71 13 20 00    	mov    %eax,0x201371(%rip)        # 6042a0 <mcb_count>

    if (PAGESIZE * no_of_pages > aligned_size + sz) {
  402f2f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  402f33:	48 c1 e0 0c          	shl    $0xc,%rax
  402f37:	48 89 c1             	mov    %rax,%rcx
  402f3a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  402f3d:	48 63 d0             	movslq %eax,%rdx
  402f40:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  402f44:	48 01 d0             	add    %rdx,%rax
  402f47:	48 39 c1             	cmp    %rax,%rcx
  402f4a:	76 34                	jbe    402f80 <alloc_new+0x15f>
        make_head(((char *)p_mcb + aligned_size + sz), (PAGESIZE * no_of_pages - aligned_size - sz));
  402f4c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  402f50:	c1 e0 0c             	shl    $0xc,%eax
  402f53:	89 c2                	mov    %eax,%edx
  402f55:	8b 45 dc             	mov    -0x24(%rbp),%eax
  402f58:	29 c2                	sub    %eax,%edx
  402f5a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  402f5e:	29 c2                	sub    %eax,%edx
  402f60:	89 d0                	mov    %edx,%eax
  402f62:	8b 55 dc             	mov    -0x24(%rbp),%edx
  402f65:	48 63 ca             	movslq %edx,%rcx
  402f68:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  402f6c:	48 01 d1             	add    %rdx,%rcx
  402f6f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  402f73:	48 01 ca             	add    %rcx,%rdx
  402f76:	89 c6                	mov    %eax,%esi
  402f78:	48 89 d7             	mov    %rdx,%rdi
  402f7b:	e8 74 fe ff ff       	callq  402df4 <make_head>
    }

    allocated_mem += aligned_size; 
  402f80:	8b 15 16 13 20 00    	mov    0x201316(%rip),%edx        # 60429c <allocated_mem>
  402f86:	8b 45 dc             	mov    -0x24(%rbp),%eax
  402f89:	01 d0                	add    %edx,%eax
  402f8b:	89 05 0b 13 20 00    	mov    %eax,0x20130b(%rip)        # 60429c <allocated_mem>
    
    return ((void *) p_mcb + sz);
  402f91:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  402f95:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  402f99:	48 01 d0             	add    %rdx,%rax
}
  402f9c:	c9                   	leaveq 
  402f9d:	c3                   	retq   

0000000000402f9e <malloc>:

void* malloc(size_t elem_size)
{
  402f9e:	55                   	push   %rbp
  402f9f:	48 89 e5             	mov    %rsp,%rbp
  402fa2:	48 83 ec 30          	sub    $0x30,%rsp
  402fa6:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
    MCB_P p_mcb;
    int flag, sz, temp = 0, aligned_size;
  402faa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)

    // Align elem_size to header size
    aligned_size = ((((elem_size - 1) >> 3) + 1) << 3);
  402fb1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  402fb5:	48 ff c8             	dec    %rax
  402fb8:	48 c1 e8 03          	shr    $0x3,%rax
  402fbc:	48 ff c0             	inc    %rax
  402fbf:	48 c1 e0 03          	shl    $0x3,%rax
  402fc3:	89 45 ec             	mov    %eax,-0x14(%rbp)
    heap_end=heap_end;
  402fc6:	48 8b 05 c3 12 20 00 	mov    0x2012c3(%rip),%rax        # 604290 <heap_end>
  402fcd:	48 89 05 bc 12 20 00 	mov    %rax,0x2012bc(%rip)        # 604290 <heap_end>
    if (heap_end == 0) {
  402fd4:	48 8b 05 b5 12 20 00 	mov    0x2012b5(%rip),%rax        # 604290 <heap_end>
  402fdb:	48 85 c0             	test   %rax,%rax
  402fde:	75 0f                	jne    402fef <malloc+0x51>
        /*no heap has been assigned yet*/
        return alloc_new(aligned_size);
  402fe0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  402fe3:	89 c7                	mov    %eax,%edi
  402fe5:	e8 37 fe ff ff       	callq  402e21 <alloc_new>
  402fea:	e9 1a 01 00 00       	jmpq   403109 <malloc+0x16b>
    } else {

        flag  = NO_MCB;
  402fef:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%rbp)
        p_mcb = (MCB_P)mem_start_p;
  402ff6:	48 8b 05 8b 12 20 00 	mov    0x20128b(%rip),%rax        # 604288 <mem_start_p>
  402ffd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
        sz    = sizeof(MCB_t);
  403001:	c7 45 e8 08 00 00 00 	movl   $0x8,-0x18(%rbp)

        //printf("\nheap_end : %p\treqd size: %p",heap_end, ((char *)p_mcb + aligned_size + sz));
        while (heap_end >= ((char *)p_mcb + aligned_size + sz)) {
  403008:	eb 33                	jmp    40303d <malloc+0x9f>
            if (p_mcb->is_available == FREE) {
  40300a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  40300e:	8b 00                	mov    (%rax),%eax
  403010:	85 c0                	test   %eax,%eax
  403012:	75 1c                	jne    403030 <malloc+0x92>
                if (p_mcb->size >= (aligned_size + sz)) {
  403014:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  403018:	8b 40 04             	mov    0x4(%rax),%eax
  40301b:	8b 55 e8             	mov    -0x18(%rbp),%edx
  40301e:	8b 4d ec             	mov    -0x14(%rbp),%ecx
  403021:	01 ca                	add    %ecx,%edx
  403023:	39 d0                	cmp    %edx,%eax
  403025:	7c 09                	jl     403030 <malloc+0x92>
                    flag = REUSE_MCB;
  403027:	c7 45 f4 02 00 00 00 	movl   $0x2,-0xc(%rbp)
                    break;
  40302e:	eb 2e                	jmp    40305e <malloc+0xc0>
                }
            }
            p_mcb = (MCB_P) ((char *)p_mcb + p_mcb->size);
  403030:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  403034:	8b 40 04             	mov    0x4(%rax),%eax
  403037:	48 98                	cltq   
  403039:	48 01 45 f8          	add    %rax,-0x8(%rbp)
        flag  = NO_MCB;
        p_mcb = (MCB_P)mem_start_p;
        sz    = sizeof(MCB_t);

        //printf("\nheap_end : %p\treqd size: %p",heap_end, ((char *)p_mcb + aligned_size + sz));
        while (heap_end >= ((char *)p_mcb + aligned_size + sz)) {
  40303d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  403040:	48 63 d0             	movslq %eax,%rdx
  403043:	8b 45 e8             	mov    -0x18(%rbp),%eax
  403046:	48 98                	cltq   
  403048:	48 01 c2             	add    %rax,%rdx
  40304b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  40304f:	48 01 c2             	add    %rax,%rdx
  403052:	48 8b 05 37 12 20 00 	mov    0x201237(%rip),%rax        # 604290 <heap_end>
  403059:	48 39 c2             	cmp    %rax,%rdx
  40305c:	76 ac                	jbe    40300a <malloc+0x6c>
                }
            }
            p_mcb = (MCB_P) ((char *)p_mcb + p_mcb->size);
        }

        if (flag != NO_MCB) {
  40305e:	83 7d f4 01          	cmpl   $0x1,-0xc(%rbp)
  403062:	0f 84 97 00 00 00    	je     4030ff <malloc+0x161>
            p_mcb->is_available = IN_USE;
  403068:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  40306c:	c7 00 01 00 00 00    	movl   $0x1,(%rax)

            if (flag == REUSE_MCB) {
  403072:	83 7d f4 02          	cmpl   $0x2,-0xc(%rbp)
  403076:	75 67                	jne    4030df <malloc+0x141>
                if (p_mcb->size > aligned_size + sz) {
  403078:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  40307c:	8b 40 04             	mov    0x4(%rax),%eax
  40307f:	8b 55 e8             	mov    -0x18(%rbp),%edx
  403082:	8b 4d ec             	mov    -0x14(%rbp),%ecx
  403085:	01 ca                	add    %ecx,%edx
  403087:	39 d0                	cmp    %edx,%eax
  403089:	7e 46                	jle    4030d1 <malloc+0x133>
                    temp        = p_mcb->size; 
  40308b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  40308f:	8b 40 04             	mov    0x4(%rax),%eax
  403092:	89 45 f0             	mov    %eax,-0x10(%rbp)
                    p_mcb->size = aligned_size + sz;
  403095:	8b 45 e8             	mov    -0x18(%rbp),%eax
  403098:	8b 55 ec             	mov    -0x14(%rbp),%edx
  40309b:	01 c2                	add    %eax,%edx
  40309d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  4030a1:	89 50 04             	mov    %edx,0x4(%rax)

                    make_head(((char *)p_mcb + aligned_size + sz),(temp - aligned_size - sz));
  4030a4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  4030a7:	8b 55 f0             	mov    -0x10(%rbp),%edx
  4030aa:	29 c2                	sub    %eax,%edx
  4030ac:	89 d0                	mov    %edx,%eax
  4030ae:	2b 45 e8             	sub    -0x18(%rbp),%eax
  4030b1:	8b 55 ec             	mov    -0x14(%rbp),%edx
  4030b4:	48 63 ca             	movslq %edx,%rcx
  4030b7:	8b 55 e8             	mov    -0x18(%rbp),%edx
  4030ba:	48 63 d2             	movslq %edx,%rdx
  4030bd:	48 01 d1             	add    %rdx,%rcx
  4030c0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  4030c4:	48 01 ca             	add    %rcx,%rdx
  4030c7:	89 c6                	mov    %eax,%esi
  4030c9:	48 89 d7             	mov    %rdx,%rdi
  4030cc:	e8 23 fd ff ff       	callq  402df4 <make_head>
                }        
                mcb_count++;
  4030d1:	8b 05 c9 11 20 00    	mov    0x2011c9(%rip),%eax        # 6042a0 <mcb_count>
  4030d7:	ff c0                	inc    %eax
  4030d9:	89 05 c1 11 20 00    	mov    %eax,0x2011c1(%rip)        # 6042a0 <mcb_count>
            }
            allocated_mem += aligned_size;
  4030df:	8b 15 b7 11 20 00    	mov    0x2011b7(%rip),%edx        # 60429c <allocated_mem>
  4030e5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  4030e8:	01 d0                	add    %edx,%eax
  4030ea:	89 05 ac 11 20 00    	mov    %eax,0x2011ac(%rip)        # 60429c <allocated_mem>
            return ((char *) p_mcb + sz);
  4030f0:	8b 45 e8             	mov    -0x18(%rbp),%eax
  4030f3:	48 63 d0             	movslq %eax,%rdx
  4030f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  4030fa:	48 01 d0             	add    %rdx,%rax
  4030fd:	eb 0a                	jmp    403109 <malloc+0x16b>
        }

        /*when no hole is found to match the request*/
        return alloc_new(aligned_size); 
  4030ff:	8b 45 ec             	mov    -0x14(%rbp),%eax
  403102:	89 c7                	mov    %eax,%edi
  403104:	e8 18 fd ff ff       	callq  402e21 <alloc_new>
    }

}
  403109:	c9                   	leaveq 
  40310a:	c3                   	retq   

000000000040310b <free>:

void free(void *p)
{
  40310b:	55                   	push   %rbp
  40310c:	48 89 e5             	mov    %rsp,%rbp
  40310f:	48 83 ec 18          	sub    $0x18,%rsp
  403113:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    MCB_P ptr = (MCB_P)p;
  403117:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  40311b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    ptr--;
  40311f:	48 83 6d f8 08       	subq   $0x8,-0x8(%rbp)

    mcb_count--;
  403124:	8b 05 76 11 20 00    	mov    0x201176(%rip),%eax        # 6042a0 <mcb_count>
  40312a:	ff c8                	dec    %eax
  40312c:	89 05 6e 11 20 00    	mov    %eax,0x20116e(%rip)        # 6042a0 <mcb_count>
    ptr->is_available = FREE;
  403132:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  403136:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    allocated_mem    -= (ptr->size - sizeof(MCB_t));
  40313c:	8b 05 5a 11 20 00    	mov    0x20115a(%rip),%eax        # 60429c <allocated_mem>
  403142:	89 c2                	mov    %eax,%edx
  403144:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  403148:	8b 40 04             	mov    0x4(%rax),%eax
  40314b:	29 c2                	sub    %eax,%edx
  40314d:	89 d0                	mov    %edx,%eax
  40314f:	83 c0 08             	add    $0x8,%eax
  403152:	89 05 44 11 20 00    	mov    %eax,0x201144(%rip)        # 60429c <allocated_mem>

}
  403158:	c9                   	leaveq 
  403159:	c3                   	retq   

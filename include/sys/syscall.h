#ifndef __SYS_SYSCALL_H
#define __SYS_SYSCALL_H

#define SYS_exit       60
#define SYS_brk        12
#define SYS_fork       57
#define SYS_getpid     39
#define SYS_getppid   110
#define SYS_execve     59
#define SYS_wait4      61
#define SYS_nanosleep  35
#define SYS_alarm      37
#define SYS_getcwd     79
#define SYS_chdir      80
#define SYS_open        2
#define SYS_read        0
#define SYS_write       1
#define SYS_lseek       8
#define SYS_close       3
#define SYS_pipe       22
#define SYS_dup        32
#define SYS_dup2       33
#define SYS_getdents   78


#include<sys/defs.h>

void sys_write(uint64_t fd,uint64_t buff,uint64_t len);
void sys_exit(uint64_t error_code);
int sys_fork();
int sys_getpid();
uint64_t sys_read_dir(void* dir,char* userBuff);
uint64_t sys_open_dir(const char* dir);
int sys_close_directory(void* dir);
uint64_t sys_open_file(const char* name);
uint64_t sys_open_file(const char* name);
uint64_t sys_read_file(int fd, char* buf , int numBytes);
uint64_t sys_close_file(int fd);
uint64_t sys_lseek_file(int fd,uint64_t offset, int whence);
uint64_t sys_read_terminal(char* buf);
uint64_t sys_getcwd(char*buff,uint64_t);
int sys_chdir(char* path);


#endif

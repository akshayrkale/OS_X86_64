int pipe(int *pipefd);
int pipe_write(int file_table_index,char *buf,int numBytesToWrite);
int pipe_read(int file_table_index,char* buf, int numBytesToRead);
int pipe_close(int fd);
int dup2(int oldfd, int newfd);
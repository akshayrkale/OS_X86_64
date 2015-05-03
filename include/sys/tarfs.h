#ifndef _TARFS_H
#define _TARFS_H
extern char _binary_tarfs_start;
extern char _binary_tarfs_end;

struct posix_header_ustar {
	char name[100];
	char mode[8];
	char uid[8];
	char gid[8];
	char size[12];
	char mtime[12];
	char checksum[8];
	char typeflag[1];
	char linkname[100];
	char magic[6];
	char version[2];
	char uname[32];
	char gname[32];
	char devmajor[8];
	char devminor[8];
	char prefix[155];
	char pad[12];
};
//TARFS file system
typedef struct {
    char name[100];
    int size;
    int typeflag;
    uint64_t addr_hdr;
    int par_ind;
} tarfs_entry;

extern tarfs_entry tarfs_fs[100];
enum { KSEEK_SET = 0, KSEEK_CUR = 1, KSEEK_END = 2 };
enum { KO_RDONLY = 0, KO_WRONLY = 1, KO_RDWR = 2, KO_CREAT = 0x40, KO_DIRECTORY = 0x10000 };

#define K_NAME_MAX 255
struct K_dirent
{
	long d_ino;
	uint64_t d_off;
	unsigned short d_reclen;
	char d_name [K_NAME_MAX+1];
};


void tarfs_init();
uint64_t kopendir(const char *name);
uint64_t kreaddir(void *dir,char* userBuff); //directory read
int kclosedir(void* dir);
int kopen(const char*); //open a file
int kread(int fd,char* buf, int numBytesRead);
int kwrite(int fd,char* buf, int numBytesRead);
int kclose(int fd);
uint64_t klseek(int,uint64_t,int);
void kgetcwd(char*buff);
int kchdir(char* path);
void convert_to_absolute_path(const char* path,char* absPath);

	/* Device specific functions */

int read_file(char *buf,int file_table_index, int numBytesToRead);
int write_file(char *buf,int numBytesToWrite);
int terminal_read(char *buf,int file_table_index, int numBytesToRead);
int terminal_write(char *buf,int numBytesToWrite);

#define DIRECTORY 5
#define FILE_TYPE 0

#endif

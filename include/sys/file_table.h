

#define TYPE_FILE 0
#define TYPE_DIRECTORY 1
#define TYPE_PIPE 2


typedef struct{

	int readers;
	int writers;
	uint64_t address; //Only valid for pipe buffers and directories
	int duplicateFD;
	uint64_t read_cursor;
	uint64_t write_cursor;

}Pipe;


typedef struct{

	/*
		This is the structure of a single entry in the FILE Table
		which is a table of ALL OPEN files in the system
	*/
	int inode_num; //the entry in the tarfs table
	uint64_t cursor; //current cursor position
	int ref_count; //number of processes which have this file open
	int size;
	int present; //indicates if this entry is valid or not 0->free 1->present
	int (*read)(); //pointer to the device specific read call
	int (*write)(); //pointer to the device specific write call
	int (*close)(); //pointer to the device specific close call
	//uint64_t address; //Only valid for pipe buffers and directories
	uint64_t type;
	Pipe pipe; //

} fileTable_entry;

extern fileTable_entry file_table[10];

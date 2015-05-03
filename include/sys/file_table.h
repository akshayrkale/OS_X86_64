
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
	int (*read)(); //pointer to the read call
	int (*write)(); //pointer to the write call
	uint64_t address; //Only valid for pipe buffers

} fileTable_entry;

extern fileTable_entry file_table[10];

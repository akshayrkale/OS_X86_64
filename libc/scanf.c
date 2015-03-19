#include <syscall.h>
#include <sys/defs.h>
#include <stdlib.h>
#include <sys/syscall.h>
#include <stdarg.h>

int scan_ret=0;
int scan_num(int* num)
{
		char number[32];
		int i=0,neg=1;;
		*num=0;
		if(read(0, number, 1) < 0)
			return -1;
		if(number[0] == '-')
		{
			////printf("read %c",number[i]);
			number[0]='0';
			neg=-1;
		
		//printf("out");
		}
		
		do
		{			
			////printf("numbers");
			if((number[i] == '\n') | (number[i] == ' ') | (number[i]>'9') | (number[i]<'0'))
			{
				////printf("scan_ret %d",*num*neg);
				*num=*num*neg;
				break;
			}
			else
			{
				//printf("read %d",number[i]);
				*num=number[i++]-48 + *num*10;
				scan_ret=1;
			}
			if(read(0, &number[i], 1) < 0) 
				return -1;
		}while(1);
	
return 0;
}

int scan_hex(int* num)
{
		char number[32];
		int i=0,neg=1,j=0;
		*num=0;
		do{
			if(read(0, &number[i++], 1) < 0)
				return -1;
		}while((number[i-1] != '\n') & (number[i-1] != ' '));
		
		//printf("readtot%d",i);
		if(number[j]=='-')
		{
			neg=-1;
			j++;
		}
		if((number[j]=='0') & (number[j+1]=='x'))
		{
			//printf("corr start");
				j=j+2;
		}
		
		do
		{			
			//printf("numbers %d", j);
			if((number[j] == '\n') | (number[j] == ' ') | !(((number[j] >= '0') & (number[j] <= '9')) | ((number[j] >= 'a') & (number[j] <= 'f')) | ((number[j] >= 'A') & (number[j] <= 'F'))))
			{
				
				*num=*num*neg;
				break;
			}
			else
			{
				if((number[j] >= '0') & (number[j] <= '9'))
					*num=number[j++]-48 + *num*16;
				if((number[j] >= 'a') & (number[j] <= 'f'))
					*num=number[j++]-'a' + 10 + *num*16;
				if((number[j] >= 'A') & (number[j] <= 'F'))
					*num=number[j++]-'A' + 10 + *num*16;	
				scan_ret=1;
			}
			
		}while(1);
	
	return 0;
}

int scanf(const char *format, ...) {
	va_list val;
	int printed = 0;
	scan_ret=0;
	va_start(val, format);
	
	while(*format) 
	{
		if(*format == '%')
		{
			switch(*(++format))
			{
			case 'd':
			printed=printed;
			int* num = va_arg(val, int*);
			if(scan_num(num)<0)
				return -1;
			format++;
			continue;
			
			case 'c':
			printed=printed;
			char* chr = va_arg(val, char*);
			if(read(1, chr, 1) < 0)
				return -1;
			scan_ret=1;
			format++;
			continue;
			
			case 's':
			printed=printed;
			char* str = va_arg(val, char*);
			do
			{
				if(read(1, str, 1)< 0)
					return -1;
				if(*(str) == '\n' || *(str) == ' ')
				{
					*str='\0';
					break;
				}
				else
				{
					str++;
					scan_ret=1;
				}
			}while(1);
			format++;
			continue;
			
			case 'x':
			printed=printed;
			int* hex = va_arg(val, int*);
			if(scan_hex(hex)<0)
				return -1;
			format++;
			continue;
			
			}
		}
		
	}
	return scan_ret;
}

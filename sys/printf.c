//#include <sys/defs.h>
#include <stdlib.h>
#include<sys/sbunix.h>
#include <stdarg.h>

#define tabwidth 4
#define colour  0x1F
// update errno.
char screen[1024];
int screen_ctr;
static int x=10,y;

int write_text() {
	int  i;
	
    volatile char *video = (volatile char*)0xB8000;
    for(i=0;i<screen_ctr;i++)
    {
		if(screen[i]=='\n')
		{
			x++;
			y=0;
			continue;
		}
		if(screen[i] == '\t')
		{	
			y+=tabwidth;
			if(y>79)
			{
				y=y-79;
				x++;
			}
			continue;
		}
		else
		{
			*(video + 2*(x*80 + y)) = screen[i];
			*(video + 2*(x*80 + y)+1) = colour;
			y=y+1;
			if(y==80)
			{
				x++;
				y=0;
			}
		}
	}
	return 0;
 }


void print_ptr(long int num, int base)
{
	int number[32];
	int i=0;

		screen[screen_ctr++] = '0';
		screen[screen_ctr++] = 'x';
	
	do
	{
		int rem=num%base;
		if((rem) >= 10)
		{
			rem = rem-10 + 'a';
		}
		else{
			rem = rem + '0';
		}
		number[i]= rem;
		i++;
	}while((num=num/base) !=0);


	while(i-- != 0)
	{

		screen[screen_ctr++] = number[i];
	}
}

void print_num(int num, int base)
{
	int number[32];
	int i=0;

	if(base == 16)
	{

		screen[screen_ctr++] = '0';
		screen[screen_ctr++] = 'x';
	}
	do
	{
		int rem=num%base;
		if((rem) >= 10)
		{

			rem = rem-10 + 'a';
		}
		else{
			rem = rem + '0';
		}
		number[i]= rem;
		i++;
	}while((num=num/base) !=0);


	while(i-- != 0)
	{

		screen[screen_ctr++] = number[i];
	}
}

void printf(const char *format, ...) {
	va_list val;
	int printed = 0;
	screen_ctr=0;
	va_start(val, format);

	while(*format)
	{
		if(*format == '%')
		{
			switch(*(++format))
			{
			case 'd':
				printed=printed;
				int num = va_arg(val, int);
				if(num<0)
				{
					screen[screen_ctr++]='-';
					print_num(-num,10);
				}
				else
					print_num(num,10);
				format++;
				continue;

			case 'c':
				printed=printed;;
				int chr = va_arg(val, int);
				screen[screen_ctr++] = chr;
				format++;
				continue;

			case 's':
				printed=printed;
				char* str = va_arg(val, char*);
				while(*(str) != '\0')
					screen[screen_ctr++] = *str++;
				format++;
				continue;

			case 'x':
				printed=printed;
				int hex = va_arg(val, int);
				if(hex<0)
				{
					screen[screen_ctr++]='-';
				    hex=-hex;
                }
				print_num(hex,16);

				format++;
				continue;

            case 'p':
				printed=printed;
				long int ptr = va_arg(val, long int );
                if(ptr < 0)
                {
                    screen[screen_ctr++]='-';
                    ptr=-ptr;
                }
				print_ptr(ptr,16);

				format++;
				continue;
 
			case '%':
				printed=printed;
				char c='%';

				screen[screen_ctr++] = c;
			}
		}
		else
		{

			screen[screen_ctr++] = *format;
			++printed;
			++format;
		}
	}

	printed = write_text();
	
}


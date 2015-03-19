//#include <sys/defs.h>
#include <stdlib.h>
#include <stdio.h>
#include <stdarg.h>

// update errno.
char screen[1024];
int screen_ctr;
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

int printf(const char *format, ...) {
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
					print_num(-hex,16);
				}
				else
					print_num(hex,16);

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

	printed = write(1,screen, screen_ctr);
	if(printed < 0)
		return -1;
	return screen_ctr;

}

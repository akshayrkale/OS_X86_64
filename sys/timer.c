#include <sys/port.h>
#include <sys/defs.h>


void init_PIT(uint16_t frequency){

	//Timer ISR already registered in init_idt()

	uint16_t divisor = 1193180 / frequency;

	outb(0x43, 0x34);

	unsigned char l = (uint16_t)(divisor & 0xFF);
	unsigned char h = (uint16_t)( (divisor>>8) & 0xFF );

	// Send the frequency divisor.
	outb(0x40, l);
	outb(0x40, h);

}

#include<stdio.h>
void print_time(long int cur_tick,volatile char *pos)
{
unsigned char num[10];
int i=0;
    while(cur_tick)
    {
    
        num[i]=cur_tick %10;
        cur_tick = cur_tick/10;
        i++;
    }
int j=0;
    while(i--)
    {
        *pos = num[j++]+'0';
        *(pos+1) = 0x1F;
        pos=pos-2;
    }
}

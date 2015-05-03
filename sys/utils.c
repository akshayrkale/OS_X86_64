#include<sys/defs.h>
long stoi(const char *s) 
{
    long i;
    i = 0;
    while(*s >= '0' && *s <= '9')
    {   
        i = i * 10 + (*s - '0');
        s++;
    }   
    return i;
}


uint64_t power(uint64_t x, int e) {
    if (e == 0) return 1;

    return x * power(x, e-1);
}

uint64_t octalToDecimal(uint64_t octal)
{
    uint64_t decimal = 0, i=0;
    while(octal!=0){
        decimal = decimal + (octal % 10) * power(8,i++);
        octal = octal/10;
    }   
    return decimal;
}

void kmemcpy(void* dst, void* src , uint64_t size)
{
    char* i=src;
    char* j=dst;
    for(;i<(char*)src+size; )
    {
        *j=*i;
        i++;
        j++;
    }
}



void kmemset(void* start, int x, size_t size){

if(size==0)
    return;
for(char* i=(char*)start;(char*)i<(char*)start+size; i++)
    *i = x;

return;
}

#include<stdio.h>
int k=0;
int main()
{
    int i=299999999;
    k=k+i*2;
printf("You are inside tab%d",k);

while(i--);

printf("TABZ OUT OF BLOCK Q");
return k;
}

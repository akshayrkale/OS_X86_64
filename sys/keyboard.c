#include<sys/sbunix.h>
#include<sys/port.h>
#include <sys/defs.h>
#include <sys/paging.h>
#define CAPSLOCK  0x3a
#define LSHIFT    0x2a
#define RSHIFT    0x36
#define CTRL      0x1d

#define FALSE 0;
#define TRUE 1;
char keymap[256];
char keymap_upper[256];
char special=' ';
unsigned char capslock = FALSE;
unsigned char shift = FALSE;
unsigned char ctrl = FALSE;

void keyboard_read()
{
while (inb(0x64) & 0x01) // While there is data available.
{
  unsigned char scancode = inb(0x60);

 if (scancode == 0xe0)
 {
   return;
 }

 if(scancode == 0x0e || scancode == 0x1c || scancode == 0x0f)
 {
 special = 92;
 }
 // Was this a keypress?
 unsigned char keypress = TRUE;
 if (scancode & 0x80)
 {
   keypress = FALSE;
   scancode &= 0x7f;
   special = ' ';
 }

 
 unsigned char useUpper = FALSE;
 unsigned char useNums = FALSE;
 switch (scancode)
 {
 case CAPSLOCK:
   if (keypress)
   {
     capslock = !capslock;
   }
   return;
 case LSHIFT:
 case RSHIFT:
   if (keypress)
   {
     shift = TRUE;
   }
   else
   {
     shift = FALSE;
   }
   return;
 case CTRL:
   if (keypress)
   {
     ctrl = TRUE;
     special = '^';
   }
    else 
   {
     ctrl = FALSE;
   }
   return;
 
 }
 
 if ( (capslock&&!shift) || (!capslock&&shift) )
 {
   useUpper = TRUE;
 }
 if (shift)
 {
   useNums = TRUE;
 }
 
 if (!keypress)
 {
   return;
 }
 
 char theChar;
 if (scancode < 0x02)
 {
   theChar = keymap[scancode];
 }
 else if (scancode <= 0x0e /* backspace */ ||
          (scancode >= 0x1a /*[*/ && scancode <= 0x1c /*]*/) ||
          (scancode >= 0x27 /*;*/ && scancode <= 0x29 /*`*/) ||
          (scancode == 0x2b) ||
          (scancode >= 0x33 /*,*/ && scancode <= 0x35 /*/*/) )
 {
   if (useNums)
   {
     theChar = keymap_upper[scancode];
   }
   else
   {
     theChar = keymap[scancode];
   }
 }
 else if ( (scancode >= 0x10 /*Q*/ && scancode <= 0x19 /*P*/) ||
           (scancode >= 0x1e /*A*/ && scancode <= 0x26 /*L*/) ||
           (scancode >= 0x2c /*Z*/ && scancode <= 0x32 /*M*/) )
 {
   if (useUpper)
   {
     theChar = keymap_upper[scancode];
   }
   else
   {
     theChar = keymap[scancode];
   }
 }
 else if (scancode <= 0x39 /* space */)
 {
   theChar = keymap[scancode];
 }
 else
 {
   return;
 }
 volatile char 	*video = (volatile char*) VIDEO_START + 2*(24*80 + 78);
 *video = special;
 *(video+1) = 0x1F; 
 *(video+2) = theChar; 
 *(video+3) = 0x1F;
}
}



void keyboard_init()
{
  
  
  while (inb(0x64) & 0x01) // While there is data available.
  {
    inb(0x60);
  }
  
  keymap[0x00] = 0x00;
  keymap[0x01] = 0x1b; // Escape
  keymap[0x02] = '1';
  keymap[0x03] = '2';
  keymap[0x04] = '3';
  keymap[0x05] = '4';
  keymap[0x06] = '5';
  keymap[0x07] = '6';
  keymap[0x08] = '7';
  keymap[0x09] = '8';
  keymap[0x0a] = '9';
  keymap[0x0b] = '0';
  keymap[0x0c] = '-';
  keymap[0x0d] = '=';
  keymap[0x0e] = 'b'; // Backspace
  keymap[0x0f] = 't'; // Tab
  keymap[0x10] = 'q';
  keymap[0x11] = 'w';
  keymap[0x12] = 'e';
  keymap[0x13] = 'r';
  keymap[0x14] = 't';
  keymap[0x15] = 'y';
  keymap[0x16] = 'u';
  keymap[0x17] = 'i';
  keymap[0x18] = 'o';
  keymap[0x19] = 'p';
  keymap[0x1a] = '[';
  keymap[0x1b] = ']';
  keymap[0x1c] = 'n'; // Enter
  keymap[0x1d] = 0x00; // LCtrl
  keymap[0x1e] = 'a';
  keymap[0x1f] = 's';
  keymap[0x20] = 'd';
  keymap[0x21] = 'f';
  keymap[0x22] = 'g';
  keymap[0x23] = 'h';
  keymap[0x24] = 'j';
  keymap[0x25] = 'k';
  keymap[0x26] = 'l';
  keymap[0x27] = ';';
  keymap[0x28] = '\'';
  keymap[0x29] = '`';
  keymap[0x2a] = 0x00; // LShift
  keymap[0x2b] = '\\';
  keymap[0x2c] = 'z';
  keymap[0x2d] = 'x';
  keymap[0x2e] = 'c';
  keymap[0x2f] = 'v';
  keymap[0x30] = 'b';
  keymap[0x31] = 'n';
  keymap[0x32] = 'm';
  keymap[0x33] = ',';
  keymap[0x34] = '.';
  keymap[0x35] = '/';
  keymap[0x36] = 0x00; // RShift
  keymap[0x37] = '*';  // Keypad-*
  keymap[0x38] = 0x00; // LAlt
  keymap[0x39] = ' ';
  
  keymap_upper[0x02] = '!';
  keymap_upper[0x03] = '@';
  keymap_upper[0x04] = '#';
  keymap_upper[0x05] = '$';
  keymap_upper[0x06] = '%';
  keymap_upper[0x07] = '^';
  keymap_upper[0x08] = '&';
  keymap_upper[0x09] = '*';
  keymap_upper[0x0a] = '(';
  keymap_upper[0x0b] = ')';
  keymap_upper[0x0c] = '_';
  keymap_upper[0x0d] = '+';
  keymap_upper[0x10] = 'Q';
  keymap_upper[0x11] = 'W';
  keymap_upper[0x12] = 'E';
  keymap_upper[0x13] = 'R';
  keymap_upper[0x14] = 'T';
  keymap_upper[0x15] = 'Y';
  keymap_upper[0x16] = 'U';
  keymap_upper[0x17] = 'I';
  keymap_upper[0x18] = 'O';
  keymap_upper[0x19] = 'P';
  keymap_upper[0x1a] = '{';
  keymap_upper[0x1b] = '}';
  keymap_upper[0x1e] = 'A';
  keymap_upper[0x1f] = 'S';
  keymap_upper[0x20] = 'D';
  keymap_upper[0x21] = 'F';
  keymap_upper[0x22] = 'G';
  keymap_upper[0x23] = 'H';
  keymap_upper[0x24] = 'J';
  keymap_upper[0x25] = 'K';
  keymap_upper[0x26] = 'L';
  keymap_upper[0x27] = ':';
  keymap_upper[0x28] = '"';
  keymap_upper[0x29] = '~';
  keymap_upper[0x2b] = '|';
  keymap_upper[0x2c] = 'Z';
  keymap_upper[0x2d] = 'X';
  keymap_upper[0x2e] = 'C';
  keymap_upper[0x2f] = 'V';
  keymap_upper[0x30] = 'B';
  keymap_upper[0x31] = 'N';
  keymap_upper[0x32] = 'M';
  keymap_upper[0x33] = '<';
  keymap_upper[0x34] = '>';
  keymap_upper[0x35] = '?';
  
  
}

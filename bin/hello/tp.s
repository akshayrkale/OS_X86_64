.text
.global main

main:
mov  %eax, 1
mov  %eax, 2
mov  %eax, 3
callq main
int $80




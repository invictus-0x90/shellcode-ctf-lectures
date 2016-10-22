BITS 32

global _start

section .text
_start:
    jmp short loc1

;sys_write(fd, buff, count)
loc2:

;zero out registers
xor eax, eax
xor ebx, ebx
xor ecx, ecx
xor edx, edx

mov bl, 0 ;0 is stdout
pop ecx	  ;pops lololo into ecx
mov dl, 8 ;number of bytes to write
mov al, 4 ;the number of the syscall
int 0x80  ;calls kernel interrupt

xor eax,eax ;zero out eax
mov al, 0x1 ;sys_exit
int 0x80



loc1:
call loc2
db "lolololo"
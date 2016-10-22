BITS 32

xor ebx, ebx
mul ebx
xor ecx, ecx

;do challenge 1
mov bl, 6
mov cl, 4
mov dl, 3
call challenge_1

;do challenge 2
push BYTE 3
push BYTE 4
push BYTE 5
mov ebx, esp
call challenge_2
jmp short do_challenge3

;do challenge_3
do_challenge3:
push 3
push 4
mov ecx, esp
mov bl, 5
call challenge_3

;challenge_1(5,4,3)
challenge_1:
cmp bl, 5
jne get_loss
cmp cl, 4
jne get_loss
cmp dl, 3
jne get_loss
xor ebx, ebx
mul ebx
xor ecx, ecx
ret

;challenge_2([5,4,3])
challenge_2:
xor edi, edi
mul edi
xchg edi, ebx
mov bl,  [edi]
mov cl, [edi+4]
mov dl, [edi+8]
call challenge_1
ret

;challenge_3(5, [4,3])
challenge_3:
mov edi, ecx
xor ecx, ecx
mov cl, [edi]
mov dl, [edi+4]
call challenge_1
jmp short get_win



message:
xor ebx, ebx
mul ebx
mov al, 0xff
mov edi, [esp]	;store string pointer for len check
mov ebp, [esp]
cld				;clear direction flags
mov ecx, 0xffffffff
repne scasb
dec edi
sub edi, ebp	;edi = len(string)+1
mov edx, edi	;mov length into ecx
mov ecx, ebp	;mov string back into ebx
mov al, 0x4		;sys_write(0, string, len)
int 0x80
xor eax, eax
mov al,1
int 0x80		;sys_exit


get_win:
call message
db "[+] Well Done!! [+]", 0xff

get_loss:
call message
db "[-] Try Harder [-]", 0xff


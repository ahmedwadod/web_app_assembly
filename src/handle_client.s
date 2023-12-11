.intel_syntax noprefix

.section .text

.extern print

RECV=0x2d
REQ_MAX_LEN=256

# handle_client(int client_fd, int ip)
# Handles and processes the TCP client
#
# Params:
# client_fd: Client file descriptor
# ip: Client ip
#
# Returns: null
.global handle_client
handle_client:
	push rdi
	push rax

	mov rax, OFFSET msg
	call print

_recv_loop:
	nop
	# RECV
	mov rdi, [rsp]
	mov rsi, OFFSET data
	mov rdx, REQ_MAX_LEN
	mov r10, 0
	mov rax, RECV
	syscall

	cmp rax, 0
	je _end
	
	# Process the data
	push rax
	add rax, OFFSET data
	movb [rax], 0

	mov rax, OFFSET data
	call print

	mov rdi, [rsp + 8]
	mov rsi, OFFSET data
	mov rdx, [rsp]
	mov rax, 0x01
	syscall

	pop rax
	jmp _recv_loop

_end:
	pop rax
	pop rdi
	ret

.section .data
data:
	.skip 256

.section .rodata
msg: .string "Client Connected\n"

welc: .string "Welcome"

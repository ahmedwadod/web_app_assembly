.intel_syntax noprefix

.section .text

.extern print
.extern malloc
.extern free

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
	nop
	push rdi
	push rax

	mov rax, OFFSET msg
	call print

	# Allocate memory
	mov rax, REQ_MAX_LEN + 1
	call malloc
	push rax

_recv_loop:
	nop
	# RECV
	mov rdi, [rsp + 8] #fd
	mov rsi, [rsp]
	mov rdx, REQ_MAX_LEN
	mov r10, 0
	mov r8, 0
	mov r9, 0
	mov rax, RECV
	syscall

	cmp rax, 0
	jle _end
	
	# Process the data

	# Make it null terminated
	push rax # Push data length to stack
	add rax, [rsp + 8] # Add the pointer
	movb [rax], 0

	# Validate request
	mov rax, [rsp + 8]
	mov rdi, [rsp] 
	call validate_request
	cmp rax, 0
	jne _bad_request

	# Print request
	mov rax, [rsp + 8]
	call print

	# Remove the data length from stack
	pop rax
	jmp _recv_loop

_end:
	mov rax, rsp
	mov rdi, REQ_MAX_LEN + 1
	call free

	pop rax
	pop rax
	pop rdi
	ret

_bad_request:
	mov rax, OFFSET bad_req_msg
	call print
	pop rax
	jmp _end

.section .rodata
msg: .string "Client Connected\n"

bad_req_msg:
	.string "Bad Request\n"

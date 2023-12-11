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

	# Make it null terminated
	push rax # Push data length to stack
	add rax, OFFSET data
	movb [rax], 0

	# Validate request
	sub rax, OFFSET data
	mov rdi, rax
	mov rax, OFFSET data
	call validate_request
	cmp rax, 0
	jne _bad_request

	# Print request
	mov rax, OFFSET data
	call print
	


	# Remove the data length from stack
	pop rax
	jmp _recv_loop

_end:
	pop rax
	pop rdi
	ret

_bad_request:
	mov rax, OFFSET bad_req_msg
	call print
	pop rax
	jmp _end

.section .data
data:
	.skip 256

.section .rodata
msg: .string "Client Connected\n"

bad_req_msg:
	.string "Bad Request\n"
good_req_msg:
	.string "Valid Request\n"

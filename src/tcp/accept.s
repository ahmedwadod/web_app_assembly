.intel_syntax noprefix

.section .text

.extern close

ACCEPT=0x2b

# accept(int socket_fd, void* handleClient)
# Wait for a TCP client to connect and handle the client
# using the function `handleClient`
#
# Params:
# handleClient:	void handleClient(int client_fd, int ip)
#
# Returns: null
.global accept
accept:
	nop
	push rdi # Push the function pointer
	# Accept
	mov rdi, rax
	mov rsi, OFFSET in_addr
	mov rdx, OFFSET in_addr_len
	mov rax, ACCEPT
	syscall

	# Get the IP and store it in rdi
	mov rsi, OFFSET in_addr_ip
	movsxd rdx, [rsi]
	mov rdi, rdx

	pop rdx # Get function pointer from stack
	push rax # Push client_fd to the stack

	# Call the handleClient (rax: client_fd, rdi: ip, rdx: the pointer)
	call rdx

	pop rax # Get the client_fd from stack
	call close 
	ret


.section .data
in_addr:
	.skip 4
in_addr_ip:
	.skip 4
in_addr_pad:
	.skip 8

in_addr_len:
	.quad 0

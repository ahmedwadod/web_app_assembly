.intel_syntax noprefix

.section .text

.extern print_err
.extern exit_fail

SOCKET=0x29
BIND=0x31
LISTEN=0x32

AF_INET=0x02
SOCK_STREAM=0x01
PORT=0x901f # 8080 in big endian
CONN_LIMIT=1

# create_server()
# Creates a TCP socket, bind it to PORT
# and start listening on the socket.
#
# Returns: int socket_fd
.global create_server
create_server:
	# Socket	
	mov rdi, AF_INET
	mov rsi, SOCK_STREAM
	mov rdx, 0
	mov rax, SOCKET
	syscall

	push rax # Push fd to the stack

	# Check for socket error
	cmp rax, 0
	jl _socket_error

	# Bind 
	mov rdi, rax
	mov rsi, OFFSET addr
	mov rdx, 16
	mov rax, BIND
	syscall

	cmp rax, 0
	jl _bind_error

	# listen
	mov rdi, [rsp]
	mov rsi, CONN_LIMIT
	mov rax, LISTEN
	syscall

	cmp rax, 0
	jl _bind_error

	pop rax # Store socket fd in rax
	ret

_socket_error:
	mov rax, OFFSET socket_err_msg
	call print_err
	call exit_fail

_bind_error:
	mov rax, OFFSET bind_err_msg
	call print_err
	call exit_fail

.section .rodata
socket_err_msg:
	.string "Unable to create socket!\n"
bind_err_msg:
	.string "Unable to bind or listen on the specified port!\n"

addr:
	.hword AF_INET
	.hword PORT
	.skip 12

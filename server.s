.intel_syntax noprefix
.global _start

.section .text

.extern exit
.extern print
.extern create_server
.extern close

_start:
	# Main Server
	mov rax, OFFSET welcome_msg
	call print

	# Create TCP Server
	call create_server
	push rax
	mov rax, OFFSET tcp_success_msg
	call print


	# Close the socket fd
	mov rax, [rsp]
	call close
	call exit


.section .rodata

welcome_msg:
	.string "ASM Server is starting up...\n"
tcp_success_msg:
	.string "TCP Server created successfully\n"

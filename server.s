.intel_syntax noprefix
.global _start

.section .text

.extern exit
.extern print

_start:
	# Main server
	mov rax, OFFSET welcome_msg
	call print

	call exit


.section .rodata

welcome_msg:
	.string "ASM Server is starting up...\n"

.intel_syntax noprefix

.section .text

CLOSE=0x03

# close(int fd)
# Closes an opened file
#
# Params:
# fd: File descriptor
#
# Return: null
.global close
close:
	mov rdi, rax
	mov rax, CLOSE
	syscall
	ret


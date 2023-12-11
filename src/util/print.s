.intel_syntax noprefix

.section .text

WRITE=0x01
STDOUT=0x01
STDERR=0x02

# print(char* str)
# Prints a null-terminated string to STDOUT
#
# Params:
# str: Pointer to a null-terminated string
#
# Returns: Length of the printed string
.global print
print:
	push rax
	call _count_len
	mov rdi, STDOUT #fd
	pop rsi # buf
	mov rdx, rax # len from _count_len
	mov rax, WRITE
	syscall
	ret

_count_len:
	mov rcx, 0
_loop:
	movsxb rdx, BYTE PTR [rax]
	add rax, 1
	add rcx, 1
	cmp rdx, 0
	jne _loop
	mov rax, rcx
	ret

# print_err(char* str)
# Prints a null-terminated string to STDERR
#
# Params:
# str: Pointer to a null-terminated string
#
# Returns: Length of the printed string
.global print_err
print_err:
	push rax
	call _count_len
	mov rdi, STDERR #fd
	pop rsi # buf
	mov rdx, rax # len from _count_len
	mov rax, WRITE
	syscall
	ret

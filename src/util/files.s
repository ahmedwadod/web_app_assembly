.intel_syntax noprefix

.section .text

.extern malloc

O_RDONLY=0x0
OPEN=0x02
FSTAT=0x05
MMAP=0x09
PROT_READ=0x01
MAP_PRIVATE=0x02

# char* read_file(char* filename, long* size_buf)
# Opens and reads a file by it's name
#
# Params:
# filename: a null-terminated string of the file name
# size_buf: a pointer to a memory location to store the read file size
# 
# Returns: 
# On success: pointer to data
# On fail: null
.global read_file
read_file:
	push rbp
	mov rbp, rsp

	# Store size_buf in the stack 
	mov [rbp - 32], rdi

	# Open the file
	mov rdi, rax
	mov rsi, O_RDONLY
	mov rdx, 0
	mov rax, OPEN
	syscall

	# Check if it exists
	cmp rax, 0
	jle _file_err

	# Store the fd in the stack
	movq [rbp - 24], rax

	# Get the file size
	# Allocate stat struct (144 byte)
	mov rax, 144
	call malloc
	# Store the stat pointer
	movq [rsp - 16], rax 
	
	# Fstat
	mov rsi, rax # Stat pointer
	mov rdi, [rsp - 24] # fd
	mov rax, FSTAT
	syscall
	cmp rax, 0
	jne _file_err

	movq rax, [rsp - 16] # Stat pointer
	add rax, 48 # Location of size
	mov rsi, [rax] # File size (rsi used by mmap)

	# Memory map the file
	mov rdi, 0
	mov rdx, PROT_READ
	mov r10, MAP_PRIVATE
	mov r8, [rsp - 24]
	mov r9, 0
	mov rax, MMAP
	syscall

	# Check for errors
	cmp rax, 0
	jle _file_err

	# See if user wants the size
	mov rdx, [rbp - 32] # size_buf
	cmp rdx, 0
	je _end

	# Store the size in size_buf
	movq rcx, [rsp - 16] # Stat pointer
	add rcx, 48 # size location
	mov rdi, [rcx]
	movq [rdx], rdi

_end:
	# Return the file address
	pop rbp
	ret # Pointer already in rax

_file_err:
	mov rax, 0
	pop rbp
	ret



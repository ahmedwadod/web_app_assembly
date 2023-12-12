.intel_syntax noprefix

.section .text

MMAP=0x09
MUNMAP=0x0b
PROT_WRITE=0x02
PROT_READ=0x01
MAP_SHARED=0x01
MAP_ANON=0x20
MAP_PRIVATE=0x02

# void* malloc(int size)
# Allocates shared memory in the heap
#
# Params:
# size: The required size in bytes
#
# Returns: a pointer the allocated memory
.global malloc
malloc:
	nop
	mov rsi, rax # Size
	mov rdi, 0 # Address
	mov rdx, PROT_WRITE 
	or rdx, PROT_READ # Protection
	mov r10, MAP_SHARED # Flags
	or r10, MAP_ANON
	mov r8, -1 # fd
	mov r9, 0 # Offset
	mov rax, MMAP
	syscall
	ret

# void* malloc_priv(int size)
# Allocates private memory in the heap
#
# Params:
# size: The required size in bytes
#
# Returns: a pointer the allocated memory
.global malloc_priv
malloc_priv:
	mov rsi, rax # Size
	mov rdi, 0 # Address
	mov rdx, PROT_WRITE # Protection
	mov r10, MAP_PRIVATE
	or r10, MAP_ANON # Flags
	mov r8, -1 # fd
	mov r9, 0 # Offset
	mov rax, MMAP
	syscall
	ret

# free(int* addr, int size)
# Free allocated memory
#
# Params:
# addr: Pointer to the address to deallocate
# size: Size of the object to deallocate
#
# Returns: null
.global free
free:
	mov rsi, rdi
	mov rdi, rax
	mov rax, MUNMAP
	syscall
	ret












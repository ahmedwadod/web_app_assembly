.intel_syntax noprefix

.section .text

# validate_request(char* str, int length)
# Validate incoming request if it is a valid GET
# Http request.
#
# Params:
# str: Pointer to a request string
# length: Full length of the request
#
# Returns:
# 0: Success
# 1: Fail
.global validate_request
validate_request:
	nop
	# Min valid request length is 5
	cmp rdi, 5
	jl _ret_fail

	# God forgive me for comparing strings like this
	movd edx, [rax]
	movd eax, [GET_STR]
	cmp edx, eax
	jne _ret_fail
	
_ret_success:
	mov rax, 0
	ret

_ret_fail:
	mov rax, 1
	ret

.section .rodata

GET_STR:
	.ascii "GET "

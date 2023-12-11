.intel_syntax noprefix

.section .text

EXIT=0x3c
EXIT_SUCCESS=0
EXIT_FAIL=1

# exit()
# Safe exit with success
#
# Returns: null
.global exit
exit:
	mov rax, EXIT
	mov rdi, EXIT_SUCCESS
	syscall

# exit_fail()
# Safe exit with fail code
#
# Return: null
.global exit_fail
exit_fail:
	mov rax, EXIT
	mov rdi, EXIT_FAIL
	syscall

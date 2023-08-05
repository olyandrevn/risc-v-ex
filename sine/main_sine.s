
# syscalls
exit    = 93
read    = 63
write   = 64
ds	    = 0x20000

.section .data

newline: .byte 0x0A

# This is  0-ended string with input data
input: 	.asciz "0.234"
 .space 100

# This will be used for 0-ended string with result. Use "-1" if you cannot calculate the function
output:                
.align 4
.space	100
  

.section .text 
.globl _start

_start:     

	# gp initialization
	li	gp, ds

	# Buffer initialisation will be here
   
    # Read from input
    li  a7, read
    li  a0, 0
	la	a1, input
    la  a2, 100
    ecall

    la  a1, input
	la	a2, output
    call    sine

    # Write to output
    li  a7, write
    li  a0, 1
    la	a1, output
    la  a2, 100
    ecall

    li  a7, write
    li  a0, 1
    la  a1, newline
    la  a2, 1
    ecall

	# Result checking will be here

	li	a0, 0
	li	a7, exit
	ecall

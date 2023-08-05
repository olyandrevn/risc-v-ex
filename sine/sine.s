.macro fin
    addi sp, sp, -8
    sd   ra, 0(sp)
.endm

.macro fout
    ld   ra, 0(sp)
    addi sp, sp, 8
.endm

.globl sine

default_answer = 0x312d
ans            = 0
ans_len        = 8

.section .data
# if you need some data, put it here
var:
.align 8
.space 100

zero_point:
 .asciz "0.00000"
 .asciz "0.09983"
 .asciz "0.19866"
 .asciz "0.29552"
 .asciz "0.38941"
 .asciz "0.47942"
 .asciz "0.56464"
 .asciz "0.64421"
 .asciz "0.71735"
 .asciz "0.78332"

one_point:
 .asciz "0.84147"
 .asciz "0.89120"
 .asciz "0.93203"
 .asciz "0.96355"
 .asciz "0.98544"
 .asciz "0.99749"
   
.section .text

# Sine
#   Params
#	a1 -- input buffer will contain string with the argument
#	a2 -- output string buffer for the string result
sine:
    fin

    # load input address to the pointer
    mv   a3, a1

    # load first digit
    lb   t0, 0(a3)

    # get INT value of first digit
    addi t0, t0, -48

    # move pointer to the next char
    addi a3, a3, 1
    
    # load point
    lb   t1, 0(a3)
    
    # check if it's really point
    li   t2, '.'
    bne  t1, t2, erret

    # move pointer to the next char
    addi a3, a3, 1

    # load second digit
    lb   t1, 0(a3)

    # get INT value of second digit
    addi t1, t1, -48

    # check the value of the first digit
    li   t2, 0
    beq  t2, t0, first_digit_zero
    li   t2, 1
    beq  t2, t0, first_digit_one
    j    erret

first_digit_zero:
    # load value-table address to pointer
    la   a4, zero_point

    # calculate answer
    j    get_answer

first_digit_one:
    # check if value <= 1.5
    li   t2, 6
    bge  t1, t2, erret

    # load value-table address to pointer
    la   a4, one_point

get_answer:
    # find the shift to closest value in table: zero_point or one_point
    call get_table_shift

    # move pointer in table to correct value
    add  a4, a4, t2

    # init answer length as ans_len
    li   t2, ans_len

save_answer:
    # load i-th byte of value-answer
    lb   t3, 0(a4)

    # save i-th byte to output
    sb   t3, 0(a2)

    addi t2, t2, -1
    addi a4, a4, 1
    addi a2, a2, 1

    beq t2, x0, suret
    j   save_answer

get_table_shift:
    # init shift as 0
    li   t2, 0

while_shift_not_found:
    # find the closest value in table based on second digit value
    beq  t1, x0, ret
    addi t2, t2, ans_len
    addi t1, t1, -1
    j    while_shift_not_found

erret:
    li   t2, default_answer
    sw   t2, 0(a2)

	ret

suret:
    fout
    ret

ret:
    ret

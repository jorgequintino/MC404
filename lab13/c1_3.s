.globl operation

operation:
    addi sp, sp, -32
    sw ra, 24(sp)
    sw fp, 28(sp)
    addi fp, sp, 32


    li a0, 9
    sw a0, 0(sp)
    li a1, -10
    sw a1, 4(sp)
    li a2, 11
    sw a2, 8(sp)
    li a3, -12
    sw a3, 12(sp)
    li a4, 13
    sw a4, 16(sp)
    li a5, -14
    sw a5, 20(sp)


    li a0, 1
    li a1, -2
    li a2, 3
    li a3, -4
    li a4, 5
    li a5, -6
    li a6, 7
    li a7, -8

    jal mystery_function


    lw fp, 28(sp)
    lw ra, 24(sp)
    addi sp, sp, 32

    ret
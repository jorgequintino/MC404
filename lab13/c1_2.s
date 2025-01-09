.globl my_function

my_function:
    addi sp, sp, -20
    sw ra, 4(sp)
    sw fp, 0(sp)
    addi fp, sp, 20

    add a3, a0, a1
    sw a0, 8(sp)
    sw a1, 12(sp)

    mv a1, a0
    mv a0, a3
    jal mystery_function
    mv a4, a0 


    lw a1, 12(sp)

    sub a4, a1, a4
    add a5, a4, a2 #aux
    mv a0, a5

    jal mystery_function
    mv a6, a0
    
    add a2, a2, a5
    sub a0, a2, a6


    lw fp, 0(sp)
    lw ra, 4(sp)
    addi sp, sp, 20

    ret
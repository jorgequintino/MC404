.globl node_creation

node_creation:
    addi sp, sp, -16
    sw ra, 4(sp)
    sw fp, 0(sp)
    addi fp, sp, 16

    mv a0, sp
    addi a0, a0, 8

    li t0, 30
    sw t0, 0(a0)

    li t1, 25
    sb t1, 4(a0)

    li t2, 64
    sb t2, 5(a0)

    li t3, -12
    sh t3, 6(a0)

    jal mystery_function

    lw fp, 0(sp)
    lw ra, 4(sp)
    addi sp, sp, 16

    ret
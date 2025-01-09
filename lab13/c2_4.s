.globl node_op

node_op:
    addi sp, sp, -8
    sw ra, 4(sp)
    sw fp, 0(sp)
    addi fp, sp, 8

    lw t0, 0(a0)

    lbu t1, 4(a0)

    lbu t2, 5(a0)

    lhu t3, 6(a0)

    add a0, t0, t1
    sub a0, a0, t2
    add a0, a0, t3

    lw fp, 0(sp)
    lw ra, 4(sp)
    addi sp, sp, 8

    ret
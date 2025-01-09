.globl swap_int
.globl swap_short
.globl swap_char

swap_int:
    addi sp, sp, -8
    sw ra, 4(sp)
    sw fp, 0(sp)
    addi fp, sp, 8

    lw a2, 0(a0)
    lw a3, 0(a1)

    sw a3, 0(a0)
    sw a2, 0(a1)

    li a0, 0

    lw fp, 0(sp)
    lw ra, 4(sp)
    addi sp, sp, 8

    ret

swap_short:
    addi sp, sp, -8
    sw ra, 4(sp)
    sw fp, 0(sp)
    addi fp, sp, 8

    lhu a2, 0(a0)
    lhu a3, 0(a1)

    sh a3, 0(a0)
    sh a2, 0(a1)

    li a0, 0

    lw fp, 0(sp)
    lw ra, 4(sp)
    addi sp, sp, 8
    
    ret

swap_char:
    addi sp, sp, -8
    sw ra, 4(sp)
    sw fp, 0(sp)
    addi fp, sp, 8

    lbu a2, 0(a0)
    lbu a3, 0(a1)

    sb a3, 0(a0)
    sb a2, 0(a1)

    li a0, 0

    lw fp, 0(sp)
    lw ra, 4(sp)
    addi sp, sp, 8
    
    ret
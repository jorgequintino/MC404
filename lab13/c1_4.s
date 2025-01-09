.globl operation

operation:
    addi sp, sp, -32
    sw ra, 24(sp)
    sw fp, 28(sp)
    addi fp, sp, 32
    
    add a0, a1, a2
    sub a0, a0, a5
    add a0, a0, a7
    
    lw a1, 8(fp)
    lw a2, 16(fp)

    add a0, a0, a1
    sub a0, a0, a2


    lw fp, 28(sp)
    lw ra, 24(sp)
    addi sp, sp, 32

    ret
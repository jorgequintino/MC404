.globl operation

operation:
    addi sp, sp, -40
    sw ra, 32(sp)
    sw fp, 36(sp)
    addi fp, sp, 40
    
    sw a5, 0(sp)
    sw a4, 4(sp)
    sw a3, 8(sp)
    sw a2, 12(sp)
    sw a1, 16(sp)
    sw a0, 20(sp)

    lw a0, 20(fp)
    lw a1, 16(fp)
    lw a2, 12(fp)
    lw a3, 8(fp)
    lw a4, 4(fp)
    lw a5, 0(fp)


    sw a6, 24(sp)
    sw a7, 28(sp)

    lw a6, 28(sp)
    lw a7, 24(sp)

    jal mystery_function

    lw fp, 36(sp)
    lw ra, 32(sp)
    addi sp, sp, 40

    ret
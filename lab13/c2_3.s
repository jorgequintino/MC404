.globl fill_array_int
.globl fill_array_short
.globl fill_array_char

fill_array_int:
    addi sp, sp, -408
    sw ra, 4(sp)
    sw fp, 0(sp)
    addi fp, sp, 408

    mv t0, sp
    addi t0, t0, 8
    mv a0, t0

    li t1, 0
    li t2, 100

    for_int:
    beq t1, t2, finished_int
    
    sw t1, 0(t0)
    addi t0, t0, 4
    addi t1, t1, 1
    j for_int

    finished_int:
    jal mystery_function_int

    lw fp, 0(sp)
    lw ra, 4(sp)
    addi sp, sp, 408

    ret

fill_array_short:
    addi sp, sp, -208
    sw ra, 4(sp)
    sw fp, 0(sp)
    addi fp, sp, 208

    mv t0, sp
    addi t0, t0, 8
    mv a0, t0

    li t1, 0
    li t2, 100

    for_short:
    beq t1, t2, finished_short
    
    sw t1, 0(t0)
    addi t0, t0, 2
    addi t1, t1, 1
    j for_short

    finished_short:
    jal mystery_function_short

    lw fp, 0(sp)
    lw ra, 4(sp)
    addi sp, sp, 208

    ret

fill_array_char:
    addi sp, sp, -108
    sw ra, 4(sp)
    sw fp, 0(sp)
    addi fp, sp, 108

    mv t0, sp
    addi t0, t0, 8
    mv a0, t0

    li t1, 0
    li t2, 100

    for_char:
    beq t1, t2, finished_char
    
    sw t1, 0(t0)
    addi t0, t0, 1
    addi t1, t1, 1
    j for_char

    finished_char:
    jal mystery_function_char

    lw fp, 0(sp)
    lw ra, 4(sp)
    addi sp, sp, 108

    ret
.globl middle_value_int
.globl middle_value_short
.globl middle_value_char
.globl value_matrix

middle_value_int:
    addi sp, sp, -8
    sw ra, 4(sp)
    sw fp, 0(sp)
    addi fp, sp, 8

    li t0, 2
    div a3, a1, t0  #middle
    slli a3, a3, 2

    add a3, a3, a0
    lw a0, 0(a3)

    lw fp, 0(sp)
    lw ra, 4(sp)
    addi sp, sp, 8

    ret

middle_value_short:
    addi sp, sp, -8
    sw ra, 4(sp)
    sw fp, 0(sp)
    addi fp, sp, 8

    li t0, 2
    div a3, a1, t0  #middle
    slli a3, a3, 1

    add a3, a3, a0
    lhu a0, 0(a3)

    lw fp, 0(sp)
    lw ra, 4(sp)
    addi sp, sp, 8

    ret

middle_value_char:
    addi sp, sp, -8
    sw ra, 4(sp)
    sw fp, 0(sp)
    addi fp, sp, 8

    li t0, 2
    div a3, a1, t0  #middle
    add a3, a3, a0
    lbu a0, 0(a3)

    lw fp, 0(sp)
    lw ra, 4(sp)
    addi sp, sp, 8

    ret

value_matrix:
    addi sp, sp, -8
    sw ra, 4(sp)
    sw fp, 0(sp)
    addi fp, sp, 8

    li t0, 12
    li t1, 42
    li t2, 0
    li t3, 0

    width:
    beq t2, a1, height
    addi t2, t2, 1
    slli t4, t1, 2
    add a0, a0, t4
    j width

    height:
    beq t3, a2, found_it
    addi t3, t3, 1
    j height

    found_it:
    slli t4, a2, 2
    add a0, a0, t4
    lw a0, 0(a0)

    lw fp, 0(sp)
    lw ra, 4(sp)
    addi sp, sp, 8

    ret
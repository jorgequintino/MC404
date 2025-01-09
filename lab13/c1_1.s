.globl increment_my_var
.globl my_var

increment_my_var:
    addi sp, sp, -16
    sw ra, 4(sp)
    sw fp, 0(sp)
    addi fp, sp, 16

    la a0, my_var
    lw a1, 0(a0)
    addi a1, a1, 1
    sw a1, 0(a0)
    
    lw fp, 0(sp)
    lw ra, 4(sp)
    addi sp, sp, 16
    ret

.data
    my_var: .word 10
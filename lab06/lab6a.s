.text
.global _start

_start:
    jal read
    la a1, input_address
    jal tonumeric
    jal sqrt
    jal tostring
    jal write
    exit:
    #exit
    li a0, 0
    li a7, 93
    ecall
    ret

read:
    li a0, 0  # file descriptor = 0 (stdin)
    la a1, input_address #  buffer to write the data
    li a2, 20  # size (reads only 1 byte)
    li a7, 63 # syscall read (63)
    ecall
    
tonumeric:
    li t1, 1000
    li t2, 100
    li t3, 10
    li t4, 0                    # counter of numbers
    li t5, 4                    # counter of numbers
    la a2, N1

    1:

    # First Number
    lbu t0, 0(a1)               # Load first Byte of First Number
    addi t0, t0, -'0'           # Transform to int
    mul t0, t0, t1              # Mul by 1000
    mv a0, t0                   # a0 <- 1000* (first byte)
    lbu t0, 1(a1)               
    addi t0, t0, -'0'           
    mul t0, t0, t2             
    add a0, a0, t0
    lbu t0, 2(a1)               
    addi t0, t0, -'0'           
    mul t0, t0, t3             
    add a0, a0, t0
    lbu t0, 3(a1)               
    addi t0, t0, -'0'           
    add a0, a0, t0 

    sw a0, 0(a2)

    addi a1, a1, 5
    addi a2, a2, 4

    addi t4, t4, 1
    beq t4, t5, 1f
    j 1b

    1:
    ret

sqrt:
    li a4, 2                    #coloca 2 no a2
     
    li t0, 1
    li t4, 0                    # counter of numbers
    li t5, 4                    # counter of numbers
    la a2, N1

    begin:
    li t3, 10
    lw t6, 0(a2)
    div t1, t6, a4              # k = y/2

    1:
    div t2, t6, t1             # y/k
    add t1, t1, t2             #k' = k + y/k
    div t1, t1, a4             #k'=k'/2

    addi t3, t3, -1
    bge t3, t0, 1b

    sw t1, 0(a2)
    addi a2, a2, 4
    addi t4, t4, 1
    beq t4, t5, 1f
    j begin

    1:
    ret

tostring:
    li t1, 1000
    li t2, 100
    li t3, 10
    li t4, 0                    # counter of numbers
    li t5, 4                    # counter of numbers
    li t6, ' '
    li a6, '\n'
    la a2, N1
    la a5, output

    1:
    lw t0, 0(a2)
    div a3, t0, t1 #quociente
    addi a3, a3, '0'           # Transform to string
    sw a3, 0(a5)
    rem a4, t0, t1
    addi a5, a5, 1

    div a3, a4, t2 #quociente
    addi a3, a3, '0'           # Transform to string
    sw a3, 0(a5)
    rem a4, a4, t2
    addi a5, a5, 1

    div a3, a4, t3 #quociente
    addi a3, a3, '0'           # Transform to string
    sw a3, 0(a5)
    rem a4, a3, t2
    addi a5, a5, 1
    sw a4, 0(a5)

    #addi a1, a1, 5
    addi a2, a2, 4

    addi t4, t4, 1
    addi a5, a5, 1
    beq t4, t5, 1f
    
    sw t6, 0(a5)
    addi a5, a5, 1
    j 1b

    1:
    sw a6, 0(a5)
    ret
    
write:
    li a0, 1            # file descriptor = 1 (stdout)
    la a1, output       # buffer
    li a2, 20           # size
    li a7, 64           # syscall write (64)
    ecall

.bss

input_address:
    .skip 0x14  # buffer
N1:
    .skip 0x4
N2:
    .skip 0x4
N3:
    .skip 0x4
N4:
    .skip 0x4
output:
    .skip 0x14

.data


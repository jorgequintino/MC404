.text
.global _start

_start:
    jal readfirst
    jal readsecond  
    jal tonumeric
    jal distance
    jal ycoord
    jal xcoord
    jal bestsqrt
    jal tostring
    jal write
    exit:
    li a0, 0
    li a7, 93
    ecall
    ret

readfirst:
    li a0, 0  # file descriptor = 0 (stdin)
    la a1, input1_address #  buffer to write the data
    li a2, 12  # size (reads only 1 byte)
    li a7, 63 # syscall read (63)
    ecall
    ret

readsecond:
    li a0, 0  # file descriptor = 0 (stdin)
    la a1, input2_address #  buffer to write the data
    li a2, 20  # size (reads only 1 byte)
    li a7, 63 # syscall read (63)
    ecall
    ret
    
tonumeric:
    li t1, 1000
    li t2, 100
    li t3, 10
    li t4, 0                    # counter of numbers
    li t5, 2
    li a4, '+'
    li a3, -1
    la a2, YB
    la t6, input1_address

    1:                          #first line of input

    # First Number
    lb a5, 0(t6)                #salva sinal do numero em a5
    lb t0, 1(t6)                # Load first Byte of First Number
    addi t0, t0, -'0'           # Transform to int
    mul t0, t0, t1              # Mul by 1000
    mv a0, t0                   # a0 <- 1000* (first byte)
    lb t0, 2(t6)               
    addi t0, t0, -'0'           
    mul t0, t0, t2             
    add a0, a0, t0
    lb t0, 3(t6)               
    addi t0, t0, -'0'           
    mul t0, t0, t3             
    add a0, a0, t0
    lb t0, 4(t6)               
    addi t0, t0, -'0'
    add a0, a0, t0           

    beq a5, a4, positive        # se for positivo não mult -1
    mul a0, a0, a3

    positive:
    sw a0, 0(a2)

    addi t6, t6, 6
    addi a2, a2, 4

    addi t4, t4, 1
    beq t4, t5, 1f
    j 1b

    1:                          #second line of input
    la t6, input2_address
    li t5, 6
    
    1:
    # First Number
    lbu t0, 0(t6)               # Load first Byte of First Number
    addi t0, t0, -'0'           # Transform to int
    mul t0, t0, t1              # Mul by 1000
    mv a0, t0                   # a0 <- 1000* (first byte)
    lbu t0, 1(t6)               
    addi t0, t0, -'0'           
    mul t0, t0, t2             
    add a0, a0, t0
    lbu t0, 2(t6)               
    addi t0, t0, -'0'           
    mul t0, t0, t3             
    add a0, a0, t0
    lbu t0, 3(t6)               
    addi t0, t0, -'0'           
    add a0, a0, t0 

    sw a0, 0(a2)

    addi t6, t6, 5
    addi a2, a2, 4

    addi t4, t4, 1
    beq t4, t5, 1f
    j 1b

    1:
    ret

distance:
    li t0, 3
    li t1, 10
    la t2, TR
    lw t3, 0(t2)
    la a1, DA

    #DA
    la t4, TA
    lw t5, 0(t4)
    sub t6, t3, t5
    mul t6, t6, t0
    div t6, t6, t1
    sw t6, 0(a1)
    addi a1, a1, 4
    addi t4, t4, 4

    #DB
    lw t5, 0(t4)
    sub t6, t3, t5
    mul t6, t6, t0
    div t6, t6, t1
    sw t6, 0(a1)
    addi a1, a1, 4
    addi t4, t4, 4

    #DC
    lw t5, 0(t4)
    sub t6, t3, t5
    mul t6, t6, t0
    div t6, t6, t1
    sw t6, 0(a1)
    
    ret

ycoord:
    li t6, 2
    la t0, YB
    lw t1, 0(t0)
    la t2, DA
    lw t3, 0(t2)
    la a1, Y

    #DA²
    mul t3, t3, t3
    addi t2, t2, 4

    #DB²
    lw t4, 0(t2)
    mul t4, t4, t4

    #YB²
    mul t5, t1, t1

    #Y
    add a2, t3, t5
    sub a2, a2, t4
    div a2, a2, t1
    div a2, a2, t6
    sw a2, 0(a1)

    ret

xcoord:
    li a4, 2                       #coloca 2 no a2
    li a6, -1
    li t0, 1
    la a2, X1

    la t1, DA
    lw t3, 0(t1)
    la a1, Y
    lw a3, 0(a1)

    #DA²
    mul t3, t3, t3

    #Y²
    mul a3, a3, a3

    #DA²-Y²
    sub a5, t3, a3



    begin:
    li t6, 21
    div t4, a5, a4                    # k = y/2

    1:
    div t2, a5, t4                    # y/k
    add t4, t4, t2                    #k' = k + y/k
    div t4, t4, a4                    #k'=k'/2

    addi t6, t6, -1
    bge t6, t0, 1b

    sw t4, 0(a2)                      #positive X1
    addi a2, a2, 4
    mul t4, t4, a6
    sw t4, 0(a2)                      #negative X2
 
    ret

bestsqrt:
    la t0, XC
    lw t1, 0(t0)
    la t2, Y
    lw t3, 0(t2)
    la t4, DC
    lw t5, 0(t4)
    la a1, X1        #positive
    lw a2, 0(a1)
    li a6, -1

    #Y² and DC²
    mul t3, t3, t3 #y²
    mul t5, t5, t5 #dc²

    #positive sqrt (X1)
    sub a4, a2, t1
    mul a4, a4, a4
    add a4, a4, t3
    sub a4, a4, t5

    addi a1, a1, 4

    #negative sqrt (X2)
    lw a3, 0(a1)
    sub a5, a3, t1
    mul a5, a5, a5
    add a5, a5, t3
    sub a5, a5, t5

    addi a1, a1, 4

    bge a4, x0, second
    mul a4, a4, a6

    second:
    bge a5, x0, result
    mul a5, a5, a6

    result:
    blt a4, a5, positive_sqrt
    sw a3, 0(a1)                   # - SQRT
    ret

    positive_sqrt:
    sw a2, 0(a1)                   # SQRT
    ret

tostring:
    li t1, 1000
    li t2, 100
    li t3, 10
    li t4, '-'   
    li t5, '+'
    li t6, ' '
    li a6, -1
    la a2, X
    la a5, output
    li a1, 0
    li a7, 2

    paridade:
    lw t0, 0(a2)
    sw t5, 0(a5)
    bge t0, x0, 1f
    sw t4, 0(a5)
    mul t0, t0, a6

    1:
    addi a5, a5, 1
    #lw t0, 0(a2)
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

    

    addi a1, a1, 1
    addi a5, a5, 1
    beq a1, a7, 1f
    
    sw t6, 0(a5)
    addi a5, a5, 1
    la a2, Y
    j paridade

    1:
    li a6, '\n'
    sw a6, 0(a5)
    ret
    
write:
    li a0, 1            # file descriptor = 1 (stdout)
    la a1, output       # buffer
    li a2, 12           # size
    li a7, 64           # syscall write (64)
    ecall

.bss

input1_address:
    .skip 0xc  # buffer
input2_address:
    .skip 0x14  # buffer
YB:
    .skip 0x4
XC:
    .skip 0x4
TA:
    .skip 0x4
TB:
    .skip 0x4
TC:
    .skip 0x4
TR:
    .skip 0x4
DA:
    .skip 0x4
DB:
    .skip 0x4
DC:
    .skip 0x4
Y:
    .skip 0x4
X1:
    .skip 0x4
X2:
    .skip 0x4
X:
    .skip 0x4
output:
    .skip 0xc

.data

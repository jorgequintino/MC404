.globl _start
_start:
    #first command
    la a0, buffer
    jal gets
    jal atoi

    #operations to be done
    li t0, 1
    beq a0, t0, straight           #read and write
    addi t0, t0, 1
    beq a0, t0, reversed           #read and write inverted
    addi t0, t0, 1
    beq a0, t0, turntohex          #change its base
    addi t0, t0, 1
    beq a0, t0, algebric           #algebric operation

    straight:
    la a0, buffer
    jal gets
    jal puts
    j itsover

    reversed:
    la a0, buffer
    jal gets
    mv t0, a1
    mv t6, t3
    jal invert_string_func
    jal puts

    j itsover

    turntohex:
    la a0, buffer
    jal gets
    jal atoi
    la a1, buffer
    li a2, 16
    jal itoa
    jal puts
    j itsover

    algebric:
    la a0, buffer
    jal gets
    jal algebric_func
    la a1, buffer
    li a2, 10
    jal itoa
    jal puts
    j itsover

    itsover:
    jal exit

#write function
puts:
    addi sp, sp, -8                   
    sw ra, 4(sp)
    sw fp, 0(sp)
    addi fp, sp, 8

    mv a2, a0                         #moves a0 into a2 (next register available)
    li t1, 0                          #loads '\0' on t1
    li t3, '\n'

    writting:
    mv a1, a2
    lbu t0, 0(a2)                     #loads char on t0
    beq t0, t1, over                  #if char is '\0'
    jal write
    addi a2, a2, 1                    #next position
    j writting
    
    over:
    
    sb t3, 0(a2)                      #loads '\n' on t3
    mv a1, a2                         #moves a0 to a1 (str adress)
    jal write

    lw fp, 0(sp)
    lw ra, 4(sp)
    addi sp, sp, 8

    li a0, 0                          #value of return
    ret

#read function
gets:
    addi sp, sp, -16
    sw a0, 8(sp)
    sw ra, 4(sp)
    sw fp, 0(sp)
    addi fp, sp, 16

    li t0, 0                        #loads '\0' to t0
    li t1, '\n'                     #loads '\n' to t1
    li t3, 0
    mv a1, a0                       #moves str adress to a1

    reading:
    jal read
    lbu t2, 0(a1)                   #load read byte on t2
    beq t2, t0, fim                 #if said byte is '\0'
    beq t2, t1, fim                 #if said byte is '\n'
    addi a1, a1, 1
    addi t3, t3, 1
    j reading
    
    fim:

    sb t0, 0(a1)                    # loads '\0' (t0) on string

    lw fp, 0(sp)
    lw ra, 4(sp)
    lw a0, 8(sp)
    addi sp, sp, 16

    ret

#toNumeric function
atoi:
    addi sp, sp, -8
    sw ra, 4(sp)
    sw fp, 0(sp)
    addi fp, sp, 8

    #sets constants
    mv a1, a0
    li a2, 0
    li t4, '-'
    li t3, 0
    li t2, 1
    li t1, 10

    lbu t0, 0(a1)                               #first algorism

    bne t0, t4, while                           #is positive
    addi a1, a1, 1
    li t2, -1                                   #marks as negative
    
    while:
    lbu t0, 0(a1)                               #next algorism
    beq t0, t3, finito

    mul a2, a2, t1                              #multiply by 10 what we have
    addi t0, t0, -48                            #tonumeric
    add a2, a2, t0                              #add to what we have
    
    addi a1, a1, 1                              #prox byte
    j while

    finito:                                     #multiply by 1 or -1
    mul a2, a2, t2
    mv a0, a2                                   #return value
    
    lw fp, 0(sp)
    lw ra, 4(sp)
    addi sp, sp, 8

    ret

#soving algebric expressions
algebric_func:
    addi sp, sp, -8
    sw ra, 4(sp)
    sw fp, 0(sp)
    addi fp, sp, 8

    #sets constants
    mv a1, a0
    li a2, 0
    li t5, 0
    li t4, '-'
    li t3, ' '
    li t2, 1
    li t1, 10

    lbu t0, 0(a1)                               #first algorism

    bne t0, t4, while_alg                       #is positive
    addi a1, a1, 1
    li t2, -1                                   #marks as negative
    
    while_alg:
    lbu t0, 0(a1)                               #next algorism
    beq t0, t3, operator
    beq t0, t5, operator

    mul a2, a2, t1                              #multiply by 10 what we have
    addi t0, t0, -48                            #tonumeric
    add a2, a2, t0                              #add to what we have
    
    addi a1, a1, 1                              #prox byte
    j while_alg

    operator:                                   #multiply by 1 or -1
    mul a2, a2, t2
    mv a5, a2

    #moves to algebric expression operator
    addi a1, a1, 1
    lbu t0, 0(a1)
    mv a6, t0                                   #saves it at a register
    addi a1, a1, 2

    #getting the next number
    li a2, 0
    li t2, 1

    lbu t0, 0(a1)                               #first algorism

    bne t0, t4, while_alg2                      #is positive
    addi a1, a1, 1
    li t2, -1                                   #marks as negative
    
    while_alg2:
    lbu t0, 0(a1)                               #next algorism
    beq t0, t5, lastnumber
    beq t0, t3, lastnumber

    mul a2, a2, t1                              #multiply by 10 what we have
    addi t0, t0, -48                            #tonumeric
    add a2, a2, t0                              #add to what we have
    
    addi a1, a1, 1                              #prox byte
    j while_alg2

    lastnumber:
    mul a2, a2, t2
    mv a7, a2

    #checks which operations is to be done
    li t0, '+'
    beq a6, t0, soma
    li t0, '-'
    beq a6, t0, subtracao
    li t0, '*'
    beq a6, t0, mult
    li t0, '/'
    beq a6, t0, divisao

    soma:
    add a2, a5, a7
    j opover

    subtracao:
    sub a2, a5, a7
    j opover

    mult:
    mul a2, a5, a7
    j opover

    divisao:
    div a2, a5, a7
    j opover

    opover:
    mv a0, a2                                   #return value
    
    lw fp, 0(sp)
    lw ra, 4(sp)
    addi sp, sp, 8

    ret

#toString function
itoa:
    addi sp, sp, -16
    sw a1, 8(sp)
    sw ra, 4(sp)
    sw fp, 0(sp)
    addi fp, sp, 16

    li t1, '-'
    li t2, 1
    li t3, 10
    la t4, inverted_buffer
    li t5, 16
    li t6, 0                                        #sets buffer size

    #which base
    beq a2, t3, decimal
    beq a2, t5, hexadecimal

    decimal:
    
    bge a0, x0, positive                            #checks if it's positive or negative
    li t2, -1
    mul a0, a0, t2                                  #turns it to positive

    #saves the number inverted
    positive:

    rem a4, a0, a2                                  #gets whats left to divide
 
    addi a4, a4, '0'                                #turns to char
    sb a4, 0(t4)                                    #stores it on inverted buffer
    addi t4, t4, 1                                  #moves position on buffer
    addi t6, t6, 1                                  #updates buffer size
    div a0, a0, a2

    beq a0, x0, negatives                           #if is '\0'
    j positive
    
    negatives:
    #in case it is not positive, needs the '-' char before inverting
    bge t2, x0, inverting                           
    sb t1, 0(t4)
    addi t4, t4, 1
    addi t6, t6, 1

    j inverting    

    hexadecimal:
   
    #same logic from decimal, but considering when there's letters
    remu a4, a0, a2
    bge a4, t3, letter

    addi a4, a4, '0'
    sb a4, 0(t4)
    addi t4, t4, 1
    addi t6, t6, 1
    divu a0, a0, a2

    beq a0, x0, inverting
    j hexadecimal

    letter:

    addi a4, a4, '7'
    sb a4, 0(t4)
    addi t4, t4, 1
    addi t6, t6, 1
    divu a0, a0, a2

    beq a0, x0, inverting
    j hexadecimal

    #puts the last char of inverted buffer at first on normal buffer (a1, buffer adress)
    inverting:
    addi t4, t4, -1
    
    beq t6, x0, finish
    lbu a0, 0(t4)
    sb a0, 0(a1)

    addi a1, a1, 1
    addi t6, t6, -1

    j inverting

    finish:
    #finishing string with null char '\0'
    addi t4, t4, 1
    sb x0, 0(a1)
    mv a0, a1

    lw fp, 0(sp)
    lw ra, 4(sp)
    lw a0, 8(sp)
    addi sp, sp, 16

    ret

#reverse a string
invert_string_func:
    addi sp, sp, -16
    sw ra, 4(sp)
    sw fp, 0(sp)
    addi fp, sp, 16

    la t4, inverted_buffer
    sw t4, 8(sp)
    
    #puts the last char of original buffer at first on inverted buffer
    invert:
    addi t0, t0, -1
    
    beq t6, x0, over_invert
    lbu a0, 0(t0)
    sb a0, 0(t4)

    addi t4, t4, 1
    addi t6, t6, -1

    j invert

    over_invert:
    lw fp, 0(sp)
    lw ra, 4(sp)
    lw t4, 8(sp)
    mv a0, t4
    addi sp, sp, 16

    ret

#leaving function
exit:
    li a0, 0
    li a7, 93
    ecall
    ret

read:
    addi sp, sp, -4
    sw ra, 0(sp)

    #gets base adress 
    la a0, base_address
    lw a0, 0(a0)

    #sets peripheral to read a byte
    li a5, 1
    sb a5, 2(a0)

    read_it:
    lbu a2, 2(a0)
    bnez a2, read_it                      #until register is set 0, it's not finished
    lbu a2, 3(a0)                         #loads byte read
    sb a2, 0(a1)                          #stores it on buffer
    mv a0, a2

    lw ra, 0(sp)
    addi sp, sp, 4
    ret
write:
    addi sp, sp, -4
    sw ra, 0(sp)

    #gets base adress
    la a4, base_address
    lw a4, 0(a4)
    
    lbu a1, 0(a1)                          #load char from buffer
    beqz a1, finish_writing                #if its a null char, finish writing
    sb a1, 1(a4)                           #store the byte to write

    #sets peripheral to write
    li a5, 1
    sb a5, 0(a4)

    write_it:
    lbu a0, 0(a4)
    bnez a0, write_it                      #until register is set 0, it's not finished

    finish_writing:

    lw ra, 0(sp)
    addi sp, sp, 4
    ret
.bss
    buffer: .skip 200
    inverted_buffer: .skip 200
.data
    base_address: .word 0xFFFF0100

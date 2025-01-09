.globl puts
#write function
puts:
    addi sp, sp, -8                   
    sw ra, 4(sp)
    sw fp, 0(sp)
    addi fp, sp, 8

    mv a3, a0                         # moves a0 into a3 (next register available)
    li t1, 0                          #loads '\0' on t1
    li t2, 0                          #sets str on t2 to call write
    li t3, '\n'

    #gets str size
    writting:
    lbu t0, 0(a3)                     #loads char on t0
    beq t0, t1, over                  #if char is '\0'
    addi t2, t2, 1                    #bigger size
    addi a3, a3, 1                    #next position
    j writting
    
    over:

    addi t2, t2, 1                    #updates size
    sb t3, 0(a3)                      #loads '\n' on t3
    mv a1, a0                         #moves a0 to a1 (str adress)
    mv a2, t2                         #moves t2 to a2 (str size)
    jal write

    lw fp, 0(sp)
    lw ra, 4(sp)
    addi sp, sp, 8

    li a0, 0                         #value of return
    ret

.globl gets
#read function
gets:
    addi sp, sp, -16
    sw a0, 8(sp)
    sw ra, 4(sp)
    sw fp, 0(sp)
    addi fp, sp, 16

    li t0, 0                        #loads '\0' to t0
    li t1, '\n'                     #loads '\n' to t1
    mv a1, a0                       #moves str adress to a1

    reading:
    jal read
    lbu t2, 0(a1)                   # load read byte on t2
    beq t2, t0, fim                 # if said byte is '\0'
    beq t2, t1, fim                 # if said byte is '\n'
    addi a1, a1, 1
    j reading
    
    fim:

    sb t0, 0(a1)                   # loads '\0' (t0) on string

    lw fp, 0(sp)
    lw ra, 4(sp)
    lw a0, 8(sp)
    addi sp, sp, 16

    ret

.globl atoi
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

.globl itoa
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
    rem a4, a0, a2
    bge a4, t3, letter

    addi a4, a4, '0'
    sb a4, 0(t4)
    addi t4, t4, 1
    addi t6, t6, 1
    div a0, a0, a2

    beq a0, x0, inverting
    j hexadecimal

    letter:

    addi a4, a4, '7'
    sb a4, 0(t4)
    addi t4, t4, 1
    addi t6, t6, 1
    div a0, a0, a2

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

.globl exit
#leaving function
exit:
    li a0, 0
    li a7, 93
    ecall
    ret

read:
    addi sp, sp, -4
    sw ra, 0(sp)

    li a0, 0                                      # file descriptor = 0 (stdin)
    li a2, 1                                      # size (reads only 1 byte)
    li a7, 63                                     # syscall read (63)
    ecall

    lw ra, 0(sp)
    addi sp, sp, 4
    ret

write:
    addi sp, sp, -4
    sw ra, 0(sp)

    li a0, 1                                      # file descriptor = 1 (stdout)
    li a7, 64                                     # syscall write (64)
    ecall

    lw ra, 0(sp)
    addi sp, sp, 4
    ret

.globl recursive_tree_search
#binary tree search function
recursive_tree_search:
    addi sp, sp, -12
    sw ra, 4(sp)
    sw fp, 0(sp)
    addi fp, sp, 12

    beqz a0, node_null                       #checks if it is a null node [==0]
    lw t0, 0(a0)                             #loads the value from node on t0
    beq t0, a1, found_it                     #checks if the current analysed value is the one being searched

    #loads the adresses for the next nodes
    lw t1, 4(a0)                             #left node adress on t1
    lw t2, 8(a0)                             #right node adress on t2
    sw t2, 8(sp)                             #stores the adress for the right node on stack

    #goes to left node first
    mv a0, t1
    jal recursive_tree_search
    bnez a0, update_depth                    #checks if ao!= 0. if so, the value was found and its depth must be updated retroactively

    #goes to right node 
    lw t2, 8(sp)                             #corrects the adress to said node from possible recursive calling changes
    mv a0, t2
    jal recursive_tree_search
    bnez a0, update_depth                    #checks if ao!= 0. if so, the value was found and its depth must be updated retroactively

    node_null:
    li a0, 0
    j closed

    found_it:
    li a0, 1                                 #sets depth as 1 on the node where the searched value was found
    j closed

    update_depth:
    addi a0, a0, 1                           #adds 1 for each recursive comeback

    closed:
    lw fp, 0(sp)
    lw ra, 4(sp)
    lw t2, 8(sp)
    addi sp, sp, 12
    ret

.bss
    buffer: .skip 100
    inverted_buffer: .skip 100
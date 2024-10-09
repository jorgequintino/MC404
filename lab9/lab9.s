.text
.global _start

_start:
    jal read
    la a1, input_address
    jal tonumeric

    addi s9, x0, -1                             #counter of nodes

    jal search

    jal tostring
    jal write

    jal exit

tonumeric:
    li t6, 'g'
    li t5, '0'
    li t4, '-'
    li t3, 'a'
    li a7, 1
    li t1, 10
    # a1 has input_address

    lbu t0, 0(a1)                               #first algorism

    bne t0, t4, begin
    addi a1, a1, 1
    li a7, -1
    lbu t0, 0(a1)

    begin:

    bge t0, t3, letters

    addi t0, t0, -48                            #tonumeric
    mv a3, t0                                   #moves it to a3
    addi a1, a1, 1                              #prox byte
    j while

    letters:
    addi t0, t0, -87                            #tonumeric
    mv a3, t0                                   #moves it to a3
    addi a1, a1, 1                              #prox byte
    
        
    while:
    lbu t2, 0(a1)                               #second agorism
    blt t2, t5, final                          #checks if it's between 0 and f
    bge t2, t6, final

    bge t2, t3, whileletters

    mul a3, a3, t1                              # multiply by 10 what we have
    addi t2, t2, -48                            #tonumeric
    add a3, a3, t2                              #add to what we have
    
    addi a1, a1, 1                              #prox byte
    j while

    whileletters:
    mul a3, a3, t1                              # multiply by 10 what we have
    addi t2, t2, -87                            #tonumeric
    add a3, a3, t2                              #add to what we have
    
    addi a1, a1, 1                              #prox byte
    j while

    final:
    mul a3, a3, a7
    mv s1, a3
    
    ret

search:
    la s2, head_node
    mv s11, s1                                             #moves the searched value to s11

    first:
    addi s9, s9, 1                                         #which node we're checking
    lw s3, 0(s2)
    
    addi s2, s2, 4                                         #next item of that node
    lw s4, 0(s2)
    
    add t6, s3, s4                                         #multiply both values
    beq s11, t6, found                                     #checks if it's a match

    #not a match
    addi s2, s2, 4                                         
    
    lw s5, 0(s2)                                          #gets the address to next node
    mv s2, s5
    lw s5, 0(s2)
    bnez s5, first                                        #if its value is not zero, continue searching

    #there's no more nots to look at
    la a3, node_position
    li a7, -1
    sw a7, 0(a3)
    j end                                                 #end of search, returns -1 at node_position

    found:
    la a3, node_position
    sw s9, 0(a3)
    
    end:
    ret

read:
    li a0, 0                                      # file descriptor = 0 (stdin)
    la a1, input_address                          #  buffer to write the data
    li a2, 20                                     # size (reads only 1 byte)
    li a7, 63                                     # syscall read (63)
    ecall
    ret

tostring:
    la a1, node_position
    lw a2, 0(a1)
    li t1, 0
    li t2, '-'
    li t3, -1
    li t4, 10
    li t5, '\n'
    li a1, 100
    la a3, output

    bge a2, t1, positive                            #checks if it's positive or negative
    sw t2, 0(a3) 
    addi a3, a3, 1
    mul a2, a2, t3                                  #turns it to positive
    j finish

    positive:

    blt a2, t4, finish                              #it can't be divided by 10
    blt a2, a1, dividingbyten

    #divided by 100
    div t6, a2, a1                                    #quocient 
    addi t6, t6, '0'                                  #turns to string
    sw t6, 0(a3)                                      #saves it at output
    addi a3, a3, 1                                    #moves to next spot available at output
    rem a2, a2, a1                                    #gets what's left

    dividingbyten:

    #divided by 10 [0-99]:
    div t6, a2, t4                                    #quocient 
    addi t6, t6, '0'                                  #turns to string
    sw t6, 0(a3)                                      #saves it at output
    addi a3, a3, 1                                    #moves to next spot available at output
    rem a2, a2, t4                                    #gets what's left

    finish:
    #one algorism number [0-9]:
    addi a2, a2, '0'                                  #turns to string
    sw a2, 0(a3)                                      #saves it at output
    addi a3, a3, 1
    sw t5, 0(a3)    

    ret

write:
    li a0, 1                                      # file descriptor = 1 (stdout)
    la a1, output                                 # buffer
    li a2, 20                                     # size
    li a7, 64                                     # syscall write (64)
    ecall
    ret
exit:
    li a0, 0
    li a7, 93
    ecall
    ret

.bss

input_address:
    .skip 0x14  # buffer
node_position:
    .skip 0x4
output:
    .skip 0x14

.data

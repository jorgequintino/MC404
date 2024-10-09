.text
.global _start

_start:
    jal openfile
    mv s1, a0
    jal read
    jal measures
    
    jal setcanvassize
    jal processing
       
    mv a0, s1
    jal closefile
    jal exit

measures:
    la a2, windth
    la a1, input_address
    la a4, height
    li a5, 1                                    # counter of numbers
    li a6, 2
    li t1, 10
    li t5, '0'
    li t6, ':'
    addi a1, a1, 3
    
    begin:
    
    lbu t0, 0(a1)                               #first algorism
    addi t0, t0, -48                            #tonumeric
    mv a3, t0                                   #moves it to a3
    addi a1, a1, 1                              #prox byte
    
    while:
    lbu t2, 0(a1)                               #second agorism
    bltu t2, t5, second                         #checks if it's between 0 and 9
    bgeu t2, t6, second

    mul a3, a3, t1                              # multiply by 10 what we have
    addi t2, t2, -48                            #tonumeric
    add a3, a3, t2                              #add to what we have
    
    addi a1, a1, 1                              #prox byte
    j while

    second:
    sw a3, 0(a2)                                #saves first number, windth
    debug99:
    addi a1, a1, 1                              #prox byte

    lbu t0, 0(a1)                               #first algorism 
    addi t0, t0, -48
    mv a3, t0
    addi a1, a1, 1
    
    while2:
    lbu t2, 0(a1)
    bltu t2, t5, fim
    bgeu t2, t6, fim

    mul a3, a3, t1
    addi t2, t2, -48
    add a3, a3, t2
    
    addi a1, a1, 1
    j while2

    fim:
    sw a3, 0(a4)
    
    addi s2, a1, 5                              #position to start pixels

    ecall
    ret

processing:
    la t6, windth
    lw t1, 0(t6)
    la t6, height
    lw t2, 0(t6)
    mul t3, t1, t2
    addi t3, t3, -1                             #pixel list len
    li t4, 0                                    #for windth counter
    li t5, 0                                    #for height counter
    
    forwindth:
    
    bge t4, t1, updatewindth                     #t4 bigger than windth length counter, updates the height counter
    lbu t0, 0(s2)                                 #pixel

    # RED
    addi a5, t0, 0                               #load char in a5
    slli a5, a5, 24                              #bit shift to make sure its all zeros on right
    mv a2, a5                                    #store it on the right register

    #GREEN
    addi a5, t0, 0                               #load char in a5
    slli a5, a5, 16                              #bit shift to make sure its all zeros on right
    add a2, a2, a5                               #store it on the right register

    #BLUE
    addi a5, t0, 0                               #load char in a5
    slli a5, a5, 8                               #bit shift to make sure its all zeros on right
    add a2, a2, a5                               #store it on the right register

    #ALFA
    #add a5, t0, 255                               #add 225 to the char of the pixel
    
    #srli a5, a5, 24                               #bit shift to position it 
    #slli a5, a5, 24                               #bit shift to make sure its all zeros
    addi a2, a2, 255                                #store it on the right register

    mv s3, ra
    jal ra, setpixel
    mv ra, s3

    #progressing loop
    addi s2, s2, 1                               #increase list position of pixels

    addi t4, t4, 1                               #increase windth
    j forwindth

    updatewindth:
    li t4, 0                                     #sets windth counter to zero
    addi t5, t5, 1                               #progress on the height
    bge t5, t2, finish                           #if the height counter is equal to canvas height, finish
    j forwindth

    finish:
    #li s2, 0
    ecall
    ret

setpixel:
    mv a0, t4                                    #pixel's X coordenate
    mv a1, t5                                    #pixel's y coordenate
    li a7, 2200
    ecall
    ret

setcanvassize:
    la a2, windth
    lw a0, 0(a2)
    la a3, height
    lw a1, 0(a3)
    li a7, 2201
    ecall
    ret

openfile:
    la a0, input_file                            # address for the file path
    li a1, 0                                     # flags (0: rdonly, 1: wronly, 2: rdwr)
    li a2, 0                                     # mode
    li a7, 1024                                  # syscall open
    ecall
    ret

read:
    mv a0, s1                                    # Set file descriptor from s1
    la a1, input_address                         #  buffer to write the data
    li a2, 0x40010                               # size (reads only 1 byte)
    li a7, 63                                    # syscall read (63)
    ecall
    ret

closefile:
    li a7, 57                                    # syscall close
    ecall
    ret

exit:
    li a0, 0
    li a7, 93
    ecall
    ret

.bss

input_address:
    .skip 0x40010             # buffer
windth:
    .skip 0x4
height:
    .skip 0x4
output3:
    .skip 0x4

.data

input_file: .asciz "image.pgm"

.text
.global _start

_start:
    jal readfirst
    jal readsecond
    jal processing_first
    jal processing_second
    jal processing_third
    jal write1
    jal write2
    jal write3
    exit:
    li a0, 0
    li a7, 93
    ecall
    ret

readfirst:
    li a0, 0  # file descriptor = 0 (stdin)
    la a1, input1_address #  buffer to write the data
    li a2, 5  # size (reads only 1 byte)
    li a7, 63 # syscall read (63)
    ecall
    ret

readsecond:
    li a0, 0  # file descriptor = 0 (stdin)
    la a1, input2_address #  buffer to write the data
    li a2, 8  # size (reads only 1 byte)
    li a7, 63 # syscall read (63)
    ecall
    ret

processing_first:
    la t1, output1
    la a1, input1_address
    lb a2, 0(a1)          #d1
    lb a3, 1(a1)          #d2
    lb a4, 2(a1)          #d3
    lb a5, 3(a1)          #d4
    li t6, '\n'

    #p1
    xor t2, a2, a3
    xor t2, t2, a5
    sw t2, 0(t1)
    addi t1, t1, 1

    #p2
    xor t3, a2, a4
    xor t3, t3, a5
    sw t3, 0(t1)
    addi t1, t1, 1
    sw a2, 0(t1)
    addi t1, t1, 1


    #p3
    xor t4, a3, a4
    xor t4, t4, a5
    sw t4, 0(t1)
    addi t1, t1, 1
    sw a3, 0(t1)
    addi t1, t1, 1
    sw a4, 0(t1)
    addi t1, t1, 1
    sw a5, 0(t1)
    addi t1, t1, 1
    sw t6, 0(t1)

    ret

processing_second:
    la t0, output2
    la t1, input2_address
    lb a1, 0(t1)           #p1
    lb a2, 1(t1)           #p2
    lb a3, 2(t1)           #d1
    lb a4, 3(t1)           #p3
    lb a5, 4(t1)           #d2
    lb a6, 5(t1)           #d3
    lb a7, 6(t1)           #d4
    li t6, '\n'

    #d1
    sw a3, 0(t0)
    addi t0, t0, 1

    #d2
    sw a5, 0(t0)
    addi t0, t0, 1

    #d3
    sw a6, 0(t0)
    addi t0, t0, 1

    #d4
    sw a7, 0(t0)
    addi t0, t0, 1

    sw t6, 0(t0)

    ret

processing_third:
    la t0, output3
    la t1, input2_address
    lb a1, 0(t1)           #p1
    lb a2, 1(t1)           #p2
    lb a3, 2(t1)           #d1
    lb a4, 3(t1)           #p3
    lb a5, 4(t1)           #d2
    lb a6, 5(t1)           #d3
    lb a7, 6(t1)           #d4
    li t6, '\n'
    li t4, '0'
    li t5, '1'

    sw t4, 0(t0)

    #p1
    xor t2, a3, a5
    xor t2, t2, a7

    beq a1, t2, p2
    sw t5, 0(t0)
    j final

    p2:
    xor t2, a3, a6
    xor t2, t2, a7

    beq a2, t2, p3
    sw t5, 0(t0)
    j final

    p3:
    xor t2, a5, a6
    xor t2, t2, a7

    beq a4, t2, final
    sw t5, 0(t0)

    final:
    sw t6, 1(t0)
    ret

write1:
    li a0, 1            # file descriptor = 1 (stdout)
    la a1, output1      # buffer
    li a2, 8            # size
    li a7, 64           # syscall write (64)
    ecall


write2:
    li a0, 1            # file descriptor = 1 (stdout)
    la a1, output2      # buffer
    li a2, 5            # size
    li a7, 64           # syscall write (64)
    ecall

write3:
    li a0, 1            # file descriptor = 1 (stdout)
    la a1, output3      # buffer
    li a2, 2            # size
    li a7, 64           # syscall write (64)
    ecall

.bss

input1_address:
    .skip 0xc  # buffer
input2_address:
    .skip 0x14  # buffer
output1:
    .skip 0x8
output2:
    .skip 0x5
output3:
    .skip 0x2

.data

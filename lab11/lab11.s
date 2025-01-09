.text
.global _start

_start:
    # loads base address
    la t0, base_address
    lw t0, 0(t0)

    jal start_car
    jal move_to_destination
    jal stop_car
    jal exit

start_car:
    # starts the engine of the car
    li a0, 1
    sb a0, 0x21(t0)               # engine on

    # adjusting the wheel
    li a0, -15
    sb a0, 0x20(t0)

    ret

move_to_destination:
    # sets destination coordinates
    li t1, 73                     # X
    li t2, 1                      # Y
    li t3, -19                    # Z

    loop:
    # sets to read coordinates
    li a0, 1
    sb a0, 0x00(t0)

    # loads each coordenate on a register
    lw t4, 0x10(t0)               # X
    lw t5, 0x14(t0)               # Y
    lw t6, 0x18(t0)               # Z

    # checks if the car has arrived
    beq t1, t4, arrived          # matching X coordinate
    beq t2, t5, arrived          # matching Y coordinate
    beq t3, t6, arrived          # matching Z coordinate

    # loop
    j loop

    arrived:
    ret

stop_car:
    # turn off the engine
    li a0, 0                      # engine off
    sb a0, 0x21(t0)
    
    # sets handbreak
    li a0, 1                      # handbreak on
    sb a0, 0x22(t0)

    ret
    
exit:
    li a0, 0
    li a7, 93
    ecall
    ret

.data
base_address: .word 0xFFFF0100
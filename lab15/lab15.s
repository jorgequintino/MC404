.text
.align 4

int_handler:
  ###### Manipulador de Syscalls e Interrupções ######

  # Implementar o manipulador de syscalls aqui

  # Guardar o contexto antes de manipular a syscall
  addi sp, sp, -16
  sw ra, 12(sp)
  sw t0, 8(sp)
  sw t1, 4(sp)
  sw t2, 0(sp)

  # Identificar o código do syscall (armazenado em a7)
  csrr t0, mepc         # Carregar endereço de retorno
  li t1, 10             # Código do syscall_set_engine_and_steering
  beq a7, t1, handle_set_engine_and_steering

  li t1, 11             # Código do syscall_set_hand_brake
  beq a7, t1, handle_set_hand_brake

  li t1, 12             # Código do syscall_read_line_camera
  beq a7, t1, handle_read_line_camera

  li t1, 15             # Código do syscall_get_position
  beq a7, t1, handle_get_position

  # Retornar ao ponto de interrupção
  addi t0, t0, 4        # Adicionar 4 ao endereço de retorno (para continuar após o ecall)
  csrw mepc, t0
  # Restaurar o contexto
  lw ra, 12(sp)
  lw t0, 8(sp)
  lw t1, 4(sp)
  lw t2, 0(sp)
  addi sp, sp, 16
  mret

  handle_set_engine_and_steering:
  # Implementar syscall_set_engine_and_steering
  # Parâmetros:
  # a0: direção do movimento (-1, 0, 1)
  # a1: ângulo do volante (-127 a 127)
  li t2, -1            # Validar parâmetros
  bgt a0, t2, invalid_parameters
  li t2, 1
  blt a0, t2, invalid_parameters
  li t2, 127
  blt a1, t2, invalid_parameters
  li t2, -127
  bgt a1, t2, invalid_parameters

  # Definir o valor nos registradores de MMIO
  li t1, 0x10000020    # Endereço do volante
  sb a1, 0(t1)         # Armazenar valor do ângulo do volante
  li t1, 0x10000021    # Endereço do motor
  sb a0, 0(t1)         # Armazenar direção do motor
  li a0, 0             # Sucesso
  j return_from_handler

  handle_set_hand_brake:
  # Implementar syscall_set_hand_brake
  # Parâmetros:
  # a0: 1 para usar o freio de mão, 0 para liberar
  li t1, 0x10000022    # Endereço do freio de mão
  sb a0, 0(t1)         # Armazenar valor do freio de mão
  j return_from_handler

  handle_read_line_camera:
  # Implementar syscall_read_line_camera
  # Parâmetros:
  # a0: endereço do array de 256 elementos que armazenará os dados da câmera de linha
  li t1, 0x10000024    # Endereço da câmera de linha
  lw t2, 0(t1)         # Carregar o endereço base
  mv t3, a0            # Carregar o endereço do array
  li t4, 256           # Definir o tamanho do array
  copy_camera_data:
  lbu t5, 0(t2)        # Ler byte da câmera
  sb t5, 0(t3)         # Armazenar no array
  addi t2, t2, 1       # Próximo byte da câmera
  addi t3, t3, 1       # Próximo byte do array
  addi t4, t4, -1      # Decrementar contador
  bnez t4, copy_camera_data
  j return_from_handler

  handle_get_position:
  # Implementar syscall_get_position
  # Parâmetros:
  # a0: endereço da variável para armazenar a posição X
  # a1: endereço da variável para armazenar a posição Y
  # a2: endereço da variável para armazenar a posição Z
  li t1, 0x10000010    # Endereço da posição X
  lw t2, 0(t1)         # Ler posição X
  sw t2, 0(a0)         # Armazenar na variável
  li t1, 0x10000014    # Endereço da posição Y
  lw t2, 0(t1)         # Ler posição Y
  sw t2, 0(a1)         # Armazenar na variável
  li t1, 0x10000018    # Endereço da posição Z
  lw t2, 0(t1)         # Ler posição Z
  sw t2, 0(a2)         # Armazenar na variável
  j return_from_handler

  invalid_parameters:
  li a0, -1            # Parâmetros inválidos
  j return_from_handler

  return_from_handler:
  # Restaurar contexto
  lw ra, 12(sp)
  lw t0, 8(sp)
  lw t1, 4(sp)
  lw t2, 0(sp)
  addi sp, sp, 16
  #mret

  csrr t0, mepc       # Carregar o endereço de retorno (endereço da instrução que invocou o syscall)
  addi t0, t0, 4      # Adiciona 4 ao endereço de retorno (para retornar após o ecall)
  csrw mepc, t0       # Armazena o endereço de retorno no mepc
  mret                # Recupera o contexto restante (pc <- mepc)

.globl _start
_start:
  la t0, int_handler  # Carrega o endereço da rotina que vai tratar as interrupções
  csrw mtvec, t0      # Define o vetor de interrupção (e syscalls) no registrador MTVEC

  # Código para trocar para o modo usuário e chamar a função user_main
  # Inicializar a pilha do usuário aqui

  li t0, 0x180        # Configurar o valor no MSTATUS para mudar para o modo usuário
  csrw mstatus, t0    # Atualizar o MSTATUS para modo usuário
  li sp, 0x2000       # Inicializar a pilha do usuário
  la t0, user_main    # Carregar o endereço da função user_main
  csrw mepc, t0       # Definir o PC de retorno para user_main
  mret                # Trocar para o modo usuário e iniciar a execução

.globl control_logic
control_logic:
  # Inicializar variáveis para posição do carro e estado
  la a0, x_pos        # Carregar endereço da variável que armazena a posição x
  la a1, y_pos        # Carregar endereço da variável que armazena a posição y
  la a2, z_pos        # Carregar endereço da variável que armazena a posição z

  # Chamar syscall para obter a posição do carro
  li a7, 15           # Código do syscall_get_position
  ecall               # Executar syscall para obter posição

  # Lógica de controle para mover o carro até a entrada da pista
  # Exemplo: Iniciar o motor e definir a direção
  li a0, 1            # Mover para frente
  li a1, 0            # Direção reta
  li a7, 10           # Código do syscall_set_engine_and_steering
  ecall               # Executar syscall para definir motor e direção

  # Lógica para desativar o freio de mão
  li a0, 0            # Desativar freio de mão
  li a7, 11           # Código do syscall_set_hand_brake
  ecall               # Executar syscall para desativar o freio de mão

  # Loop para continuar o movimento até atingir o objetivo
control_loop:
  # Lógica para ler a câmera de linha e ajustar a direção
  la a0, line_data    # Endereço do array para armazenar dados da câmera de linha
  li a7, 12           # Código do syscall_read_line_camera
  ecall               # Executar syscall para ler a câmera de linha

  # Ajustar direção com base nos dados da câmera (exemplo simplificado)
  li a0, 1            # Mover para frente
  li a1, 20           # Direção levemente para a direita
  li a7, 10           # Código do syscall_set_engine_and_steering
  ecall

  # Repetir a leitura e o ajuste até atingir a entrada da pista
  j control_loop

# Definir variáveis
.data
x_pos: .word 0
y_pos: .word 0
z_pos: .word 0
line_data: .space 256   # Array para armazenar dados da câmera de linha

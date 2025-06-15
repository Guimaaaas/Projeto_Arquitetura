
		# Constantes
.eqv	keyboard_status 0xFFFF0000  # Endereco do status do teclado
.eqv	display_status  0xFFFF0008  # Endereco do status do display
.eqv	keyboard_buffer 0xFFFF0004  # Endereco do buffer do teclado
.eqv	display_buffer  0xFFFF000C  # Endereco do buffer do display

.data


	banner:  		.asciiz "ACT-shell>>"   # String padrao a ser exibida no MMIO
	input_usuario: 		.space 100    # Espaco reservado para o comando digitado pelo usuario
	
	# Caracteres
	barra_n:   	  .byte 10      # Valor em ASCII do caractere de quebra de linha '\n'
	traco:      	  .byte 45      # Valor em ASCII do caractere '-'
	virgula:          .byte 44      # Valor em ASCII do caractere ','
	abre_chave:       .byte 123     # Valor em ASCII do caractere '{'
	fecha_chave:      .byte 125     # Valor em ASCII do caractere '}'
	abre_colchete:    .byte 91      # Valor em ASCII do caractere '['
	fecha_colchete:   .byte 93      # Valor em ASCII do caractere ']'
	
	# Comandos
	comando_adicionar_morador: 		.asciiz "ad_morador"
	comando_remover_morador: 		.asciiz "rm_morador"
	comando_adicionar_automovel: 		.asciiz "ad_auto"
	comando_remover_automovel:		.asciiz "rm_auto"
	comando_limpar_apartamento:		.asciiz "limpar_ap"
	comando_informacaos_apartamento:	.asciiz "info_ap"
	comando_informacaos_geral:		.asciiz "info_geral"
	comando_salvar_txt:			.asciiz "salvar"
	comando_recarregar_txt:			.asciiz "recarregar"
	comando_limpar_dados:			.asciiz "formatar"
	
	# Repositorios
	repositorio_apto:           		.space 7000 # Espaco reservado para a gravacao temporaria dos apartamentos cadastrados
	apto_repositorio_externo:     	 	.asciiz  "apartamento.txt"	
	
	# Mensagens de erro:
	msg_comando_invalido:			.asciiz "Comando invalido"
	msg_maximo_moradores:			.asciiz "Falha: AP com numero max de moradores"
	msg_apto_invalido:			.asciiz "Falha: AP invalido"
	msg_morador_nao_encontrado:		.asciiz "Falha: morador nao encontrado"
	msg_maximo_automoveis:			.asciiz "Falha: AP com numero max de automóveis"
	msg_tipo_invalido:			.asciiz "Falha: tipo invalido"
	msg_automovel_nao_encontrado:		.asciiz "Falha: automovel nao encontrado"
	
	# Mensagens de retorno:
	msg_apto_vazio:				.asciiz "Apartamento vazio"
	
.text

carregar_externo:
	jal ler_dados          # função que chama syscall e carrega o arquivo
	j main       	       # segue execução principal


main:

	# Ponteiro do buffer de input
	la $t0, input_usuario      # $t0 = endereço base do buffer
	li $t1, 0                  # $t1 = offset atual

leitura_input:
	# Imprimir o banner
	li $v0, 4
	la $a0, banner
	syscall

esperar_tecla:
	lw $t2, keyboard_status
	andi $t2, $t2, 1           # Verifica se bit 0 está setado (tecla pressionada)
	beqz $t2, esperar_tecla    # Se não, espera

	# Ler caractere
	lw $t3, keyboard_buffer    # $t3 = caractere lido

	sb $t3, 0($t0)             # Salva caractere no buffer
	addiu $t0, $t0, 1          # Avança ponteiro
	addi  $t1, $t1, 1          # Conta caractere lido

	# Verifica se é \n (barra_n tem valor 10)
	la $t4, barra_n
	lb $t4, 0($t4)
	beq $t3, $t4, final_input

	j esperar_tecla            # Continua lendo

final_input:
	li $t5, 0                  # Byte nulo
	sb $t5, 0($t0)             # Coloca nulo ao final do buffer

	# Aqui você pode seguir com o parser ou comando interpretador
	j main                     # Por enquanto, reinicia leitura

ler_dados:
    li   $v0, 13
    la   $a0, apto_repositorio_externo
    li   $a1, 0
    li   $a2, 0
    syscall
    move $s0, $v0
    bltz $s0, fim_carregar

    li   $v0, 14
    move $a0, $s0
    la   $a1, repositorio_apto
    li   $a2, 4500
    syscall

    li   $v0, 16
    move $a0, $s0
    syscall

fim_carregar:
    jr $ra



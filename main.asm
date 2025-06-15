
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
	repositorio_apto:           		.space 4500 # Espaco reservado para a gravacao temporaria dos apartamentos cadastrados
	apto.txt:     	 			.asciiz  "apartamento.txt"	
	
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


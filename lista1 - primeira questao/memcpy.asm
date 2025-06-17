# UFRPE - ARQUITETURA E ORGANIZAÇ�O DE COMPUTADORES - 2025.1 
# PROFESSOR: VITOR COUTINHO
# GRUPO: TULIO FALCAO - OTAVIO OLIMPIO - CARLOS EDUARDO - ARTUR GUIMARAES
# ATIVIDADE 1VA
# PRIMEIRA QUEST�O - LETRA B

# FUNÇ�O MEMCPY

.data

	# Dados para testar a funç�o memcpy
	fonte: .asciiz "Tulio Falcao"
	destino: .space 10

.text
	
	main:
		la $a0, destino
		la $a1, fonte
		li $a2, 8
		
		jal memcpy
		
		jal imprime
		
		jal fim
		
	memcpy:
		move $t0, $a0 # salva o endereco original de a0 para t0
		
		beqz $a2, end # verifica se o numero de bytes a ser copiado e zero
		
		loop:
			lb $t1, 0($a1) # carrega um byte da fonte para t1
			sb $t1, 0($a0) # salva o byte carregado em t1 para o destino em a0 
			
			addi $a0, $a0, 1 # incrementa o ponteiro de destino para o proximo byte
			addi $a1, $a1, 1 # incrementa o ponteiro da fonte para o proximo byte
			addi $a2, $a2, -1 # Decrementa o contador de bytes
			
			bnez $a2, loop # se o contador nao for zero, retorna ao loop. Caso contrario, segue
		end:
			move $v0, $t0 # salva o endereco para o registrador v0 (saida da funcao)
			jr $ra # retorna para a linha de codigo que chamou a funcao
			
	imprime:
		move $a0, $v0 # move o valor em v0 para o registrador requerido para impress�o da string
		li $v0, 4 # comando para impress�o de string
		syscall # executa a chamada
		
	fim:
		li $v0, 10 # comando que finaliza o programa
		syscall # executa a chamada
		
		

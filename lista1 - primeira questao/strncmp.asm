# UFRPE - ARQUITETURA E ORGANIZAÇ�O DE COMPUTADORES - 2025.1 
# PROFESSOR: VITOR COUTINHO
# GRUPO: TULIO FALCAO - OTAVIO OLIMPIO - CARLOS EDUARDO - ARTUR GUIMARAES 
# ATIVIDADE 1VA
# PRIMEIRA QUEST�O - LETRA D

# FUNCAOO STRNCMP
.data

	# strings de teste
	string1: .asciiz "guitarra"
	string2: .asciiz "baixo"
	string3: .asciiz "gutarra"
	num: .word 3
	
	# strings de saida
	maiorQue: .asciiz "A primeira string � maior que a segunda, portanto as strings s�o diferentes"
	igual: .asciiz "As strings s�o iguais"
	menorQue: .asciiz "A primeira string � menor que a segunda, portanto as strings s�o diferentes"
	valor: .asciiz "Valor de retorno: "
	pulaLinha: .asciiz "\n"
	quantidade: .asciiz "Quantidade de caracteres comparados: "

.text

	main:
		la $a0, string1 # carrega uma string em a0 
		la $a1, string3 # carrega outra string para a1
		lw $a2, num # carrega o valor da quantidade de caracteres a ser comparada
		
		jal strcmp # chama a funç�o 
		
		move $s0, $v0 # move o retorno da funç�o para s0
		
		beqz $s0, imprimeIgual # se o valor de retorno for zero, significa que as string s�o iguais. Chama a funç�o que imprime o resultado
		bnez $s0, imprimeDiferente # se o valor de retorno for diferente de zero, as strings s�o diferentes. Chama a funç�o que imprime o resultado
				
	strncmp:
		move $t3, $a2 # carrega a quantidade de caracteres a ser comparada
		
		loop:
			lb $t0, 0($a0) # carrega o caractere da primeira string em t0
			lb $t1, 0($a1) # carrega o caractere da segunda string em t1
			
			sub $t2, $t0, $t1 # confere se os caracteres sao iguais, subtraindo os valores em t0 e t1. Se o resultado for zero, os caracteres sao iguais
			
			bnez $t2, saida # confere se o resultado da subtracao e diferente de zero. Se for, vai para a funcao saida e sai do loop.
			beqz $t0, saida # confere se o caractere da primeira string e NULL
			beqz $t1, saida # confere se o caractere da segunda string e NULL
			beqz $t3, saida # confere se o valor de quantidade de caracteres foi zerado
			
			# se o fluxo chegou aqui, e porque os caracteres sao iguais e nao nulos. O fluxo segue para o loop, incrementando-se um byte em t0 e t1 para se checar os proximos caracteres
			addi $a0, $a0, 1 
			addi $a1, $a1, 1
			addi $t3, $t3, -1
			j loop # retorna ao loop
			
		saida:
			move $v0, $t3 # como os caracteres foram diferentes ou NULL, o loop e quebrado e move-se o valor de t3 para o registrador v0 (retorno de funcao)
			jr $ra # pula para a linha que chamou a funcao
		
	
	imprimeIgual:
		# imprime a mensagem valor
		li $v0, 4 
		la $a0, valor
		syscall
		
		# imprime o valor em s0
		li $v0, 1
		add $a0, $zero, $s0
		syscall
		
		# pula linha
		li $v0, 4
		la $a0, pulaLinha
		syscall
		
		# imprime a quantidade de caracteres comparados
		li $v0, 4
		la $a0, quantidade
		syscall
		
		li $v0, 1
		add $a0, $zero, $a2
		syscall
		
		# pula linha
		li $v0, 4
		la $a0, pulaLinha
		syscall
		
		# imprime a mensagem do resultado de strings iguais
		li $v0, 4
		la $a0, igual
		syscall
		
		# finaliza o programa
		li $v0, 10
		syscall
		
	imprimeDiferente:
		
		# imprime a mensagem valor
		li $v0, 4
		la $a0, valor
		syscall
		
		# imprime o valor em s0
		li $v0, 1
		add $a0, $zero, $s0
		syscall
		
		# pula a linha
		li $v0, 4
		la $a0, pulaLinha
		syscall
		
		# imprime a quantidade de caracteres comparados
		li $v0, 4
		la $a0, quantidade
		syscall
		
		li $v0, 1
		add $a0, $zero, $a2
		syscall
		
		# pula linha
		li $v0, 4
		la $a0, pulaLinha
		syscall
		
		# confere se o valor em s0 � maior que zero. Se for, vai para a funç�o 'imprimeMior''. Caso cont�rio, imprime a mensagem menorQue
		bgtz $s0, imprimeMaior
		la $a0, menorQue
		syscall
		
		#finaliza o programa
		li $v0, 10
		syscall
		
	imprimeMaior:
		# imprime a mensagem maiorQue
		li $v0, 4
		la $a0, maiorQue
		syscall
		
		# finaliza o programa
		li $v0, 10
		syscall
	

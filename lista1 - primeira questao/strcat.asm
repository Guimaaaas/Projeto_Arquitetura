# UFRPE - ARQUITETURA E ORGANIZAÇ�O DE COMPUTADORES - 2025.1 
# PROFESSOR: VITOR COUTINHO
# GRUPO: TULIO FALCAO - OTAVIO OLIMPIO - CARLOS EDUARDO - ARTUR GUIMARAES
# ATIVIDADE 1VA
# PRIMEIRA QUEST�O - LETRA E

# FUNÇ�O STRCAT



.data

	destination: .asciiz "Ola, "
	source: .asciiz "Mundo!"
	buffer: .space 100
	
.text

	main:	
		# carrega os endereços das strings e chama a funç�o strcat
		la $a0, destination
		la $a1, source
		jal strcat
		
		# move o retorno da funç�o strcat para $a0 e imprime o resultado
		move $a0, $v0
		li $v0, 4
		syscall
		
		# finaliza o programa
		li $v0, 10
		syscall
		
	strcat:
		move $v0, $a0 # salva o endereço original da destination no registrador de retorno
		move $t0, $a0 # faz uma c�pia do endereço da destination para o registrador $t0
		move $t2, $a1 # move o endereço da source para t2
		
		encontraFimLoop:
			lb $t1, 0($t0) # carrega o byte da c�pia de destination em t1
			beqz $t1, copiaFonteLoop # se o byte for NULL, chama a funç�o que copia os bytes da string source
			addi $t0, $t0, 1 # se o byte n�o for NULL, incrementa um byte e retorna ao loop
			j encontraFimLoop
		
		copiaFonteLoop:
			lb $t3, 0($t2) # carrega o byte atual da string source apontado por t2 para t3
			sb $t3, 0($t0) # salva o caractere de source em destination
			
			beqz $t3, fimDaFuncao # se t3 for NULL, chama a funç�o
			
			addi $t0, $t0, 1 # avança o ponteiro de destination
			addi $t2, $t2, 1 # avança o ponteiro de source
			j copiaFonteLoop # continua o loop
			
		fimDaFuncao:
			jr $ra # retorna o valor 
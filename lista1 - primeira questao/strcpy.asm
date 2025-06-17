# UFRPE - ARQUITETURA E ORGANIZAÇ�O DE COMPUTADORES - 2025.1 
# PROFESSOR: VITOR COUTINHO
# GRUPO: TULIO FALCAO - OTAVIO OLIMPIO - CARLOS EDUARDO - ARTUR GUIMARAES 
# ATIVIDADE 1VA
# PRIMEIRA QUEST�O - LETRA A

# FUNÇ�O STRCPY

.data

	fonte: .asciiz "Opa!" # string para teste
	destino: .space 20 # espaço destinado � string na mem�ria

.text

	main:
		la $a0, destino #carrega o endereço de destino da string 
		la $a1, fonte #carrega a string
		
		jal strcpy # chama a função strcpy
		
		jal imprime # imprime a string copiada pela funç�o strcpy
		
		jal fim # finaliza o programa
	
	strcpy:
		move $t0, $a0 #move o endereco para t0 porque a0 sera necessario
		
		loop:
			lb $t1, 0($a1) # carrega para t1 o primeiro byte da string
			sb $t1, 0($a0) # armazena o byte em t1 no destino (a0)
			
			beqz $t1, end # verifica se t1 � igual a zero. Se o byte n�o for uma "letra" e for um "\n" (caracterizando o fim da string), seu valor ser� igual a zero. Se o byte for "\n" ele vai para a subfunç�o 'end'. Caso contr�rio, segue e volta para o loop
			
			addi $a0, $a0, 1 # como o byte em $t1 n�o � "\n" esta linha incrementa para o pr�ximo endereço a ser guardado o pr�ximo byte
			addi $a1, $a1, 1 # da mesma forma, incrementa-se a1 para ir para o byte seguinte da string
			
			j loop # com o endereço de destino e o byte da string devidamente incrementados, volta-se ao loop
		
		end:
			move $v0, $t0 #com o fim da string, a string em t0 � movida para o registrador que carregar� o valor de retorno da funç�o
			jr $ra #sai da funç�o e volta para a linha de c�digo que a chamou
			
	imprime:
		move $a0, $v0 # move o valor em v0 para o registrador requerido para impress�o da string
		li $v0, 4 # comando para impress�o de string
		syscall # executa a chamada
		
	fim:
		li $v0, 10 # comando que finaliza o programa
		syscall # executa a chamada
		
		

.data
	# Realizando o cadastro e insercao de apartamentos
	nome: .asciiz "Otavio Olimpio"
	apartamento: .asciiz "02"
	array_apartamentos: .space 8000 # Array de espacos do apartamento
	localArquivo: .asciiz "D:/Cursos/LC/2025.1/Arq. Org. Comp/Assembly/Assembly/Projeto/predio.txt"

.text 
	add $s2, $zero, $a1
	la $a0, apartamento
	la $a1, nome
	jal ad_pessoa
	
	j encerra

# Funcao para inserir pessoa em apartamento
ad_pessoa:

	# Definindo os limites de atuacao #
	
	# Adicionando em t1 a posicao do primeiro apartamento
	addi $t1, $s2, 0 
	# Adicionando em t2 o ultimo valor da ultima posicao do predio
	addi $t2, $t1, 8000
	# Adicionando em t3 o nome que esta armazenado em a1
	addi $t3, $a1, 0
	
	# Verificadando disponibilidade dos apartamentos
	analisador_apt:
		# Verificando a disponibilidade da posicao atual
		add $a1, $t1, 0
		# Salvando a posicao atual antes de chamar outra funcao
		addi $t4, $ra, $zero
		# Salvando o numero do apartamento de entrada a ser comparado antes de chamar outra funcao
		addi $t5, $a0, $zero
		# Verificar se as strings de entrada e a que esta armazenada s�o iguais
		jal strcmp
		# Resgatando o valor de ra apos a execucao da funcao
		addi $ra, $t4, $zero 
		# Resgatando o valor de a0 apos a execucao da funcao
		addi $a0, $t5, $zero
		# Se o retorno de strcmp for igual a 0, chamaremos uma funcao para inseir essa pessoa neste apartamento
		beq $v0, 0, ad_apartamento
		
		
		# Se o retorno de strcmp for diferente de 0, seguiremos para conferencia no proximo apartamento
		addi $t1, $t1, 200
		# Varificando de todos os apartamentos ja foram visitados
		beq $t1, $t2, nao_exite_apt
		# Volta para o inicio da funcao para verificar o proximo apartamento
		j analisador_apt
		
	# funcao para adicionar uma pessoa em um apartamento
	ad_apartamento:
		# Verificando as posicoes de cada apartamento
		addi $t1, $t1, 3 
		# Contador pois se passar de cinco excede a quantidade de pessoas neste apartamento
		addi $t5, $zero, 0
	
		# Varredura em cada apartamento por disponibilidade
		verificador_vaga:
			# Verifica nome a nome na busca por uma vaga
			lb $t3, 0($t1)
			# Se achar alguma vaga chamamos mais uma funcao para realizar a insercao
			beq $t3, 0, tem_vaga
			# Caso contrario passaremos para o proximo nome na procura
			addi $t1, $t1, 40
			# Tambem adicionamos 1 em nosso contador para nao perder as contas de quantos faltam 
			addi $t5, $t5, 1
			# Se o nosso contador chegar em 5 chamamos uma funcao para ir ao proximo apartamento
			beq $t5, 5, apt_lotado
			# Caso contrario seguiremos para o proximo nome
			j verificador_vaga
		# Neste momento inserimos um usuario em uma vaga disponivel
		tem_vaga:
		 # Inserindo em a0 o nome desejado
		addi $a0, $t1, 0 
		# Inserindo no espa�o desejado
		addi $a1, $t3, 0
		# Armazenando a posicao original do arquivo
		addi $t9, $ra, 0
		# Copiando a string em um novo endereco
		jal strcpy
		addi $ra, $t9, 0
		# A fun��o terminou retorna ao inicio
		jr $ra
		
		# Se nao tiver vaga retornaremos 2
		apt_lotado:
		# Inserindo 2 no retorno
		addi $v0, $zero, 2
		#fim da funcao
		jr $ra

	strcpy:
		move $t0, $a0 #move o endereco para t0 porque a0 sera necessario
		loop:
			lb $t1, 0($a1) # carrega para t1 o primeiro byte da string
			sb $t1, 0($a0) # armazena o byte em t1 no destino (a0)
			
			beqz $t1, fim # verifica se t1 � igual a zero. Se o byte n�o for uma "letra" e for um "\n" (caracterizando o fim da string), seu valor ser� igual a zero. Se o byte for "\n" ele vai para a subfunç�o 'end'. Caso contr�rio, segue e volta para o loop
			
			addi $a0, $a0, 1 # como o byte em $t1 n�o � "\n" esta linha incrementa para o pr�ximo endereço a ser guardado o pr�ximo byte
			addi $a1, $a1, 1 # da mesma forma, incrementa-se a1 para ir para o byte seguinte da string
			
			j loop # com o endereço de destino e o byte da string devidamente incrementados, volta-se ao loop
		
		fim:
			move $v0, $t0 #com o fim da string, a string em t0 � movida para o registrador que carregar� o valor de retorno da funç�o
			jr $ra #sai da funç�o e volta para a linha de c�digo que a chamou
	
	memcpy:
		move $t0, $a0 # salva o endereco original de a0 para t0
		
		beqz $a2, fim # verifica se o numero de bytes a ser copiado e zero
		
		loop:
			lb $t1, 0($a1) # carrega um byte da fonte para t1
			sb $t1, 0($a0) # salva o byte carregado em t1 para o destino em a0 
			
			addi $a0, $a0, 1 # incrementa o ponteiro de destino para o proximo byte
			addi $a1, $a1, 1 # incrementa o ponteiro da fonte para o proximo byte
			addi $a2, $a2, -1 # Decrementa o contador de bytes
			
			bnez $a2, loop # se o contador nao for zero, retorna ao loop. Caso contrario, segue
		fim:
			move $v0, $t0 # salva o endereco para o registrador v0 (saida da funcao)
			jr $ra # retorna para a linha de codigo que chamou a funcao
			
	strcmp:
		loop:
			lb $t0, 0($a0) # carrega o caractere da primeira string em t0
			lb $t1, 0($a1) # carrega o caractere da segunda string em t1
			
			sub $t2, $t0, $t1 # confere se os caracteres sao iguais, subtraindo os valores em t0 e t1. Se o resultado for zero, os caracteres sao iguais
			
			bnez $t2, saida # confere se o resultado da subtracao e diferente de zero. Se for, vai para a funcao saida e sai do loop.
			beqz $t0, saida # confere se o caractere da primeira string e NULL
			beqz $t1, saida # confere se o caractere da segunda string e NULL
			
			# se o fluxo chegou aqui, e porque os caracteres sao iguais e nao nulos. O fluxo segue para o loop, incrementando-se um byte em t0 e t1 para se checar os proximos caracteres
			addi $a0, $a0, 1 
			addi $a1, $a1, 1
			j loop # retorna ao loop
			
		saida:
			move $v0, $t2 # como os caracteres foram diferentes ou NULL, o loop e quebrado e move-se o valor de t2 para o registrador v0 (retorno de funcao)
			jr $ra # pula para a linha que chamou a funcao
	
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
			
	strcat:
		move $v0, $a0 # salva o endereço original da destination no registrador de retorno
		move $t0, $a0 # faz uma c�pia do endereço da destination para o registrador $t0
		move $t2, $a1 # move o endereço da source para t2
		
		encontraFimLoop:
			lb $t1, 0($t0) # carrega o byte da copia de destination em t1
			beqz $t1, copiaFonteLoop # se o byte for NULL, chama a funcao que copia os bytes da string source
			addi $t0, $t0, 1 # se o byte nao for NULL, incrementa um byte e retorna ao loop
			j encontraFimLoop
		
		copiaFonteLoop:
			lb $t3, 0($t2) # carrega o byte atual da string source apontado por t2 para t3
			sb $t3, 0($t0) # salva o caractere de source em destination
			
			beqz $t3, fimDaFuncao # se t3 for NULL, chama a funcao
			
			addi $t0, $t0, 1 # avanca o ponteiro de destination
			addi $t2, $t2, 1 # avanca o ponteiro de source
			j copiaFonteLoop # continua o loop
			
		fimDaFuncao:
			jr $ra # retorna o valor 
# finaliza o codigo
encerra: 
  addi $v0, $0, 10
  syscall
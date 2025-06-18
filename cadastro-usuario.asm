# UFRPE - ARQUITETURA E ORGANIZACAO DE COMPUTADORES - 2025.1 
# PROFESSOR: VITOR COUTINHO
# GRUPO: TULIO FALCAO - OTAVIO OLIMPIO - CARLOS EDUARDO - ARTUR GUIMARAES 
# ATIVIDADE 1VA
# CADASTRO DE USUARIO

.data
	# Realizando o cadastro e insercao de apartamentos
	nome: .asciiz "Otavio Olimpio"
	apartamento: .asciiz "01"
	array_apartamentos: .space 8000 # Array de espacos do apartamento
	
.text 
	main:
		# Inserindo as informacoes em registradores
		la $a0, apartamento
		la $a1, nome
		# Chamando a funcao adicionar pessoa
		jal ad_pessoa
		# Encerrando o programa
		j encerra

# Funcao para inserir pessoa em apartamento
ad_pessoa:
	
	# Adicionando em t1 a posicao do primeiro apartamento
	addi $t1, $s2, 0 
	# Adicionando em t2 o ultimo valor da ultima posicao do predio
	addi $t2, $t1, 8000
	# Adicionando em t3 o nome que esta armazenado em a1
	addi $t3, $a1, 0
	
	# Verificadando disponibilidade dos apartamentos
	analisador_apt:
		# Verificando a disponibilidade da posicao atual
		addi $a1, $t1, 0
		# Salvando a posicao atual antes de chamar outra funcao
		move $t4, $ra
		# Salvando o numero do apartamento de entrada a ser comparado antes de chamar outra funcao
		move $t5, $a0
		# Verificar se a string de entrada e a que esta armazenada são iguais
		jal strcmp
		# Resgatando o valor de ra apos a execucao da funcao
		move $ra, $t4
		# Resgatando o valor de a0 apos a execucao da funcao
		move $a0, $t5
		# Se o retorno de strcmp for igual a 0, chamaremos uma funcao para inseir essa pessoa neste apartamento
		beq $v0, 0, ad_apartamento
		
		
		# Se o retorno de strcmp for diferente de 0, seguiremos para conferencia no proximo apartamento
		addi $t1, $t1, 200
		# Varificando de todos os apartamentos ja foram visitados
		#beq $t1, $t2, nao_exite_apt
		# Volta para o inicio da funcao para verificar o proximo apartamento
		j analisador_apt
		
	# funcao para adicionar uma pessoa em um apartamento
	ad_apartamento:
		# Inserindo na primeira posicao dos nomes
		addi $t1, $t1, 10 
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
			# Inserindo no espaço desejado
			addi $a1, $t3, 0
			# Armazenando a posicao original do arquivo
			addi $t9, $ra, 0
			# Copiando a string em um novo endereco
			#jal strcpy
			addi $ra, $t9, 0
			# A função terminou retorna ao inicio
			jr $ra
		
		# Se nao tiver vaga retornaremos 2
		apt_lotado:
			# Inserindo 2 no retorno
			addi $v0, $zero, 2
			#fim da funcao
			jr $ra

				
# função que compara duas strings
strcmp:  
	# inicia o loop principal da função
   	loop: 
      		# carrega o valor a partir de a0 a ser avaliado 
      		lb $t0, 0($a0) 
      		# incrementa para que a proxima letra seja pega.
      		addi $a0, $a0, 1  
      		 # carrega o valor a partir de a1 a ser avaliado 
      		lb $t1, 0($a1) 
      		# incrementa para que a proxima letra seja pega.
      		addi $a1, $a1, 1  
      		#  verifica se os valores analizados são diferentes
      		bne $t0, $t1, final_diferente  
      		#  verifica se os dois valores são iguais
    		beq $t0, $0, filtro  
    		#  Verificando se se a outra string finalizou antes se a mesma acabou antes ambas são diferentes
    		beq $t1, $0, final_diferente  
      	# volta para o inicio do loop
	j loop  
      	
      	#  verificando se os resultados anlizados são iguais
      	filtro:  
      		# caso sejao iguais va para final_igual
       		beq $t1, $0, final_igual
       		# se for diferente, va para final_diferente  
        	j final_diferente  
      	
      	# para os casos de uma string encerrar antes da outra, e do primeiro valor diferente entre um e outro
      	final_diferente:  
      		# Realiza uma subtração entre o ultimo valor de a0 e o ultimo valor de a1, para atender as diretrizes da função, alem de devolver o resultado em v0.
        	sub $v0, $t0, $t1 
        	 #  retorna ao local onde foi chamado no programa 
       		jr $ra
       
        # se as strings forem iguais
      	final_igual:   
        	# o retorno em v0 deve ser 0
         	addi $v0, $0, 0  
         	#  retorna ao local onde foi chamado no programa 
         	jr $ra 

# espaço na memoria em a0, a1 a mensagema ser copiada       
strcpy:
	 #move o endereco para t0 porque a0 sera necessario
	move $t0, $a0
	loop_main:
		lb $t1, 0($a1) # carrega para t1 o primeiro byte da string
		sb $t1, 0($a0) # armazena o byte em t1 no destino (a0)
		
		beqz $t1, end # verifica se t1 ï¿½ igual a zero. Se o byte nï¿½o for uma "letra" e for um "\n" (caracterizando o fim da string), seu valor serï¿½ igual a zero. Se o byte for "\n" ele vai para a subfunÃ§ï¿½o 'end'. Caso contrï¿½rio, segue e volta para o loop
		
		addi $a0, $a0, 1 # como o byte em $t1 nï¿½o ï¿½ "\n" esta linha incrementa para o prï¿½ximo endereÃ§o a ser guardado o prï¿½ximo byte
		addi $a1, $a1, 1 # da mesma forma, incrementa-se a1 para ir para o byte seguinte da string
		
		j loop # com o endereco de destino e o byte da string devidamente incrementados, volta-se ao loop
		
	end:
		move $v0, $t0 #com o fim da string, a string em t0 ï¿½ movida para o registrador que carregarao valor de retorno da funcao
		jr $ra #sai da funcao e volta para a linha de cï¿½digo que a chamou
		
# finaliza o codigo
encerra: 
  	addi $v0, $0, 10
  	syscall

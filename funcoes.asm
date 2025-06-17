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
		# Verificar se as strings de entrada e a que esta armazenada são iguais
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
		 # carrega em a0 o que devemos incerir no local do nome
		addi $a0, $t1, 0 
		# carrega o espaço a ser incerido
		addi $a1, $t3, 0
		addi $t9, $ra, 0
		jal strcpy
		addi $ra, $t9, 0
		# A função terminou retorna ao inicio
		jr $ra
		
		# Se nao tiver vaga retornaremos 2
		apt_lotado:
		# Inserindo 2 no retorno
		addi $v0, $zero, 2
		#fim da funcao
		jr $ra
	####################################################
	vaga_disponivel:  # se chegarmos aqui é por que o nome pode ser incerido
    
    addi $a0, $t7, 0 # carrega em a0 o que devemos incerir no local do nome
    addi $a1, $t4, 0 # carrega o espaço a ser incerido
    addi $t9, $ra, 0 # salva a posição original do arquivo
    jal strcpy  # copia a string no novo local controlando o numero de caracteres par aque o mesmo não utrapasse 19
    addi $ra, $t9, 0 # recupera a posição original do arquivo

   
	####################################################
# finaliza o codigo
encerra: 
  addi $v0, $0, 10
  syscall
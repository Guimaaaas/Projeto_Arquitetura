.data

.text
.globl main

main:
    li $v0, 4           # syscall: imprimir string
    la $a0, mensagem    # carrega o endereço da string definida em outro arquivo
    syscall

    li $v0, 10          # syscall: encerrar o programa
    syscall
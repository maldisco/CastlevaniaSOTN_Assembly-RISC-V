.data
teto:		.word 0
chao:		.word 0


.text
atualiza_tela:
	loadw(t1, tela_atual)
	
	li t2, 1
	beq t1, t2, config_tela_1
	
	li t2, 2
	beq t1, t2, config_tela_2
	
	li t2, 3
	beq t1, t2, config_tela_3

config_tela_1:
	la s0, tela_1
	savew(s0, sprite_tela_atual)
	jal IMPRIME
	li t1, 10
	savew(t1, teto)
	li t1, 165
	savew(t1, chao)
	savew(zero, velocidadeX_luffy)
	savew(zero, velocidadeY_luffy)
	configuracoes_iniciais()
 	call poll_loop

config_tela_2:
	la s0, tela_2
	savew(s0, sprite_tela_atual)
	jal IMPRIME
	li t1, 10
	savew(t1, teto)
	li t1, 165
	savew(t1, chao)
	savew(zero, velocidadeX_luffy)
	savew(zero, velocidadeY_luffy)
	configuracoes_iniciais()
	call poll_loop

config_tela_3:
	la s0, tela_3
	savew(s0, sprite_tela_atual)
	jal IMPRIME
	li t1, 10
	savew(t1, teto)
	li t1, 165
	savew(t1, chao)
	savew(zero, velocidadeX_luffy)
	savew(zero, velocidadeY_luffy)
	configuracoes_iniciais()
	call poll_loop

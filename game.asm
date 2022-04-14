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
 	call poll_loop

config_tela_2:
	la s0, tela_2
	savew(s0, sprite_tela_atual)
	jal IMPRIME
	call poll_loop

config_tela_3:
	la s0, tela_3
	savew(s0, sprite_tela_atual)
	jal IMPRIME
	call poll_loop

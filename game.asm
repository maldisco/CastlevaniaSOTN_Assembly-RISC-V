.data
teto:		.byte 0
chao:		.word 0


.text
atualiza_tela:
	loadw(t1, tela_atual)
	
	li t2, 1
	beq t1, t2, config_tela_1

config_tela_1:
	mv s9, a0
	li a1, 0
	li a2, 0
	li a3, MAPA.LARGURA
	li a4, MAPA.LARGURA
	frame_address(a5)
	li a6, 0
	li a7, MAPA.ALTURA
	call Trenderiza_luffy
	
	mv s9, a0
	li a1, 0
	li a2, 0
	li a3, MAPA.LARGURA
	li a4, MAPA.LARGURA
	other_frame_address(a5)
	li a6, 0
	li a7, MAPA.ALTURA
	call Trenderiza_luffy
	
	li t1, 10
	saveb(t1, teto)
	li t1, 170
	savew(t1, chao)
	saveb(zero, velocidadeX_luffy)
	saveb(zero, velocidadeY_luffy)
 	call poll_loop


atualiza_tela:
	loadw(t1, tela_atual)
	
	li t2, 1
	beq t1, t2, config_tela_1

config_tela_1:
	mv s9, a0
	li a1, 0
	li a2, 0
	li a3, MAPA.IMAGEM.LARGURA
	li a4, MAPA.LARGURA
	frame_address(a5)
	offset_mapa(a6)
	li a7, MAPA.ALTURA
	call RENDER
	
	mv s9, a0
	li a1, 0
	li a2, 0
	li a3, MAPA.IMAGEM.LARGURA
	li a4, MAPA.LARGURA
	other_frame_address(a5)
	offset_mapa(a6)
	li a7, MAPA.ALTURA
	call RENDER

	saveb(zero, velocidadeY_luffy)
 	tail poll_loop


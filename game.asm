atualiza_tela:
	loadw(t1, tela_atual)
	
	li t2, 1
	beq t1, t2, config_tela_1

config_tela_1:
	# Renderiza mapa na frame 1
	mv 		s9, a0
	li 		a1, 0
	li 		a2, 0
	li 		a3, MAPA.IMAGEM.LARGURA
	li		a4, MAPA.LARGURA
	frame_address(a5)
	offset_mapa(a6)
	li 		a7, MAPA.ALTURA
	jal 		RENDER
	
	# Renderiza mapa na frame 0
	mv 		s9, a0
	li 		a1, 0
	li 		a2, 0
	li 		a3, MAPA.IMAGEM.LARGURA
	li 		a4, MAPA.LARGURA
	other_frame_address(a5)
	offset_mapa(a6)
	li 		a7, MAPA.ALTURA
	jal 		RENDER
	
	# Inicia velocidade Y como 0
	la 		t1, velocidadeY_luffy
	fcvt.s.w	ft1, zero
	fsw		ft1, (t1)
 	tail poll_loop


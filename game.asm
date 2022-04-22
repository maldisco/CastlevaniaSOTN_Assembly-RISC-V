# Troca para a tela que o personagem passou
# a0 = cor label da tela alvo
TROCA_TELA:		li		t0, 12
			beq		a0, t0, TELA_1.PARA.TELA_2	# se a cor for 12, muda da tela 1 para tela 2

TELA_1.PARA.TELA_2:	
	

config_tela_1:
	la		t1, mapa.imagem.largura
	li 		t2, T1.LARGURA
	sh 		t2, 0(t1)
	
	la		t1, mapa.hitbox.largura 
	li 		t2, T1.LARGURA
	sh		t2, 0(t1)
	
	la 		t1, mapa.max.x
	li 		t2, T1.MAX.X
	sh		t2, 0(t1)
	
	la 		t1, mapa.min.x
	li		t2, T1.MIN.X
	sh		t2, 0(t1)
	
	la 		t1, mapa.max.y
	sh		zero, 0(t1)
	
	la 		t1, mapa.min.y
	sh		zero, 0(t1)
	
	la 		t0, mapa_hitbox
	la 		t1, tela_1_hitboxes
	sw		t1, 0(t0)
	
	la 		t0, mapa.x
	li		t1, T1.X_INI
	sh		t1, 0(t0)
	
	la		t0, mapa.y
	li 		t1, T1.Y_INI
	sh		t1, 0(t0)
	
	la 		t0, mapa.lock.x
	li		t1, T1.LOCK_X
	sb		t1, 0(t0)
	
	la 		t0, mapa.lock.y
	li		t1, T1.LOCK_Y
	sb		t1, 0(t0)
	
	# Renderiza mapa na frame 1
	mv 		s9, a0
	li 		a1, 0
	li 		a2, 0
	li 		a3, T1.LARGURA
	li		a4, MAPA.LARGURA
	frame_address(a5)
	offset_mapa(a6)
	li 		a7, MAPA.ALTURA
	jal 		RENDER
	
	# Renderiza mapa na frame 0
	mv 		s9, a0
	li 		a1, 0
	li 		a2, 0
	li 		a3, T1.LARGURA
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
 



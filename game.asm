# Troca para a tela que o personagem passou
# a0 = cor label da tela alvo
TELA.TROCA:		li		t0, -1
			beq		a0, t0, TELA_1.PARA.TELA_2	# se a cor for 12, muda da tela 1 para tela 2

TELA_1.PARA.TELA_2:	addi		sp, sp, 4			# Reseta a pilha
			
			la		t1, mapa.imagem.largura
			li 		t2, T2.LARGURA
			sh 		t2, 0(t1)
		
			la		t1, mapa.hitbox.largura 
			li 		t2, T2.LARGURA
			sh		t2, 0(t1)
	
			la 		t1, mapa.max.x
			li 		t2, T2.MAX.X
			sh		t2, 0(t1)
	
			la 		t1, mapa.min.x
			li		t2, T2.MIN.X
			sh		t2, 0(t1)
			
			la 		t1, mapa.max.y
			li		t2, T2.MAX.Y
			sh		t2, 0(t1)
			
			la 		t1, mapa.min.y
			li		t2, T2.MIN.Y
			sh		t2, 0(t1)
			
			la 		t0, mapa_hitbox
			la 		t1, tela_2_hitboxes
			sw		t1, 0(t0)
			
			la 		t0, mapa.x
			li		t1, T2.X_INI
			sh		t1, 0(t0)
			
			la		t0, mapa.y
			li 		t1, T2.Y_INI
			sh		t1, 0(t0)
			
			la 		t0, mapa.lock.x
			li		t1, T2.LOCK_X
			sb		t1, 0(t0)
			
			la 		t0, mapa.lock.y
			li		t1, T2.LOCK_Y
			sb		t1, 0(t0)
			
			la		t0, horizontal_luffy
			li		t1, 93
			sw		t1, (t0)
			
			la		t0, vertical_luffy
			li		t1, 139
			sw		t1, (t0)
			
			la		t0, moveX
			li		t1, -7
			sb		t1, (t0)
			
			la		t0, pulando
			li		t1, 1
			sb		t1, (t0)
			
			la		t0, velocidadeY_luffy
			li 		t1, -6		
			fcvt.s.w 	ft1, t1	
			fsw		ft1, (t0)
			
			la		t0, sentido
			li		t1, -1
			sb		t1, (t0)
			
			la		t0, socando
			sb		zero, (t0)
			
			mv 		s9, s7			# S9 = Tela atual, S7 = Tela 2
			
			# Renderiza mapa na frame 1
			mv 		a0, s9
			li 		a1, 0
			li 		a2, 0
			li 		a3, T2.LARGURA
			li		a4, MAPA.LARGURA
			frame_address(a5)
			offset_mapa(a6)
			li 		a7, MAPA.ALTURA
			jal 		RENDER
			
			# Renderiza mapa na frame 0
			mv 		a0, s9
			li 		a1, 0
			li 		a2, 0
			li 		a3, T2.LARGURA
			li 		a4, MAPA.LARGURA
			other_frame_address(a5)
			offset_mapa(a6)
			li 		a7, MAPA.ALTURA
			jal 		RENDER
	
			li 		a7, 1
			li 		a0, 999
			ecall
	
			tail poll_loop
	
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
	
			mv		s9, s8			# S9 = Tela atual e S8 = Tela 1
	
			# Renderiza mapa na frame 1
			mv 		a0, s9
			li 		a1, 0
			li 		a2, 0
			li 		a3, T1.LARGURA
			li		a4, MAPA.LARGURA
			frame_address(a5)
			offset_mapa(a6)
			li 		a7, MAPA.ALTURA
			jal 		RENDER
	
			# Renderiza mapa na frame 0
			mv 		a0, s9
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
 



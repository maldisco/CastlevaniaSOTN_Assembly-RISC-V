# Troca para a tela que o personagem passou
# a0 = cor label da tela alvo
TELA.TROCA:		li		t0, -1
			beq		a0, t0, TELA_1.PARA.TELA_2	# se a cor for 12, muda da tela 1 para tela 2
			
			li		t0, -2
			beq		a0, t0, TELA_2.PARA.TELA_1
			
			li		t0, -3
			beq		a0, t0,	TELA_2.PARA.TELA_3
			
			li 		t0, -4
			beq		a0, t0, TELA_3.PARA.TELA_2 
			
			li		t0, -5
			beq 		a0, t0, TELA_3.PARA.TELA_4

TELA_1.PARA.TELA_2:	la		t1, mapa.imagem.largura
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
			
			la		t0, horizontal_alucard
			li		t1, 110
			sw		t1, (t0)
			
			la		t0, vertical_alucard
			li		t1, 150
			sw		t1, (t0)
			
			la		t0, moveX
			li		t1, -14
			sb		t1, (t0)
			
			la		t0, pulando
			li		t1, 1
			sb		t1, (t0)
			
			la		t0, velocidadeY_alucard
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
	
			tail		LOOP_JOGO			

TELA_2.PARA.TELA_1:	la		t1, mapa.imagem.largura
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
			li		t2, T1.MAX.Y
			sh		t2, 0(t1)
			
			la 		t1, mapa.min.y
			li		t2, T1.MIN.Y
			sh		t2, 0(t1)
			
			la 		t0, mapa_hitbox
			la 		t1, tela_1_hitboxes
			sw		t1, 0(t0)
			
			la 		t0, mapa.x
			li		t1, 212
			sh		t1, 0(t0)
			
			la		t0, mapa.y
			li 		t1, 0
			sh		t1, 0(t0)
			
			la		t0, horizontal_alucard
			li		t1, 120
			sw		t1, (t0)
			
			la		t0, vertical_alucard
			li		t1, 30
			sw		t1, (t0)
			
			la		t0, moveX
			sb		zero, (t0)
			
			la		t0, pulando
			sb		zero, (t0)
			
			la		t0, velocidadeY_alucard	
			fcvt.s.w 	ft1, zero
			fsw		ft1, (t0)
			
			la		t0, sentido
			li		t1, 1
			sb		t1, (t0)
			
			la		t0, socando
			sb		zero, (t0)
			
			mv 		s9, s8			# S9 = Tela atual, S8 = Tela 1
			
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
	
			tail		LOOP_JOGO

TELA_2.PARA.TELA_3:	la		t1, mapa.imagem.largura
			li 		t2, T3.LARGURA
			sh 		t2, 0(t1)
		
			la		t1, mapa.hitbox.largura 
			li 		t2, T3.LARGURA
			sh		t2, 0(t1)
	
			la 		t1, mapa.max.x
			li 		t2, T3.MAX.X
			sh		t2, 0(t1)
	
			la 		t1, mapa.min.x
			li		t2, T3.MIN.X
			sh		t2, 0(t1)
			
			la 		t1, mapa.max.y
			li		t2, T3.MAX.Y
			sh		t2, 0(t1)
			
			la 		t1, mapa.min.y
			li		t2, T3.MIN.Y
			sh		t2, 0(t1)
			
			la 		t0, mapa_hitbox
			la 		t1, tela_3_hitboxes
			sw		t1, 0(t0)
			
			la 		t0, mapa.x
			li		t1, T3.X_INI
			sh		t1, 0(t0)
			
			la		t0, mapa.y
			li 		t1, T3.Y_INI
			sh		t1, 0(t0)
			
			la		t0, horizontal_alucard
			li		t1, 240
			sw		t1, (t0)
			
			la		t0, vertical_alucard
			li		t1, 115
			sw		t1, (t0)
			
			la		t0, moveX
			sb		zero, (t0)
			
			la		t0, pulando
			sb		zero, (t0)
			
			la		t0, velocidadeY_alucard	
			fcvt.s.w 	ft1, zero
			fsw		ft1, (t0)
			
			la		t0, sentido
			li		t1, -1
			sb		t1, (t0)
			
			la		t0, socando
			sb		zero, (t0)
			
			mv 		s9, s6			# S9 = Tela atual, S6 = Tela 3
			
			# Renderiza mapa na frame 1
			mv 		a0, s9
			li 		a1, 0
			li 		a2, 0
			li 		a3, T3.LARGURA
			li		a4, MAPA.LARGURA
			frame_address(a5)
			offset_mapa(a6)
			li 		a7, MAPA.ALTURA
			jal 		RENDER
			
			# Renderiza mapa na frame 0
			mv 		a0, s9
			li 		a1, 0
			li 		a2, 0
			li 		a3, T3.LARGURA
			li 		a4, MAPA.LARGURA
			other_frame_address(a5)
			offset_mapa(a6)
			li 		a7, MAPA.ALTURA
			jal 		RENDER
			
			tail		LOOP_JOGO

TELA_3.PARA.TELA_2:	la		t1, mapa.imagem.largura
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
			li		t1, 0
			sh		t1, 0(t0)
			
			la		t0, mapa.y
			li 		t1, 0
			sh		t1, 0(t0)
			
			la		t0, horizontal_alucard
			li		t1, 0
			sw		t1, (t0)
			
			la		t0, vertical_alucard
			li		t1, 95
			sw		t1, (t0)
			
			la		t0, moveX
			sb		zero, (t0)
			
			la		t0, pulando
			sb		zero, (t0)
			
			la		t0, velocidadeY_alucard	
			fcvt.s.w 	ft1, zero
			fsw		ft1, (t0)
			
			la		t0, sentido
			li		t1, 1
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
	
			tail		LOOP_JOGO

TELA_3.PARA.TELA_4:
			la		t1, mapa.imagem.largura
			li 		t2, T4.LARGURA
			sh 		t2, 0(t1)
		
			la		t1, mapa.hitbox.largura 
			li 		t2, T4.LARGURA
			sh		t2, 0(t1)
	
			la 		t1, mapa.max.x
			li 		t2, T4.MAX.X
			sh		t2, 0(t1)
	
			la 		t1, mapa.min.x
			li		t2, T4.MIN.X
			sh		t2, 0(t1)
			
			la 		t1, mapa.max.y
			li		t2, T4.MAX.Y
			sh		t2, 0(t1)
			
			la 		t1, mapa.min.y
			li		t2, T4.MIN.Y
			sh		t2, 0(t1)
			
			la 		t0, mapa_hitbox
			la 		t1, tela_4_hitboxes
			sw		t1, 0(t0)
			
			la 		t0, mapa.x
			li		t1, T4.X_INI
			sh		t1, 0(t0)
			
			la		t0, mapa.y
			li 		t1, T4.Y_INI
			sh		t1, 0(t0)
			
			la		t0, horizontal_alucard
			li		t1, 0
			sw		t1, (t0)
			
			la		t0, vertical_alucard
			li		t1, 72
			sw		t1, (t0)
			
			la		t0, moveX
			sb		zero, (t0)
			
			la		t0, pulando
			sb		zero, (t0)
			
			la		t0, velocidadeY_alucard
			fcvt.s.w 	ft1, zero
			fsw		ft1, (t0)
			
			la		t0, sentido
			li		t1, 1
			sb		t1, (t0)
			
			la		t0, socando
			sb		zero, (t0)
			
			mv 		s9, s5			# S9 = Tela atual, S5 = Tela 4
			
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
	
			tail		LOOP_JOGO

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
			la 		t1, velocidadeY_alucard
			fcvt.s.w	ft1, zero
			fsw		ft1, (t1)
			
			# Dialogo inicial do jogo			
 			tail 		LOOP_JOGO
 



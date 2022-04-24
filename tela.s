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

# Configurações para mudar da tela 1 para 2
TELA_1.PARA.TELA_2:	jal 		CONFIG.TELA_2			# Padrões
			
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
			
			tail		LOOP_JOGO			

# Configurações para mudar da tela 2 para 1
TELA_2.PARA.TELA_1:	jal		CONFIG.TELA_1
			
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
	
			tail		LOOP_JOGO

# Configurações para mudar da tela 2 para 3
TELA_2.PARA.TELA_3:	jal		CONFIG.TELA_3
			
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
			
			
			tail		LOOP_JOGO

# Configurações para mudar da tela 3 para 2
TELA_3.PARA.TELA_2:	jal 		CONFIG.TELA_2
			
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
			
			tail		LOOP_JOGO

# Configurações ao mudar da tela 3 para 4
TELA_3.PARA.TELA_4:	jal		CONFIG.TELA_4
			
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
			
	
			tail		LOOP_JOGO

# Configuracoes ao iniciar o jogo
config_tela_1:		jal		CONFIG.TELA_1
	
			la 		t0, mapa.x
			li		t1, T1.X_INI
			sh		t1, 0(t0)
	
			la		t0, mapa.y
			li 		t1, T1.Y_INI
			sh		t1, 0(t0)
	
			mv		s9, s8			# S9 = Tela atual e S8 = Tela 1
	
			# Inicia velocidade Y como 0
			la 		t1, velocidadeY_alucard
			fcvt.s.w	ft1, zero
			fsw		ft1, (t1)
			
			# Dialogo inicial do jogo
			# jal		DIALOGO_1.START
									
 			tail 		LOOP_JOGO
 
# Constantes ao mudar para o mapa 1
CONFIG.TELA_1:		mv		s9, s8				# S9 = Tela atual, S8 = tela 1
			
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
			li		t2, T1.MAX.Y
			sh		t2, 0(t1)
			
			la 		t1, mapa.min.y
			li		t2, T1.MIN.Y
			sh		t2, 0(t1)
			
			la 		t0, mapa_hitbox
			la 		t1, tela_1_hitboxes
			sw		t1, 0(t0)
 			
 			ret
 			
# Constantes ao mudar para o mapa 2
CONFIG.TELA_2:		mv 		s9, s7				# S9 = Tela atual, S7 = Tela 2

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

			ret

# Constantes ao mudar para o mapa 3
CONFIG.TELA_3:		mv		s9, s6				# s9 = tela atual, s5 = tela 3
			
			la		t1, mapa.imagem.largura
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
			
			ret

# Constantes ao mudar para tela 4
CONFIG.TELA_4:		mv		s9, s5				# S9 = tela atual, s5 = tela 4
			
			
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
			
			ret
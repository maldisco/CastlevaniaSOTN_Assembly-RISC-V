# Troca para a tela que o personagem passou
# a0 = codigo da tela alvo
TELA.TROCA:		li 		t0,FRAME_SELECT
			sw 		s0,(t0)						# Atualiza a tela para o usuário ver as atualizações
			
			csrr		s11, 3073					# Guarda o horário da atualização de frame

			li		t0, -1
			beq		a0, t0, TELA_1.PARA.TELA_2	
			
			li		t0, -2
			beq		a0, t0, TELA_2.PARA.TELA_1
			
			li		t0, -3
			beq		a0, t0,	TELA_2.PARA.TELA_3
			
			li 		t0, -4
			beq		a0, t0, TELA_3.PARA.TELA_2 
			
			li		t0, -7
			beq		a0, t0, TELA_2.PARA.TELA_10
			
			li		t0, -6
			beq		a0, t0, TELA_2.PARA.TELA_11
			
			li		t0, -5
			beq 		a0, t0, TELA_3.PARA.TELA_BF
			
			li		t0, -8
			beq		a0, t0, TELA_3.PARA.TELA_5_CIMA
			
			li		t0, -9
			beq		a0, t0, TELA_3.PARA.TELA_5_BAIXO
			
			li		t0, -14
			beq		a0, t0, TELA_5.PARA.TELA_3_BAIXO
			
			li		t0, -22
			beq		a0, t0, TELA_5.PARA.TELA_3_CIMA
			
			li		t0, -15
			beq		a0, t0, TELA_5.PARA.TELA_6
			
			li		t0, -16
			beq		a0, t0, TELA_6.PARA.TELA_5
			
			li		t0, -10
			beq		a0, t0, TELA_4.PARA.TELA_7 
			
			li		t0, -18
			beq		a0, t0, TELA_7.PARA.TELA_4
			
			li		t0, -17
			beq		a0, t0, TELA_7.PARA.TELA_10
			
			li		t0, -19
			beq		a0, t0, TELA_7.PARA.TELA_8
			
			li		t0, -20
			beq		a0, t0, FIM_DE_JOGO
			
			li		t0, -21
			beq		a0, t0, TELA_8.PARA.TELA_7
			
			li 		t0, -12
			beq		a0, t0, TELA_10.PARA.TELA_7
			
			li		t0, -13
			beq		a0, t0, TELA_10.PARA.TELA_2
			
			li		t0, -11
			beq		a0, t0, TELA_11.PARA.TELA_2	
			
# Configurações para mudar da tela 1 para 2
TELA_1.PARA.TELA_2:	jal 		CONFIG.TELA_2			# Padrões
			
			li		s4, T2.X_INI
			li 		s3, T2.Y_INI	
			li		s6, 110
			li		s5, 150
			li		t1, -14
			fcvt.s.w	fs3, t1
			fcvt.s.w	fa1, zero
			li		t1, 1
			fcvt.s.w	fa2, t1
			li 		t1, -6		
			fcvt.s.w 	fs2, t1	
			li		t1, -1
			fcvt.s.w	fa4, t1	
			fcvt.s.w	fa7, zero
			
			tail		LOOP_JOGO			

# Configurações para mudar da tela 2 para 1
TELA_2.PARA.TELA_1:	jal		CONFIG.TELA_1
			
			li		s4, 212
			li 		s3, 0
			li		s6, 120
			li		s5, 30
			fcvt.s.w	fs3, zero
			fcvt.s.w	fa1, zero
			fcvt.s.w	fa2, zero			
			fcvt.s.w 	fs2, zero
			li		t1, 1
			fcvt.s.w	fa4, t1
			fcvt.w.s	t1, fa6
			xori		t1, t1, 1
			fcvt.s.w	fa7, t1	
			
			
			tail		LOOP_JOGO

# Configurações para mudar da tela 2 para 3
TELA_2.PARA.TELA_3:	jal		CONFIG.TELA_3
			
			li		s4, T3.X_INI
			li 		s3, T3.Y_INI	
			li		s6, 240
			li		s5, 115
			fcvt.s.w	fs3, zero
			fcvt.s.w	fa1, zero
			fcvt.s.w	fa2, zero			
			fcvt.s.w 	fs2, zero
			li		t1, -1
			fcvt.s.w	fa4, t1	
			
			tail		LOOP_JOGO

# Configurações ao mudar da tela 2 para 10
TELA_2.PARA.TELA_10:	jal		CONFIG.TELA_10
			
			li		s4, 0
			li 		s3, 0
			li		s6, 20
			li		s5, 95
			fcvt.s.w	fs3, zero
			fcvt.s.w	fa1, zero
			fcvt.s.w	fa2, zero			
			fcvt.s.w 	fs2, zero
			li		t1, 1
			fcvt.s.w	fa4, t1
			li		t1, 2	
			fcvt.s.w	fa0, t1	
			fcvt.s.w	fa7, zero		
	
			tail		LOOP_JOGO

# Configurações ao mudar da tela 2 para tela 11
TELA_2.PARA.TELA_11:	jal		CONFIG.TELA_11
			
			li		s4, 0
			li 		s3, 0
			li		s6, 20
			li		s5, 109
			fcvt.s.w	fs3, zero
			fcvt.s.w	fa1, zero
			fcvt.s.w	fa2, zero			
			fcvt.s.w 	fs2, zero
			li		t1, 1
			fcvt.s.w	fa4, t1
			fcvt.s.w	ft3, t1
			
			# Define se haverá um objeto na sala
			la		t0, comida.pego
			lb		t1, (t0)
			xori		t1, t1, 1
			li		t2, 3
			mul		t1, t1, t2
			fcvt.s.w	fa7, t1
			la		t0, objeto.x
			li		t1, 142
			sb		t1, (t0)
			la		t0, objeto.y
			li		t1, 161
			sb		t1, (t0)
			la		t0, comida.descritor
			lw		t1, (t0)
			la		t0, objeto.descritor
			sw		t1, (t0)
			
			tail		LOOP_JOGO

# Configurações para mudar da tela 3 para 2
TELA_3.PARA.TELA_2:	jal 		CONFIG.TELA_2
			
			li		s4, 0
			li 		s3, 0
			li		s6, 0
			li		s5, 95
			fcvt.s.w	fs3, zero
			fcvt.s.w	fa1, zero
			fcvt.s.w	fa2, zero			
			fcvt.s.w 	fs2, zero
			li		t1, 1
			fcvt.s.w	fa4, t1	
			
			tail		LOOP_JOGO

# Configurações ao mudar da tela 3 para 4
TELA_BF.PARA.TELA_4:	jal		CONFIG.TELA_4
			
			li		s4, T4.X_INI
			li 		s3, T4.Y_INI
			li		s6, 0
			li		s5, 72
			fcvt.s.w	fs3, zero
			fcvt.s.w	fa1, zero
			fcvt.s.w	fa2, zero			
			fcvt.s.w 	fs2, zero
			fcvt.s.w	fa0, zero
			li		t1, 1
			fcvt.s.w	fa4, t1	
			
			jal 		OST.SETUP			
	
			tail		LOOP_JOGO

# Configracoes ao mudar da tela 3 para 4
TELA_3.PARA.TELA_BF:	jal		CONFIG.TELA_BF
			
			li		s4, 0
			li		s3, 0
			li		s6, 10
			li		s5, 160
			fcvt.s.w	fs3, zero
			fcvt.s.w	fa1, zero
			fcvt.s.w	fa2, zero			
			fcvt.s.w 	fs2, zero
			li		t1, 1
			fcvt.s.w	fa0, t1
			li		t1, 1
			fcvt.s.w	fa4, t1	
			li		t0, 100
			fcvt.s.w	fs0, t0
			li		t0, SANS.X
			fcvt.s.w	fs11, t0
			li		t0, SANS.Y
			fcvt.s.w	fs10, t0			
			
			jal		OST.SETUP_MEGALO
			
			mv		a0, s9
			li		a1, 0		
			li 		a2, 0
			la		t1, mapa.imagem.largura
			lhu		a3, 0(t1)
			li 		a4, MAPA.LARGURA		
			frame_address(a5)
			offset_mapa(a6)
			li 		a7, MAPA.ALTURA
			jal		RENDER
			
			# Renderiza o SANS dormindo
			la		a0, sanzz
			li		a1, 0
			li		a2, 0
			li		a7, 1024
			ecall

			li		a1, SANS.X		
			li 		a2, SANS.Y
			li		a3, 64
			li 		a4, SANS.LARGURA		
			frame_address(a5)
			li		a6, 0
			li 		a7, SANS.ALTURA
			jal		RENDER
			
			# Dialogo pré-boss
			jal		DIALOGO_2.START
			
			tail		LOOP_JOGO

# Configurações ao mudar da tela 3 para 5
TELA_3.PARA.TELA_5_CIMA:jal		CONFIG.TELA_5
			
			li		s4, 191
			li 		s3, 0
			li		s6, 220
			li		s5, 70
			fcvt.s.w	fs3, zero
			fcvt.s.w	fa1, zero
			fcvt.s.w	fa2, zero				
			fcvt.s.w 	fs2, zero
			li		t1, -1
			fcvt.s.w	fa4, t1				
	
			tail		LOOP_JOGO

# Configurações ao mudar da tela 3 para 5
TELA_3.PARA.TELA_5_BAIXO:	
			jal		CONFIG.TELA_5
			
			li		s4, 193
			li 		s3, 222
			li		s6, 225
			li		s5, 100
			fcvt.s.w	fs3, zero
			fcvt.s.w	fa1, zero
			fcvt.s.w	fa2, zero			
			fcvt.s.w 	fs2, zero
			li		t1, -1
			fcvt.s.w	fa4, t1				
	
			tail		LOOP_JOGO

# Configurações para mudar da tela 5 para 3
TELA_5.PARA.TELA_3_BAIXO:	
			jal		CONFIG.TELA_3
			
			li		s4, T3.X_INI
			li 		s3, T3.Y_INI
			li		s6, 10
			li		s5, 115
			fcvt.s.w	fs3, zero
			fcvt.s.w	fa1, zero
			fcvt.s.w	fa2, zero			
			fcvt.s.w 	fs2, zero
			li		t1, 1
			fcvt.s.w	fa4, t1	
			
			tail		LOOP_JOGO

# Configurações para mudar da tela 5 para 3
TELA_5.PARA.TELA_3_CIMA:jal		CONFIG.TELA_3
			
			li		s4, 0
			li 		s3, 236
			li		s6, 10
			li		s5, 90
			fcvt.s.w	fs3, zero
			fcvt.s.w	fa1, zero
			fcvt.s.w	fa2, zero			
			fcvt.s.w 	fs2, zero
			li		t1, 1
			fcvt.s.w	fa4, t1	
			
			tail		LOOP_JOGO

# Configurações para mudar da tela 5 para 6
TELA_5.PARA.TELA_6:	jal		CONFIG.TELA_6
			
			li		s4, T6.X_INI
			li 		s3, T6.Y_INI
			li		s6, 223
			li		s5, 88
			fcvt.s.w	fs3, zero
			fcvt.s.w	fa1, zero
			fcvt.s.w	fa2, zero			
			fcvt.s.w 	fs2, zero
			li		t1, -1
			fcvt.s.w	fa4, t1	
			
			# Define se haverá um objeto na sala
			la		t0, coracao.pego
			lb		t1, (t0)
			xori		t1, t1, 1
			li		t2, 2
			mul		t1, t1, t2
			fcvt.s.w	fa7, t1
			la		t0, objeto.x
			li		t1, 176
			sb		t1, (t0)
			la		t0, objeto.y
			li		t1, 171
			sb		t1, (t0)
			la		t0, coracao.descritor
			lw		t1, (t0)
			la		t0, objeto.descritor
			sw		t1, (t0)
			
			tail		LOOP_JOGO

# Configurações ao mudar da tela 6 para 5
TELA_6.PARA.TELA_5:	jal		CONFIG.TELA_5
			
			li		s4, 0
			li 		s3, 0
			li		s6, 20
			li		s5, 70
			fcvt.s.w	fs3, zero
			fcvt.s.w	fa1, zero
			fcvt.s.w	fa2, zero			
			fcvt.s.w 	fs2, zero
			li		t1, 1
			fcvt.s.w	fa4, t1	
			fcvt.s.w	fa7, zero			
	
			tail		LOOP_JOGO

# Configurações ao mudar da tela 4 para 7
TELA_4.PARA.TELA_7:	jal		CONFIG.TELA_7
			
			li		s4, 0
			li 		s3, 528
			li		s6, 20
			li		s5, 70
			fcvt.s.w	fs3, zero
			fcvt.s.w	fa1, zero
			fcvt.s.w	fa2, zero			
			fcvt.s.w 	fs2, zero
			li		t1, 1
			fcvt.s.w	fa4, t1				
	
			tail		LOOP_JOGO
			

# Configurações ao mudar da tela 7 para 4
TELA_7.PARA.TELA_4:	jal		CONFIG.TELA_4
			
			li		s4, 704
			li		s3, 222
			li		s6, 220
			li		s5, 90
			fcvt.s.w	fs3, zero
			fcvt.s.w	fa1, zero
			fcvt.s.w	fa2, zero			
			fcvt.s.w 	fs2, zero
			li		t1, -1
			fcvt.s.w	fa4, t1				
	
			tail		LOOP_JOGO

# Configurações ao mudar da tela 7 para 10
TELA_7.PARA.TELA_10:	jal		CONFIG.TELA_10
			
			li		s4, 0
			li 		s3, 0
			li		s6, 220
			li		s5, 95
			fcvt.s.w	fs3, zero
			fcvt.s.w	fa1, zero
			fcvt.s.w	fa2, zero			
			fcvt.s.w 	fs2, zero
			li		t1, -1
			fcvt.s.w	fa4, t1	
			li		t1, 2
			fcvt.s.w	fa0, t1			
	
			tail		LOOP_JOGO

# Configurações ao mudar da tela 7 para tela 8
TELA_7.PARA.TELA_8:	jal		CONFIG.TELA_11
			
			li		s4, 0
			li 		s3, 0
			li		s6, 20
			li		s5, 109
			fcvt.s.w	fs3, zero
			fcvt.s.w	fa1, zero
			fcvt.s.w	fa2, zero			
			fcvt.s.w 	fs2, zero
			li		t1, 1
			fcvt.s.w	fa4, t1
			fcvt.s.w	ft3, t1
			
			la 		t0, mapa_hitbox
			la 		t1, tela_8_hitboxes
			sw		t1, 0(t0)
			
			tail		LOOP_JOGO

# Configurações ao mudar da tela 8 para tela 7
TELA_8.PARA.TELA_7:	jal		CONFIG.TELA_7
			
			li		s4, 0
			li 		s3, 528
			li		s6, 220
			li		s5, 75
			fcvt.s.w	fs3, zero
			fcvt.s.w	fa1, zero
			fcvt.s.w	fa2, zero			
			fcvt.s.w 	fs2, zero
			li		t1, -1
			fcvt.s.w	fa4, t1	
			fcvt.s.w	fa0, zero
			fcvt.s.w	ft3, zero			
	
			tail		LOOP_JOGO

# Configurações ao mudar da tela 10 para 7
TELA_10.PARA.TELA_7:	jal		CONFIG.TELA_7
			
			li		s4, 0
			li 		s3, 528
			li		s6, 220
			li		s5, 75
			fcvt.s.w	fs3, zero
			fcvt.s.w	fa1, zero
			fcvt.s.w	fa2, zero			
			fcvt.s.w 	fs2, zero
			li		t1, -1
			fcvt.s.w	fa4, t1	
			fcvt.s.w	fa0, zero			
	
			tail		LOOP_JOGO

# Configurações ao mudar da tela 10 para 2
TELA_10.PARA.TELA_2:	jal		CONFIG.TELA_2
			
			li		s4, 447
			li 		s3, 0
			li		s6, 205
			li		s5, 95
			fcvt.s.w	fs3, zero
			fcvt.s.w	fa1, zero
			fcvt.s.w	fa2, zero			
			fcvt.s.w 	fs2, zero
			li		t1, -1
			fcvt.s.w	fa4, t1	
			fcvt.s.w	fa0, zero			
	
			tail		LOOP_JOGO

# Configurações ao mudar da tela 11 para 2
TELA_11.PARA.TELA_2:	jal		CONFIG.TELA_2
			
			li		s4, 447
			li 		s3, 257
			li		s6, 205
			li		s5, 95
			fcvt.s.w	fs3, zero
			fcvt.s.w	fa1, zero
			fcvt.s.w	fa2, zero			
			fcvt.s.w 	fs2, zero
			li		t1, -1
			fcvt.s.w	fa4, t1
			fcvt.s.w	ft3, zero				
	
			tail		LOOP_JOGO

# Fim do jogo (só fecha)
FIM_DE_JOGO:		li		a7, 10
			ecall
			

# Configuracoes ao iniciar o jogo
config_newgame:		jal		CONFIG.TELA_1
	
			li		s4, T1.X_INI			# s4 = Posição X do mapa
			li 		s3, T1.Y_INI			# s3 = Posição Y do mapa
			li		s6, 120				# s6 = Posição X do personagem
			li		s5, 135				# s5 = Posição Y do personagem
	
			# Inicia velocidade Y como 0
			fcvt.s.w	fs2, zero
			li		t1, 1
			fcvt.s.w	fa7, t1
			
			la		t0, faca.descritor
			lw		t1, (t0)
			la		t0, objeto.descritor
			sw		t1, (t0)
			
			mv		a0, s9
			li		a1, 0		
			li 		a2, 0
			la		t1, mapa.imagem.largura
			lhu		a3, 0(t1)
			li 		a4, MAPA.LARGURA		
			frame_address(a5)
			offset_mapa(a6)
			li 		a7, MAPA.ALTURA
			jal		RENDER
			
			# Dialogo inicial do jogo
			jal		DIALOGO_1.START
									
 			tail 		LOOP_JOGO
 
# Constantes ao mudar para o mapa 1
CONFIG.TELA_1:		la		t0, TELA.DESCRITORES
			lw		s9, 0(t0)
			
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
CONFIG.TELA_2:		la		t0, TELA.DESCRITORES
			lw		s9, 4(t0)

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
CONFIG.TELA_3:		la		t0, TELA.DESCRITORES
			lw		s9, 8(t0)
			
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
CONFIG.TELA_4:		la		t0, TELA.DESCRITORES
			lw		s9, 12(t0)
			
			
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

# Constantes ao mudar para tela 5
CONFIG.TELA_5:		la		t0, TELA.DESCRITORES
			lw		s9, 16(t0)
			
			
			la		t1, mapa.imagem.largura
			li 		t2, T5.LARGURA
			sh 		t2, 0(t1)
		
			la		t1, mapa.hitbox.largura 
			li 		t2, T5.LARGURA
			sh		t2, 0(t1)
	
			la 		t1, mapa.max.x
			li 		t2, T5.MAX.X
			sh		t2, 0(t1)
	
			la 		t1, mapa.min.x
			li		t2, T5.MIN.X
			sh		t2, 0(t1)
			
			la 		t1, mapa.max.y
			li		t2, T5.MAX.Y
			sh		t2, 0(t1)
			
			la 		t1, mapa.min.y
			li		t2, T5.MIN.Y
			sh		t2, 0(t1)
			
			la 		t0, mapa_hitbox
			la 		t1, tela_5_hitboxes
			sw		t1, 0(t0)
			
			ret

# Constantes ao mudar para tela 6
CONFIG.TELA_6:		la		t0, TELA.DESCRITORES
			lw		s9, 20(t0)
			
			
			la		t1, mapa.imagem.largura
			li 		t2, T6.LARGURA
			sh 		t2, 0(t1)
		
			la		t1, mapa.hitbox.largura 
			li 		t2, T6.LARGURA
			sh		t2, 0(t1)
	
			la 		t1, mapa.max.x
			li 		t2, T6.MAX.X
			sh		t2, 0(t1)
	
			la 		t1, mapa.min.x
			li		t2, T6.MIN.X
			sh		t2, 0(t1)
			
			la 		t1, mapa.max.y
			li		t2, T6.MAX.Y
			sh		t2, 0(t1)
			
			la 		t1, mapa.min.y
			li		t2, T6.MIN.Y
			sh		t2, 0(t1)
			
			la 		t0, mapa_hitbox
			la 		t1, tela_6_hitboxes
			sw		t1, 0(t0)
			
			ret

# Constantes para tela 7
CONFIG.TELA_7:		la		t0, TELA.DESCRITORES
			lw		s9, 24(t0)
			
			
			la		t1, mapa.imagem.largura
			li 		t2, T7.LARGURA
			sh 		t2, 0(t1)
		
			la		t1, mapa.hitbox.largura 
			li 		t2, T7.LARGURA
			sh		t2, 0(t1)
	
			la 		t1, mapa.max.x
			li 		t2, T7.MAX.X
			sh		t2, 0(t1)
	
			la 		t1, mapa.min.x
			li		t2, T7.MIN.X
			sh		t2, 0(t1)
			
			la 		t1, mapa.max.y
			li		t2, T7.MAX.Y
			sh		t2, 0(t1)
			
			la 		t1, mapa.min.y
			li		t2, T7.MIN.Y
			sh		t2, 0(t1)
			
			la 		t0, mapa_hitbox
			la 		t1, tela_7_hitboxes
			sw		t1, 0(t0)
			
			ret

# Constantes para tela 10
CONFIG.TELA_10:		la		t0, TELA.DESCRITORES
			lw		s9, 28(t0)
			
			la		t1, mapa.imagem.largura
			li 		t2, T10.LARGURA
			sh 		t2, 0(t1)
		
			la		t1, mapa.hitbox.largura 
			li 		t2, T10.LARGURA
			sh		t2, 0(t1)
	
			la 		t1, mapa.max.x
			li 		t2, T10.MAX.X
			sh		t2, 0(t1)
	
			la 		t1, mapa.min.x
			li		t2, T10.MIN.X
			sh		t2, 0(t1)
			
			la 		t1, mapa.max.y
			li		t2, T10.MAX.Y
			sh		t2, 0(t1)
			
			la 		t1, mapa.min.y
			li		t2, T10.MIN.Y
			sh		t2, 0(t1)
			
			la 		t0, mapa_hitbox
			la 		t1, tela_10_hitboxes
			sw		t1, 0(t0)
			
			li		t0, 128
			li		t1, 106
			fcvt.s.w	fs10, t1
			fcvt.s.w	fs11, t0
			
			ret

# Constantes para a tela 11
CONFIG.TELA_11:		la		t0, TELA.DESCRITORES
			lw		s9, 40(t0)
			
			la		t1, mapa.imagem.largura
			li 		t2, T11.LARGURA
			sh 		t2, 0(t1)
		
			la		t1, mapa.hitbox.largura 
			li 		t2, T11.LARGURA
			sh		t2, 0(t1)
	
			la 		t1, mapa.max.x
			li 		t2, T11.MAX.X
			sh		t2, 0(t1)
	
			la 		t1, mapa.min.x
			li		t2, T11.MIN.X
			sh		t2, 0(t1)
			
			la 		t1, mapa.max.y
			li		t2, T11.MAX.Y
			sh		t2, 0(t1)
			
			la 		t1, mapa.min.y
			li		t2, T11.MIN.Y
			sh		t2, 0(t1)
			
			la 		t0, mapa_hitbox
			la 		t1, tela_11_hitboxes
			sw		t1, 0(t0)
			
			ret

# Constantes para a tela de bossfight
CONFIG.TELA_BF:		la		t0, TELA.DESCRITORES
			lw		s9, 32(t0)
			
			la		t1, mapa.imagem.largura
			li 		t2, TBF.LARGURA
			sh 		t2, 0(t1)
		
			la		t1, mapa.hitbox.largura 
			li 		t2, TBF.LARGURA
			sh		t2, 0(t1)
	
			la 		t1, mapa.max.x
			li 		t2, TBF.MAX.X
			sh		t2, 0(t1)
	
			la 		t1, mapa.min.x
			li		t2, TBF.MIN.X
			sh		t2, 0(t1)
			
			la 		t1, mapa.max.y
			li		t2, TBF.MAX.Y
			sh		t2, 0(t1)
			
			la 		t1, mapa.min.y
			li		t2, TBF.MIN.Y
			sh		t2, 0(t1)
			
			la 		t0, mapa_hitbox
			la 		t1, tela_bf_hitboxes
			sw		t1, 0(t0)
			
			ret

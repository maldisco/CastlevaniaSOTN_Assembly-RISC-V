.data

# Posi�oes atuais do personagem
horizontal_luffy:			.word 120
vertical_luffy:				.word 135


velocidadeY_luffy:			.float 0

# booleano para indicar se o personagem est� em anima��o de pulo
moveX:					.byte 0
pulando:				.byte 0
sentido:				.byte 1
socando:				.byte 0

.text
# Renderiza novamente o mapa
MAPA.ATUALIZA:		addi 		sp, sp, -4
			sw 		ra, (sp)				# Guardando endere�o de retorno para o loop principal
		
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
			
			lw 		ra, (sp)				# Retorna ao loop principal
			addi 		sp, sp, 4
			ret

# Atualiza a posi��o da personagem 	
LUFFY.ATUALIZA:		addi 		sp, sp, -4
			sw 		ra, (sp)			# Guardando endere�o de retorno para o loop principal
		
			la	 	t1, velocidadeY_luffy
			flw 		ft1, (t1)
			loadw(t2, vertical_luffy)
			fcvt.s.w 	ft2, t2
			fadd.s 		ft3, ft2, ft1
			fcvt.w.s 	s1, ft3				# s1 = Nova posi��o Y
			
			la 		t2, GRAVIDADE
			flw 		ft0, (t2)
			fadd.s 		fs2, ft1, ft0			
			fcvt.w.s	s2, fs2				# s2 = Nova velocidade Y = velocidade + gravidade
			
			loadb(t1, socando)
			bnez 		t1, LUFFY.SOCANDO
			loadb(t1, pulando)
			bnez 		t1, LUFFY.PULANDO
			loadb(t1, moveX)
			bgtz 		t1, LUFFY.CORRENDO.DIREITA
			bltz 		t1, LUFFY.CORRENDO.ESQUERDA
			
LUFFY.PARADO:		jal 		COLISAO.BAIXO			# Checa se colidiu com o ch�o
			bnez 		a0, LP.COLIDIU.BAIXO
						
LP.MOVE.MAPA:		la 		t1, mapa.y
			lhu 		t2, (t1)
			addi 		t2, t2, 2			# desce 2 pixels
			la 		t0, mapa.max.y
			lhu		t3, 0(t0)
			bgt 		t2, t3, LP.MOVE.CHAR		# Se passar do Limite inferior do mapa, move o personagem ao inv�s do mapa
			
			sh		t2, (t1)			# Se n�o, move mapa
			j 		LP.COLIDIU.BAIXO

LP.MOVE.CHAR:		# Movimenta o personagem em Y
			la		t0, vertical_luffy
			lw		t1, 0(t0)
			addi 		t1, t1, 3
			sw		t1, 0(t0)
					
LP.COLIDIU.BAIXO:	# Gera os valores para renderizar
			mv 		a0, s10				# Descritor
			loadw(a1, horizontal_luffy)			# X na tela
			loadw(a2, vertical_luffy)			# Y na tela
			li 		a3, LUFFY.OFFSET		# Largura da imagem
			li 		a4, LUFFY.LARGURA		# Largura da sprite
			frame_address(a5)				# Endere�o da frame
			loadb(t1, sprite_frame_atual)
			li 		t2, 48
			blt 		t1, t2,LP.NAORESETA
			
			li		t1, 0
			saveb(t1, sprite_frame_atual)
			
LP.NAORESETA:
			addi 		t3, t1, 1			# Avan�a um movimento na anima��o
			saveb(t3, sprite_frame_atual)
			li 		t2, 4
			mul 		t1, t1, t2
			la 		t2, luffy.parado.direita.offsets
			loadb(t3, sentido)
			bgtz 		t3, LP.SENTIDO.DIREITA
			
			la 		t2 luffy.parado.esquerda.offsets
			
LP.SENTIDO.DIREITA:
			add 		t2, t2, t1
			lw 		a6, (t2)			# Offset na imagem
			li 		a7, LUFFY.ALTURA
			jal 		RENDER
			atualiza_tela()					# Troca a frame sendo mostrada (0->1/1->0)
			lw 		ra, (sp)			# Retorna ao loop principal
			addi 		sp, sp, 4
			ret
# LPU	
LUFFY.PULANDO:		# Atualiza a posi��o Y
			fcvt.s.w 	ft0, zero
			la 		t1, velocidadeY_luffy
			flw 		ft1, 0(t1)
			flt.s		t1, ft1, ft0			# t1 = 1 if ft1 < ft0 else 0
					
			bnez		t1, LPU.SUBINDO
			
LPU.DESCENDO:		# Checa se j� caiu no ch�o
			jal 		COLISAO.BAIXO
			beqz 		a0, LPU.MOVE_Y
			
			saveb(zero, pulando)
			# Salva nova velocidade Y
			la 		t1, velocidadeY_luffy
			fsw		fs2, (t1)
			j 		LPU.ATUALIZA_X	
				
LPU.SUBINDO:		# Checa se bateu no teto
			jal 		COLISAO.CIMA
			beqz 		a0, LPU.MOVE_Y
			
			# Salva nova velocidade Y
			la 		t1, velocidadeY_luffy
			fsw		fs2, (t1)
			j 		LPU.ATUALIZA_X	
				
LPU.MOVE_Y:		# Movimenta o mapa em Y
			la 		t1, mapa.y
			lhu 		t2, 0(t1)
			la 		t3, velocidadeY_luffy
			flw 		ft1, 0(t3)
			fcvt.w.s	t3, ft1
			add 		t2, t2, t3
			la		t0, mapa.max.y
			lhu		t3, 0(t0)
			bgt		t2, t3, LPU.MOVE_Y.CHAR		# Se passar do limite inferior do mapa, move o personagem ao inv�s do mapa
			
			la		t0, mapa.min.y
			lhu		t3, 0(t0)
			blt		t2, t3, LPU.MOVE_Y.CHAR		# Se passar do limite superior do mapa, move o personagem ao inv�s do mapa
			
			la		t0, vertical_luffy		# Se o personagem est� acima da metade da tela, move o personagem ao inv�s do mapa
			lw		t3, (t0)	
			li 		t4, 130
			blt		t3, t4, LPU.MOVE_Y.CHAR		
												
			sh		t2, (t1)			# Se n�o, move mapa
			j		LPU.ATUALIZA_X
					
LPU.MOVE_Y.CHAR:	# Movimenta o personagem em Y
			la		t0, vertical_luffy
			lw		t1, 0(t0)
			la 		t3, velocidadeY_luffy
			flw 		ft1, 0(t3)
			fcvt.w.s	t3, ft1
			add 		t1, t1, t3
			sw		t1, 0(t0)	
	
															
# Atualiza a posi��o X
LPU.ATUALIZA_X:		# Salva nova velocidade Y
			la 		t1, velocidadeY_luffy
			fsw		fs2, (t1)
			loadb(t1, moveX)
			beqz 		t1, LPU.PARADO
			bgtz 		t1, LPU.DIREITA

LPU.ESQUERDA:		# Testa colis�o a esquerda
			jal 		COLISAO.ESQUERDA			
			bnez 		a0, LPU.PARADO	
			 
			
			la 		t1, mapa.x
			lhu 		t2, (t1)
			addi 		t2, t2, -2
			la		t0, mapa.min.x
			lhu 		t3, 0(t0)
			blt		t2, t3, LPU.ESQUERDA.MOVE.CHAR	
			
			la		t0, horizontal_luffy
			lw		t4, (t0)
			li		t5, 120
			bgt 		t4, t5, LPU.ESQUERDA.MOVE.CHAR		
						
LPU.ESQUERDA.MOVE.MAPA:	# Movimenta o mapa em X			
			sh 		t2, (t1)
			j 		LPU.PARADO
			
LPU.ESQUERDA.MOVE.CHAR:	la 		t1, horizontal_luffy
			lw 		t2, 0(t1)
			addi 		t2, t2, -2
			sw 		t2, 0(t1)
						
			j 		LPU.PARADO
			
LPU.DIREITA:		# Calcula colis�o
			jal 		COLISAO.DIREITA
			bnez 		a0, LPU.PARADO				# Se bateu em algo, n�o move
								
			la	 	t1, mapa.x
			lhu 		t2, (t1)
			addi 		t2, t2, 2
			la		t0, mapa.max.x
			lhu		t3, 0(t0)
			bgt 		t2, t3, LPU.DIREITA.MOVE.CHAR
			
			la		t0, horizontal_luffy
			lw		t4, (t0)
			li		t5, 120
			blt		t4, t5, LPU.DIREITA.MOVE.CHAR
				
LPU.DIREITA.MOVE.MAPA:	# Movimenta o mapa em X			
			sh 		t2, (t1)
			j 		LPU.PARADO
			
LPU.DIREITA.MOVE.CHAR:	la 		t1, horizontal_luffy
			lw 		t2, 0(t1)
			addi 		t2, t2, 2
			sw 		t2, 0(t1)
						
LPU.PARADO:	# Gera os valores para renderizar
			mv 		a0, s10					# Descritor
			loadw(a1, horizontal_luffy)				# X na tela
			loadw(a2, vertical_luffy)				# Y na tela 
			li 		a3, LUFFY.OFFSET			# Largura da imagem
			li 		a4, LUFFY.LARGURA			# Largura da sprite
			frame_address(a5)					# Endere�o da frame
			loadb(t1, sprite_frame_atual)
			li 		t2, 88
			blt 		t1, t2,LPU.NAO_RESETA			# Se tiver chegado na ultima anima��o, reseta
			
			li 		t1, 0
			saveb(t1, sprite_frame_atual)
			
LPU.NAO_RESETA:
			addi 		t3, t1, 1				# Avan�a um movimento na anima��o
			saveb(t3, sprite_frame_atual)
			li 		t2, 4
			mul 		t1, t1, t2
			la 		t2, luffy.pulando.direita.offsets
			loadb(t3, sentido)
			bgtz 		t3, LPU.SENTIDO.DIREITA
			
			la 		t2 luffy.pulando.esquerda.offsets
			
LPU.SENTIDO.DIREITA:
			add 		t2, t2, t1
			lw 		a6, (t2)				# Offset na imagem
			li 		a7, LUFFY.ALTURA
			jal 		RENDER
			
			atualiza_tela()
			lw 		ra, (sp)				# Retorna ao loop principal
			addi		sp, sp, 4
			ret

# LCD			
LUFFY.CORRENDO.DIREITA:	# Calcula colis�o
			jal 		COLISAO.DIREITA
			bnez 		a0, LCD.COLIDIU
								
LCD.MOVE.MAPA:		# Se tiver chegado no final do mapa OU o personagem est� � esquerda do centro da tela, move o personagem
			# Se n�o, move a tela/mapa
			la 		t1, mapa.x
			lhu 		t2, (t1)
			addi 		t2, t2, 2
			la		t0, mapa.max.x
			lhu		t3, (t0)
			bgt		t2, t3 LCD.MOVE.CHAR
			
			la		t0, horizontal_luffy
			lw		t4, (t0)
			li		t5, 120
			blt 		t4, t5, LCD.MOVE.CHAR
			
			sh 		t2, (t1)
			j 		LCD.COLIDIU
			
LCD.MOVE.CHAR:		la 		t1, horizontal_luffy
			lw 		t2, 0(t1)
			addi 		t2, t2, 2
			sw 		t2, 0(t1)
			
LCD.COLIDIU:		jal 		COLISAO.BAIXO
			bnez 		a0, LCD.COLIDIU.BAIXO		
		
LCD.MOVE_Y.MAPA:
			# Movimenta o mapa em Y
			la 		t1, mapa.y
			lhu 		t2, (t1)
			addi 		t2, t2, 3			# desce 2 pixels
			la		t0, mapa.max.y
			lhu		t3, 0(t0)
			bgt 		t2, t3, LCD.MOVE_Y.CHAR		# Se chegou ao limite inferior do mapa, move o personagem ao inv�s do mapa
			
			sh		t2, (t1)
			j 		LCD.COLIDIU.BAIXO

LCD.MOVE_Y.CHAR:	# Movimenta o personagem em Y
			la		t0, vertical_luffy
			lw		t1, 0(t0)
			addi 		t1, t1, 3
			sw		t1, 0(t0)
			
LCD.COLIDIU.BAIXO:	# Decrementa uma movimenta��o a direita
			la 		t1, moveX
			lb 		t2, (t1)
			addi 		t2, t2, -1
			sb 		t2, (t1)
			# Gera os valores para renderizar
			mv 		a0, s10						# Descritor
			loadw(a1, horizontal_luffy)					# X na tela
			loadw(a2, vertical_luffy)					# Y na tela
			li 		a3, LUFFY.OFFSET				# Largura da imagem
			li 		a4, LUFFY.LARGURA				# Largura da sprite
			frame_address(a5)						# Endere�o da frame
			loadb(t1, sprite_frame_atual)
			li 		t2, 62
			
			blt 		t1, t2,LCD.NAO_RESETA
			
			li 		t1, 32
			saveb(t1, sprite_frame_atual)
			
LCD.NAO_RESETA:
			addi 		t3, t1, 1					# Avan�a um movimento na anima��o
			saveb(t3, sprite_frame_atual)
			li 		t2, 4
			mul 		t1, t1, t2
			la 		t2, luffy.correndo.direita.offsets
			add 		t2, t2, t1
			lw 		a6, (t2)					# Offset na imagem
			li 		a7, LUFFY.ALTURA
			jal 		RENDER

			atualiza_tela()
			lw 		ra, (sp)					# Retorna ao loop principal
			addi 		sp, sp, 4
			ret
# LCE	
LUFFY.CORRENDO.ESQUERDA:# Calcula colis�o
			jal 		COLISAO.ESQUERDA
			bnez 		a0, LCE.COLIDIU 

LUFFY.MOVE.MAPA:	# Se tiver chegado no inicio do mapa OU o personagem est� � direita do centro da tela, move o personagem
			# Se n�o, move a tela/mapa		 					 		
			la 		t1, mapa.x
			lhu		t2, (t1)
			addi 		t2, t2, -2
			la		t0, mapa.min.x
			lhu		t3, 0(t0)
			blt		t2, t3, LCE.MOVE.CHAR
			
			la		t0, horizontal_luffy
			lw		t4, (t0)
			li		t5, 120
			bgt		t4, t5, LCE.MOVE.CHAR			
		
			sh 		t2, (t1)
			j 		LCE.COLIDIU
			
LCE.MOVE.CHAR:		la 		t1, horizontal_luffy
			lw 		t2, 0(t1)
			addi 		t2, t2, -2
			sw 		t2, 0(t1)
			
LCE.COLIDIU:		jal 		COLISAO.BAIXO
			bnez 		a0, LCE.COLIDIU.BAIXO

LCE.MOVE_Y.MAPA:
			# Movimenta o mapa em Y
			la 		t1, mapa.y
			lhu 		t2, (t1)
			addi 		t2, t2, 3			# desce 2 pixels
			la		t0, mapa.max.y
			lhu		t3, 0(t0)
			bgt 		t2, t3, LCE.MOVE_Y.CHAR		# Se tiver chegado no limite inferior do mapa, move o personagem ao inv�s do mapa
			
			sh		t2, (t1)
			j 		LCE.COLIDIU.BAIXO

LCE.MOVE_Y.CHAR:	# Movimenta o personagem em Y
			la		t0, vertical_luffy
			lw		t1, 0(t0)
			addi 		t1, t1, 3
			sw		t1, 0(t0)
			
LCE.COLIDIU.BAIXO:	# Decrementa uma movimenta��o a esquerda
			la 		t1, moveX
			lb 		t2, (t1)
			addi 		t2, t2, 1
			sb 		t2, (t1)
			# Gera os valores para renderizar
			mv 		a0, s10						# Descritor
			loadw(a1, horizontal_luffy)					# X na tela
			loadw(a2, vertical_luffy)					# Y na tela
			li 		a3, LUFFY.OFFSET				# Largura da imagem
			li 		a4, LUFFY.LARGURA				# Largura da sprite
			frame_address(a5)						# Endere�o da frame
			loadb(t1, sprite_frame_atual)
			li 		t2, 62
			blt 		t1, t2,LCE.NAO_RESETA				# Se tiver chegado na �ltima anima��o, recicla
			
			li 		t1, 32
			saveb(t1, sprite_frame_atual)
			
LCE.NAO_RESETA:
			addi 		t3, t1, 1					# Avan�a um movimento na anima��o
			saveb(t3, sprite_frame_atual)
			li 		t2, 4
			mul 		t1, t1, t2
			la 		t2, luffy.correndo.esquerda.offsets
			add 		t2, t2, t1
			lw 		a6, (t2)					# Offset na imagem
			li 		a7, LUFFY.ALTURA
			jal	RENDER
		
			atualiza_tela()	
			lw 		ra, (sp)					# Retorna ao loop principal
			addi		sp, sp, 4
			ret	

# LS	
LUFFY.SOCANDO:		# Testa colis�o abaixo
			jal 		COLISAO.BAIXO
			bnez		a0, LS.COLIDIU.BAIXO		
	
LS.MOVE_Y:		# Movimenta o mapa em Y
			la 		t1, mapa.y
			lhu 		t2, 0(t1)
			la 		t3, velocidadeY_luffy
			flw 		ft1, 0(t3)
			fcvt.w.s	t3, ft1
			add 		t2, t2, t3
			la		t0, mapa.max.y
			lhu		t3, 0(t0)
			bgt		t2, t3, LS.MOVE_Y.CHAR		# Se passar do limite inferior do mapa, move o personagem ao inv�s do mapa
			
			la		t0, mapa.min.y
			lhu		t3, 0(t0)
			blt		t2, t3, LS.MOVE_Y.CHAR		# Se passar do limite superior do mapa, move o personagem ao inv�s do mapa
			
			la		t0, vertical_luffy		# Se o personagem est� acima da metade da tela, move o personagem ao inv�s do mapa
			lw		t3, (t0)	
			li 		t4, 130
			blt		t3, t4, LS.MOVE_Y.CHAR		
												
			sh		t2, (t1)			# Se n�o, move mapa
			j		LS.COLIDIU.BAIXO
					
LS.MOVE_Y.CHAR:	# Movimenta o personagem em Y
			la		t0, vertical_luffy
			lw		t1, 0(t0)
			la 		t3, velocidadeY_luffy
			flw 		ft1, 0(t3)
			fcvt.w.s	t3, ft1
			add 		t1, t1, t3
			sw		t1, 0(t0)	
			
LS.COLIDIU.BAIXO:	# Salva nova velocidade Y
			la 		t1, velocidadeY_luffy
			fsw		fs2, (t1)
			# Gera os valores para renderizar
			mv 		a0, s10						# Descritor
			loadw(a1, horizontal_luffy)					# X na tela
			loadw(a2, vertical_luffy)					# Y na tela
			li 		a3, LUFFY.OFFSET				# Largura da imagem
			li 		a4, LUFFY.LARGURA				# Largura da sprite
			frame_address(a5)						# Endere�o da frame
		
			loadb(t1, sprite_frame_atual)
			li 		t2, 34
			blt 		t1, t2,LS.RENDER				# Se tiver chegado na ultima anima��o, para de socar
			
			li 		t1, 0
			saveb(t1, sprite_frame_atual)
			saveb(t1, socando)
			j LS.RET
			
LS.RENDER:		addi 		t3, t1, 1					# Avan�a um movimento na anima��o
			saveb(t3, sprite_frame_atual)
			li 		t2, 4
			mul 		t1, t1, t2
			la 		t2, luffy.socando.direita.offsets
			loadb(t3, sentido)
			bgtz 		t3, LS.SENTIDO.DIREITA
			
			la 		t2, luffy.socando.esquerda.offsets			
LS.SENTIDO.DIREITA:
			add 		t2, t2, t1
			lw 		a6, (t2)					# Offset na imagem
			li 		a7, LUFFY.ALTURA
			jal 		RENDER
		
			atualiza_tela()
LS.RET:
			lw 		ra, (sp)					# Retorna ao loop principal
			addi 		sp, sp, 4
			ret
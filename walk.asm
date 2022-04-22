.data

# Posiçoes atuais do personagem
horizontal_luffy:			.word 120
vertical_luffy:				.word 130


velocidadeY_luffy:			.float 0

# booleano para indicar se o personagem está em animação de pulo
moveX:				.byte 0
pulando:			.byte 0
sentido:			.byte 1
socando:			.byte 0

# Tempo desde a ultima atualização de posição
tempo_luffy:			.word 0

.text
# Renderiza novamente o mapa
MAPA.ATUALIZA:		addi 		sp, sp, -4
			sw 		ra, (sp)				# Guardando endereço de retorno para o loop principal
		
			mv 		a0, s9
			li		a1, 0		
			li 		a2, 0
			li 		a3, MAPA.IMAGEM.LARGURA
			li 		a4, MAPA.LARGURA		
			frame_address(a5)
			offset_mapa(a6)
			li 		a7, MAPA.ALTURA
			jal		RENDER
			
			lw 		ra, (sp)				# Retorna ao loop principal
			addi 		sp, sp, 4
			ret

# Atualiza a posição da personagem 	
LUFFY.ATUALIZA:		addi 		sp, sp, -4
			sw 		ra, (sp)			# Guardando endereço de retorno para o loop principal
		
			la	 	t1, velocidadeY_luffy
			flw 		ft1, (t1)
			loadw(t2, vertical_luffy)
			fcvt.s.w 	ft2, t2
			fadd.s 		ft3, ft2, ft1
			fcvt.w.s 	s1, ft3				# s1 = Nova posição Y
			
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
			
LUFFY.PARADO:		jal 		COLISAO.BAIXO			# Checa se colidiu com o chão
			bnez 		a0, LP.COLIDIU.BAIXO
			
			# Movimenta o mapa em Y
			la 		t1, mapa.y
			lhu 		t2, (t1)
			addi 		t2, t2, 2			# desce 2 pixels
			mv		a1, t2
			li 		a2, MAPA.MAX.Y
			jal 		MIN
			sh 		a0, 0(t1)
			
LP.COLIDIU.BAIXO:	# Gera os valores para renderizar
			mv 		a0, s10				# Descritor
			loadw(a1, horizontal_luffy)			# X na tela
			loadw(a2, vertical_luffy)			# Y na tela
			li 		a3, LUFFY.OFFSET		# Largura da imagem
			li 		a4, LUFFY.LARGURA		# Largura da sprite
			frame_address(a5)				# Endereço da frame
			loadb(t1, sprite_frame_atual)
			li 		t2, 24
			blt 		t1, t2,LUFFY.PARADO.NAORESETA
			
			li		t1, 0
			saveb(t1, sprite_frame_atual)
			
LUFFY.PARADO.NAORESETA:
			addi 		t3, t1, 1			# Avança um movimento na animação
			saveb(t3, sprite_frame_atual)
			li 		t2, 4
			mul 		t1, t1, t2
			la 		t2, luffy.parado.direita.offsets
			loadb(t3, sentido)
			bgtz 		t3, LUFFY.PARADO.SENTIDO.DIREITA
			
			la 		t2 luffy.parado.esquerda.offsets
			
LUFFY.PARADO.SENTIDO.DIREITA:
			add 		t2, t2, t1
			lw 		a6, (t2)			# Offset na imagem
			li 		a7, LUFFY.ALTURA
			jal 		RENDER
			atualiza_tela()					# Troca a frame sendo mostrada (0->1/1->0)
			lw 		ra, (sp)			# Retorna ao loop principal
			addi 		sp, sp, 4
			ret
# LPU	
LUFFY.PULANDO:		# Atualiza a posição Y
			fcvt.s.w 	ft0, zero
			la 		t1, velocidadeY_luffy
			flw 		ft1, 0(t1)
			flt.s		t1, ft1, ft0			# t1 = 1 if ft1 < ft0 else 0
					
			bnez		t1, LPU.SUBINDO
			
LPU.DESCENDO:		# Checa se já caiu no chão
			jal 		COLISAO.BAIXO
			beqz 		a0, LPU.MOVE_Y
			
			saveb(zero, pulando)
			# Salva nova velocidade Y
			la 		t1, velocidadeY_luffy
			fsw		fs2, (t1)
			j 		LPU.ATUALIZA_X	
				
LPU.SUBINDO:		#Checa se bateu no teto
			jal 	COLISAO.CIMA
			beqz 	a0, LPU.MOVE_Y
			
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
			# MIN entre a nova posição e a maior posição possível
			mv 		a1, t2			
			li 		a2, MAPA.MAX.Y
			jal 		MIN
			# MAX entre a nova posição e a menor posição possível
			mv 		a1, a0
			li 		a2, MAPA.MIN.Y
			jal 		MAX				
			sh 		a0, 0(t1)			
# Atualiza a posição X
LPU.ATUALIZA_X:		# Salva nova velocidade Y
			la 		t1, velocidadeY_luffy
			fsw		fs2, (t1)
			loadb(t1, moveX)
			beqz 		t1, LPU.PARADO
			bgtz 		t1, LPU.DIREITA

LPU.ESQUERDA:		jal 		COLISAO.ESQUERDA			
			bnez 		a0, LPU.PARADO	
			 
			la 		t1, mapa.lock.x
			lb 		t1, 0(t1)
			bgtz 		t1, LPU.ESQUERDA.MOVE.CHAR
								
LPU.ESQUERDA.MOVE.MAPA:		# Movimenta o mapa em X			
			la 		t1, mapa.x
			lhu 		t2, (t1)
			addi 		t2, t2, -3
			mv 		a1, t2
			li 		a2, MAPA.MIN.X
			jal 		MAX
			sh 		a0, (t1)
			j 		LPU.PARADO
			
LPU.ESQUERDA.MOVE.CHAR:	la 		t1, horizontal_luffy
			lw 		t2, 0(t1)
			addi 		t2, t2, -3
			sw 		t2, 0(t1)
			j 		LPU.PARADO
			
LPU.DIREITA:		jal 		COLISAO.DIREITA
			bnez 		a0, LPU.PARADO	# Se bateu em algo, não move
				
			la 		t1, mapa.lock.x
			lb 		t1, 0(t1)
			bgtz 		t1, LPU.DIREITA.MOVE.CHAR
				
LPU.DIREITA.MOVE.MAPA:		# Movimenta o mapa em X			
			la	 	t1, mapa.x
			lhu 		t2, (t1)
			addi 		t2, t2, 3
			mv 		a1, t2
			li 		a2, MAPA.MAX.X
			jal 		MIN
			sh 		a0, (t1)
			j 		LPU.PARADO
			
LPU.DIREITA.MOVE.CHAR:	la 		t1, horizontal_luffy
			lw 		t2, 0(t1)
			addi 		t2, t2, 3
			sw 		t2, 0(t1)
			
LPU.PARADO:	# Gera os valores para renderizar
			mv 		a0, s10					# Descritor
			loadw(a1, horizontal_luffy)				# X na tela
			loadw(a2, vertical_luffy)				# Y na tela 
			li 		a3, LUFFY.OFFSET			# Largura da imagem
			li 		a4, LUFFY.LARGURA			# Largura da sprite
			frame_address(a5)					# Endereço da frame
			loadb(t1, sprite_frame_atual)
			li 		t2, 44
			blt 		t1, t2,LPU.NAO_RESETA			# Se tiver chegado na ultima animação, reseta
			
			li 		t1, 0
			saveb(t1, sprite_frame_atual)
			
LPU.NAO_RESETA:
			addi 		t3, t1, 1				# Avança um movimento na animação
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
LUFFY.CORRENDO.DIREITA:	# Checa se deve destravar a camera
			la 		t1, mapa.lock.x
			lb 		t2, 0(t1)
			beqz 		t2, LCD.NAOTRAVADA
			la 		t2, horizontal_luffy
			lw 		t2, 0(t2)
			addi 		t2, t2 , 3
			li 		t3, 280
			blt 		t2, t3, LCD.NAOTRAVADA
			li 		t2, 0					# Se a camera estiver travada, e o personagem chegar no limite esquerdo da tela
			sb 		t2, (t1)				# Destrava a camera
			la 		t1, mapa.x
			la 		t2, horizontal_luffy
			lhu 		t3, 0(t1)
			li		t4, 145					# Coloca o personagem no meio da tela
			addi 		t3, t3, 145				# Arrasta a tela para esquerda
			sh 		t3, 0(t1)
			sw 		t4, 0(t2)
			
LCD.NAOTRAVADA:		# Checa se deve travar a camera horizontalmente
			la 		t1, mapa.x
			lhu 		t2, 0(t1)
			li		t3, MAPA.MAX.X
			blt 		t2, t3, LCD.NAOTRAVA
			la		t1, mapa.lock.x
			li		t2, 1
			sb 		t2, 0(t1)
			
LCD.NAOTRAVA:		# Calcula colisões
			jal 		COLISAO.DIREITA
			bnez 		a0, LCD.COLIDIU
			la 		t1, mapa.lock.x
			lb 		t1, 0(t1)
			
			bgtz 		t1, LCD.MOVE.CHAR
					
LCD.MOVE.MAPA:		# Movimenta o mapa em X			
			la 		t1, mapa.x
			lhu 		t2, (t1)
			addi 		t2, t2, 3
			mv 		a1, t2
			li 		a2, MAPA.MAX.X
			jal 		MIN
			sh 		a0, (t1)
			
			j 		LCD.COLIDIU
			
LCD.MOVE.CHAR:		la 		t1, horizontal_luffy
			lw 		t2, 0(t1)
			addi 		t2, t2, 3
			sw 		t2, 0(t1)
			
LCD.COLIDIU:		jal 		COLISAO.BAIXO

			bnez 		a0, LCD.COLIDIU.BAIXO
			# Movimenta o mapa em Y
			la 		t1, mapa.y
			lhu 		t2, (t1)
			addi 		t2, t2, 2					# S2 =  Velocidade Y do personagem
			mv 		a1, t2
			li 		a2, MAPA.MAX.Y
			jal 		MIN
			sh 		a0, 0(t1)
			
LCD.COLIDIU.BAIXO:	# Decrementa uma movimentação a direita
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
			frame_address(a5)						# Endereço da frame
			loadb(t1, sprite_frame_atual)
			li 		t2, 31
			
			blt 		t1, t2,LCD.NAO_RESETA
			
			li 		t1, 16
			saveb(t1, sprite_frame_atual)
			
LCD.NAO_RESETA:
			addi 		t3, t1, 1					# Avança um movimento na animação
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
LUFFY.CORRENDO.ESQUERDA:# Checa se deve destravar a camera horizontalmente
			la 		t1, mapa.lock.x
			lb 		t2, 0(t1)
			beqz 		t2, LCE.NAOTRAVADA
			la 		t2, horizontal_luffy
			lw 		t2, 0(t2)
			addi 		t2, t2, -3
			bgtz 		t2, LCE.NAOTRAVADA
			li 		t2, 0						# Se a camera estiver travada, e o personagem chegar no limite esquerdo da tela
			sb 		t2, (t1)					# Destrava a camera
			la 		t1, mapa.x
			lhu 		t2, 0(t1)
			addi 		t2, t2, -145					# Arrasta a tela para esquerda
			sh 		t2, 0(t1)
			la 		t1, horizontal_luffy
			lw 		t2, 0(t1)
			addi 		t2, t2, 145					# Coloca o personagem no meio da tela
			sw 		t2, 0(t1)	
			
LCE.NAOTRAVADA:		# Checa se deve travar a camera horizontalmente
			la 		t1, mapa.x
			lhu 		t2, 0(t1)
			li 		t3, MAPA.MIN.X
			bgt 		t2, t3, LCE.NAOTRAVA
			la 		t1, mapa.lock.x
			li 		t2, 1
			sb 		t2, 0(t1)
			
LCE.NAOTRAVA:		jal 		COLISAO.ESQUERDA
			bnez 		a0, LCE.COLIDIU
			la 		t1, mapa.lock.x
			lb 		t1, 0(t1)
			bgtz 		t1, LCE.MOVE.CHAR
			
LCE.MOVE.MAPA:		# Movimenta o mapa em X			
			la 		t1, mapa.x
			lhu		t2, (t1)
			addi 		t2, t2, -3
			mv 		a1, t2
			li 		a2, MAPA.MIN.X
			jal 		MAX
			sh 		a0, (t1)
			j 		LCE.COLIDIU
			
LCE.MOVE.CHAR:		la 		t1, horizontal_luffy
			lw 		t2, 0(t1)
			addi 		t2, t2, -3
			sw 		t2, 0(t1)
			
LCE.COLIDIU:		jal 		COLISAO.BAIXO
			bnez 		a0, LCE.COLIDIU.BAIXO
			
			# Movimenta o mapa em Y
			la 		t1, mapa.y
			lhu 		t2, (t1)
			addi 		t2, t2, 2					# S2 =  Velocidade Y do personagem
			mv 		a1, t2
			li 		a2, MAPA.MAX.Y
			jal 		MIN
			sh 		a0, 0(t1)
			
LCE.COLIDIU.BAIXO:	# Decrementa uma movimentação a esquerda
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
			frame_address(a5)						# Endereço da frame
			loadb(t1, sprite_frame_atual)
			li 		t2, 31
			blt 		t1, t2,LCE.NAO_RESETA				# Se tiver chegado na última animação, recicla
			
			li 		t1, 16
			saveb(t1, sprite_frame_atual)
			
LCE.NAO_RESETA:
			addi 		t3, t1, 1					# Avança um movimento na animação
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
LUFFY.SOCANDO:		# Testa colisões verticais
			jal 	COLISAO.BAIXO
			bnez		a0, LS.COLIDIU.BAIXO
			# Movimenta o mapa em Y
			la 		t1, mapa.y	
			lhu 		t2, 0(t1)
			la 		t3, velocidadeY_luffy
			flw 		ft1, 0(t3)
			fcvt.w.s	t3, ft1
			add 		t2, t2, t3		
			# MIN entre a nova posição e a maior posição possível
			mv 		a1, t2			
			li 		a2, MAPA.MAX.Y
			jal 		MIN
			# MAX entre a nova posição e a menor posição possível
			mv 		a1, a0
			li 		a2, MAPA.MIN.Y
			jal 		MAX				
			sh 		a0, 0(t1)		
			# Salva nova velocidade Y
			la 		t1, velocidadeY_luffy
			fsw		fs2, (t1)
LS.COLIDIU.BAIXO:	# Gera os valores para renderizar
			mv 		a0, s10						# Descritor
			loadw(a1, horizontal_luffy)					# X na tela
			loadw(a2, vertical_luffy)					# Y na tela
			li 		a3, LUFFY.OFFSET				# Largura da imagem
			li 		a4, LUFFY.LARGURA				# Largura da sprite
			frame_address(a5)						# Endereço da frame
		
			loadb(t1, sprite_frame_atual)
			li 		t2, 17
			blt 		t1, t2,LS.RENDER				# Se tiver chegado na ultima animação, para de socar
			
			li 		t1, 0
			saveb(t1, sprite_frame_atual)
			saveb(t1, socando)
			j LS.RET
			
LS.RENDER:		addi 		t3, t1, 1					# Avança um movimento na animação
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
# ====================================================== REFATORAR COLISÕES LEMBRE =========================================================================

# Checa colisão à direita do personagem
# Return a0, 1 = Colidiu
COLISAO.DIREITA:	# Calcula coordenadas inicais da hitbox do persongem
			la 		t1, mapa.x
			lh 		t1, (t1)
			la 		t2, mapa.y
			lh 		t2, (t2)
			la 		t3, horizontal_luffy
			lw 		t3, (t3)
			li 		t4, LUFFY.HITBOX_OFFSET.X
			add 		t3, t3, t4
			addi 		t3, t3, 2
			la 		t4, vertical_luffy
			lw 		t4, (t4)
			li 		t5, LUFFY.HITBOX_OFFSET.Y
			add 		t4, t4, t5
	
			add 		t1, t1, t3			 # X do personagem relativo ao mapa
			add 		t2, t2, t4			 # Y do personagem relativo ao mapa
			
			la 		t3, map_hitbox
			addi 		t3, t3, 8
	 
			li 		t4, MAPA.HITBOX.LARGURA
			mul 		t4, t4, t2
			add 		t4, t4, t1			# t4 = Primeiro pixel do personagem no mapa de hitboxes
			
			li 		t5, LUFFY.HITBOX.LARGURA
			add 		t4, t4, t5			# t4 = Primeiro pixel a direita do personagem
			
			li 		t5, LUFFY.HITBOX.ALTURA
			addi 		t5, t5, -10			# Sobe um pouco pra não testar no pé
			
			li 		t6, 0
			
CD.LOOP:		add 		t1, t4, t3
			lb 		t2, 0(t1)
			bnez 		t2, CD.NEGATIVO
			
	 		li 		a0, 1
	 		ret
	 		
CD.NEGATIVO:		addi		t6, t6, 1
		 	li 		t1, MAPA.HITBOX.LARGURA
		 	add 		t4, t4, t1
		 	blt 		t6, t5, CD.LOOP
		 	
CD.FIM:			li 		a0, 0
			ret

# Checa colisão à esquerda do personagem
# Return a0, 1 = Colidiu
COLISAO.ESQUERDA:	# Calcula coordenadas inicais da hitbox do persongem
			la 		t1, mapa.x
			lh 		t1, (t1)
			la 		t2, mapa.y
			lh 		t2, (t2)
			la 		t3, horizontal_luffy
			lw		t3, (t3)
			li 		t4, LUFFY.HITBOX_OFFSET.X
			add 		t3, t3, t4
			addi 		t3, t3, -2
			la 		t4, vertical_luffy
			lw 		t4, (t4)
			li 		t5, LUFFY.HITBOX_OFFSET.Y
			add 		t4, t4, t5
			
			add 		t1, t1, t3			 # X do personagem relativo ao mapa
			add 		t2, t2, t4			 # Y do personagem relativo ao mapa
	
			la 		t3, map_hitbox
			addi 		t3, t3, 8
	 
			li		t4, MAPA.HITBOX.LARGURA
			mul 		t4, t4, t2
			add 		t4, t4, t1			# t4 = Endereço do primeiro pixel do personagem 
			
			li		t5, LUFFY.HITBOX.ALTURA
			addi 		t5, t5, -5
			
			li 		t6, 0
			
CE.LOOP:		add		t1, t4, t3
			lb		t2, 0(t1)
			bnez 		t2, CE.NEGATIVO
			
	 		li 		a0, 1
	 		ret
	 		
CE.NEGATIVO:		addi 		t6, t6, 1
		 	li 		t1, MAPA.HITBOX.LARGURA
		 	add 		t4, t4, t1
		 	blt		t6, t5, CE.LOOP
CE.FIM:
			li 		a0, 0
		 	ret

# Checa colisão abaixo do personagem
# Return a0, 1 = Colidiu
COLISAO.BAIXO:		# Calcula coordenadas inicais da hitbox do persongem
			la 		t1, mapa.x
			lh 		t1, (t1)
			la 		t2, mapa.y
			lh 		t2, (t2)
			la 		t3, horizontal_luffy
			lw 		t3, (t3)
			li		t4, LUFFY.HITBOX_OFFSET.X
			add 		t3, t3, t4
			la 		t4, vertical_luffy
			lw 		t4, (t4)
			li		t5, LUFFY.HITBOX_OFFSET.Y
			add 		t4, t4, t5
			addi 		t4, t4, 2
	
			add 		t1, t1, t3			 # X do personagem relativo ao mapa
			add 		t2, t2, t4			 # Y do personagem relativo ao mapa
	
			la 		t3, map_hitbox
			addi 		t3, t3, 8
	 
			li		t4, MAPA.HITBOX.LARGURA
			li 		t5, LUFFY.HITBOX.ALTURA
			add 		t2, t2, t5			# Desce até o pé do personagem
			mul 		t4, t4, t2
			add 		t4, t4, t1			# t4 = Endereço do primeiro pixel abaixo do personagem
	
			add 		t3, t3, t4			# Pixel no endereço de hitboxes
			li 		t5, LUFFY.HITBOX.LARGURA
			li		t6, 0
			
CB.LOOP:		lb		t2, 0(t3)
			bnez 		t2, CB.NEGATIVO
			
	 		li		a0, 1
	 		ret
	 		
CB.NEGATIVO:		addi 		t6, t6, 1
			addi 		t3, t3, 1
			blt 		t6, t5, CB.LOOP
			 
CB.FIM:			li		a0, 0
			ret
	
# Checa colisão acima do personagem
# Return a0, 1 = Colidiu
COLISAO.CIMA:		# Calcula coordenadas inicais da hitbox do persongem
			la		t1, mapa.x
			lh 		t1, (t1)
			la 		t2, mapa.y
			lh 		t2, (t2)
			la 		t3, horizontal_luffy
			lw 		t3, (t3)
			li		t4, LUFFY.HITBOX_OFFSET.X
			add		t3, t3, t4
			la		t4, vertical_luffy
			lw 		t4, (t4)
			li		t5, LUFFY.HITBOX_OFFSET.Y
			add 		t4, t4, t5
			addi		t4, t4, -2
			
			add 		t1, t1, t3			 # X do personagem relativo ao mapa
			add 		t2, t2, t4			 # Y do personagem relativo ao mapa
			
			la 		t3, map_hitbox
			addi 		t3, t3, 8
			 
			li 		t4, MAPA.HITBOX.LARGURA
			mul 		t4, t4, t2
			add 		t4, t4, t1			# t4 = Endereço do primeiro pixel acima do personagem
			
			add 		t3, t3, t4			# t3 = Pixel no endereço de hitboxes	
			li 		t5, LUFFY.HITBOX.LARGURA
			li 		t6, 0
CC.LOOP:
			lb 		t2, 0(t3)
			bnez 		t2, CC.NEGATIVO
			
			li 		a0, 1
			ret
			 
CC.NEGATIVO:
			addi 		t6, t6, 1
			addi 		t3, t3, 1
			blt 		t6, t5, CB.LOOP
			
CC.FIM:			li 		a0, 0
			ret	
	
# Param a0 = Descritor
# Param a1 = X na VGA
# Param a2 = Y na VGA
# Param a3 = Largura da imagem
# Param a4 = Largura da sprite
# Param a5 = Endereço da frame
# Param a6 = Offset na imagem
# Param a7 = Altura da sprite
RENDER:			# Calculo do endereço na VGA
			li 		t3, 320
			mul 		t3, t3, a2			# Y do personagem x 320 (Altura inicial)
			add 		t3, t3, a1
			add 		a5, a5, t3			# a5 = Endereço inicial = Frame 0/1 + horizontal + 320 x vertical
	
			# Calculo do endereço final na VGA
			li		t1, 320
			mul		t1, t1, a7
			add 		t1, t1, a4
			add 		t1, a5, t1
		
# a0 = Descritor
# a6 = Offset na imagem
# a5 = Offset na tela
# t1 = Endereço final na tela	
RENDER.LOOP: 		# Salva o descritor
			mv 		t5, a0
		
			# Chega à posição definida pelo offset na imagem
			li 		a7, 62
			mv		a1, a6			# a6 = offset na imagem
			li 		a2, 0
			ecall
				
			# Restaura a0
			mv		a0, t5
		
			# Transfere os bytes de uma linha do arquivo para a memóeria VGA
			li 		a7, 63
			mv 		a1, a5			# a5 = Endereço na VGA
			mv 		a2, a4			# a4 = Quantidade de bytes em uma linha
			ecall					# Escreve uma linha
				
			# Restaura a0
			mv 		a0, t5
		
			# Incrementar offset imagem (pular linha)
			add 		a6, a6, a3 
				
			# Incrementa offset VGA (pular linha)
			addi 		a5, a5, 320
		
			# a5 = Endereço atual na VGA
			# t1 = Endereço final na VGA
			bltu		a5, t1, RENDER.LOOP
			ret
			
	
	

.data

# Posiçoes atuais do personagem
horizontal_luffy:			.word 120
vertical_luffy:				.word 135


velocidadeY_luffy:			.float 0

# booleano para indicar se o personagem está em animação de pulo
moveX:					.byte 0
pulando:				.byte 0
sentido:				.byte 1
socando:				.byte 0

.text
# Renderiza novamente o mapa
MAPA.ATUALIZA:		addi 		sp, sp, -4
			sw 		ra, (sp)				# Guardando endereço de retorno para o loop principal
		
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
			
			la 		t0, mapa.lock.y
			lb		t1, 0(t0)
			bnez 		t1, LP.MOVE.CHAR		# Se o mapa estiver travado em Y, move o personagem
			
LP.MOVE.MAPA:
			la 		t1, mapa.y
			lhu 		t2, (t1)
			addi 		t2, t2, 2			# desce 2 pixels
			la 		t0, mapa.max.y
			lhu		t3, 0(t0)
			bgt 		t2, t3, LP.MOVE.CHAR		# Se passar do Limite inferior do mapa, move o personagem ao invés do mapa
			
			sh		t2, (t1)			# Se não, move mapa
			j 		LP.COLIDIU.BAIXO

LP.MOVE.CHAR:		# Movimenta o personagem em Y
			la		t0, vertical_luffy
			lw		t1, 0(t0)
			addi 		t1, t1, 3
			sw		t1, 0(t0)
			
			li		t2, 130
			blt		t1, t2, LP.COLIDIU.BAIXO
			
			la		t0, mapa.lock.y
			sb		zero, (t0)
					
LP.COLIDIU.BAIXO:	# Gera os valores para renderizar
			mv 		a0, s10				# Descritor
			loadw(a1, horizontal_luffy)			# X na tela
			loadw(a2, vertical_luffy)			# Y na tela
			li 		a3, LUFFY.OFFSET		# Largura da imagem
			li 		a4, LUFFY.LARGURA		# Largura da sprite
			frame_address(a5)				# Endereço da frame
			loadb(t1, sprite_frame_atual)
			li 		t2, 24
			blt 		t1, t2,LP.NAORESETA
			
			li		t1, 0
			saveb(t1, sprite_frame_atual)
			
LP.NAORESETA:
			addi 		t3, t1, 1			# Avança um movimento na animação
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
LUFFY.PULANDO:		# Atualiza a posição Y
			fcvt.s.w 	ft0, zero
			la 		t1, velocidadeY_luffy
			flw 		ft1, 0(t1)
			flt.s		t1, ft1, ft0			# t1 = 1 if ft1 < ft0 else 0
					
			bnez		t1, LPU.SUBINDO
			
LPU.DESCENDO:		la		t0, vertical_luffy
			lw		t1, (t0)
			li 		t2, 130
			bgt		t1, t2, LPU.DESCENDO.NAO_DESTRAVA		
			
			la		t0, mapa.lock.y
			sb		zero, (t0)
			
LPU.DESCENDO.NAO_DESTRAVA:
			# Checa se já caiu no chão
			jal 		COLISAO.BAIXO
			beqz 		a0, LPU.MOVE_Y
			
			saveb(zero, pulando)
			# Salva nova velocidade Y
			la 		t1, velocidadeY_luffy
			fsw		fs2, (t1)
			j 		LPU.ATUALIZA_X	
				
LPU.SUBINDO:		la		t0, vertical_luffy
			lw		t1, (t0)
			li 		t2, 130
			blt		t1, t2, LPU.SUBINDO.NAO_DESTRAVA		
			
			la		t0, mapa.lock.y
			sb		zero, (t0)
			
LPU.SUBINDO.NAO_DESTRAVA:	
			# Checa se bateu no teto
			jal 		COLISAO.CIMA
			beqz 		a0, LPU.MOVE_Y
			
			# Salva nova velocidade Y
			la 		t1, velocidadeY_luffy
			fsw		fs2, (t1)
			j 		LPU.ATUALIZA_X	
				
LPU.MOVE_Y:		la		t0, mapa.lock.y
			lb		t1, 0(t0)
			bnez 		t1, LPU.MOVE_Y.CHAR
						
LPU.MOVE_Y.MAPA:	# Movimenta o mapa em Y
			la 		t1, mapa.y
			lhu 		t2, 0(t1)
			la 		t3, velocidadeY_luffy
			flw 		ft1, 0(t3)
			fcvt.w.s	t3, ft1
			add 		t2, t2, t3
			la		t0, mapa.max.y
			lhu		t3, 0(t0)
			bgt		t2, t3, LPU.MOVE_Y.CHAR		# Se passar do limite inferior do mapa, move o personagem ao invés do mapa
			
			la		t0, mapa.min.y
			lhu		t3, 0(t0)
			blt		t2, t3, LPU.MOVE_Y.CHAR		# Se passar do limite superior do mapa, move o personagem ao invés do mapa
			
			sh		t2, (t1)			# Se não, move mapa
			j		LPU.ATUALIZA_X
					
LPU.MOVE_Y.CHAR:	# Movimenta o personagem em Y
			la		t0, vertical_luffy
			lw		t1, 0(t0)
			la 		t3, velocidadeY_luffy
			flw 		ft1, 0(t3)
			fcvt.w.s	t3, ft1
			add 		t1, t1, t3
			sw		t1, 0(t0)	
	
															
# Atualiza a posição X
LPU.ATUALIZA_X:		# Salva nova velocidade Y
			la 		t1, velocidadeY_luffy
			fsw		fs2, (t1)
			loadb(t1, moveX)
			beqz 		t1, LPU.PARADO
			bgtz 		t1, LPU.DIREITA

LPU.ESQUERDA:		la 		t1, mapa.x
			lhu 		t2, 0(t1)
			la		t0, mapa.min.x
			lhu		t3, 0(t0)
			bgt 		t2, t3, LPU.ESQUERDA.NAOTRAVA
			
			la 		t1, mapa.lock.x
			li 		t2, 1
			sb 		t2, 0(t1)
			
LPU.ESQUERDA.NAOTRAVA:	jal 		COLISAO.ESQUERDA			
			bnez 		a0, LPU.PARADO	
			 
			la 		t1, mapa.lock.x
			lb 		t1, 0(t1)
			bgtz 		t1, LPU.ESQUERDA.MOVE.CHAR
			
			la 		t1, mapa.x
			lhu 		t2, (t1)
			addi 		t2, t2, -3
			la		t0, mapa.min.x
			lhu 		t3, 0(t0)
			blt		t2, t3, LPU.ESQUERDA.MOVE.CHAR			
						
LPU.ESQUERDA.MOVE.MAPA:	# Movimenta o mapa em X			
			sh 		t2, (t1)
			j 		LPU.PARADO
			
LPU.ESQUERDA.MOVE.CHAR:	la 		t1, horizontal_luffy
			lw 		t2, 0(t1)
			addi 		t2, t2, -3
			sw 		t2, 0(t1)
			
			li		t1, 130
			bgt 		t2, t1, LPU.PARADO
			
			la		t0, mapa.lock.x
			sb		zero, (t0)			
			j 		LPU.PARADO
			
LPU.DIREITA:		# Checa se deve travar a camera horizontalmente
			la 		t1, mapa.x
			lhu 		t2, 0(t1)
			la		t0, mapa.max.x
			lhu		t3, 0(t0)
			blt 		t2, t3, LPU.DIREITA.NAOTRAVA
			
			la		t1, mapa.lock.x
			li		t2, 1
			sb 		t2, 0(t1)
			
LPU.DIREITA.NAOTRAVA:	# Calcula colisão
			jal 		COLISAO.DIREITA
			bnez 		a0, LPU.PARADO				# Se bateu em algo, não move
				
			la 		t1, mapa.lock.x
			lb 		t1, 0(t1)
			bgtz 		t1, LPU.DIREITA.MOVE.CHAR
				
			la	 	t1, mapa.x
			lhu 		t2, (t1)
			addi 		t2, t2, 3
			la		t0, mapa.max.x
			lhu		t3, 0(t0)
			bgt 		t2, t3, LPU.DIREITA.MOVE.CHAR
				
LPU.DIREITA.MOVE.MAPA:	# Movimenta o mapa em X			
			sh 		t2, (t1)
			j 		LPU.PARADO
			
LPU.DIREITA.MOVE.CHAR:	la 		t1, horizontal_luffy
			lw 		t2, 0(t1)
			addi 		t2, t2, 3
			sw 		t2, 0(t1)
			
			li		t1, 130
			blt		t2, t1, LPU.PARADO			# Se o mapa estiver travado e o personagem voltar pro meio da tela, destrava
			
			la		t0, mapa.lock.x
			sb		zero, (t0)
			
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
			li 		t3, 130
			blt 		t2, t3, LCD.NAOTRAVADA
			
			li 		t2, 0					# Se a camera estiver travada, e o personagem voltar pro centro
			sb 		t2, (t1)				# Destrava a camera
			
LCD.NAOTRAVADA:		# Checa se deve travar a camera horizontalmente
			la 		t1, mapa.x
			lhu 		t2, 0(t1)
			la		t0, mapa.max.x
			lhu		t3, 0(t0)
			blt 		t2, t3, LCD.NAOTRAVA
			
			la		t1, mapa.lock.x
			li		t2, 1
			sb 		t2, 0(t1)
			
LCD.NAOTRAVA:		# Calcula colisão
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
			la		t0, mapa.max.x
			lhu		a2, 0(t0)
			jal 		MIN
			sh 		a0, (t1)
			j 		LCD.COLIDIU
			
LCD.MOVE.CHAR:		la 		t1, horizontal_luffy
			lw 		t2, 0(t1)
			addi 		t2, t2, 3
			sw 		t2, 0(t1)
			
LCD.COLIDIU:		jal 		COLISAO.BAIXO
			bnez 		a0, LCD.COLIDIU.BAIXO		
		
			# Checa se o mapa está travado verticalmente
			la 		t0, mapa.lock.y
			lb		t1, 0(t0)
			beqz 		t1, LCD.MOVE_Y.CHAR

LCD.MOVE_Y.MAPA:
			# Movimenta o mapa em Y
			la 		t1, mapa.y
			lhu 		t2, (t1)
			addi 		t2, t2, 3			# desce 2 pixels
			la		t0, mapa.max.y
			lhu		t3, 0(t0)
			bgt 		t2, t3, LCD.MOVE_Y.CHAR
			
			sh		t2, (t1)
			j 		LCD.COLIDIU.BAIXO

LCD.MOVE_Y.CHAR:	# Movimenta o personagem em Y
			la		t0, vertical_luffy
			lw		t1, 0(t0)
			addi 		t1, t1, 3
			sw		t1, 0(t0)
			
			li		t2, 130
			bgt		t1, t2, LCD.COLIDIU.BAIXO
			
			la		t0, mapa.lock.y
			li		t1, 1
			sb		t1, (t0)
			
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
			li 		t3, 120
			bgt 		t2, t3, LCE.NAOTRAVADA
			
			li 		t2, 0						# Se a camera estiver travada, e o personagem voltar pro meio da tela
			sb 		t2, (t1)					# Destrava a camera
			
LCE.NAOTRAVADA:		# Checa se deve travar a camera horizontalmente
			la 		t1, mapa.x
			lhu 		t2, 0(t1)
			la		t0, mapa.min.x
			lhu		t3, 0(t0)
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
			la		t0, mapa.min.x
			lhu		a2, 0(t0)
			jal 		MAX
			sh 		a0, (t1)
			j 		LCE.COLIDIU
			
LCE.MOVE.CHAR:		la 		t1, horizontal_luffy
			lw 		t2, 0(t1)
			addi 		t2, t2, -3
			sw 		t2, 0(t1)
			
LCE.COLIDIU:		jal 		COLISAO.BAIXO
			bnez 		a0, LCE.COLIDIU.BAIXO
			
			# Checa se o mapa está travado verticalmente
			la 		t0, mapa.lock.y
			lb		t1, 0(t0)
			beqz 		t1, LCE.MOVE_Y.CHAR

LCE.MOVE_Y.MAPA:
			# Movimenta o mapa em Y
			la 		t1, mapa.y
			lhu 		t2, (t1)
			addi 		t2, t2, 3			# desce 2 pixels
			la		t0, mapa.max.y
			lhu		t3, 0(t0)
			bgt 		t2, t3, LCE.MOVE_Y.CHAR
			
			sh		t2, (t1)
			j 		LCE.COLIDIU.BAIXO

LCE.MOVE_Y.CHAR:	# Movimenta o personagem em Y
			la		t0, vertical_luffy
			lw		t1, 0(t0)
			addi 		t1, t1, 3
			sw		t1, 0(t0)
			
			li		t2, 130
			bgt		t1, t2, LCE.COLIDIU.BAIXO
			
			la		t0, mapa.lock.y
			li		t1, 1
			sb		t1, (t0)
			
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
LUFFY.SOCANDO:		# Testa colisão abaixo
			jal 		COLISAO.BAIXO
			bnez		a0, LS.COLIDIU.BAIXO
			
LS.MOVE_Y:		la		t0, mapa.lock.y
			lw		t1, 0(t0)
			beqz 		t1, LS.MOVE_Y.MAPA
			
LS.MOVE_Y.CHAR:		# Movimenta o personagem em Y
			la		t0, vertical_luffy
			lw		t1, 0(t0)
			la 		t3, velocidadeY_luffy
			flw 		ft1, 0(t3)
			fcvt.w.s	t3, ft1
			add 		t1, t1, t3
			sw		t1, 0(t0)
			j 		LS.COLIDIU.BAIXO			
												
LS.MOVE_Y.MAPA:		# Movimenta o mapa em Y
			la 		t1, mapa.y
			lhu 		t2, 0(t1)
			la 		t3, velocidadeY_luffy
			flw 		ft1, 0(t3)
			fcvt.w.s	t3, ft1
			add 		t2, t2, t3		
			# MIN entre a nova posição e a maior posição possível
			mv 		a1, t2	
			la 		t0, mapa.max.y		
			lhu		a2, 0(t0)
			jal 		MIN
			# MAX entre a nova posição e a menor posição possível
			mv 		a1, a0
			la 		t0, mapa.min.y
			lhu 		a2, 0(t0)
			jal 		MAX				
			sh 		a0, 0(t1)	
			# Salva nova velocidadeY
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
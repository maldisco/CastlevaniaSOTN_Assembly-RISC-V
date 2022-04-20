.data

# Posiçoes atuais do personagem
horizontal_luffy:			.word 160
vertical_luffy:				.word 145


velocidadeY_luffy:			.byte 0

# booleano para indicar se o personagem está em animação de pulo
moveX:				.byte 0
pulando:			.byte 0
sentido:			.byte 1
socando:			.byte 0

# Tempo desde a ultima atualização de posição
tempo_luffy:			.word 0

.text
# Lida com o evento de apertar uma tecla do teclado
LUFFY.ACOES:
	li t1, 'd'
	beq s0, t1, DIREITA		# checa se a tecla 'D' foi apertada
	
	li t1, 'a'
	beq s0, t1, ESQUERDA		# checa se a tecla 'A' foi apertada
	
	li t1, 'w'
	beq s0, t1, PULA		# checa se a tecla 'W' foi apertada
	
	li t1, 's'
	beq s0, t1, PARA		# checa se a tecla 'S' foi apertada
	
	li t1, 'z'
	beq s0, t1, SOCA
	
	# Se nenhuma tecla de ação foi apertada, volta para o loop
		ret
	
	
	# Se a tecla D foi apertada,
	# - moveX = 1 (direita)
	# - sentido = 1 (direita)
	DIREITA:				
		li t1, 1
		saveb(t1, moveX)
		saveb(t1, sentido)
		ret
	
	# Se a tecla A foi apertada,
	# - moveX = -1 (esquerda)
	# - sentido = -1 (esquerda)
	ESQUERDA:				
		li t1, -1
		saveb(t1, moveX)
		saveb(t1, sentido)
		ret
	
	# Se a tecla W foi apertada
	# - Se pulando < 2
	# - - pulando += 1
	# - - velocidadeY = -12 (subindo)
	# - Senão
	# - - nada
	PULA:					
		loadb(t1, pulando)
		li t2, 2
		bge t1, t2, pula_direita	
			addi t1, t1, 1
			saveb(t1, pulando)
			saveb(zero, sprite_frame_atual) 	
			li t1, -12					
			saveb(t1, velocidadeY_luffy)
			
		pula_direita:
		ret
	
	# Se a tecla S foi apertada
	# - Se pulando > 0
	# - - nada
	# - Senão
	# - - Se moveX > 0
	# - - - sentido = 1 (direita)
	# - - Senão
	# - - - sentido = -1 (esquerda)
	# - - moveX = 0
	PARA:					
		loadb(t1, pulando)
		bnez t1, nao_pode_parar		
			loadb(t1, moveX)
			li t2, 1
			bgtz t1, PARA.SENTIDO.DIREITA
				li t2, -1
			PARA.SENTIDO.DIREITA:
			li t1, 0
			saveb(t1, moveX)
			saveb(t2, sentido)
		nao_pode_parar:
		ret
	
	# Se a tecla Z foi apertada
	# - Se socando > 0
	# - - nada
	# - Senão
	# - - socando = 1	
	SOCA:					# se a tecla 'Z' foi apertada, faz animação de soco		
		loadb(t1, socando)
		bnez t1, ja_esta_socando
			saveb(zero, moveX)
			li t1, 1
			saveb(t1, socando)
		ja_esta_socando:
		ret

# Atualiza a posição da personagem 	
LUFFY.ATUALIZA:
	addi sp, sp, -4
	sw ra, (sp)				# Guardando endereço de retorno para o loop principal

	loadb(t1, velocidadeY_luffy)
	loadw(t2, vertical_luffy)
	add s1, t2, t1				# Nova posição Y = posição + velocidade
	
	li t2, GRAVIDADE
	add s2, t1, t2				# Nova velocidade Y = velocidade + gravidade
	
	loadb(t1, socando)
	bnez t1, LUFFY.SOCANDO
	
	loadb(t1, pulando)
	bnez t1 LUFFY.PULANDO
	
	loadb(t1, moveX)
	bgtz t1, LUFFY.CORRENDO.DIREITA
	
	bltz t1, LUFFY.CORRENDO.ESQUERDA
	
	LUFFY.PARADO:
		# Checa se colidiu com o chão
		la t1, vertical_luffy
		lw a1, 0(t1)
		call COLISAO.BAIXO
		bnez a0, LP.COLIDIU.BAIXO
			# Movimenta o mapa em Y
			la t1, mapa.y
			lhu t2, (t1)
			add t2, t2, s2			# S2 =  Velocidade Y do personagem
			mv a1, t2
			li a2, MAPA.MAX.Y
			call MIN
			sh a0, 0(t1)
		LP.COLIDIU.BAIXO:
		
		troca_tela()				# Troca a frame (0->1/1->0)
		
		# Renderiza novamente o mapa
		mv a0, s9
		li a1, 0
		li a2, 0
		li a3, MAPA.IMAGEM.LARGURA
		li a4, MAPA.LARGURA
		frame_address(a5)
		offset_mapa(a6)
		li a7, MAPA.ALTURA
		call RENDER
						
		# Gera os valores para renderizar
		mv a0, s10				# Descritor
		loadw(a1, horizontal_luffy)		# X na tela
		loadw(a2, vertical_luffy)		# Y na tela
		li a3, LUFFY.OFFSET			# Largura da imagem
		li a4, LUFFY.PARADO.LARGURA		# Largura da sprite
		frame_address(a5)			# Endereço da frame
		
		loadb(t1, sprite_frame_atual)
		li t2, 18
		blt t1, t2,LUFFY.PARADO.NAORESETA
			li t1, 0
			saveb(t1, sprite_frame_atual)
		LUFFY.PARADO.NAORESETA:
		addi t3, t1, 1				# Avança um movimento na animação
		saveb(t3, sprite_frame_atual)
		li t2, 4
		mul t1, t1, t2
		la t2, luffy.parado.direita.offsets
		loadb(t3, sentido)
		bgtz t3, LUFFY.PARADO.SENTIDO.DIREITA
			la t2 luffy.parado.esquerda.offsets
		LUFFY.PARADO.SENTIDO.DIREITA:
		add t2, t2, t1
		lw a6, (t2)				# Offset na imagem
		li a7, LUFFY.PARADO.ALTURA
		call RENDER
		
		atualiza_tela()
	
		jal att_tempo_luffy
	
		lw ra, (sp)			# Retorna ao loop principal
		addi sp, sp, 4
		ret
	
	LUFFY.PULANDO:
		# Atualiza a posição Y
		LUFFY.PULANDO.ATUALIZAY:
		la t1, velocidadeY_luffy
		lb t2, 0(t1)
		bltz t2, LUFFY.PULANDO.SUBINDO
		
		LUFFY.PULANDO.DESCENDO:	
			# Checa se já caiu no chão
			la t1, vertical_luffy
			lw a1, 0(t1)
			call COLISAO.BAIXO
			beqz a0, LUFFY.PULANDO.MOVE
				saveb(zero, pulando)
				saveb(s2, velocidadeY_luffy)
				j LUFFY.PULANDO.ATUALIZAX
		
		LUFFY.PULANDO.SUBINDO:
			# Checa se bateu no teto
			la t1, vertical_luffy
			lw a1, 0(t1)
			call COLISAO.CIMA
			beqz a0, LUFFY.PULANDO.MOVE
				saveb(s2, velocidadeY_luffy)
				j LUFFY.PULANDO.ATUALIZAX	
		
		LUFFY.PULANDO.MOVE:
		# Movimenta o mapa em Y
		la t1, mapa.y
		lhu t2, 0(t1)
		loadb(t3, velocidadeY_luffy)
		add t2, t2, t3		
		# MIN entre a nova posição e a maior posição possível
		mv a1, t2			
		li a2, MAPA.MAX.Y
		call MIN
		# MAX entre a nova posição e a menor posição possível
		mv a1, a0
		li a2, MAPA.MIN.Y
		call MAX				
		sh a0, 0(t1)		
		saveb(s2, velocidadeY_luffy)
				
		# Atualiza a posição X
		LUFFY.PULANDO.ATUALIZAX:
		saveb(s2, velocidadeY_luffy)
		loadb(t1, moveX)
		beqz t1, LUFFY.PULANDO.PARADO
			bgtz t1, LUFFY.PULANDO.DIREITA
			# Se estiver indo para esquerda, movimenta para o outro lado
				la t1, horizontal_luffy
				lw a1, (t1)
				addi a1, a1, -2
				call COLISAO.ESQUERDA
				bnez a0, LUFFY.PULANDO.PARADO	 
					la t1, mapa.lock.x
					lb t1, 0(t1)
					bgtz t1, LPE.MOVE.CHAR
					
					LPE.MOVE.MAPA:
						# Movimenta o mapa em X			
						la t1, mapa.x
						lhu t2, (t1)
						addi t2, t2, -2
						mv a1, t2
						li a2, MAPA.MIN.X
						call MAX
						sh a0, (t1)
						j LUFFY.PULANDO.PARADO
					LPE.MOVE.CHAR:
						la t1, horizontal_luffy
						lw t2, 0(t1)
						addi t2, t2, -2
						sw t2, 0(t1)
						j LUFFY.PULANDO.PARADO
			LUFFY.PULANDO.DIREITA:
				la t1, horizontal_luffy
				lw a1, (t1)
				addi a1, a1, 2
				call COLISAO.DIREITA
				bnez a0, LUFFY.PULANDO.PARADO	# Se bateu em algo, não move	
					la t1, mapa.lock.x
					lb t1, 0(t1)
					bgtz t1, LPD.MOVE.CHAR
					
					LPD.MOVE.MAPA:
						# Movimenta o mapa em X			
						la t1, mapa.x
						lhu t2, (t1)
						addi t2, t2, 2
						mv a1, t2
						li a2, MAPA.MAX.X
						call MIN
						sh a0, (t1)
						j LUFFY.PULANDO.PARADO
					LPD.MOVE.CHAR:
						la t1, horizontal_luffy
						lw t2, 0(t1)
						addi t2, t2, 2
						sw t2, 0(t1)
		LUFFY.PULANDO.PARADO:
		
		troca_tela()				# Troca a frame (0->1/1->0)
		# Renderiza novamente o mapa
		mv a0, s9
		li a1, 0
		li a2, 0
		li a3, MAPA.IMAGEM.LARGURA
		li a4, MAPA.LARGURA
		frame_address(a5)
		offset_mapa(a6)
		li a7, MAPA.ALTURA
		call RENDER
		
		# Gera os valores para renderizar
		mv a0, s10				# Descritor
		loadw(a1, horizontal_luffy)		# X na tela
		loadw(a2, vertical_luffy)		# Y na tela 
		li a3, LUFFY.OFFSET			# Largura da imagem
		li a4, LUFFY.PULANDO.LARGURA		# Largura da sprite
		frame_address(a5)			# Endereço da frame
		
		loadb(t1, sprite_frame_atual)
		li t2, 30
		blt t1, t2,LUFFY.PULANDO.NAORESETA
			li t1, 0
			saveb(t1, sprite_frame_atual)
		LUFFY.PULANDO.NAORESETA:
		addi t3, t1, 1				# Avança um movimento na animação
		saveb(t3, sprite_frame_atual)
		li t2, 4
		mul t1, t1, t2
		la t2, luffy.pulando.direita.offsets
		loadb(t3, sentido)
		bgtz t3, LUFFY.PULANDO.SENTIDO.DIREITA
			la t2 luffy.pulando.esquerda.offsets
		LUFFY.PULANDO.SENTIDO.DIREITA:
		add t2, t2, t1
		lw a6, (t2)				# Offset na imagem
		li a7, LUFFY.PULANDO.ALTURA
		call RENDER
		
		atualiza_tela()
	
		jal att_tempo_luffy

		lw ra, (sp)			# Retorna ao loop principal
		addi sp, sp, 4
		ret
		
	
	LUFFY.CORRENDO.DIREITA:
		# Checa se deve destravar a camera
		la t1, mapa.lock.x
		lb t2, 0(t1)
		beqz t2, LCD.NAOTRAVADA
			la t2, horizontal_luffy
			lw t2, 0(t2)
			addi t2, t2 , 2
			li t3, 280
			blt t2, t3, LCD.NAOTRAVADA
				li t2, 0		# Se a camera estiver travada, e o personagem chegar no limite esquerdo da tela
				sb t2, (t1)		# Destrava a camera
				la t1, mapa.x
				la t2, horizontal_luffy
				lhu t3, 0(t1)
				li t4, 145		# Coloca o personagem no meio da tela
				addi t3, t3, 145	# Arrasta a tela para esquerda
				sh t3, 0(t1)
				sw t4, 0(t2)
		LCD.NAOTRAVADA:
	
		# Checa se deve travar a camera horizontalmente
		la t1, mapa.x
		lhu t2, 0(t1)
		li t3, MAPA.MAX.X
		blt t2, t3, LCD.NAOTRAVA
			la t1, mapa.lock.x
			li t2, 1
			sb t2, 0(t1)
		LCD.NAOTRAVA:		
		
		# Calcula colisões
		la t1, horizontal_luffy
		lw a1, (t1)
		addi a1, a1, 2
		call COLISAO.DIREITA
		
		bnez a0, LCD.COLIDIU
			la t1, mapa.lock.x
			lb t1, 0(t1)
			bgtz t1, LCD.MOVE.CHAR
			
			LCD.MOVE.MAPA:
				# Movimenta o mapa em X			
				la t1, mapa.x
				lhu t2, (t1)
				addi t2, t2, 2
				mv a1, t2
				li a2, MAPA.MAX.X
				call MIN
				sh a0, (t1)
				j LCD.COLIDIU
			LCD.MOVE.CHAR:
				la t1, horizontal_luffy
				lw t2, 0(t1)
				addi t2, t2, 2
				sw t2, 0(t1)
		LCD.COLIDIU:
		
		la t1, vertical_luffy
		lw a1, 0(t1)
		call COLISAO.BAIXO
		bnez a0, LCD.COLIDIU.BAIXO
			# Movimenta o mapa em Y
			la t1, mapa.y
			lhu t2, (t1)
			add t2, t2, s2			# S2 =  Velocidade Y do personagem
			mv a1, t2
			li a2, MAPA.MAX.Y
			call MIN
			sh a0, 0(t1)
		LCD.COLIDIU.BAIXO:
		
		troca_tela()				# Troca a frame (0->1/1->0)
		
		# Renderiza novamente o mapa
		mv a0, s9
		li a1, 0
		li a2, 0
		li a3, MAPA.IMAGEM.LARGURA
		li a4, MAPA.LARGURA
		frame_address(a5)
		offset_mapa(a6)
		li a7, MAPA.ALTURA
		call RENDER
		
		# Gera os valores para renderizar
		mv a0, s10				# Descritor
		loadw(a1, horizontal_luffy)		# X na tela
		loadw(a2, vertical_luffy)		# Y na tela
		li a3, LUFFY.OFFSET			# Largura da imagem
		li a4, LUFFY.CORRENDO.LARGURA		# Largura da sprite
		frame_address(a5)			# Endereço da frame
		
		loadb(t1, sprite_frame_atual)
		li t2, 24
		blt t1, t2,LUFFY.CORRENDO.DIREITA.NAORESETA
			li t1, 0
			saveb(t1, sprite_frame_atual)
		LUFFY.CORRENDO.DIREITA.NAORESETA:
		addi t3, t1, 1				# Avança um movimento na animação
		saveb(t3, sprite_frame_atual)
		li t2, 4
		mul t1, t1, t2
		la t2, luffy.correndo.direita.offsets
		add t2, t2, t1
		lw a6, (t2)				# Offset na imagem
		li a7, LUFFY.CORRENDO.ALTURA
		call RENDER
		
		atualiza_tela()
	
		jal att_tempo_luffy
	
		lw ra, (sp)			# Retorna ao loop principal
		addi sp, sp, 4
		ret
	
	LUFFY.CORRENDO.ESQUERDA:
		# Checa se deve destravar a camera horizontalmente
		la t1, mapa.lock.x
		lb t2, 0(t1)
		beqz t2, LCE.NAOTRAVADA
			la t2, horizontal_luffy
			lw t2, 0(t2)
			addi t2, t2, -2
			bgtz t2, LCE.NAOTRAVADA
				li t2, 0		# Se a camera estiver travada, e o personagem chegar no limite esquerdo da tela
				sb t2, (t1)		# Destrava a camera
				la t1, mapa.x
				lhu t2, 0(t1)
				addi t2, t2, -145	# Arrasta a tela para esquerda
				sh t2, 0(t1)
				la t1, horizontal_luffy
				lw t2, 0(t1)
				addi t2, t2, 145	# Coloca o personagem no meio da tela
				sw t2, 0(t1)
				la t1, mapa.y
				lhu t2, 0(t1)
				addi t2, t2, -50	# Reposiciona a tela verticalmente
				sh t2, 0(t1)	
		LCE.NAOTRAVADA:
	
		# Checa se deve travar a camera horizontalmente
		la t1, mapa.x
		lhu t2, 0(t1)
		li t3, MAPA.MIN.X
		bgt t2, t3, LCE.NAOTRAVA
			la t1, mapa.lock.x
			li t2, 1
			sb t2, 0(t1)
		LCE.NAOTRAVA:
		
	
		la t1, horizontal_luffy
		lw a1, (t1)
		addi a1, a1, -2
		call COLISAO.ESQUERDA
		
		bnez a0, LCE.COLIDIU
			la t1, mapa.lock.x
			lb t1, 0(t1)
			bgtz t1, LCE.MOVE.CHAR
			
			LCE_MOVE.MAPA:
				# Movimenta o mapa em X			
				la t1, mapa.x
				lhu t2, (t1)
				addi t2, t2, -2
				mv a1, t2
				li a2, MAPA.MIN.X
				call MAX
				sh a0, (t1)
				j LCE.COLIDIU
			LCE.MOVE.CHAR:
				la t1, horizontal_luffy
				lw t2, 0(t1)
				addi t2, t2, -2
				sw t2, 0(t1)
		LCE.COLIDIU:
		
		la t1, vertical_luffy
		lw a1, 0(t1)
		call COLISAO.BAIXO
		bnez a0, LCE.COLIDIU.BAIXO
			# Movimenta o mapa em Y
			la t1, mapa.y
			lhu t2, (t1)
			add t2, t2, s2			# S2 =  Velocidade Y do personagem
			mv a1, t2
			li a2, MAPA.MAX.Y
			call MIN
			sh a0, 0(t1)
		LCE.COLIDIU.BAIXO:

		
		troca_tela()				# Troca a frame (0->1/1->0)
		
		# Renderiza novamente o mapa
		mv a0, s9
		li a1, 0
		li a2, 0
		li a3, MAPA.IMAGEM.LARGURA
		li a4, MAPA.LARGURA
		frame_address(a5)
		offset_mapa(a6)
		li a7, MAPA.ALTURA
		call RENDER
		
		# Gera os valores para renderizar
		mv a0, s10				# Descritor
		loadw(a1, horizontal_luffy)		# X na tela
		loadw(a2, vertical_luffy)		# Y na tela
		li a3, LUFFY.OFFSET			# Largura da imagem
		li a4, LUFFY.CORRENDO.LARGURA		# Largura da sprite
		frame_address(a5)			# Endereço da frame
		
		loadb(t1, sprite_frame_atual)
		li t2, 24
		blt t1, t2,LUFFY.CORRENDO.ESQUERDA.NAORESETA
			li t1, 0
			saveb(t1, sprite_frame_atual)
		LUFFY.CORRENDO.ESQUERDA.NAORESETA:
		addi t3, t1, 1				# Avança um movimento na animação
		saveb(t3, sprite_frame_atual)
		li t2, 4
		mul t1, t1, t2
		la t2, luffy.correndo.esquerda.offsets
		add t2, t2, t1
		lw a6, (t2)				# Offset na imagem
		li a7, LUFFY.CORRENDO.ALTURA
		call RENDER
		
		atualiza_tela()
	
		jal att_tempo_luffy
	
		lw ra, (sp)			# Retorna ao loop principal
		addi sp, sp, 4
		ret	
	
	LUFFY.SOCANDO:
		troca_tela()				# Troca a frame (0->1/1->0)
		
		# Renderiza novamente o mapa
		mv s9, a0
		li a1, 0
		li a2, 0
		li a3, MAPA.IMAGEM.LARGURA
		li a4, MAPA.LARGURA
		frame_address(a5)
		offset_mapa(a6)
		li a7, MAPA.ALTURA
		call RENDER
		
		# Gera os valores para renderizar
		mv a0, s10				# Descritor
		loadw(a1, horizontal_luffy)		# X na tela
		loadw(a2, vertical_luffy)		# Y na tela
		addi a2, a2, -8
		li a3, LUFFY.OFFSET			# Largura da imagem
		li a4, LUFFY.SOCANDO.LARGURA		# Largura da sprite
		frame_address(a5)			# Endereço da frame
		
		loadb(t1, sprite_frame_atual)
		li t2, 48
		blt t1, t2,LUFFY.SOCANDO.DIREITA.NAORESETA
			li t1, 0
			saveb(t1, sprite_frame_atual)
			saveb(t1, socando)
		LUFFY.SOCANDO.DIREITA.NAORESETA:
		addi t3, t1, 1				# Avança um movimento na animação
		saveb(t3, sprite_frame_atual)
		li t2, 4
		mul t1, t1, t2
		la t2, luffy.socando.direita.offsets
		loadb(t3, sentido)
		bgtz t3, LUFFY.SOCANDO.SENTIDO.DIREITA
			la t2, luffy.socando.esquerda.offsets
			addi a1, a1, -23
		LUFFY.SOCANDO.SENTIDO.DIREITA:
		add t2, t2, t1
		lw a6, (t2)				# Offset na imagem
		li a7, LUFFY.SOCANDO.ALTURA
		call RENDER
		
		atualiza_tela()
	
		jal att_tempo_luffy
	
		lw ra, (sp)			# Retorna ao loop principal
		addi sp, sp, 4
		ret

# Checa colisão à direita do personagem
# Param a1 = Nova posição X do personagem
# Return a0, 1 = Colidiu
COLISAO.DIREITA:
	la t1, mapa.x
	lh t1, (t1)
	la t2, mapa.y
	lh t2, (t2)
	mv t3, a1
	la t4, vertical_luffy
	lw t4, (t4)
	
	add t1, t1, t3			 # X do personagem relativo ao mapa
	add t2, t2, t4			 # Y do personagem relativo ao mapa
	
	la t3, map_hitbox
	addi t3, t3, 8
	 
	li t4, MAPA.HITBOX.LARGURA
	mul t4, t4, t2
	add t4, t4, t1			# t4 = Primeiro pixel do personagem no mapa de hitboxes
	li t5, LUFFY.CORRENDO.LARGURA
	add t4, t4, t5			# t4 = Primeiro pixel a direita do personagem
	li t5, LUFFY.CORRENDO.ALTURA
	addi t5, t5, -20
	li t6, 0
	CD.LOOP:
		add t1, t4, t3
		lb t2, 0(t1)
		bnez t2, CD.NEGATIVO
	 		li a0, 1
	 		ret
	 	CD.NEGATIVO:
	 	addi t6, t6, 1
	 	li t1, MAPA.HITBOX.LARGURA
	 	add t4, t4, t1
	 	blt t6, t5, CD.LOOP
	 CD.FIM:
	 li a0, 0
	 ret

# Checa colisão à esquerda do personagem
# Param a1 = Nova posição X do personagem
# Return a0, 1 = Colidiu
COLISAO.ESQUERDA:
	la t1, mapa.x
	lh t1, (t1)
	la t2, mapa.y
	lh t2, (t2)
	mv t3, a1
	la t4, vertical_luffy
	lw t4, (t4)
	
	add t1, t1, t3			 # X do personagem relativo ao mapa
	add t2, t2, t4			 # Y do personagem relativo ao mapa
	
	la t3, map_hitbox
	addi t3, t3, 8
	 
	li t4, MAPA.HITBOX.LARGURA
	mul t4, t4, t2
	add t4, t4, t1			# t4 = Endereço do primeiro pixel do personagem 
	li t5, LUFFY.CORRENDO.ALTURA
	addi t5, t5, -20
	li t6, 0
	CE.LOOP:
		add t1, t4, t3
		lb t2, 0(t1)
		bnez t2, CE.NEGATIVO
	 		li a0, 1
	 		ret
	 	CE.NEGATIVO:
	 	addi t6, t6, 1
	 	li t1, MAPA.HITBOX.LARGURA
	 	add t4, t4, t1
	 	blt t6, t5, CE.LOOP
	 CE.FIM:
	 li a0, 0
	 ret

# Checa colisão abaixo do personagem
# Param a1 = Posição do personagem em Y após gravidade
# Return a0, 1 = Colidiu
COLISAO.BAIXO:
	la t1, mapa.x
	lh t1, (t1)
	la t2, mapa.y
	lh t2, (t2)
	la t3, horizontal_luffy
	lw t3, (t3)
	mv t4, a1
	
	add t1, t1, t3			 # X do personagem relativo ao mapa
	add t2, t2, t4			 # Y do personagem relativo ao mapa
	
	la t3, map_hitbox
	addi t3, t3, 8
	 
	li t4, MAPA.HITBOX.LARGURA
	addi t2, t2, 47			# Desce até o pé do personagem
	mul t4, t4, t2
	add t4, t4, t1			# t4 = Endereço do primeiro pixel abaixo do personagem
	
	add t3, t3, t4			# Pixel no endereço de hitboxes
	li t5, 37
	li t6, 0
	CB.LOOP:
		lb t2, 0(t3)
		bnez t2, CB.NEGATIVO
	 		li a0, 1
	 		ret
	 	CB.NEGATIVO:
	 	addi t6, t6, 1
	 	addi t3, t3, 1
	 	blt t6, t5, CB.LOOP
	CB.FIM:
	li a0, 0
	ret

# Checa colisão acima do personagem
# Param a1 = Nova posição Y do personagem
# Return a0, 1 = Colidiu
COLISAO.CIMA:
	la t1, mapa.x
	lh t1, (t1)
	la t2, mapa.y
	lh t2, (t2)
	la t3, horizontal_luffy
	lw t3, (t3)
	mv t4, a1
	
	add t1, t1, t3			 # X do personagem relativo ao mapa
	addi t1, t1, 37			# Chega ao limite direito da box do personagem
	add t2, t2, t4			 # Y do personagem relativo ao mapa
	addi t2, t2, -1			# Sobe 1 pixel acima do personagem
	
	la t3, map_hitbox
	addi t3, t3, 8
	 
	li t4, MAPA.HITBOX.LARGURA
	mul t4, t4, t2
	add t4, t4, t1			# t4 = Endereço do primeiro pixel acima do personagem
	
	add t3, t3, t4			# t3 = Pixel no endereço de hitboxes
	lw t2, (t3)			# Carrega uma word 
	
	bnez t2, CC.NEGATIVO		# Checa se a word é um bloco colidível
		li a0, 1
		ret
	CC.NEGATIVO:
	li a0, 0
	ret		

# Checa se passou o tempo necessário desde a última atualização (controle de FPS)
# return a0= passou (0=não, 1=sim)
checa_tempo:
	loadw(t1, tempo_luffy)		# carrega o momento da ultima renderização
	csrr t2, 3073
	sub t1, t2, t1
	li t2, 16
	bgeu t1, t2, ct_pode		# se for maior que 64 milissegundos, pode renderizar denovo
		li a0, 0			# se não, não renderiza
		ret
	ct_pode:
	li a0, 1
	ret

# Atualiza o tempo atual
att_tempo_luffy:
	csrr t1, 3073
	savew(t1, tempo_luffy)
	ret

	
# Param a0 = Descritor
# Param a1 = X na VGA
# Param a2 = Y na VGA
# Param a3 = Largura da imagem
# Param a4 = Largura da sprite
# Param a5 = Endereço da frame
# Param a6 = Offset na imagem
# Param a7 = Altura da sprite
RENDER:					
	# Calculo do offset na imagem
	mv a6, a6
		
	# Calculo frame
	mv a5, a5
	
	# Calculo do offset na tela
	li t3, 320
	mul t3, t3, a2			# Y do personagem x 320 (Altura inicial)
	add t3, t3, a1
	add a5, a5, t3			# a5 = Endereço inicial = Frame 0/1 + horizontal + 320 x vertical
	
	# Calculo do endereço final na tela
	li t1, 320
	mul t1, t1, a7
	add t1, t1, a4
	add t1, a5, t1
		
	# A0 = File descriptor da sprite
	# A6 = Offset na imagem
	# A5 = Offset na tela
	# t1 = Endereço final na tela	
	RENDER.LOOP: 
		# Salva o descritor
		mv t5, a0
		
		# Seek no arquivo da imagem
		li a7, 62
		mv a1, a6			# A6 = offset na imagem
		li a2, 0
		ecall
				
		# Restaura a0
		mv a0, t5
		
		# Read no arquivo da imagem
		li a7, 63
		mv a1, a5			# A5 = offset na tela
		mv a2, a4
		ecall				# Escreve uma linha
				
		# Restaura a0
		mv a0, t5
		
		# Incrementar offset imagem (pular linha)
		add a6, a6, a3 
				
		# Incrementa offset tela (pular linha)
		addi a5, a5, 320
		
		# a5 = Endereço atual na tela
		# t1 = Endereço final na tela
		bltu a5, t1, RENDER.LOOP
		ret
			
	
	

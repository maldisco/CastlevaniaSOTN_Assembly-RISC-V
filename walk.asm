.data

# Posiçoes atuais do personagem
horizontal_luffy:			.word 20
vertical_luffy:				.word 170

# Velocidades do personagem
velocidadeX_luffy:			.byte 0
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
acoes_luffy:
	li t1, 'd'
	beq s0, t1, direita		# checa se a tecla 'D' foi apertada
	
	li t1, 'a'
	beq s0, t1, esquerda		# checa se a tecla 'A' foi apertada
	
	li t1, 'w'
	beq s0, t1, pula		# checa se a tecla 'W' foi apertada
	
	li t1, 's'
	beq s0, t1, para		# checa se a tecla 'S' foi apertada
	
	li t1, 'z'
	beq s0, t1, soca
	
	# se nenhuma tecla de ação foi apertada, volta para o loop
		tail poll_loop
	
	direita:				# se a tecla 'D' foi apertada, velocidade = +15
		li t1, 1
		saveb(t1, moveX)
		saveb(t1, sentido)
		tail poll_loop
	
	esquerda:				# se a tecla 'A' foi apertada, velocidade = -15
		li t1, -1
		saveb(t1, moveX)
		saveb(t1, sentido)
		tail poll_loop
	
	pula:					# se a tecla 'W' foi apertada (e os dois pulos não tiverem sido feitos), velocidade vertical = -32 (subindo)
		loadb(t1, pulando)
		li t2, 2
		bge t1, t2, pula_direita	# se já foram os dois pulos, não faz nada
			addi t1, t1, 1
			saveb(t1, pulando)
			saveb(zero, sprite_frame_atual) 	# Resetando animação
			li t1, -32					# Velocidade de subida
			saveb(t1, velocidadeY_luffy)
			
		pula_direita:
		tail poll_loop

	para:					# se a tecla 'S' foi apertada, velocidade = 0
		loadb(t1, pulando)
		bnez t1, nao_pode_parar		# Se o personagem ja está pulando, não pode parar no ar
			loadb(t1, moveX)
			li t2, 1
			bgtz t1, PARA.SENTIDO.DIREITA
				li t2, -1
			PARA.SENTIDO.DIREITA:
			li t1, 0
			saveb(t1, moveX)
			saveb(t2, sentido)
		nao_pode_parar:
		tail poll_loop
		
	soca:					# se a tecla 'Z' foi apertada, faz animação de soco		
		loadb(t1, socando)
		bnez t1, ja_esta_socando
			saveb(zero, moveX)
			li t1, 1
			saveb(t1, socando)
		ja_esta_socando:
		tail poll_loop

# Atualiza a posição da personagem levando em conta:
# - Velocidade horizontal
# - Velocidade vertical
# - Gravidade	
atualiza_posicao_luffy:
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
		troca_tela()				# Troca a frame (0->1/1->0)
		
		# Renderiza novamente o mapa
		mv s9, a0
		li a1, 0
		li a2, 0
		li a3, MAPA.LARGURA
		li a4, MAPA.LARGURA
		frame_address(a5)
		li a6, 0
		li a7, MAPA.ALTURA
		call Trenderiza_luffy
						
		# Gera os valores para renderizar
		mv a0, s10				# Descritor
		loadw(a1, horizontal_luffy)		# X na tela
		loadw(a2, vertical_luffy)		# Y na tela
		loadw(t1, chao)
		bge a2, t1, LUFFY.PARADO.CHAO
			mv a2, s1			
		LUFFY.PARADO.CHAO: 
		li a3, LUFFY.OFFSET			# Largura da imagem
		li a4, LUFFY.PARADO.LARGURA		# Largura da sprite
		frame_address(a5)			# Endereço da frame
		
		loadb(t1, sprite_frame_atual)
		li t2, 6
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
		call Trenderiza_luffy
		
		atualiza_tela()
	
		jal att_tempo_luffy
	
		lw ra, (sp)			# Retorna ao loop principal
		addi sp, sp, 4
		ret
	
	LUFFY.PULANDO:
		loadb(t1, moveX)
		beqz t1, LUFFY.PULANDO.PARADO
			# Movimenta
			loadw(t2,horizontal_luffy)
			addi t2, t2, 5
			bgtz t1, LUFFY.PULANDO.DIREITA
			# Se estiver indo para esquerda, movimenta para o outro lado
				addi t2, t2, -10
			LUFFY.PULANDO.DIREITA:
			savew(t2, horizontal_luffy)
		LUFFY.PULANDO.PARADO:
	
		# Checa se já caiu no chão
		loadw(t1, chao)
		blt s1, t1, LUFFY.PULANDO.SIM
			saveb(zero, pulando)
			mv s1, t1
		LUFFY.PULANDO.SIM:
		
		# Checa se bateu no teto
		loadb(t1, teto)
		bgt s1, t1 LUFFY.PULANDO.TETO.NAO
			mv s1, t1
		LUFFY.PULANDO.TETO.NAO:
		
		# Salva novas posição Y e velocidade Y
		savew(s1, vertical_luffy)
		saveb(s2, velocidadeY_luffy)
		
		troca_tela()				# Troca a frame (0->1/1->0)
		
		# Renderiza novamente o mapa
		mv s9, a0
		li a1, 0
		li a2, 0
		li a3, MAPA.LARGURA
		li a4, MAPA.LARGURA
		frame_address(a5)
		li a6, 0
		li a7, MAPA.ALTURA
		call Trenderiza_luffy
		
		# Gera os valores para renderizar
		mv a0, s10				# Descritor
		loadw(a1, horizontal_luffy)		# X na tela
		loadw(a2, vertical_luffy)		# Y na tela
		loadb(t1, chao)
		bge a2, t1, LUFFY.PULANDO.CHAO
			mv a2, s1			
		LUFFY.PULANDO.CHAO: 
		li a3, LUFFY.OFFSET			# Largura da imagem
		li a4, LUFFY.PULANDO.LARGURA		# Largura da sprite
		frame_address(a5)			# Endereço da frame
		
		loadb(t1, sprite_frame_atual)
		li t2, 10
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
		call Trenderiza_luffy
		
		atualiza_tela()
	
		jal att_tempo_luffy

		lw ra, (sp)			# Retorna ao loop principal
		addi sp, sp, 4
		ret
		
	
	LUFFY.CORRENDO.DIREITA:
		# Movimenta
		loadw(t1,horizontal_luffy)
		addi t1, t1, 5
		savew(t1,horizontal_luffy)
		
		troca_tela()				# Troca a frame (0->1/1->0)
		
		# Renderiza novamente o mapa
		mv s9, a0
		li a1, 0
		li a2, 0
		li a3, MAPA.LARGURA
		li a4, MAPA.LARGURA
		frame_address(a5)
		li a6, 0
		li a7, MAPA.ALTURA
		call Trenderiza_luffy
		
		# Gera os valores para renderizar
		mv a0, s10				# Descritor
		loadw(a1, horizontal_luffy)		# X na tela
		loadw(a2, vertical_luffy)		# Y na tela
		loadw(t1, chao)
		bge a2, t1, LUFFY.CORRENDO.DIREITA.CHAO
			mv a2, s1			
		LUFFY.CORRENDO.DIREITA.CHAO: 
		li a3, LUFFY.OFFSET			# Largura da imagem
		li a4, LUFFY.CORRENDO.LARGURA		# Largura da sprite
		frame_address(a5)			# Endereço da frame
		
		loadb(t1, sprite_frame_atual)
		li t2, 8
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
		call Trenderiza_luffy
		
		atualiza_tela()
	
		jal att_tempo_luffy
	
		lw ra, (sp)			# Retorna ao loop principal
		addi sp, sp, 4
		ret
	
	LUFFY.CORRENDO.ESQUERDA:
		# Movimenta
		loadw(t1,horizontal_luffy)
		addi t1, t1, -5
		savew(t1,horizontal_luffy)
		
		troca_tela()				# Troca a frame (0->1/1->0)
		
		# Renderiza novamente o mapa
		mv s9, a0
		li a1, 0
		li a2, 0
		li a3, MAPA.LARGURA
		li a4, MAPA.LARGURA
		frame_address(a5)
		li a6, 0
		li a7, MAPA.ALTURA
		call Trenderiza_luffy
		
		# Gera os valores para renderizar
		mv a0, s10				# Descritor
		loadw(a1, horizontal_luffy)		# X na tela
		loadw(a2, vertical_luffy)		# Y na tela
		loadw(t1, chao)
		bge a2, t1, LUFFY.CORRENDO.ESQUERDA.CHAO
			mv a2, s1			
		LUFFY.CORRENDO.ESQUERDA.CHAO: 
		li a3, LUFFY.OFFSET			# Largura da imagem
		li a4, LUFFY.CORRENDO.LARGURA		# Largura da sprite
		frame_address(a5)			# Endereço da frame
		
		loadb(t1, sprite_frame_atual)
		li t2, 8
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
		call Trenderiza_luffy
		
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
		li a3, MAPA.LARGURA
		li a4, MAPA.LARGURA
		frame_address(a5)
		li a6, 0
		li a7, MAPA.ALTURA
		call Trenderiza_luffy
		
		# Gera os valores para renderizar
		mv a0, s10				# Descritor
		loadw(a1, horizontal_luffy)		# X na tela
		loadw(a2, vertical_luffy)		# Y na tela
		addi a2, a2, -8
		li a3, LUFFY.OFFSET			# Largura da imagem
		li a4, LUFFY.SOCANDO.LARGURA		# Largura da sprite
		frame_address(a5)			# Endereço da frame
		
		loadb(t1, sprite_frame_atual)
		li t2, 16
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
		call Trenderiza_luffy
		
		atualiza_tela()
	
		jal att_tempo_luffy
	
		lw ra, (sp)			# Retorna ao loop principal
		addi sp, sp, 4
		ret

# Configurações quando o personagem passar para a proxima tela
proxima_tela:
	loadw(t1, tela_atual)
	addi t1, t1, 1
	savew(t1, tela_atual)
	li t1, 20
	li t2, 165
	savew(t1, horizontal_luffy)
	savew(t2, vertical_luffy)
	call atualiza_tela

# Configurações quando o personagem volta uma tela
tela_anterior:
	loadw(t1, tela_atual)
	addi t1, t1, -1
	savew(t1, tela_atual)
	li t1, 240
	li t2, 160
	savew(t1, horizontal_luffy)
	savew(t2, vertical_luffy)
	call atualiza_tela		

# Checa se passou o tempo necessário desde a última atualização (controle de FPS)
# return a0= passou (0=não, 1=sim)
checa_tempo:
	loadw(t1, tempo_luffy)		# carrega o momento da ultima renderização
	csrr t2, 3073
	sub t1, t2, t1
	li t2, 48
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
Trenderiza_luffy:					
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
	Tr_loop: 
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
		bltu a5, t1, Tr_loop
		ret
			
	
	

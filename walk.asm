.data

# Posiçoes atuais do personagem
horizontal_2b:			.word 20
vertical_2b:			.word 160

# Posições antigas (a serem apagadas)
antigo_horizontal_2b:		.word 20
antigo_vertical_2b:		.word 160

# Velocidades do personagem
velocidadeX_2b:			.word 0
velocidadeY_2b:			.word 0

# Cada sprite é um conjunto de vários movimentos
# Cada vetor abaixo representa a largura do movimento e seu endereço na sprite
larguras_correndo_direita:	.word 44,34,42,39,39,43		
larguras_correndo_esquerda:	.word 43,39,39,42,34,44		
larguras_parada_direita:	.word 28,26,26
larguras_parada_esquerda:	.word 26,26,28
larguras_pulando_direita:	.word 26,35,35,35,39,52,52,52,25
larguras_pulando_esquerda:	.word 25,52,52,52,39,35,35,35,26
enderecos_correndo_direita:	.word 8,52,86,128,167,206
enderecos_correndo_esquerda:	.word 8,51,90,129,171,205
enderecos_parada_direita:	.word 8,36,62
enderecos_parada_esquerda:	.word 8,34,60
enderecos_pulando_direita:	.word 8,34,69,104,139,178,230,282,334
enderecos_pulando_esquerda:	.word 8,33,85,137,189,228,263,298,333

# booleano para indicar se o personagem está em animação de pulo
pulando:			.byte 0

# Tempo desde a ultima atualização de posição
tempo_2b:			.word 0

.text
# Lida com o evento de apertar uma tecla do teclado
acoes_2b:
	li t1, RIGHT
	beq s0, t1, direita		# checa se a tecla 'D' foi apertada
	
	li t1, LEFT
	beq s0, t1, esquerda		# checa se a tecla 'A' foi apertada
	
	li t1, UP
	beq s0, t1, pula		# checa se a tecla 'W' foi apertada
	
	li t1, DOWN
	beq s0, t1, para		# checa se a tecla 'S' foi apertada
	
	# se nenhuma tecla de ação foi apertada, volta para o loop
		tail poll_loop
	
	direita:				# se a tecla 'D' foi apertada, velocidade = +15
		li t1, 15
		savew(t1, velocidadeX_2b)
		atribuir(sprite_atual, sprite_correndo_direita)
		la t1, larguras_correndo_direita
		savew(t1, sprite_larguras_atual)
		la t1, enderecos_correndo_direita
		savew(t1, sprite_enderecos_atual)
		tail poll_loop
	
	esquerda:				# se a tecla 'A' foi apertada, velocidade = -15
		li t1, -15
		savew(t1, velocidadeX_2b)
		atribuir(sprite_atual, sprite_correndo_esquerda)
		la t1, larguras_correndo_esquerda
		savew(t1, sprite_larguras_atual)
		la t1, enderecos_correndo_esquerda
		savew(t1, sprite_enderecos_atual)
		tail poll_loop
	
	pula:					# se a tecla 'W' foi apertada (e os dois pulos não tiverem sido feitos), velocidade vertical = -45 (subindo)
		loadb(t1, pulando)
		li t2, 2
		bge t1, t2, pula_direita	# se já foram os dois pulos, não faz nada
			addi t1, t1, 1
			saveb(t1, pulando)
			blt t1, t2, nao_reseta_animacao_de_pulo		# Reseta a animação de pulo durando o inicio do segundo pulo
				li t1, 0
				savew(t1, sprite_frame_atual)
			nao_reseta_animacao_de_pulo:
			li t1, -45					# Velocidade de subida
			savew(t1, velocidadeY_2b)
			atribuir(sprite_atual, sprite_pulando_direita)
			la t1, larguras_pulando_direita
			savew(t1, sprite_larguras_atual)
			la t1, enderecos_pulando_direita
			savew(t1, sprite_enderecos_atual)
			loadw(t1, velocidadeX_2b)
			bgtz t1, pula_direita
				atribuir(sprite_atual, sprite_pulando_esquerda)
				la t1, larguras_pulando_esquerda
				savew(t1, sprite_larguras_atual)
				la t1, enderecos_pulando_esquerda
				savew(t1, sprite_enderecos_atual)
		pula_direita:
		tail poll_loop

	para:					# se a tecla 'S' foi apertada, velocidade = 0
		loadw(t1, pulando)
		bnez t1, nao_pode_parar		# Se o personagem ja está pulando, não pode parar no ar
			atribuir(sprite_atual, sprite_parada_direita)
			la t1, larguras_parada_direita
			savew(t1, sprite_larguras_atual)
			la t1, enderecos_parada_direita
			savew(t1, sprite_enderecos_atual)
			loadw(t1, velocidadeX_2b)
			bgtz t1, parada_direita
				atribuir(sprite_atual, sprite_parada_esquerda)
				la t1, larguras_parada_esquerda
				savew(t1, sprite_larguras_atual)
				la t1, enderecos_parada_esquerda
					savew(t1, sprite_enderecos_atual)
			parada_direita:
			li t1, 0
			savew(t1, velocidadeX_2b)
		nao_pode_parar:
		tail poll_loop
	
atualiza_posicao_2b:
	addi sp, sp, -4
	sw ra, (sp)				# Guardando endereço de retorno para o loop principal

	loadw(t1, velocidadeY_2b)
	loadw(t2, vertical_2b)
	add s1, t2, t1				# Nova posição Y = posição + velocidade
	
	li t2, GRAVIDADE
	add s2, t1, t2				# Nova velocidade Y = velocidade + gravidade

	li t3, 160	
	blt s1, t3, esta_no_ar			# Se o personagem ainda está no ar, a gravidade age
		li s1, 160
		li s2, 0
		savew(s2, pulando)
		loadw(t1, velocidadeX_2b)
		bgtz t1, caiu_correndo_direita				# Se a velocidade é positiva, o personagem está correndo para direita
			bltz t1, caiu_correndo_esquerda			# Se a velocidae é negativa, o personagem está correndo para esquerda
				loadw(t2, sprite_parada_direita)	# Se não, está parado
				savew(t2, sprite_atual)
				la t1, larguras_parada_direita
				savew(t1, sprite_larguras_atual)
				la t1, enderecos_parada_direita
				savew(t1, sprite_enderecos_atual)		
				j esta_no_ar
		
		caiu_correndo_esquerda: loadw(t2, sprite_correndo_esquerda)
					savew(t2, sprite_atual)
					la t1, larguras_correndo_esquerda
					savew(t1, sprite_larguras_atual)
					la t1, enderecos_correndo_esquerda
					savew(t1, sprite_enderecos_atual)
					j esta_no_ar
		
		caiu_correndo_direita:	loadw(t2, sprite_correndo_direita)
					savew(t2, sprite_atual)
					la t1, larguras_correndo_direita
					savew(t1, sprite_larguras_atual)
					la t1, enderecos_correndo_direita
					savew(t1, sprite_enderecos_atual)
	esta_no_ar:
	
	loadw(t1, teto)
	bgt s1, t1 nao_bateu_no_teto
		mv s1, t1
	nao_bateu_no_teto:	
	savew(s1, vertical_2b)
	savew(s2, velocidadeY_2b)
	
	loadw(t1, velocidadeX_2b)		# Nova posição X = posição + velocidade
	loadw(t2, horizontal_2b)
	add s3, t2, t1
	savew(s3, horizontal_2b)
	
	jal escolhe_frame_sprite_atual
	
	troca_tela()
	# s1 = Novo vertical
	# s2 = Nova velocidade
	# s3 = Novo horizontal
	jal renderiza_2b
	
	atualiza_tela()
	
	jal apagar_antiga_posicao
	
	atribuir(antigo_horizontal_2b, horizontal_2b)
	atribuir(antigo_vertical_2b, vertical_2b)
	
	jal att_tempo_2b
	
	lw ra, (sp)			# Retorna ao loop principal
	addi sp, sp, 4
	ret
	
	
escolhe_frame_sprite_atual:
	li a0, 0 		# limite
	loadw(t1, sprite_atual)
	
	# Checa qual a sprite atual para calcular o limite e a proxima frame da sprite
	la t2, twob_stand_right
	beq t1, t2, efsa_parada			
	
	la t2, twob_stand_left
	beq t1, t2, efsa_parada
	
	la t2, twob_walk_right
	beq t1, t2, efsa_correndo
	
	la t2, twob_walk_left
	beq t1, t2, efsa_correndo
	
	la t2, twob_jump_right
	beq t1, t2, efsa_pulando
	
	la t2, twob_jump_left
	beq t1, t2, efsa_pulando
	
	# Se não for nenhuma delas, algo deu errado
	li a7, 10
	ecall
	
	efsa_retorna:
		savew(t1, sprite_frame_atual)
		ret
	
	efsa_parada:
		loadw(t1, sprite_frame_atual)
		addi t1, t1, 1
		li t2, 3
		blt t1, t2, efsa_retorna
			li t1, 0
			j efsa_retorna
	
	efsa_correndo:
		loadw(t1, sprite_frame_atual)
		addi t1, t1, 1
		li t2, 7
		blt t1, t2, efsa_retorna
			li t1, 0
			j efsa_retorna
	
	efsa_pulando:
		loadw(t1, sprite_frame_atual)
		addi t1, t1, 1
		li t2, 9
		blt t1, t2, efsa_retorna
			loadw(t3, vertical_2b)
			li t2, 160
			li t1, 8
			blt t3, t4, efsa_retorna
				li t1, 0
				j efsa_retorna


# Checa colisão com blocos e paredes à direita
# a0= posição do personagem em X
# return a1= colidiu (0=sim, 1=não)
checa_colisao_direita:
	loadw(t1, tela_atual)
	
	li t2, 3
	blt t1, t2, ccd_pode_passar

		li t1, 320
		blt a0, t1, ccd_false
			li a1, 0
			ret
	ccd_false:
		li a1, 1
		ret

ccd_pode_passar:
	li t1, 320
	bgt a0, t1, proxima_tela	# Imprime e configura a próxima tela 
	
	ret

# Checa colisão com blocos e paredes à esquerda
# a0= posição do personagem em X
# return a1= colidiu (0=sim, 1=não)
checa_colisao_esquerda:
	loadw(t1, tela_atual)
	
	li t2, 1
	bgt t1, t2, cce_pode_passar

		li t1, 0
		bgt a0, t1, cce_false
			li a1, 0
			ret
	cce_false:
		li a1, 1
		ret

cce_pode_passar:
	li t1, 0
	blt a0, t1, tela_anterior	# Imprime e configura a próxima tela 
	
	ret

# Configurações quando o personagem passar para a proxima tela
proxima_tela:
	loadw(t1, tela_atual)
	addi t1, t1, 1
	savew(t1, tela_atual)
	li t1, 20
	li t2, 160
	savew(t1, horizontal_2b)
	savew(t2, vertical_2b)
	savew(t1, antigo_horizontal_2b)
	savew(t2, antigo_vertical_2b)
	call atualiza_tela

# Configurações quando o personagem volta uma tela
tela_anterior:
	loadw(t1, tela_atual)
	addi t1, t1, -1
	savew(t1, tela_atual)
	li t1, 240
	li t2, 160
	savew(t1, horizontal_2b)
	savew(t2, vertical_2b)
	savew(t1, antigo_horizontal_2b)
	savew(t2, antigo_vertical_2b)
	call atualiza_tela		

# Checa se passou o tempo necessário desde a última atualização (controle de FPS)
# return a0= passou (0=não, 1=sim)
checa_tempo:
	loadw(t1, tempo_2b)		# carrega o momento da ultima renderização
	li a7, 30
	ecall				# pega o tempo atual
	sub t1, a0, t1			# tempo atual - ultima render
	li t2, 32
	bgeu t1, t2, ct_pode		# se for maior que 64 milissegundos, pode renderizar denovo
		li a0, 0			# se não, não renderiza
		ret
	ct_pode:
	li a0, 1
	ret

# Atualiza o tempo atual
att_tempo_2b:
	li a7, 30
	ecall
	savew(a0, tempo_2b)
	ret


# Apaga a antiga posição da personagem	
apagar_antiga_posicao:			
	loadw(t3,antigo_horizontal_2b)	# t3 = posição em x
	loadw(t2,antigo_vertical_2b)	# t2 = posição em y
	addi t2, t2, -10
	li t4, 320
	other_frame_address(t5)	# endereço da frame 
	mul t4, t4, t2		# 240 x altura
	add t4, t4, t3		# + largura
	add t5, t5, t4		# + endereço
	mv a1, t5		# endereço inicial
	
	loadw(a2, sprite_tela_atual)
	addi a2, a2, 8
	add a2, a2, t4
	
	li t5, 19260		# 50 + 50*320 
	add a3, a1, t5		# endereço final = inicial + t5
	li a4, 50		# pixels por linha
	li t1, 0		# contador de pixels pintados
	aap_loop:
	bge a1,a3,aap_fora			# Se for o último endereço então sai do loop
		bne t1,a4, aap_continua		# Testa se A4 pixels foram pintados (1 linha)
			sub a1,a1,a4
			sub a2,a2,a4
			addi a1,a1,320	
			addi a2,a2,320	
			li t1,0			# Desce para a próxima linha
		aap_continua:
		lb t2, 0(a2)
		sb t2, 0(a1)		# Pinta o byte no endereço do BitMap	
		addi t1,t1,1
		addi a1,a1,1 
		addi a2,a2,1
		j aap_loop			
	aap_fora:
	ret


# Param s1 = Novo vertical
# Param s2 = Nova velocidade Y
# Param s3 = Novo horizontal
renderiza_2b:
	loadw(s4, sprite_atual)		# endereço da sprite atual
	lw t2, 4(s4)			# altura da sprite
	li t3, 50
	sub t3, t3, t2			# t3 =  50  - altura da sprite
	add s1, s1, t3			# s1 (Vertical) = s1 + t3 (se a sprite for maior que o padrão, começa a imprimir mais encima)
	
	lw s5, (s4)			# s5 = Largura da imagem = Offset
	
	frame_address(a3)
	li t4, 320
	mul t4, t4, s1			# Altura da sprite x 320 (Altura final)
	add a3, a3, t4
	add a3, a3, s3			# A3 = Endereço inicial = Frame 0/1 + horizontal + 320 x vertical
	mv a4, a3			# A4 = cópia de A3
	
	get_largura_endereco(a1, a2, sprite_frame_atual, sprite_larguras_atual, sprite_enderecos_atual)
	
	li t4, 320
	lw t2, 4(s4)
	addi t2, t2, -1
	mul t4, t4, t2
	add t4, t4, a1			# T4 = 320 x altura da sprite + largura da sprite
	add a4, a4, t4			# A4 = Endereço final = Endereço inicial + tamanho da sprite
	
	add s4, s4, a2			# Chega à frame certa dentro da imagem
	
	
	li a5, 0xffffff80
	li a6, 0
	# A1 = Largura da sprite
	# A3 = Endereço inicial
	# A4 = Endereço final
	# A5 = Cor a ser substituida pelo transparente
	# A6 = Contador de pixels pintados
	# S4 = Endereço da sprite
	# S5 = Offset
	r_loop: 	
	bge a3,a4,r_fora			# Se for o último endereço então sai do loop
		bne a6,a1, r_continua		# Testa se A1 pixels foram pintados (1 linha)
			sub a3,a3,a1
			addi a3,a3,320		
			li a6,0			# Desce para a próxima linha
			sub s4, s4, a1
			add s4, s4, s5
		r_continua:
			lb t0, 0(s4)			# Carrega o byte da sprite
		beq t0, a5, r_pula		# Testa se o byte é da cor A5
			sb t0, 0(a3)		# Pinta o byte no endereço do BitMap
		r_pula:	
			addi a6,a6,1
			addi a3,a3,1 
			addi s4,s4,1
		j r_loop			
	r_fora:
	ret
	
	

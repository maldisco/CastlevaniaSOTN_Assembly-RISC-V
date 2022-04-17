.data

# Posiçoes atuais do personagem
horizontal_luffy:			.word 20
vertical_luffy:			.word 160

# Posições antigas (a serem apagadas)
antigo_horizontal_luffy:		.word 20
antigo_vertical_luffy:		.word 160

# Velocidades do personagem
velocidadeX_luffy:			.word 0
velocidadeY_luffy:			.word 0

# Cada sprite é um conjunto de vários movimentos
# Cada vetor abaixo representa a largura do movimento e seu endereço na sprite
larguras_correndo_direita:	.word 34,45,36,30,34,46,38,30	
larguras_correndo_esquerda:	.word 34,45,36,30,34,46,38,30
larguras_parada_direita:	.word 32,31,30,30,32,33,32
larguras_parada_esquerda:	.word 32,31,30,30,32,33,32
larguras_pulando_direita:	.word 30,30,31,30,34
larguras_pulando_esquerda:	.word 30,30,31,30,34
larguras_soco_direita:		.word 37,58,42
larguras_soco_esquerda:		.word 37,58,42
enderecos_correndo_direita:	.word 8,42,87,123,153,187,233,271
enderecos_correndo_esquerda:	.word 8,42,87,123,153,187,233,271
enderecos_parada_direita:	.word 8,40,71,101,131,163,196
enderecos_parada_esquerda:	.word 8,40,71,101,131,163,196
enderecos_pulando_direita:	.word 8,38,38,69,99
enderecos_pulando_esquerda:	.word 8,38,38,69,99
enderecos_soco_direita:		.word 8,45,103
enderecos_soco_esquerda:	.word 8,45,103

# booleano para indicar se o personagem está em animação de pulo
pulando:			.byte 0

# Tempo desde a ultima atualização de posição
tempo_luffy:			.word 0

.text
# Lida com o evento de apertar uma tecla do teclado
acoes_luffy:
	li t1, D
	beq s0, t1, direita		# checa se a tecla 'D' foi apertada
	
	li t1, A
	beq s0, t1, esquerda		# checa se a tecla 'A' foi apertada
	
	li t1, W
	beq s0, t1, pula		# checa se a tecla 'W' foi apertada
	
	li t1, S
	beq s0, t1, para		# checa se a tecla 'S' foi apertada
	
	li t1, Z
	beq s0, t1, soca
	
	# se nenhuma tecla de ação foi apertada, volta para o loop
		tail poll_loop
	
	direita:				# se a tecla 'D' foi apertada, velocidade = +15
		li t1, 15
		savew(t1, velocidadeX_luffy)
		atribuir(sprite_atual, sprite_correndo_direita)
		la t1, larguras_correndo_direita
		savew(t1, sprite_larguras_atual)
		la t1, enderecos_correndo_direita
		savew(t1, sprite_enderecos_atual)
		tail poll_loop
	
	esquerda:				# se a tecla 'A' foi apertada, velocidade = -15
		li t1, -15
		savew(t1, velocidadeX_luffy)
		atribuir(sprite_atual, sprite_correndo_esquerda)
		la t1, larguras_correndo_esquerda
		savew(t1, sprite_larguras_atual)
		la t1, enderecos_correndo_esquerda
		savew(t1, sprite_enderecos_atual)
		tail poll_loop
	
	pula:					# se a tecla 'W' foi apertada (e os dois pulos não tiverem sido feitos), velocidade vertical = -50 (subindo)
		loadb(t1, pulando)
		li t2, 2
		bge t1, t2, pula_direita	# se já foram os dois pulos, não faz nada
			addi t1, t1, 1
			saveb(t1, pulando)
					
			savew(zero, sprite_frame_atual) 	# Resetando animação
			
			li t1, -50					# Velocidade de subida
			savew(t1, velocidadeY_luffy)
			atribuir(sprite_atual, sprite_pulando_direita)
			la t1, larguras_pulando_direita
			savew(t1, sprite_larguras_atual)
			la t1, enderecos_pulando_direita
			savew(t1, sprite_enderecos_atual)
			loadw(t1, velocidadeX_luffy)
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
			loadw(t1, velocidadeX_luffy)
			bgtz t1, parada_direita
				atribuir(sprite_atual, sprite_parada_esquerda)
				la t1, larguras_parada_esquerda
				savew(t1, sprite_larguras_atual)
				la t1, enderecos_parada_esquerda
				savew(t1, sprite_enderecos_atual)
			parada_direita:
			li t1, 0
			savew(t1, velocidadeX_luffy)
		nao_pode_parar:
		tail poll_loop
		
	soca:					# se a tecla 'Z' foi apertada, faz animação de soco	
		loadw(t1, velocidadeX_luffy)
		bgtz t1, soca_direita		# se a velocidade for positiva, soca para direita
		
		bltz t1, soca_esquerda		# se a velocidade for negativa, soca para esquerda
						
		loadw(t1, sprite_atual)		# senão...
		
		la t2, luffy_parado_direita
		beq t1, t2, soca_direita		# se a velocidade for 0 e a sprite estiver virada para direita, soca para direita
		
		la t2, luffy_parado_esquerda
		beq t1, t2, soca_esquerda		# se a velocidade for 0 e a sprite estiver virada para esquerda, soca para esquerda

		tail poll_loop			# Em último caso, volta ao loop (teoricamente nunca vai chegar aqui)
		
		soca_direita:
			atribuir(sprite_temp, sprite_atual)
			atribuir(larguras_temp, sprite_larguras_atual)
			atribuir(enderecos_temp, sprite_enderecos_atual)
			atribuir(sprite_atual, sprite_soco_direita)
			la t1, larguras_soco_direita
			savew(t1, sprite_larguras_atual)
			la t1, enderecos_soco_direita
			savew(t1, sprite_enderecos_atual)
			savew(zero, sprite_frame_atual)
			tail poll_loop
	
		soca_esquerda:
			atribuir(sprite_temp, sprite_atual)
			atribuir(larguras_temp, sprite_larguras_atual)
			atribuir(enderecos_temp, sprite_enderecos_atual)
			atribuir(sprite_atual, sprite_soco_esquerda)
			la t1, larguras_soco_esquerda
			savew(t1, sprite_larguras_atual)
			la t1, enderecos_soco_esquerda
			savew(t1, sprite_enderecos_atual)
			savew(zero, sprite_frame_atual)
			tail poll_loop

# Atualiza a posição da personagem levando em conta:
# - Velocidade horizontal
# - Velocidade vertical
# - Gravidade	
atualiza_posicao_luffy:
	addi sp, sp, -4
	sw ra, (sp)				# Guardando endereço de retorno para o loop principal

	loadw(t1, velocidadeY_luffy)
	loadw(t2, vertical_luffy)
	add s1, t2, t1				# Nova posição Y = posição + velocidade
	
	li t2, GRAVIDADE
	add s2, t1, t2				# Nova velocidade Y = velocidade + gravidade
	
	loadw(t3, chao)	
	blt s1, t3, esta_no_ar			# Se o personagem ainda está no ar, a gravidade age
		loadw(s1, chao)
		li s2, 0
		loadb(t1, pulando)
		beqz t1, esta_no_ar			# Se o personagem não estiver em estado de pulo/queda, ignora todo esse trecho
			savew(s2, pulando)
			loadw(t1, velocidadeX_luffy)
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
	
	loadw(t1, teto)			# Carrega coordenadas do teto
	bgt s1, t1 nao_bateu_no_teto	# Se a posição vertical for maior que a coordenada do teto, bateu
		mv s1, t1			# Posição vertical = teto
	nao_bateu_no_teto:	
	
	
	# Salva novas posições e velocidades verticais
	savew(s1, vertical_luffy)
	savew(s2, velocidadeY_luffy)
	
	jal escolhe_frame_sprite_atual		# Escolhe a sprite que será pintada
		
	loadw(s3, horizontal_luffy)
	loadw(t1, velocidadeX_luffy)
	add a0, s3, t1			# a0 = nova posição X
	jal checa_colisao		# Checa se o personagem colidiu com algo ou passou da tela: Resultado em a1
	beqz a1, colidiu
		mv s3, a0
		savew(s3, horizontal_luffy)	# Salva posição X do persomagem
	colidiu:			# Se colidiu, não se move
	
	troca_tela()
	
	# s1 = Novo vertical
	# s2 = Nova velocidade
	# s3 = Novo horizontal
	jal renderiza_luffy
	
	atualiza_tela()
	
	jal apagar_antiga_posicao
	
	atribuir(antigo_horizontal_luffy, horizontal_luffy)
	atribuir(antigo_vertical_luffy, vertical_luffy)
	
	jal att_tempo_luffy
	
	lw ra, (sp)			# Retorna ao loop principal
	addi sp, sp, 4
	ret
	
	
escolhe_frame_sprite_atual:
	li a0, 0 		# limite
	loadw(t1, sprite_atual)
	
	# Checa qual a sprite atual para calcular o limite e a proxima frame da sprite
	la t2, luffy_parado_direita
	beq t1, t2, efsa_parada			
	
	la t2, luffy_parado_esquerda
	beq t1, t2, efsa_parada
	
	la t2, luffy_correndo_direita
	beq t1, t2, efsa_correndo
	
	la t2, luffy_correndo_esquerda
	beq t1, t2, efsa_correndo
	
	la t2, luffy_pulando_direita
	beq t1, t2, efsa_pulando
	
	la t2, luffy_pulando_esquerda
	beq t1, t2, efsa_pulando
	
	la t2, luffy_soco_direita
	beq t1, t2, efsa_socando
	
	la t2, luffy_soco_esquerda
	beq t1, t2, efsa_socando
	
	# Se não for nenhuma delas, algo deu errado
	li a7, 10
	ecall
	
	efsa_retorna:
		savew(t1, sprite_frame_atual)
		ret
	
	efsa_parada:
		loadw(t1, sprite_frame_atual)
		addi t1, t1, 1
		li t2, 8
		blt t1, t2, efsa_retorna
			li t1, 0
			j efsa_retorna
	
	efsa_correndo:
		loadw(t1, sprite_frame_atual)
		addi t1, t1, 1
		li t2, 9
		blt t1, t2, efsa_retorna
			li t1, 0
			j efsa_retorna
	
	efsa_pulando:
		loadw(t1, sprite_frame_atual)
		addi t1, t1, 1
		li t2, 6
		blt t1, t2, efsa_retorna
			loadw(t3, vertical_luffy)
			li t2, 160
			li t1, 4
			blt t3, t2, efsa_retorna
				li t1, 0
				j efsa_retorna
	
	efsa_socando:
		loadw(t1, sprite_frame_atual)
		addi t1, t1, 1
		li t2, 4
		blt t1, t2, efsa_retorna
			atribuir(sprite_atual, sprite_temp)
			atribuir(sprite_larguras_atual, larguras_temp)
			atribuir(sprite_enderecos_atual, enderecos_temp)
			li t1, 0
			j efsa_retorna


# Checa colisão com blocos e paredes (ou se passou para a proxima tela/tela anterior)
# Param a0 = Nova posição X do personagem
# Return a1,  0 = colidiu, 1 = não colidiu
checa_colisao:
	loadw(t1, velocidadeX_luffy)
	bgtz t1, colisao_direita	# Se a velocidade for positiva, checa colisão a direita
	bltz t1, colisao_esquerda	# Se a velocidade for negativa, checa colisão a direita
	
	li a1, 1
	ret				# Se estiver parado, retorna
	
	colisao_direita:
		loadb(t2, sprite_frame_atual)
		loadw(t1, sprite_larguras_atual)
		li t3, 4
		mul t2, t2, t3
		add t1, t1, t2
		lw t1, (t1)				# t1 = Largura da sprite atual
		add a2, a0, t1				# a2 = a0 + t1 = Limite à direita

		loadw(t1, tela_atual)
		li t2, 3			# Se estiver nas telas 1 ou 2, pode passar
		blt t1, t2, cc_pode_passar
						# Se não, está no fim do mapa
			li t1, 320
			blt a2, t1, cc_pode_mover
				li a1, 0		# Se tiver chegado no limite da ultima tela, não pode mais andar para esse lado
				ret
			cc_pode_mover:
			li a1, 1
			ret
	
		cc_pode_passar:
		li t1, 320
		bgt a2, t1, proxima_tela	# Imprime e configura a próxima tela 
		li a1, 1
		ret
		
	
	colisao_esquerda:
		loadw(t1, tela_atual)
		li t2, 1
		bgt t1, t2, ce_pode_passar
			
			li t1, 0
			bgt a0, t1, ce_pode_mover
				li a1, 0
				ret
			ce_pode_mover:
			li a1, 1 
			ret
			
		ce_pode_passar:
		li t1, 0
		blt a0, t1, tela_anterior
		li a1, 1
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
	savew(t1, antigo_horizontal_luffy)
	savew(t2, antigo_vertical_luffy)
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
	savew(t1, antigo_horizontal_luffy)
	savew(t2, antigo_vertical_luffy)
	call atualiza_tela		

# Checa se passou o tempo necessário desde a última atualização (controle de FPS)
# return a0= passou (0=não, 1=sim)
checa_tempo:
	loadw(t1, tempo_luffy)		# carrega o momento da ultima renderização
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
att_tempo_luffy:
	li a7, 30
	ecall
	savew(a0, tempo_luffy)
	ret


# Apaga a antiga posição da personagem	
apagar_antiga_posicao:			
	loadw(t3,antigo_horizontal_luffy)	# t3 = posição em x
	loadw(t2,antigo_vertical_luffy)	# t2 = posição em y
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
	li a4, 60		# pixels por linha
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
renderiza_luffy:
	loadw(s4, sprite_atual)		# endereço da sprite atual
	lw t2, 4(s4)			# altura da sprite
	li t3, 46
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
	
	

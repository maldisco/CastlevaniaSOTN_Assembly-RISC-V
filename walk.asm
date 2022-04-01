.data
TWOB_POSX:		.word 74
TWOB_POSY:		.word 183
TWOB_OLD_POSX:		.word 74
TWOB_OLD_POSY:		.word 183
SIZES_RIGHT:		.word 44,34,42,39,39,43		# largura de cada sprite de corrida à direita
SIZES_LEFT:		.word 43,39,39,42,34,44		# largura de cada sprite de corrida à direita
ADDRESS_RIGHT:		.word 8,52,86,128,167,206
ADDRESS_LEFT:		.word 8,51,90,129,171,205
JUMP_RIGHT:		.word 197,207,199,202,202,198
JUMP_LEFT:		.word 198,202,202,199,207,197
CURRENT_SPRITE:		.word 0

.text

TWOB_WALK:
	li a1, RIGHT		# carrega para a1 o código da tecla 'D'
	li a2, LEFT		# carrega para a2 o código da tecla 'A'
	
	li t2, 0					# reseta animação
	savew(t2, CURRENT_SPRITE)
	
	beq s0, a1, DIREITA	# se for igual ao código da tecla 'D', anda para direita
	beq s0, a2, ESQUERDA	# se for igual ao código da tecla 'A', anda para esquerd
	j POLL_LOOP
DIREITA:	
	switch_frame()					# troca de frame (só na memória, não no bitmap)
	loadw(t2, TWOB_POSX)				# carrega para t2 a posição atual do personagem em X
	addi t2, t2, 10					# adiciona 10 pixels (largura da sprite) -> desloca à direita
	savew(t2, TWOB_POSX)				# salva o novo valor de posição do personagem
	jal WALK_RIGHT
	frame_refresh()					# troca de frame (no bitmap)
	jal ERASE_OLD_POSITION				# apaga a posição antiga
	loadw(t2, TWOB_OLD_POSX)			# atualiza posição antiga
	addi t2, t2, 10		
	savew(t2, TWOB_OLD_POSX)	
	j D_APERTADO					# checa se a tecla ainda está apertada
ESQUERDA:
	switch_frame()					# troca de frame (só na memória, não no bitmap)
	loadw(t2, TWOB_POSX)				# carrega para t2 a posição atual do personagem em X
	addi t2, t2, -10				# subtrai 10 pixels (largura da sprite) -> desloca à direita
	savew(t2, TWOB_POSX)				# salva o novo valor de posição do personagem
	jal WALK_LEFT
	frame_refresh()					# troca de frame (no bitmap)
	jal ERASE_OLD_POSITION				# apaga a posição antiga
	loadw(t2, TWOB_OLD_POSX)			# atualiza posição antiga
	addi t2, t2, -10				
	savew(t2, TWOB_OLD_POSX)	
	j D_ESQUERDA					# volta ao loop
	

D_APERTADO:
	li s11, MMIO_set
	lw t1, (s11)
	beqz t1, POLL_LOOP
	loadw(t1, CURRENT_SPRITE)
	addi t1, t1, 1
	li t2, 7
	bne t1, t2, DA_SALVA
	li t1, 0
DA_SALVA:
	savew(t1, CURRENT_SPRITE)
	j DIREITA
	
D_ESQUERDA:
	li s11, MMIO_set
	lw t1, (s11)
	beqz t1, POLL_LOOP
	loadw(t1, CURRENT_SPRITE)
	addi t1, t1, 1
	li t2, 7
	bne t1, t2, DE_SALVA
	li t1, 0
DE_SALVA:
	savew(t1, CURRENT_SPRITE)
	j ESQUERDA
	
	

########################
# Apaga o bloco antigo #
########################	
ERASE_OLD_POSITION:			
	loadw(t3,TWOB_OLD_POSX)	# t3 = posição em x
	loadw(t2,TWOB_OLD_POSY)	# t2 = posição em y
	li t4, 320
	other_frame_address(t5)	# endereço da frame 
	mul t4, t4, t2		# 240 x altura
	add t4, t4, t3		# + largura
	add t5, t5, t4		# + endereço
	mv a1, t5		# endereço inicial
	li t5, 16050		# 50 + 50*320 
	add a2, a1, t5		# endereço final = inicial + t5
	li a3, 50		# pixels por linha
	li t1, 0		# contador de pixels pintados
	li t2, 0		# preto
	ECP_LOOP:
	bge a1,a2,ECP_FORA			# Se for o último endereço então sai do loop
		bne t1,a3, ECP_CONTINUA		# Testa se A4 pixels foram pintados (1 linha)
			sub a1,a1,a3
			addi a1,a1,320		
			li t1,0			# Desce para a próxima linha
		ECP_CONTINUA:
		sb t2, 0(a1)		# Pinta o byte no endereço do BitMap	
		addi t1,t1,1
		addi a1,a1,1 
		j ECP_LOOP			
	ECP_FORA:
	ret

#####################
# Anda para direita #		 
#####################
WALK_RIGHT:
la s1, twob_walk_right				# s1 =  endereço da imagem
get_size_address_right(a1, a2, twob_walk_right)	# a1 = largura da sprite, a2 = endereço da sprite
loadw(t1,TWOB_POSX)				# posição em X
loadw(t2,TWOB_POSY)				# posição em Y
li t3, 320					
mul t3, t3, t2
frame_address(a3)
add a3, a3, t3
add a3, a3, t1					# a3 = endereço inicial
mv a4, a3
li t1, 15680					# 320 x 50(altura de todas as sprites)
add t1, t1, a1
add a4, a4, t1					# a4 = endereço final
add s1, s1, a2					# chega à sprite certa dentro da imagem
li a5, 0xffffff80
li a6, 0
# ==========================================================
# a1 = largura da sprite (pixels a serem pintados)
# a2 = endereço da sprite dentro da imagem
# a3 = endereço inicial
# a4 = endereço final
# a5 = cor a ser substituida pelo transparente
# a6 = contador de pixels pintados
# s1 = endereço da sprite
# ==========================================================
WR_LOOP: 	
	bge a3,a4,WR_FORA			# Se for o último endereço então sai do loop
		bne a6,a1, WR_CONTINUA		# Testa se A1 pixels foram pintados (1 linha)
			sub a3,a3,a1
			addi a3,a3,320		
			li a6,0			# Desce para a próxima linha
			li t4, 241
			sub t4, t4, a1
			add s1, s1, t4
		WR_CONTINUA:
		lb t0, 0(s1)			# Carrega o byte da sprite
		beq t0, a5, WR_PULA		# Testa se o byte é da cor A5
			sb t0, 0(a3)		# Pinta o byte no endereço do BitMap
		WR_PULA:	
		addi a6,a6,1
		addi a3,a3,1 
		addi s1,s1,1
		j WR_LOOP			
	WR_FORA:
	ret

######################
# Anda para esquerda #		 
######################
WALK_LEFT:
la s1, twob_walk_left				# s1 =  endereço da imagem
get_size_address_right(a1, a2, twob_walk_left)	# a1 = largura da sprite, a2 = endereço da sprite
loadw(t1,TWOB_POSX)				# posição em X
loadw(t2,TWOB_POSY)				# posição em Y
li t3, 320					
mul t3, t3, t2
frame_address(a3)
add a3, a3, t3
add a3, a3, t1					# a3 = endereço inicial
mv a4, a3
li t1, 15680					# 320 x 50(altura de todas as sprites)
add t1, t1, a1
add a4, a4, t1					# a4 = endereço final
add s1, s1, a2					# chega à sprite certa dentro da imagem
li a5, 0xffffff80
li a6, 0
# ==========================================================
# a1 = largura da sprite (pixels a serem pintados)
# a2 = endereço da sprite dentro da imagem
# a3 = endereço inicial
# a4 = endereço final
# a5 = cor a ser substituida pelo transparente
# a6 = contador de pixels pintados
# s1 = endereço da sprite
# ==========================================================
WL_LOOP: 	
	bge a3,a4,WL_FORA			# Se for o último endereço então sai do loop
		bne a6,a1, WL_CONTINUA		# Testa se A1 pixels foram pintados (1 linha)
			sub a3,a3,a1
			addi a3,a3,320		
			li a6,0			# Desce para a próxima linha
			li t4, 241
			sub t4, t4, a1
			add s1, s1, t4
		WL_CONTINUA:
		lb t0, 0(s1)			# Carrega o byte da sprite
		beq t0, a5, WL_PULA		# Testa se o byte é da cor A5
			sb t0, 0(a3)		# Pinta o byte no endereço do BitMap
		WL_PULA:	
		addi a6,a6,1
		addi a3,a3,1 
		addi s1,s1,1
		j WL_LOOP			
	WL_FORA:
	ret

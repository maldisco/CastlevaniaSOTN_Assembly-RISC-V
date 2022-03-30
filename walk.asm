.data
TWOB_POSX:		.word 74
TWOB_POSY:		.word 183
TWOB_OLD_POSX:		.word 74
TWOB_OLD_POSY:		.word 183
SIZES_RIGHT:		.word 44,34,42,39,39,43		# largura de cada sprite de corrida � direita
SIZES_LEFT:		.word 43,39,39,42,34,44		# largura de cada sprite de corrida � direita
CURRENT_SIZE:		.word 44

.text

TWOB_WALK:
	li a1, RIGHT		# carrega para a1 o c�digo da tecla 'D'
	li a2, LEFT		# carrega para a2 o c�digo da tecla 'A'
	
	beq s0, a1, DIREITA	# se for igual ao c�digo da tecla 'D', anda para direita
	beq s0, a2, ESQUERDA	# se for igual ao c�digo da tecla 'A', anda para esquerd
	j POLL_LOOP
DIREITA:	
	la t2, SIZES_RIGHT				# atualiza o tamanho da sprite
	lw t2, (t2)
	savew(t2, CURRENT_SIZE)
	switch_frame()					# troca de frame (s� na mem�ria, n�o no bitmap)
	loadw(t2, TWOB_POSX)				# carrega para t2 a posi��o atual do personagem em X
	addi t2, t2, 10					# adiciona 10 pixels (largura da sprite) -> desloca � direita
	savew(t2, TWOB_POSX)				# salva o novo valor de posi��o do personagem
	walk(twob_walk_right, TWOB_POSX, TWOB_POSY)	# renderiza o personagem
	frame_refresh()					# troca de frame (no bitmap)
	jal ERASE_OLD_POSITION				# apaga a posi��o antiga
	loadw(t2, TWOB_OLD_POSX)			# atualiza posi��o antiga
	addi t2, t2, 10		
	savew(t2, TWOB_OLD_POSX)	
	j POLL_LOOP					# volta ao loop
ESQUERDA:
	la t2, SIZES_LEFT				# atualiza o tamanho da sprite
	lw t2, (t2)
	savew(t2, CURRENT_SIZE)
	switch_frame()					# troca de frame (s� na mem�ria, n�o no bitmap)
	loadw(t2, TWOB_POSX)				# carrega para t2 a posi��o atual do personagem em X
	addi t2, t2, -10				# subtrai 10 pixels (largura da sprite) -> desloca � direita
	savew(t2, TWOB_POSX)				# salva o novo valor de posi��o do personagem
	walk(twob_walk_left, TWOB_POSX, TWOB_POSY)	# renderiza o personagem
	frame_refresh()					# troca de frame (no bitmap)
	jal ERASE_OLD_POSITION				# apaga a posi��o antiga
	loadw(t2, TWOB_OLD_POSX)			# atualiza posi��o antiga
	addi t2, t2, -10				
	savew(t2, TWOB_OLD_POSX)	
	j POLL_LOOP					# volta ao loop
	

########################
# Apaga o bloco antigo #
########################	
ERASE_OLD_POSITION:			
	loadw(t3,TWOB_OLD_POSX)	# t3 = posi��o em x
	loadw(t2,TWOB_OLD_POSY)	# t2 = posi��o em y
	li t4, 320
	other_frame_address(t5)	# endere�o da frame atual
	xori t5, t5, 0x1
	mul t4, t4, t2		# 240 x altura
	add t4, t4, t3		# + largura
	add t5, t5, t4		# + endere�o
	mv a1, t5		# endere�o inicial
	li t5, 16050		# 50 + 50*320 
	add a2, a1, t5		# endere�o final = inicial + t5
	li a3, 50		# pixels por linha
	li t1, 0		# contador de pixels pintados
	li t2, 0		# preto
	ECP_LOOP:
	bge a1,a2,ECP_FORA			# Se for o �ltimo endere�o ent�o sai do loop
		bne t1,a3, ECP_CONTINUA		# Testa se A4 pixels foram pintados (1 linha)
			sub a1,a1,a3
			addi a1,a1,320		
			li t1,0			# Desce para a pr�xima linha
		ECP_CONTINUA:
		sb t2, 0(a1)		# Pinta o byte no endere�o do BitMap	
		addi t1,t1,1
		addi a1,a1,1 
		j ECP_LOOP			
	ECP_FORA:
	ret
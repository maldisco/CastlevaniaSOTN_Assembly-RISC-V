.data
horizontal_2b:		.word 74
vertical_2b:		.word 183
antigo_horizontal_2b:		.word 74
antigo_vertical_2b:		.word 183
larguras_direita:		.word 44,34,42,39,39,43		# largura de cada sprite de corrida � direita
larguras_esquerda:		.word 43,39,39,42,34,44		# largura de cada sprite de corrida � direita
endereco_direita:		.word 8,52,86,128,167,206
endereco_esquerda:		.word 8,51,90,129,171,205
sprite_atual:		.word 0

.text

animacao_2b:
	li a1, RIGHT		# carrega para a1 o c�digo da tecla 'D'
	li a2, LEFT		# carrega para a2 o c�digo da tecla 'A'
	
	li t2, 0					# reseta anima��o
	savew(t2, sprite_atual)
	
	beq s0, a1, direita	# se for igual ao c�digo da tecla 'D', anda para direita
	beq s0, a2, esquerda	# se for igual ao c�digo da tecla 'A', anda para esquerd
	j poll_loop
direita:	
	troca_tela()					# troca de frame (s� na mem�ria, n�o no bitmap)
	soma(horizontal_2b, 10)				# adiciona 10 pixels (largura da sprite) -> desloca � direita
	jal move_direita
	atualiza_tela()					# troca de frame (no bitmap)
	jal apagar_antiga_posicao			# apaga a posi��o antiga
	soma(antigo_horizontal_2b, 10)			# atualiza posi��o antiga
	j d_apertado					# checa se a tecla ainda est� apertada
esquerda:
	troca_tela()					# troca de frame (s� na mem�ria, n�o no bitmap)
	subtrai(horizontal_2b, 10)			# subtrai 10 pixels (largura da sprite) -> desloca � direita
	jal move_esquerda
	atualiza_tela()					# troca de frame (no bitmap)
	jal apagar_antiga_posicao			# apaga a posi��o antiga
	subtrai(antigo_horizontal_2b, 10)			# atualiza posi��o antiga
	j a_apertado					# volta ao loop
	

d_apertado:
	li t0, MMIO_add
	lw s0, (t0)
	li t1, RIGHT
	bne s0, t1, animacao_2b
	loadw(t1, sprite_atual)
	addi t1, t1, 1
	li t2, 7
	bne t1, t2, da_salva
	li t1, 0
da_salva:
	savew(t1, sprite_atual)
	j direita
	
a_apertado:
	li t0, MMIO_add
	lw s0, (t0)
	li t1, LEFT
	bne s0, t1, animacao_2b
	loadw(t1, sprite_atual)
	addi t1, t1, 1
	li t2, 6
	bne t1, t2, aa_salva
	li t1, 0
aa_salva:
	savew(t1, sprite_atual)
	j esquerda
	
	

########################
# Apaga o bloco antigo #
########################	
apagar_antiga_posicao:			
	loadw(t3,antigo_horizontal_2b)	# t3 = posi��o em x
	loadw(t2,antigo_vertical_2b)	# t2 = posi��o em y
	li t4, 320
	other_frame_address(t5)	# endere�o da frame 
	mul t4, t4, t2		# 240 x altura
	add t4, t4, t3		# + largura
	add t5, t5, t4		# + endere�o
	mv a1, t5		# endere�o inicial
	li t5, 16050		# 50 + 50*320 
	add a2, a1, t5		# endere�o final = inicial + t5
	li a3, 50		# pixels por linha
	li t1, 0		# contador de pixels pintados
	li t2, 0		# preto
	aap_loop:
	bge a1,a2,aap_fora			# Se for o �ltimo endere�o ent�o sai do loop
		bne t1,a3, aap_continua		# Testa se A4 pixels foram pintados (1 linha)
			sub a1,a1,a3
			addi a1,a1,320		
			li t1,0			# Desce para a pr�xima linha
		aap_continua:
		sb t2, 0(a1)		# Pinta o byte no endere�o do BitMap	
		addi t1,t1,1
		addi a1,a1,1 
		j aap_loop			
	aap_fora:
	ret

#####################
# Anda para direita #		 
#####################
move_direita:
la s1, twob_walk_right				# s1 =  endere�o da imagem
get_largura_endereco(a1, a2, larguras_direita, endereco_direita)	# a1 = largura da sprite, a2 = endere�o da sprite
loadw(t1,horizontal_2b)				# posi��o em X
loadw(t2,vertical_2b)				# posi��o em Y
li t3, 320					
mul t3, t3, t2
frame_address(a3)
add a3, a3, t3
add a3, a3, t1					# a3 = endere�o inicial
mv a4, a3
li t1, 15680					# 320 x 50(altura de todas as sprites)
add t1, t1, a1
add a4, a4, t1					# a4 = endere�o final
add s1, s1, a2					# chega � sprite certa dentro da imagem
li a5, 0xffffff80
li a6, 0
# ==========================================================
# a1 = largura da sprite (pixels a serem pintados)
# a2 = endere�o da sprite dentro da imagem
# a3 = endere�o inicial
# a4 = endere�o final
# a5 = cor a ser substituida pelo transparente
# a6 = contador de pixels pintados
# s1 = endere�o da sprite
# ==========================================================
md_loop: 	
	bge a3,a4,md_fora			# Se for o �ltimo endere�o ent�o sai do loop
		bne a6,a1, md_continua		# Testa se A1 pixels foram pintados (1 linha)
			sub a3,a3,a1
			addi a3,a3,320		
			li a6,0			# Desce para a pr�xima linha
			li t4, 241
			sub t4, t4, a1
			add s1, s1, t4
		md_continua:
		lb t0, 0(s1)			# Carrega o byte da sprite
		beq t0, a5, md_pula		# Testa se o byte � da cor A5
			sb t0, 0(a3)		# Pinta o byte no endere�o do BitMap
		md_pula:	
		addi a6,a6,1
		addi a3,a3,1 
		addi s1,s1,1
		j md_loop			
	md_fora:
	ret

######################
# Anda para esquerda #		 
######################
move_esquerda:
la s1, twob_walk_left				# s1 =  endere�o da imagem
get_largura_endereco(a1, a2, larguras_esquerda, endereco_esquerda)	# a1 = largura da sprite, a2 = endere�o da sprite
loadw(t1,horizontal_2b)				# posi��o em X
loadw(t2,vertical_2b)				# posi��o em Y
li t3, 320					
mul t3, t3, t2
frame_address(a3)
add a3, a3, t3
add a3, a3, t1					# a3 = endere�o inicial
mv a4, a3
li t1, 15680					# 320 x 50(altura de todas as sprites)
add t1, t1, a1
add a4, a4, t1					# a4 = endere�o final
add s1, s1, a2					# chega � sprite certa dentro da imagem
li a5, 0xffffff80
li a6, 0
# ==========================================================
# a1 = largura da sprite (pixels a serem pintados)
# a2 = endere�o da sprite dentro da imagem
# a3 = endere�o inicial
# a4 = endere�o final
# a5 = cor a ser substituida pelo transparente
# a6 = contador de pixels pintados
# s1 = endere�o da sprite
# ==========================================================
me_loop: 	
	bge a3,a4,me_fora			# Se for o �ltimo endere�o ent�o sai do loop
		bne a6,a1, me_continua		# Testa se A1 pixels foram pintados (1 linha)
			sub a3,a3,a1
			addi a3,a3,320		
			li a6,0			# Desce para a pr�xima linha
			li t4, 241
			sub t4, t4, a1
			add s1, s1, t4
		me_continua:
		lb t0, 0(s1)			# Carrega o byte da sprite
		beq t0, a5, me_pula		# Testa se o byte � da cor A5
			sb t0, 0(a3)		# Pinta o byte no endere�o do BitMap
		me_pula:	
		addi a6,a6,1
		addi a3,a3,1 
		addi s1,s1,1
		j me_loop			
	me_fora:
	ret

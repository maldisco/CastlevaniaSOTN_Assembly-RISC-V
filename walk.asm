.data
horizontal_2b:		.word 74
vertical_2b:		.word 183
antigo_horizontal_2b:		.word 74
antigo_vertical_2b:		.word 183
larguras_direita:		.word 44,34,42,39,39,43		# largura de cada sprite de corrida à direita
larguras_esquerda:		.word 43,39,39,42,34,44		# largura de cada sprite de corrida à direita
larguras_parada:		.word 28,26,26
endereco_direita:		.word 8,52,86,128,167,206
endereco_esquerda:		.word 8,51,90,129,171,205
endereco_parada:		.word 8,36,62
sprite_atual:		.word 0

.text

animacao_2b:
	li a1, RIGHT		# carrega para a1 o código da tecla 'D'
	li a2, LEFT		# carrega para a2 o código da tecla 'A'
	
	li t2, 0					# reseta animação
	savew(t2, sprite_atual)
	
	beq s0, a1, direita	# se for igual ao código da tecla 'D', anda para direita
	beq s0, a2, esquerda	# se for igual ao código da tecla 'A', anda para esquerd
	parada:
	troca_tela()					# troca de frame (só na memória, não no bitmap)
	jal anima_parada				# animação parada
	atualiza_tela()					# troca de frame (no bitmap)
	jal apagar_antiga_posicao			# apaga a posição antiga
	li a7, 32
	li a0, 32
	ecall						# dorme por 32 milissegundos
	j nada_apertado					# testa de não há nenhuma tecla apertada
direita:	
	troca_tela()					# troca de frame (só na memória, não no bitmap)
	soma(horizontal_2b, 10)				# adiciona 10 pixels (largura da sprite) -> desloca à direita
	jal move_direita
	atualiza_tela()					# troca de frame (no bitmap)
	jal apagar_antiga_posicao			# apaga a posição antiga
	soma(antigo_horizontal_2b, 10)			# atualiza posição antiga
	j d_apertado					# checa se a tecla ainda está apertada
esquerda:
	troca_tela()					# troca de frame (só na memória, não no bitmap)
	subtrai(horizontal_2b, 10)			# subtrai 10 pixels (largura da sprite) -> desloca à direita
	jal move_esquerda
	atualiza_tela()					# troca de frame (no bitmap)
	jal apagar_antiga_posicao			# apaga a posição antiga
	subtrai(antigo_horizontal_2b, 10)			# atualiza posição antiga
	j a_apertado					# volta ao loop
	

d_apertado:
	li t0, MMIO_add					# endereço de ttecla armazenada
	lw s0, (t0)
	li t1, RIGHT
	bne s0, t1, animacao_2b				# se direita (D) estiver apertada, volta para animação
	loadw(t1, sprite_atual)				
	addi t1, t1, 1					# incrementa 1 na sprite atual
	li t2, 7	
	blt t1, t2, da_salva				# se sprite atual > 6(última), volta para 0
	li t1, 0
da_salva:
	savew(t1, sprite_atual)				# salva nova sprite
	j direita
	
a_apertado:
	li t0, MMIO_add					# endereço de ttecla armazenada
	lw s0, (t0)
	li t1, LEFT
	bne s0, t1, animacao_2b				# se esquerda (A) estiver apertada, volta para animaçã
	loadw(t1, sprite_atual)
	addi t1, t1, 1					# incrementa 1 na sprite atual
	li t2, 7
	blt t1, t2, aa_salva				# se sprite atual > 6(última), volta para 0
	li t1, 0
aa_salva:
	savew(t1, sprite_atual)				# salva nova sprite
	j esquerda
	
nada_apertado:
	li t0, MMIO_add					# endereço de ttecla armazenada
	lw s0, (t0)
	li t1, RIGHT
	li t2, LEFT
	beq s0, t1, animacao_2b
	beq s0, t2, animacao_2b				# se nem esquerda (A) nem direita (D) estiver apertadas, continua animação de parada
	loadw(t1, sprite_atual)
	addi t1, t1, 1					# incrementa 1 na sprite atual
	li t2, 3
	blt t1, t2, na_salva				# se sprite atual > 3(última), volta para 0
	li t1, 0
na_salva:
	savew(t1, sprite_atual)				# salva nova sprite
	j parada

########################
# Apaga o bloco antigo #
########################	
apagar_antiga_posicao:			
	loadw(t3,antigo_horizontal_2b)	# t3 = posição em x
	loadw(t2,antigo_vertical_2b)	# t2 = posição em y
	addi t2, t2, -9
	li t4, 320
	other_frame_address(t5)	# endereço da frame 
	mul t4, t4, t2		# 240 x altura
	add t4, t4, t3		# + largura
	add t5, t5, t4		# + endereço
	mv a1, t5		# endereço inicial
	li t5, 18880		# 50 + 50*320 
	add a2, a1, t5		# endereço final = inicial + t5
	li a3, 50		# pixels por linha
	li t1, 0		# contador de pixels pintados
	li t2, 0		# preto
	aap_loop:
	bge a1,a2,aap_fora			# Se for o último endereço então sai do loop
		bne t1,a3, aap_continua		# Testa se A4 pixels foram pintados (1 linha)
			sub a1,a1,a3
			addi a1,a1,320		
			li t1,0			# Desce para a próxima linha
		aap_continua:
		sb t2, 0(a1)		# Pinta o byte no endereço do BitMap	
		addi t1,t1,1
		addi a1,a1,1 
		j aap_loop			
	aap_fora:
	ret

#####################
# Anda para direita #		 
#####################
move_direita:
la s1, twob_walk_right				# s1 =  endereço da imagem
get_largura_endereco(a1, a2, larguras_direita, endereco_direita)	# a1 = largura da sprite, a2 = endereço da sprite
loadw(t1,horizontal_2b)				# posição em X
loadw(t2,vertical_2b)				# posição em Y
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
md_loop: 	
	bge a3,a4,md_fora			# Se for o último endereço então sai do loop
		bne a6,a1, md_continua		# Testa se A1 pixels foram pintados (1 linha)
			sub a3,a3,a1
			addi a3,a3,320		
			li a6,0			# Desce para a próxima linha
			li t4, 241
			sub t4, t4, a1
			add s1, s1, t4
		md_continua:
		lb t0, 0(s1)			# Carrega o byte da sprite
		beq t0, a5, md_pula		# Testa se o byte é da cor A5
			sb t0, 0(a3)		# Pinta o byte no endereço do BitMap
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
la s1, twob_walk_left				# s1 =  endereço da imagem
get_largura_endereco(a1, a2, larguras_esquerda, endereco_esquerda)	# a1 = largura da sprite, a2 = endereço da sprite
loadw(t1,horizontal_2b)				# posição em X
loadw(t2,vertical_2b)				# posição em Y
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
me_loop: 	
	bge a3,a4,me_fora			# Se for o último endereço então sai do loop
		bne a6,a1, me_continua		# Testa se A1 pixels foram pintados (1 linha)
			sub a3,a3,a1
			addi a3,a3,320		
			li a6,0			# Desce para a próxima linha
			li t4, 241
			sub t4, t4, a1
			add s1, s1, t4
		me_continua:
		lb t0, 0(s1)			# Carrega o byte da sprite
		beq t0, a5, me_pula		# Testa se o byte é da cor A5
			sb t0, 0(a3)		# Pinta o byte no endereço do BitMap
		me_pula:	
		addi a6,a6,1
		addi a3,a3,1 
		addi s1,s1,1
		j me_loop			
	me_fora:
	ret

##############################
# Pequenos movimentos parada #		 
##############################
anima_parada:
la s1, twob_stand				# s1 =  endereço da imagem
get_largura_endereco(a1, a2, larguras_parada, endereco_parada)	# a1 = largura da sprite, a2 = endereço da sprite
loadw(t1,horizontal_2b)				# posição em X
loadw(t2,vertical_2b)				# posição em Y
addi t2, t2, -9
li t3, 320					
mul t3, t3, t2
frame_address(a3)
add a3, a3, t3
add a3, a3, t1					# a3 = endereço inicial
mv a4, a3
li t1, 18000					# 320 x 59(altura de todas as sprites)
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
mp_loop: 	
	bge a3,a4,mp_fora			# Se for o último endereço então sai do loop
		bne a6,a1, mp_continua		# Testa se A1 pixels foram pintados (1 linha)
			sub a3,a3,a1
			addi a3,a3,320		
			li a6,0			# Desce para a próxima linha
			li t4, 80
			sub t4, t4, a1
			add s1, s1, t4
		mp_continua:
		lb t0, 0(s1)			# Carrega o byte da sprite
		beq t0, a5, mp_pula		# Testa se o byte é da cor A5
			sb t0, 0(a3)		# Pinta o byte no endereço do BitMap
		mp_pula:	
		addi a6,a6,1
		addi a3,a3,1 
		addi s1,s1,1
		j mp_loop			
	mp_fora:
	ret

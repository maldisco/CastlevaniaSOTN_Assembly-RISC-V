.data

horizontal_2b:			.word 74
vertical_2b:			.word 183

antigo_horizontal_2b:		.word 74
antigo_vertical_2b:		.word 183

larguras_direita:		.word 44,34,42,39,39,43		# largura de cada sprite de corrida � direita
larguras_esquerda:		.word 43,39,39,42,34,44		# largura de cada sprite de corrida � direita
larguras_parada:		.word 28,26,26
larguras_pulando_direita:	.word 26,35,35,35,39,52,52,52,25
larguras_pulando_esquerda:	.word 25,52,52,52,39,35,35,35,26
endereco_direita:		.word 8,52,86,128,167,206
endereco_esquerda:		.word 8,51,90,129,171,205
endereco_parada:		.word 8,36,62
endereco_pulando_direita:	.word 8,34,69,104,139,178,230,282,334
endereco_pulando_esquerda:	.word 8,33,85,137,189,228,263,298,333

sprite_parada:			.word 0
sprite_movendo:			.word 0
sprite_pulando:			.word 0

tempo_2b:			.word 0

ultima_inst:			.word 0

.text

animacao_2b:
	li a1, RIGHT		# carrega para a1 o c�digo da tecla 'D'
	li a2, LEFT		# carrega para a2 o c�digo da tecla 'A'
	li a3, UP		# carrega para a3 o c�digo da tecla 'W'
	
	beq s0, a1, direita	# se for igual ao c�digo da tecla 'D', anda para direita
	beq s0, a2, esquerda	# se for igual ao c�digo da tecla 'A', anda para esquerd
	beq s0, a3, pula
	j poll_loop

pula:
	loadw(t1, ultima_inst)
	beq t1, a1, pula_direita
	beq t1, a2, pula_esquerda
	tail pula_parada
	
parada:
	jal checa_tempo
	beqz a0, parada	
	savew(zero, ultima_inst)
	troca_tela()					# troca de frame (s� na mem�ria, n�o no bitmap)
	jal anima_parada				# anima��o parada
	atualiza_tela()					# troca de frame (no bitmap)
	jal apagar_antiga_posicao			# apaga a posi��o antiga
	jal att_tempo_2b
	loadw(t1, sprite_parada)
	addi t1, t1, 1					# incrementa 1 na sprite atual
	li t2, 3
	blt t1, t2, pnao_zera				# se sprite atual > 3(�ltima), volta para 0
		li t1, 0
	pnao_zera:
	savew(t1, sprite_parada)				# salva nova sprite
	jalr s10
	
direita:
	jal checa_tempo
	beqz a0, direita
	savew(s0, ultima_inst)
	jal att_tempo_2b	
	troca_tela()					# troca de frame (s� na mem�ria, n�o no bitmap)
	soma(horizontal_2b, 10)				# adiciona 10 pixels (largura da sprite) -> desloca � direita
	jal move_direita
	atualiza_tela()					# troca de frame (no bitmap)
	jal apagar_antiga_posicao			# apaga a posi��o antiga
	soma(antigo_horizontal_2b, 10)			# atualiza posi��o antiga
	loadw(t1, sprite_movendo)				
	addi t1, t1, 1					# incrementa 1 na sprite atual
	li t2, 7	
	blt t1, t2, dnao_zera				# se sprite atual > 6(�ltima), volta para 0
		li t1, 0
	dnao_zera:
	savew(t1, sprite_movendo)				# salva nova spri
	j pl_recheca
	
esquerda:
	jal checa_tempo
	beqz a0, esquerda
	savew(s0, ultima_inst)
	jal att_tempo_2b
	troca_tela()					# troca de frame (s� na mem�ria, n�o no bitmap)
	subtrai(horizontal_2b, 10)			# subtrai 10 pixels (largura da sprite) -> desloca � direita
	jal move_esquerda
	atualiza_tela()					# troca de frame (no bitmap)
	jal apagar_antiga_posicao			# apaga a posi��o antiga
	subtrai(antigo_horizontal_2b, 10)			# atualiza posi��o antiga
	loadw(t1, sprite_movendo)
	addi t1, t1, 1					# incrementa 1 na sprite atual
	li t2, 7
	blt t1, t2, anao_zera				# se sprite atual > 6(�ltima), volta para 0
		li t1, 0
	anao_zera:
	savew(t1, sprite_movendo)				# salva nova sprite
	j pl_recheca

pula_parada:
	jal checa_tempo
	beqz a0, pula_parada
	jal att_tempo_2b
	troca_tela()
	funcao_pulo(s9)
	savew(s9, vertical_2b)
	jal anima_pulo_direita
	atualiza_tela()
	jal apagar_antiga_posicao
	savew(s9, antigo_vertical_2b)
	loadw(t1, sprite_pulando)
	addi t1, t1, 1
	li t2, 9
	blt t1, t2, ppnao_zera
		li t1, 0
		savew(t1, sprite_pulando)
		tail poll_loop
	ppnao_zera:
	savew(t1, sprite_pulando)
	j pula_parada

pula_direita:
	jal checa_tempo
	beqz a0, pula_direita
	jal att_tempo_2b
	troca_tela()
	funcao_pulo(s9)
	savew(s9, vertical_2b)
	soma(horizontal_2b, 10)
	jal anima_pulo_direita
	atualiza_tela()
	jal apagar_antiga_posicao
	savew(s9, antigo_vertical_2b)
	soma(antigo_horizontal_2b, 10)
	loadw(t1, sprite_pulando)
	addi t1, t1, 1
	li t2, 9
	blt t1, t2, pdnao_zera
		li t1, 0
		savew(t1, sprite_pulando)
		tail poll_loop
	pdnao_zera:
	savew(t1, sprite_pulando)
	j pula_direita
	
pula_esquerda:
	jal checa_tempo
	beqz a0, pula_esquerda
	jal att_tempo_2b
	troca_tela()
	funcao_pulo(s9)
	savew(s9, vertical_2b)
	subtrai(horizontal_2b, 10)
	jal anima_pulo_esquerda
	atualiza_tela()
	jal apagar_antiga_posicao
	savew(s9, antigo_vertical_2b)
	subtrai(antigo_horizontal_2b,10)
	loadw(t1, sprite_pulando)
	addi t1, t1, 1
	li t2, 9
	blt t1, t2, penao_zera
		li t1, 0
		savew(t1, sprite_pulando)
		tail poll_loop
	penao_zera:
	savew(t1, sprite_pulando)
	j pula_esquerda
	

######################################
# Checa se o tempo neces�rio passou  #
# desde a �ltima renderiza��o.	     #
# Controle de FPS                    #
######################################
checa_tempo:
	loadw(t1, tempo_2b)		# carrega o momento da ultima renderiza��o
	li a7, 30
	ecall				# pega o tempo atual
	sub t1, a0, t1			# tempo atual - ultima render
	li t2, 48
	bge t1, t2, ct_pode		# se for maior que 16 milissegundos, pode renderizar denovo
	li a0, 0			# se n�o, n�o renderiza
	ret
ct_pode:
	li a0, 1
	ret

##########################
# Atualiza o tempo atual #
##########################
att_tempo_2b:
	li a7, 30
	ecall
	savew(a0, tempo_2b)
	ret


########################
# Apaga o bloco antigo #
########################	
apagar_antiga_posicao:			
	loadw(t3,antigo_horizontal_2b)	# t3 = posi��o em x
	loadw(t2,antigo_vertical_2b)	# t2 = posi��o em y
	addi t2, t2, -9
	li t4, 320
	other_frame_address(t5)	# endere�o da frame 
	mul t4, t4, t2		# 240 x altura
	add t4, t4, t3		# + largura
	add t5, t5, t4		# + endere�o
	mv a1, t5		# endere�o inicial
	li t5, 18880		# 50 + 50*320 
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
get_largura_endereco(a1, a2, sprite_movendo, larguras_direita, endereco_direita)	# a1 = largura da sprite, a2 = endere�o da sprite
loadw(t1,horizontal_2b)				# posi��o em X
loadw(t2,vertical_2b)				# posi��o em Y
li t3, 320					
mul t3, t3, t2
frame_address(a3)
add a3, a3, t3
add a3, a3, t1					# a3 = endere�o inicial
mv a4, a3
li t1, 15680					# 319 x 50(altura da sprite)
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
get_largura_endereco(a1, a2, sprite_movendo, larguras_esquerda, endereco_esquerda)	# a1 = largura da sprite, a2 = endere�o da sprite
loadw(t1,horizontal_2b)				# posi��o em X
loadw(t2,vertical_2b)				# posi��o em Y
li t3, 320					
mul t3, t3, t2
frame_address(a3)
add a3, a3, t3
add a3, a3, t1					# a3 = endere�o inicial
mv a4, a3
li t1, 15680					# 320 x 50(altura da sprite)
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

##############################
# Pequenos movimentos parada #		 
##############################
anima_parada:
la s1, twob_stand				# s1 =  endere�o da imagem
get_largura_endereco(a1, a2, sprite_parada, larguras_parada, endereco_parada)	# a1 = largura da sprite, a2 = endere�o da sprite
loadw(t1,horizontal_2b)				# posi��o em X
loadw(t2,vertical_2b)				# posi��o em Y
addi t2, t2, -9
li t3, 320					
mul t3, t3, t2
frame_address(a3)
add a3, a3, t3
add a3, a3, t1					# a3 = endere�o inicial
mv a4, a3
li t1, 18000					# 320 x 59(altura da sprite)
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
mp_loop: 	
	bge a3,a4,mp_fora			# Se for o �ltimo endere�o ent�o sai do loop
		bne a6,a1, mp_continua		# Testa se A1 pixels foram pintados (1 linha)
			sub a3,a3,a1
			addi a3,a3,320		
			li a6,0			# Desce para a pr�xima linha
			li t4, 80
			sub t4, t4, a1
			add s1, s1, t4
		mp_continua:
		lb t0, 0(s1)			# Carrega o byte da sprite
		beq t0, a5, mp_pula		# Testa se o byte � da cor A5
			sb t0, 0(a3)		# Pinta o byte no endere�o do BitMap
		mp_pula:	
		addi a6,a6,1
		addi a3,a3,1 
		addi s1,s1,1
		j mp_loop			
	mp_fora:
	ret

####################
# Anima��o de pulo #		 
####################
anima_pulo_direita:
la s1, twob_jump_right				# s1 =  endere�o da imagem
get_largura_endereco(a1, a2, sprite_pulando, larguras_pulando_direita, endereco_pulando_direita)	# a1 = largura da sprite, a2 = endere�o da sprite
loadw(t1,horizontal_2b)				# posi��o em X
loadw(t2,vertical_2b)				# posi��o em Y
addi t2, t2, -7
li t3, 320					
mul t3, t3, t2
frame_address(a3)
add a3, a3, t3
add a3, a3, t1					# a3 = endere�o inicial
mv a4, a3
li t1, 18000					# 320 x 59(altura da sprite)
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
ap_loop: 	
	bge a3,a4,ap_fora			# Se for o �ltimo endere�o ent�o sai do loop
		bne a6,a1, ap_continua		# Testa se A1 pixels foram pintados (1 linha)
			sub a3,a3,a1
			addi a3,a3,320		
			li a6,0			# Desce para a pr�xima linha
			li t4, 351
			sub t4, t4, a1
			add s1, s1, t4
		ap_continua:
		lb t0, 0(s1)			# Carrega o byte da sprite
		beq t0, a5, ap_pula		# Testa se o byte � da cor A5
			sb t0, 0(a3)		# Pinta o byte no endere�o do BitMap
		ap_pula:	
		addi a6,a6,1
		addi a3,a3,1 
		addi s1,s1,1
		j ap_loop			
	ap_fora:
	ret

##################################
# Anima��o de pulo para esquerda #		 
##################################
anima_pulo_esquerda:
la s1, twob_jump_left				# s1 =  endere�o da imagem
get_largura_endereco(a1, a2, sprite_pulando, larguras_pulando_esquerda, endereco_pulando_esquerda)	# a1 = largura da sprite, a2 = endere�o da sprite
loadw(t1,horizontal_2b)				# posi��o em X
loadw(t2,vertical_2b)				# posi��o em Y
addi t2, t2, -7
li t3, 320					
mul t3, t3, t2
frame_address(a3)
add a3, a3, t3
add a3, a3, t1					# a3 = endere�o inicial
mv a4, a3
li t1, 18000					# 320 x 59(altura da sprite)
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
ape_loop: 	
	bge a3,a4,ape_fora			# Se for o �ltimo endere�o ent�o sai do loop
		bne a6,a1, ape_continua		# Testa se A1 pixels foram pintados (1 linha)
			sub a3,a3,a1
			addi a3,a3,320		
			li a6,0			# Desce para a pr�xima linha
			li t4, 351
			sub t4, t4, a1
			add s1, s1, t4
		ape_continua:
		lb t0, 0(s1)			# Carrega o byte da sprite
		beq t0, a5, ape_pula		# Testa se o byte � da cor A5
			sb t0, 0(a3)		# Pinta o byte no endere�o do BitMap
		ape_pula:	
		addi a6,a6,1
		addi a3,a3,1 
		addi s1,s1,1
		j ape_loop			
	ape_fora:
	ret
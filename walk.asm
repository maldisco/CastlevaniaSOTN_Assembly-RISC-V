.data

horizontal_2b:			.word 20
vertical_2b:			.word 160

antigo_horizontal_2b:		.word 20
antigo_vertical_2b:		.word 160

larguras_direita:		.word 44,34,42,39,39,43		# largura de cada sprite de corrida à direita
larguras_esquerda:		.word 43,39,39,42,34,44		# largura de cada sprite de corrida à direita
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
dict_pulo:			.word -10,-30,-50,-30,0,30,50,30,10

tempo_2b:			.word 0
velocidade_2b:			.word 0

ultima_inst:			.word 0

.text


animacao_2b:
	li a1, RIGHT		# carrega para a1 o código da tecla 'D'
	li a2, LEFT		# carrega para a2 o código da tecla 'A'
	li a3, UP		# carrega para a3 o código da tecla 'W'
	
	beq s0, a1, direita	# se for igual ao código da tecla 'D', anda para direita
	beq s0, a2, esquerda	# se for igual ao código da tecla 'A', anda para esquerd
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
	troca_tela()					# troca de frame (só na memória, não no bitmap)
	jal anima_parada				# animação parada
	atualiza_tela()					# troca de frame (no bitmap)
	jal apagar_antiga_posicao			# apaga a posição antiga
	jal att_tempo_2b
	loadw(t1, sprite_parada)
	addi t1, t1, 1					# incrementa 1 na sprite atual
	li t2, 3
	blt t1, t2, pnao_zera				# se sprite atual > 3(última), volta para 0
		li t1, 0
	pnao_zera:
	savew(t1, sprite_parada)				# salva nova sprite
	tail pl_recheca
	
direita:
	jal checa_tempo
	beqz a0, direita
	savew(s0, ultima_inst)
	jal att_tempo_2b	
	troca_tela()					# troca de frame (só na memória, não no bitmap)
				
	# ATUALIZA POSIÇÃO X DO PERSONAGEM (CHECANDO COLISÃO)	
	loadw(s9, horizontal_2b)			# adiciona 10 pixels (largura da sprite) -> desloca à direita
	addi s9, s9, 10					
	addi a0, s9, 40					# limite a ser testado (ponto mais à direita da sprite)
	jal checa_colisao_direita			# checa colisão (resultado em a1)
	beqz a1, d_colidiu
		savew(s9, horizontal_2b)
	d_colidiu:
	
	jal move_direita
	atualiza_tela()					# troca de frame (no bitmap)
	jal apagar_antiga_posicao			# apaga a posição antiga
	atribuir(horizontal_2b, antigo_horizontal_2b)			# atualiza posição antiga
	loadw(t1, sprite_movendo)				
	addi t1, t1, 1					# incrementa 1 na sprite atual
	li t2, 7	
	blt t1, t2, dnao_zera				# se sprite atual > 6(última), volta para 0
		li t1, 0
	dnao_zera:
	savew(t1, sprite_movendo)				# salva nova spri
	tail pl_recheca
	
esquerda:
	jal checa_tempo
	beqz a0, esquerda
	savew(s0, ultima_inst)
	jal att_tempo_2b
	troca_tela()					# troca de frame (só na memória, não no bitmap)
	
	# ATUALIZA POSIÇÃO X DO PERSONAGEM (CHECANDO COLISÃO)
	loadw(s9, horizontal_2b)			
	addi s9,s9,-10					# subtrai 10 pixels na posição atual (andar pra esquerda)
	mv a0, s9					# limite à esquerda a ser testado
	jal checa_colisao_esquerda			# checa colisão (resultado em a1)
	beqz a1, e_colidiu
		savew(s9, horizontal_2b)
	e_colidiu:
	
	jal move_esquerda
	atualiza_tela()					# troca de frame (no bitmap)
	jal apagar_antiga_posicao			# apaga a posição antiga
	atribuir(horizontal_2b, antigo_horizontal_2b)	# atualiza posição antiga
	loadw(t1, sprite_movendo)
	addi t1, t1, 1					# incrementa 1 na sprite atual
	li t2, 7
	blt t1, t2, anao_zera				# se sprite atual > 6(última), volta para 0
		li t1, 0
	anao_zera:
	savew(t1, sprite_movendo)				# salva nova sprite
	tail pl_recheca

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
	atribuir(vertical_2b, antigo_vertical_2b)
	loadw(t1, sprite_pulando)
	addi t1, t1, 1
	li t2, 9
	blt t1, t2, ppnao_zera
		li t1, 0
		savew(t1, sprite_pulando)
		tail poll_loop
	ppnao_zera:
	savew(t1, sprite_pulando)
	tail pula_parada

pula_direita:
	jal checa_tempo
	beqz a0, pula_direita
	jal att_tempo_2b
	troca_tela()
	funcao_pulo(s9)
	savew(s9, vertical_2b)
	
	# ATUALIZA POSIÇÃO X DO PERSONAGEM (CHECANDO COLISÃO)	
	loadw(s9, horizontal_2b)			# adiciona 10 pixels (largura da sprite) -> desloca à direita
	addi s9, s9, 15					
	addi a0, s9, 40					# limite a ser testado (ponto mais à direita da sprite)
	jal checa_colisao_direita			# checa colisão (resultado em a1)
	beqz a1, pd_colidiu
		savew(s9, horizontal_2b)
	pd_colidiu:
	
	jal anima_pulo_direita
	atualiza_tela()
	jal apagar_antiga_posicao
	atribuir(vertical_2b, antigo_vertical_2b)
	atribuir(horizontal_2b, antigo_horizontal_2b)
	loadw(t1, sprite_pulando)
	addi t1, t1, 1
	li t2, 9
	blt t1, t2, pdnao_zera
		li t1, 0
		savew(t1, sprite_pulando)
		tail poll_loop
	pdnao_zera:
	savew(t1, sprite_pulando)
	tail pula_direita
	
pula_esquerda:
	jal checa_tempo
	beqz a0, pula_esquerda
	jal att_tempo_2b
	troca_tela()
	funcao_pulo(s9)
	savew(s9, vertical_2b)
	
	# ATUALIZA POSIÇÃO X DO PERSONAGEM (CHECANDO COLISÃO)
	loadw(s9, horizontal_2b)			
	addi s9,s9,-15					# subtrai 10 pixels na posição atual (andar pra esquerda)
	mv a0, s9					# limite à esquerda a ser testado
	jal checa_colisao_esquerda			# checa colisão (resultado em a1)
	beqz a1, pe_colidiu
		savew(s9, horizontal_2b)
	pe_colidiu:
	
	jal anima_pulo_esquerda
	atualiza_tela()
	jal apagar_antiga_posicao
	atribuir(vertical_2b, antigo_vertical_2b)
	atribuir(horizontal_2b, antigo_horizontal_2b)
	loadw(t1, sprite_pulando)
	addi t1, t1, 1
	li t2, 9
	blt t1, t2, penao_zera
		li t1, 0
		savew(t1, sprite_pulando)
		tail poll_loop
	penao_zera:
	savew(t1, sprite_pulando)
	tail pula_esquerda
	

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
	li t2, 64
	bge t1, t2, ct_pode		# se for maior que 32 milissegundos, pode renderizar denovo
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

# Move a personagem à direita
move_direita:
la s1, twob_walk_right				# s1 =  endereço da imagem
get_largura_endereco(a1, a2, sprite_movendo, larguras_direita, endereco_direita)	# a1 = largura da sprite, a2 = endereço da sprite
loadw(t1,horizontal_2b)				# posição em X
loadw(t2,vertical_2b)				# posição em Y
li t3, 320					
mul t3, t3, t2
frame_address(a3)
add a3, a3, t3
add a3, a3, t1					# a3 = endereço inicial
mv a4, a3
li t1, 15680					# 319 x 50(altura da sprite)
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

# Move a personagem à esquerda
move_esquerda:
la s1, twob_walk_left				# s1 =  endereço da imagem
get_largura_endereco(a1, a2, sprite_movendo, larguras_esquerda, endereco_esquerda)	# a1 = largura da sprite, a2 = endereço da sprite
loadw(t1,horizontal_2b)				# posição em X
loadw(t2,vertical_2b)				# posição em Y
li t3, 320					
mul t3, t3, t2
frame_address(a3)
add a3, a3, t3
add a3, a3, t1					# a3 = endereço inicial
mv a4, a3
li t1, 15680					# 320 x 50(altura da sprite)
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

# Animação da personagem parada (pequenos movimentos)
anima_parada:
la s1, twob_stand				# s1 =  endereço da imagem
get_largura_endereco(a1, a2, sprite_parada, larguras_parada, endereco_parada)	# a1 = largura da sprite, a2 = endereço da sprite
loadw(t1,horizontal_2b)				# posição em X
loadw(t2,vertical_2b)				# posição em Y
addi t2, t2, -9
li t3, 320					
mul t3, t3, t2
frame_address(a3)
add a3, a3, t3
add a3, a3, t1					# a3 = endereço inicial
mv a4, a3
li t1, 18000					# 320 x 59(altura da sprite)
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

# Animação de pulo à direita da personagem
anima_pulo_direita:
la s1, twob_jump_right				# s1 =  endereço da imagem
get_largura_endereco(a1, a2, sprite_pulando, larguras_pulando_direita, endereco_pulando_direita)	# a1 = largura da sprite, a2 = endereço da sprite
loadw(t1,horizontal_2b)				# posição em X
loadw(t2,vertical_2b)				# posição em Y
addi t2, t2, -7
li t3, 320					
mul t3, t3, t2
frame_address(a3)
add a3, a3, t3
add a3, a3, t1					# a3 = endereço inicial
mv a4, a3
li t1, 18000					# 320 x 59(altura da sprite)
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
ap_loop: 	
	bge a3,a4,ap_fora			# Se for o último endereço então sai do loop
		bne a6,a1, ap_continua		# Testa se A1 pixels foram pintados (1 linha)
			sub a3,a3,a1
			addi a3,a3,320		
			li a6,0			# Desce para a próxima linha
			li t4, 351
			sub t4, t4, a1
			add s1, s1, t4
		ap_continua:
		lb t0, 0(s1)			# Carrega o byte da sprite
		beq t0, a5, ap_pula		# Testa se o byte é da cor A5
			sb t0, 0(a3)		# Pinta o byte no endereço do BitMap
		ap_pula:	
		addi a6,a6,1
		addi a3,a3,1 
		addi s1,s1,1
		j ap_loop			
	ap_fora:
	ret

# Animação de pulo à esquerda da personagem
anima_pulo_esquerda:
la s1, twob_jump_left				# s1 =  endereço da imagem
get_largura_endereco(a1, a2, sprite_pulando, larguras_pulando_esquerda, endereco_pulando_esquerda)	# a1 = largura da sprite, a2 = endereço da sprite
loadw(t1,horizontal_2b)				# posição em X
loadw(t2,vertical_2b)				# posição em Y
addi t2, t2, -7
li t3, 320					
mul t3, t3, t2
frame_address(a3)
add a3, a3, t3
add a3, a3, t1					# a3 = endereço inicial
mv a4, a3
li t1, 18000					# 320 x 59(altura da sprite)
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
ape_loop: 	
	bge a3,a4,ape_fora			# Se for o último endereço então sai do loop
		bne a6,a1, ape_continua		# Testa se A1 pixels foram pintados (1 linha)
			sub a3,a3,a1
			addi a3,a3,320		
			li a6,0			# Desce para a próxima linha
			li t4, 351
			sub t4, t4, a1
			add s1, s1, t4
		ape_continua:
		lb t0, 0(s1)			# Carrega o byte da sprite
		beq t0, a5, ape_pula		# Testa se o byte é da cor A5
			sb t0, 0(a3)		# Pinta o byte no endereço do BitMap
		ape_pula:	
		addi a6,a6,1
		addi a3,a3,1 
		addi s1,s1,1
		j ape_loop			
	ape_fora:
	ret

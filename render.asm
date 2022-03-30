#################################
# Loop imprime uma sprite 16x16 #		 
#################################
PS_LOOP: 	
	bge a1,a2,PS_FORA			# Se for o último endereço então sai do loop
		bne t1,a4, PS_CONTINUA		# Testa se A4 pixels foram pintados (1 linha)
			sub a1,a1,a4
			addi a1,a1,320		
			li t1,0			# Desce para a próxima linha
		PS_CONTINUA:
		lb t3, 0(s1)			# Carrega o byte da sprite
		beq t3, t2, PS_PULA		# Testa se o byte é da cor T3
			sb t3, 0(a1)		# Pinta o byte no endereço do BitMap
		PS_PULA:	
		addi t1,t1,1
		addi a1,a1,1 
		addi s1,s1,1
		j PS_LOOP			
	PS_FORA:
	ret
	
###################################
# Loop imprime andar para direita #		 
###################################
PWR: 	
	bge a1,a2,PWR_OUT			# Se for o último endereço então sai do loop
		bne t1,a4, PWR_KEEP		# Testa se A4 pixels foram pintados (1 linha)
			sub a1,a1,a4
			addi a1,a1,320		
			li t1,0			# Desce para a próxima linha
			li t4, 241
			sub t4, t4, a4
			add s1, s1, t4	# avança 241 pixels na sprite
		PWR_KEEP:
		lb t3, 0(s1)			# Carrega o byte da sprite
		beq t3, t2, PWR_JUMP		# Testa se o byte é da cor T3
			sb t3, 0(a1)		# Pinta o byte no endereço do BitMap
		PWR_JUMP:	
		addi t1,t1,1
		addi a1,a1,1 
		addi s1,s1,1
		j PWR			
	PWR_OUT:
	ret
	
##########################################
# Imprime algo em toda a frame (320x240) #
##########################################
IMPRIME:
	lw t4,0(s0)			# numero de colunas
	lw t5,4(s0)			# numero de linhas
	addi s0,s0,8			# primeiro pixels depois das informações de nlin ncol
	mul t1,t4,t5          	  	# numero total de pixels da imagem
	li t2,0
	I_LOOP1:
 	beq t1,t2,I_FIM			# Se for o último endereço então sai do loop
		lw t3,0(s0)		# le um conjunto de 4 pixels : word
		sw t3,0(t0)		# escreve a word na memória VGA
		addi t0,t0,4		# soma 4 ao endereço
		addi s0,s0,4
		addi t2,t2,1		# incrementa contador de bits
		j I_LOOP1		# volta a verificar
	I_FIM:	
	ret

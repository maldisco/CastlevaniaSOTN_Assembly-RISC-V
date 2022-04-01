##########################################
# Imprime algo em toda a frame (320x240) #
##########################################
# S0 = endere�o da imagem
IMPRIME:
	lw t4,0(s0)			# numero de colunas
	lw t5,4(s0)			# numero de linhas
	addi s0,s0,8			# primeiro pixels depois das informa��es de nlin ncol
	mul t1,t4,t5          	  	# numero total de pixels da imagem
	li t2,0
	I_LOOP1:
 	beq t1,t2,I_FIM			# Se for o �ltimo endere�o ent�o sai do loop
		lw t3,0(s0)		# le um conjunto de 4 pixels : word
		sw t3,0(t0)		# escreve a word na mem�ria VGA
		addi t0,t0,4		# soma 4 ao endere�o
		addi s0,s0,4
		addi t2,t2,1		# incrementa contador de bits
		j I_LOOP1		# volta a verificar
	I_FIM:	
	ret

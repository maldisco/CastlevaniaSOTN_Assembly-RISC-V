# Imprime algo em toda a frame (320x240) 
# s0 = endereço da imagem
IMPRIME:
	li t0, FRAME_0
	li t1, FRAME_1
	lw t2,0(s0)			# numero de colunas
	lw t3,4(s0)			# numero de linhas
	addi s0,s0,8			# primeiro pixels depois das informações de nlin ncol
	mul t4,t2,t3          	  	# numero total de pixels da imagem
	li t2,0
	I_LOOP:
 	beq t4,t2,I_FIM			# Se for o último endereço então sai do loop
		lw t3,0(s0)		# le um conjunto de 4 pixels : word
		sw t3,0(t0)		# escreve a word na memória VGA (frame 0)
		sw t3,0(t1)		# escreve a word na memória VGA (frame 1)
		addi t0,t0,4		# soma 4 ao endereço
		addi t1,t1,4
		addi s0,s0,4
		addi t2,t2,1		# incrementa contador de bits
		j I_LOOP		# volta a verificar
	I_FIM:	
	ret

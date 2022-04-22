# Captura e trata o evento de apertar uma tecla do teclado
ENTRADA:		lw t1, (s11)			# carrega para t1 o estado do teclado
			beqz t1, ENTRADA.RET	# se for igual a 0 (nada digitado), volta ao loop
			li s0, MMIO_add			# carrega para s0 o endere�o armazenando a tecla digitada
			lw s0, (s0)			# carrega para s0 a tecla digitada
	
			li t1, 'd'
			beq s0, t1, DIREITA		# checa se a tecla 'D' foi apertada
			
			li t1, 'a'
			beq s0, t1, ESQUERDA		# checa se a tecla 'A' foi apertada
			
			li t1, 'w'
			beq s0, t1, PULA		# checa se a tecla 'W' foi apertada
			
			li t1, 's'
			beq s0, t1, PARA		# checa se a tecla 'S' foi apertada
			
			li t1, 'z'
			beq s0, t1, SOCA
		
ENTRADA.RET:	ret
		
# Se a tecla 'S' foi apertada
# - Se pulando > 0
# - - nada
# - Sen�o
# - - Se moveX > 0
# - - - sentido = 1 (direita)
# - - Sen�o
# - - - sentido = -1 (esquerda)
# - - moveX = 0
PARA:			loadb(t1, pulando)
			bnez t1, NAO_PODE_PARAR	
			loadb(t1, moveX)
			li t2, 1
			bgtz t1, PARA.SENTIDO.DIREITA
			li t2, -1
PARA.SENTIDO.DIREITA:	li t1, 0
			saveb(t1, moveX)
			saveb(t2, sentido)
NAO_PODE_PARAR:		ret
		
		
# Se a tecla D foi apertada,
# - moveX = 9 (armazena 9 atualiza��es de movimenta��o a direita)
# - sentido = 1 (direita)
# - Se o personagem estiver parado
# - - Reseta anima��o para 0
DIREITA:		loadb(t1, moveX)
			bgtz 		t1, DIREITA.TURN
			
			loadb(t1, pulando)
			bnez 		t1, DIREITA.TURN
			
			loadb(t1, socando)
			bnez 		t1, DIREITA.TURN
			
			saveb(zero, sprite_frame_atual)
			
DIREITA.TURN:		li 		t1, 9
			saveb(t1, moveX)
			li 		t1, 1
			saveb(t1, sentido) 
			ret
		
# Se a tecla A foi apertada
# - moveX = -9 (armazena 9 atualiza��es de movimenta��o a esquerda)
# - sentido = -1 (esquerda)
# - Se o personagem estiver parado
# - - Reseta anima��o para 0
ESQUERDA:		loadb(t1, moveX)
			bltz 		t1, ESQUERDA.TURN
			
			loadb(t1, pulando)
			bnez 		t1, ESQUERDA.TURN
			
			loadb(t1, socando)
			bnez 		t1, ESQUERDA.TURN
			
			saveb(zero, sprite_frame_atual)
			
ESQUERDA.TURN:		li 		t1, -9
			saveb(t1, moveX)
			li		 t1, -1
			saveb(t1, sentido)
			ret
		
# Se a tecla W foi apertada
# - Se pulando < 2
# - - pulando += 1
# - - velocidadeY = -6 (subindo)
# - Sen�o
# - - nada
PULA:			loadb(t1, pulando)
			li 		t2, 2
			bge 		t1, t2, PULA_DIREITA	
			addi 		t1, t1, 1
			saveb(t1, pulando)
			saveb(zero, sprite_frame_atual) 	
			li 		t1, -6		
			fcvt.s.w 	ft1, t1			
			la 		t2, velocidadeY_luffy
			fsw 		ft1, (t2)
PULA_DIREITA:		ret
	
# Se a tecla Z foi apertada
# - Se socando > 0
# - - nada
# - Sen�o
# - - socando = 1	
SOCA:			loadb(t1, socando)
			bnez 		t1, JA_ESTA_SOCANDO
			saveb(zero, sprite_frame_atual) 
			li		t1, 1
			saveb(t1, socando)
JA_ESTA_SOCANDO:	ret

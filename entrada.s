# Captura e trata o evento de apertar uma tecla do teclado
ENTRADA:		li		s11, MMIO_set
			lw 		t1, (s11)			# carrega para t1 o estado do teclado
			beqz 		t1, ENTRADA.RET	# se for igual a 0 (nada digitado), volta ao loop
			li 		t0, MMIO_add			# carrega para t0 o endereço armazenando a tecla digitada
			lw 		t0, (t0)			# carrega para t0 a tecla digitada
	
			li 		t1, 'd'
			beq 		t0, t1, DIREITA		# checa se a tecla 'D' foi apertada
			
			li 		t1, 'a'
			beq 		t0, t1, ESQUERDA		# checa se a tecla 'A' foi apertada
			
			li 		t1, 'w'
			beq 		t0, t1, PULA		# checa se a tecla 'W' foi apertada
			
			li		t1, 's'
			beq 		t0, t1, PARA		# checa se a tecla 'S' foi apertada
			
			li 		t1, 'z'
			beq 		t0, t1, SOCA
		
ENTRADA.RET:		ret
		
# Se a tecla 'S' foi apertada
# - Se pulando > 0
# - - nada
# - Senão
# - - Se moveX > 0
# - - - sentido = 1 (direita)
# - - Senão
# - - - sentido = -1 (esquerda)
# - - moveX = 0
PARA:			loadb(t1, pulando)
			bnez 		t1, NAO_PODE_PARAR	
			loadb(t1, moveX)
			li 		t1, 0
			saveb(t1, moveX)
NAO_PODE_PARAR:		ret
		
		
# Se a tecla D foi apertada,
# - moveX = 14 (armazena 14 atualizações de movimentação a direita)
# - sentido = 1 (direita)
# - Se o personagem estiver parado
# - - Reseta animação para 0
DIREITA:		loadb(t1, moveX)
			bgtz 		t1, DIREITA.TURN
			
			loadb(t1, pulando)
			bnez 		t1, DIREITA.TURN
			
			loadb(t1, socando)
			bnez 		t1, DIREITA.TURN
			
			saveb(zero, alucard.animacao)
			
DIREITA.TURN:		li 		t1, 16
			saveb(t1, moveX)
			li 		t1, 1
			saveb(t1, sentido) 
			ret
		
# Se a tecla A foi apertada
# - moveX = -14 (armazena 14 atualizações de movimentação a esquerda)
# - sentido = -1 (esquerda)
# - Se o personagem estiver parado
# - - Reseta animação para 0
ESQUERDA:		loadb(t1, moveX)
			bltz 		t1, ESQUERDA.TURN
			
			loadb(t1, pulando)
			bnez 		t1, ESQUERDA.TURN
			
			loadb(t1, socando)
			bnez 		t1, ESQUERDA.TURN
			
			saveb(zero, alucard.animacao)
			
ESQUERDA.TURN:		li 		t1, -16
			saveb(t1, moveX)
			li		 t1, -1
			saveb(t1, sentido)
			ret
		
# Se a tecla W foi apertada
# - Se pulando  == 0
# - - pulando = 1
# - - velocidadeY = -6.5 (subindo)
# - Senão
# - - nada
PULA:			la		t0, pulando
			lb 		t1, (t0)
			bgtz 		t1, NAO_PULA	
			
			li		t1, 1
			sb		t1, (t0)
			saveb(zero, alucard.animacao) 	
			la		t1, SALTO
			flw		ft0, (t1)		
			fmv.s		fs2, ft0
NAO_PULA:		ret
	
# Se a tecla Z foi apertada
# - Se socando > 0
# - - nada
# - Senão
# - - socando = 1	
SOCA:			loadb(t1, socando)
			bnez 		t1, JA_ESTA_SOCANDO
			
			addi		sp, sp, -4
			sw		ra, (sp)
			jal		OST.SLASH
			lw		ra, (sp)
			addi		sp, sp, 4
			
			saveb(zero, alucard.animacao) 
			li		t1, 1
			saveb(t1, socando)
JA_ESTA_SOCANDO:	ret

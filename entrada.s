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
			
			li		t1, 'x'
			beq		t0, t1, ARREMESSA
		
ENTRADA.RET:		ret
		
# Se a tecla 'S' foi apertada
# - Se pulando > 0
# - - nada
# - Senão
# - - moveX = 0
PARA:			fcvt.w.s	t1, fa2
			bnez 		t1, ENTRADA.RET	
			fcvt.s.w	fs3, zero		# Fs3 = move X
			ret
		
		
# Se a tecla D foi apertada,
# - moveX = 14 (armazena 14 atualizações de movimentação a direita)
# - sentido = 1 (direita)
# - Se o personagem estiver parado
# - - Reseta animação para 0
DIREITA:		fcvt.w.s	t1, fs3			# Fs3 = move X
			bgtz 		t1, DIREITA.TURN
			
			fcvt.s.w	ft11, zero
			
DIREITA.TURN:		li 		t1, 16
			fcvt.s.w	fs3, t1
			li 		t1, 1
			fcvt.s.w	fa4, t1	
			ret
		
# Se a tecla A foi apertada
# - moveX = -14 (armazena 14 atualizações de movimentação a esquerda)
# - sentido = -1 (esquerda)
# - Se o personagem estiver parado
# - - Reseta animação para 0
ESQUERDA:		fcvt.w.s	t1, fs3	
			bltz 		t1, ESQUERDA.TURN
						
			fcvt.s.w	ft11, zero
			
ESQUERDA.TURN:		li 		t1, -16
			fcvt.s.w	fs3, t1
			li		t1, -1
			fcvt.s.w	fa4, t1	
			ret
		
# Se a tecla W foi apertada
# - Se pulando  == 0
# - - pulando = 1
# - - velocidadeY = -6.5 (subindo)
# - Senão
# - - nada
PULA:			fcvt.w.s	t1, fa2
			bgtz 		t1, ENTRADA.RET	
			
			li		t1, 1
			fcvt.s.w	fa2, t1
			fcvt.s.w	ft11, zero			
			fmv.s		fs2, fs5
			ret
	
# Se a tecla Z foi apertada
# - Se socando > 0
# - - nada
# - Senão
# - - socando = 1	
SOCA:			fcvt.w.s	t1, fa1
			bnez 		t1, ENTRADA.RET
			
			addi		sp, sp, -4
			sw		ra, (sp)
			jal		OST.SLASH
			lw		ra, (sp)
			addi		sp, sp, 4
			
			fcvt.s.w	ft11, zero
			li		t1, 1
			fcvt.s.w	fa1, t1
			ret

# Se a tecla X foi apertada
# - Se faca.habilitada = 1
# - - faca.arremessa = 1 (animação do personagem)
# - - faca.renderiza = 1 (animação da faca)
# - Senão
# - - nada
ARREMESSA:		fcvt.w.s	t1, fa6	
			beqz		t1, ENTRADA.RET
			
			fcvt.w.s	t1, fa3
			bnez		t1, ENTRADA.RET
			
			fcvt.w.s	t1, fa5
			bnez		t1, ENTRADA.RET
			
			li		t1, 1
			fcvt.s.w	fa3, t1
			fcvt.s.w	fa5, t1
			
			fcvt.s.w	ft11, zero
			
			addi		t2, s6, 58
			fcvt.s.w	fs6, t2					# fs6 = Posição X da faca
			
			fcvt.w.s	t1, fa4					# fa4 = Sentido do personagem
			bgez		t1, ARREMESA.DIREITA
			
			fcvt.s.w	fs6, s6

ARREMESA.DIREITA:	addi		t2, s5, 27
			fcvt.s.w	fs7, t2					# fs7 = Posição Y da faca
			
			fcvt.s.w	fs3, zero				# fs3 = move X
			
			ret
			

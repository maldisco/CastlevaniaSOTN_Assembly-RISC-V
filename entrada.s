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
			fcvt.s.w	ft0, zero
			fmv.s		fs3, ft0		# Fs3 = move X
			ret
		
		
# Se a tecla D foi apertada,
# - moveX = 14 (armazena 14 atualizações de movimentação a direita)
# - sentido = 1 (direita)
# - Se o personagem estiver parado
# - - Reseta animação para 0
DIREITA:		fcvt.w.s	t1, fs3			# Fs3 = move X
			bgtz 		t1, DIREITA.TURN
			
			saveb(zero, alucard.animacao)
			
DIREITA.TURN:		li 		t1, 16
			fcvt.s.w	fs3, t1
			li 		t1, 1
			saveb(t1, sentido) 
			ret
		
# Se a tecla A foi apertada
# - moveX = -14 (armazena 14 atualizações de movimentação a esquerda)
# - sentido = -1 (esquerda)
# - Se o personagem estiver parado
# - - Reseta animação para 0
ESQUERDA:		fcvt.w.s	t1, fs3	
			bltz 		t1, ESQUERDA.TURN
						
			saveb(zero, alucard.animacao)
			
ESQUERDA.TURN:		li 		t1, -16
			fcvt.s.w	fs3, t1
			li		 t1, -1
			saveb(t1, sentido)
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
			saveb(zero, alucard.animacao) 			
			fmv.s		fs2, fs5
			ret
	
# Se a tecla Z foi apertada
# - Se socando > 0
# - - nada
# - Senão
# - - socando = 1	
SOCA:			loadb(t1, socando)
			bnez 		t1, ENTRADA.RET
			
			addi		sp, sp, -4
			sw		ra, (sp)
			jal		OST.SLASH
			lw		ra, (sp)
			addi		sp, sp, 4
			
			saveb(zero, alucard.animacao) 
			li		t1, 1
			saveb(t1, socando)
			ret

# Se a tecla X foi apertada
# - Se faca.habilitada = 1
# - - faca.arremessa = 1 (animação do personagem)
# - - faca.renderiza = 1 (animação da faca)
# - Senão
# - - nada
ARREMESSA:		la		t0, faca.habilitada
			lb		t1, (t0)
			beqz		t1, ENTRADA.RET
			
			la		t2, faca.arremessa
			lb		t1, (t2)
			bnez		t1, ENTRADA.RET
			
			la		t3, faca.renderiza
			lb		t1, (t3)
			bnez		t1, ENTRADA.RET
			
			li		t1, 1
			sb		t1, (t2)
			sb		t1, (t3)
			
			la		t0, alucard.animacao
			sb		zero, (t0)
			
			addi		t2, s6, 58
			fcvt.s.w	fs6, t2					# fs6 = Posição X da faca
			
			la		t0, sentido
			lb		t1, (t0)
			bgez		t1, ARREMESA.DIREITA
			
			fcvt.s.w	fs6, s6

ARREMESA.DIREITA:	addi		t2, s5, 27
			fcvt.s.w	fs7, t2					# fs7 = Posição Y da faca
			
			fcvt.s.w	fs3, zero				# fs3 = move X
			
			ret
			

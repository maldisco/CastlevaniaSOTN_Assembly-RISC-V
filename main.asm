.data

.include "macros.asm"
.text
	
	li s11, MMIO_set	# carrega para s11 o endere�o a armazenar o estado do teclado
POLL_LOOP:			# in�cio do loop de polling
	li a1, RIGHT		# carrega para a1 o c�digo da tecla 'D'
	li a2, LEFT		# carrega para a2 o c�digo da tecla 'A'
	lw t1, (s11)		# carrega para t1 o estado do teclado
	beqz t1, POLL_LOOP	# se for igual a 0 (nada digitado), volta ao loop
	li s0, MMIO_add		# carrega para s0 o endere�o a armazenar a tecla digitada
	lw s0, (s0)		# carrega para s0 a tecla digitada
	beq s0, a1, DIREITA	# se for igual ao c�digo da tecla 'D', anda para direita
	beq s0, a2, ESQUERDA	# se for igual ao c�digo da tecla 'A', anda para esquerd
	j POLL_LOOP
DIREITA:
	loadw(t2, TWOB_POSX)	# carrega para t2 a posi��o atual do personagem em X
	addi t2, t2, 10		# adiciona 10 pixels (largura da sprite) -> desloca � direita
	savew(t2, TWOB_POSX)	# salva o novo valor de posi��o do personagem
	render_sprite(twob_stand, TWOB_POSX, TWOB_POSY)	# renderiza o personagem
	j POLL_LOOP		# volta ao loop
ESQUERDA:
	loadw(t2, TWOB_POSX)	# carrega para t2 a posi��o atual do personagem em X
	addi t2, t2, -10	# subtrai 10 pixels -> desloca � esquerda
	savew(t2, TWOB_POSX)	# salva o novo valor de posi��o
	render_sprite(twob_stand, TWOB_POSX, TWOB_POSY)	# renderiza o personagem
	j POLL_LOOP		# volta ao loop
	
	li a7, 10
	ecall
	
.include "render.asm"

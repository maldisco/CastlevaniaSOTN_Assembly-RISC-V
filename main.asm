.data

.include "macros.asm"
.text
	li s11, MMIO_set
	jal att_tempo_2b
	call config_tela_1
		

poll_loop:			# in�cio do loop de polling
	savew(zero, sprite_movendo)
	tail parada
	pl_recheca:
	
	# futuras a��es
	
	lw t1, (s11)		# carrega para t1 o estado do teclado
	beqz t1, poll_loop	# se for igual a 0 (nada digitado), volta ao loop
	li s0, MMIO_add		# carrega para s0 o endere�o a armazenar a tecla digitada
	lw s0, (s0)		# carrega para s0 a tecla digitada
	j animacao_2b
				

	
.include "game.asm"	
.include "render.asm"
.include "walk.asm"

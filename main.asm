.data

.include "macros.asm"
.text
	la s0, tela_1
	jal IMPRIME
	li s11, MMIO_set
	jal att_tempo_2b	

poll_loop:			# início do loop de polling
	savew(zero, sprite_movendo)
	jal s10, parada
	pl_recheca:
	
	# futuras ações
	
	lw t1, (s11)		# carrega para t1 o estado do teclado
	beqz t1, poll_loop	# se for igual a 0 (nada digitado), volta ao loop
	li s0, MMIO_add		# carrega para s0 o endereço a armazenar a tecla digitada
	lw s0, (s0)		# carrega para s0 a tecla digitada
	j animacao_2b
				

	
.include "render.asm"
.include "walk.asm"

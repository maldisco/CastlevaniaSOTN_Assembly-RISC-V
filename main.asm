.data

.include "macros.asm"
.text
	
	li s11, MMIO_set	# carrega para s11 o endereço a armazenar o estado do teclado
POLL_LOOP:			# início do loop de polling
	lw t1, (s11)		# carrega para t1 o estado do teclado
	beqz t1, POLL_LOOP	# se for igual a 0 (nada digitado), volta ao loop
	li s0, MMIO_add		# carrega para s0 o endereço a armazenar a tecla digitada
	lw s0, (s0)		# carrega para s0 a tecla digitada
	jal TWOB_WALK
	
	li a7, 10
	ecall
	
.include "render.asm"
.include "walk.asm"

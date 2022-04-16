.data

.include "macros.asm"
.text
	carrega_sprites()
	configuracoes_iniciais()
	li s11, MMIO_set
	jal att_tempo_2b
	call config_tela_1
		

poll_loop:			# início do loop de polling
	call checa_tempo
	beqz a0, nao_atualiza
		call atualiza_posicao_2b
	nao_atualiza:
	# futuras ações	
	lw t1, (s11)		# carrega para t1 o estado do teclado
	beqz t1, poll_loop	# se for igual a 0 (nada digitado), volta ao loop
	li s0, MMIO_add		# carrega para s0 o endereço a armazenar a tecla digitada
	lw s0, (s0)		# carrega para s0 a tecla digitada
	call acoes_2b
				

	
.include "game.asm"	
.include "render.asm"
.include "walk.asm"

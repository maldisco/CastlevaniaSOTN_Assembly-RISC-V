.data

.include "macros.asm"
.text
	# Carrega arquivo de sprites do personagem principal 
	la a0, luffy
	li a1, 0
	li a2, 0
	li a7, 1024
	ecall
	mv s10, a0 # Salva em s10 
	
	la a0, mapa
	li a1, 0
	li a2, 0
	li a7, 1024
	ecall
	mv s9, a0
	
	li s11, MMIO_set
	jal att_tempo_luffy
	call OST.SETUP
	call config_tela_1	
			
	# ===================== NÃO DEVE MUDAR ===============================
	# SYMPHONY OF THE KNIGHT
	# S11 = MMIO_set
	# S10 = Descritor do arquivo de sprites do Luffy
	# S9 = Descritor do arquivo do mapa	
poll_loop:			# início do loop de polling
	call checa_tempo
	beqz a0, nao_atualiza
		#call OST.TOCA
		troca_tela()
		call MAPA.ATUALIZA
		call LUFFY.ATUALIZA
	nao_atualiza:
	lw t1, (s11)		# carrega para t1 o estado do teclado
	beqz t1, poll_loop	# se for igual a 0 (nada digitado), volta ao loop
	li s0, MMIO_add		# carrega para s0 o endereço a armazenar a tecla digitada
	lw s0, (s0)		# carrega para s0 a tecla digitada
	call LUFFY.INPUT
	j poll_loop
				

	
.include "game.asm"	
.include "render.asm"
.include "walk.asm"
.include "common.s"
.include "ost.s"

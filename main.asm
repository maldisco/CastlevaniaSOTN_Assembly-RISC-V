.data
.include "config.s"
.include "macros.asm"
.text
	# Carrega arquivo de sprites do personagem principal 
		la 		a0, luffy
		li 		a1, 0
		li 		a2, 0
		li 		a7, 1024
		ecall
		mv 		s10, a0 		# Salva em s10 
		
		la 		a0, tela1
		li		a1, 0
		li		a2, 0
		li 		a7, 1024
		ecall
		mv 		s9, a0
		
		li 		s11, MMIO_set
		csrr 		s7, 3073			# Guarda tempo atual em s7 (usado para controle de FPS)
		jal		OST.SETUP
		jal 		config_tela_1	
			
		# ===================== NÃO DEVE MUDAR ===============================
		# S11 = MMIO_set
		# S10 = Descritor do arquivo de sprites do Luffy
		# S9 = Descritor do arquivo do mapa	
		# S7 = Tempo da ultima atualizacao de tela
poll_loop:			# início do loop de polling
		csrr 		t0, 3073
		sub 		t0, t0, s7
		li 		t1, 32
		bltu 		t0, t1, nao_atualiza
		#call OST.TOCA
		troca_tela()
		jal 		ENTRADA			# Trata o input do teclado
		jal		MAPA.ATUALIZA
		jal		LUFFY.ATUALIZA
		csrr 		s7, 3073 			# Atualiza o tempo atual
nao_atualiza:
		j		poll_loop
				


.include "entrada.s"
.include "game.asm"	
.include "render.asm"
.include "walk.asm"
.include "common.s"
.include "ost.s"

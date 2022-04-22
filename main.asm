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
		
		# Carrega o arquivo da primeira tela do jogo
		la 		a0, tela1
		li		a1, 0
		li		a2, 0
		li 		a7, 1024
		ecall
		mv 		s8, a0			# Salva em s9
		
		# Carrega o arquivo da segunda tela do jogo
		la		a0, tela2
		li		a1, 0
		li		a2, 0
		li		a7, 1024
		ecall
		mv		s7, a0			# Salva em s8
		
		
		csrr 		s11, 3073			# Guarda tempo atual em s7 (usado para controle de FPS)
		jal		OST.SETUP
		jal 		config_tela_1	
			
		# ===================== NÃO DEVE MUDAR ===============================
		# S11 = Tempo da ultima atualizacao de tela
		# S10 = Descritor do arquivo de sprites do Luffy
		# S9 = Descritor do arquivo da tela atual
		# S8 = Descritor do arquivo da tela 1
		# S7 = Descritor do arquivo da tela 2
		
poll_loop:	# início do loop de polling
		csrr 		t0, 3073
		sub 		t0, t0, s11
		li 		t1, 32
		bltu 		t0, t1, nao_atualiza
		#call OST.TOCA
		troca_tela()
		jal 		ENTRADA			# Trata o input do teclado
		jal		MAPA.ATUALIZA
		jal		LUFFY.ATUALIZA
		csrr 		s11, 3073 			# Atualiza o tempo atual
nao_atualiza:
		j		poll_loop
				


.include "entrada.s"
.include "game.asm"
.include "walk.asm"
.include "fisica.s"
.include "render.s"
.include "common.s"
.include "ost.s"

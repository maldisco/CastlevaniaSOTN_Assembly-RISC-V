# D1
DIALOGO_1.START:	# Guarda o endereço de retorno
			addi 		sp, sp, -4
			sw		ra, (sp)	
			
			# Carrega o arquivo do diálogo
			la		a0, dialogo1
			li		a1, 0
			li		a2, 0
			li		a7, 1024
			ecall
			
			li		a6, 0			# Offset na imagem do dialogo
			li		t2, 4			# Numero de caixas de dialogo
			li		t6, 0			# Contador de frames
			li		t4, 0			# Offset na tela
			
D1.LOOP:		li		a1, 20			# X na VGA
			li 		a2, 140			# Y na VGA
			li		a3, 1120		# Largura da imagem
			li 		a4, 280	
			li 		a7, 79
			mv		a6, t4		
			frame_address(a5)
			jal		RENDER		

			# Para a execução enquanto o usuário não apertar nada
D1.POLL_LOOP:		li		t0, MMIO_set
			lw 		t1, (t0)		# carrega para t1 o estado do teclado
			beqz 		t1, D1.POLL_LOOP	# se for igual a 0 (nada digitado), volta ao loop
			li 		t0, MMIO_add   		# carrega para t0 o endereço armazenando a tecla digitada
			lw 		t0, (t0)		# carrega para t0 a tecla digitada
			
			
			
			addi		t6, t6, 1
			addi		t4, t4, 280
			blt		t6, t2, D1.LOOP		# Se ainda não terminou o diálogo, volta pro loop
			
			lw		ra, (sp)
			addi		sp, sp, 4
			ret

# D2
DIALOGO_2.START:	# Guarda o endereço de retorno
			addi 		sp, sp, -4
			sw		ra, (sp)	
			
			# Carrega o arquivo do diálogo
			la		a0, dialogo2
			li		a1, 0
			li		a2, 0
			li		a7, 1024
			ecall
			
			li		a6, 0			# Offset na imagem do dialogo
			li		t2, 2			# Numero de caixas de dialogo
			li		t6, 0			# Contador de frames
			li		t4, 0			# Offset na tela
			
D2.LOOP:		li		a1, 20			# X na VGA
			li 		a2, 140			# Y na VGA
			li		a3, 560			# Largura da imagem
			li 		a4, 280	
			li 		a7, 79
			mv		a6, t4		
			frame_address(a5)
			jal		RENDER		

			# Para a execução enquanto o usuário não apertar nada
D2.POLL_LOOP:		li		t0, MMIO_set
			lw 		t1, (t0)		# carrega para t1 o estado do teclado
			beqz 		t1, D2.POLL_LOOP	# se for igual a 0 (nada digitado), volta ao loop
			li 		t0, MMIO_add   		# carrega para t0 o endereço armazenando a tecla digitada
			lw 		t0, (t0)		# carrega para t0 a tecla digitada
			
			
			
			addi		t6, t6, 1
			addi		t4, t4, 280
			blt		t6, t2, D2.LOOP		# Se ainda não terminou o diálogo, volta pro loop
			
			lw		ra, (sp)
			addi		sp, sp, 4
			ret

# Morte
GAME_OVER:		li 		t0,FRAME_SELECT
			sw 		s0,(t0)

			# Carrega o arquivo de game over
			la		a0, morte
			li		a1, 0
			li		a2, 0
			li		a7, 1024
			ecall

			li		a6, 0			# Offset na imagem do dialogo
			li		t2, 5			# Numero de caixas de dialogo
			li		t6, 0			# Contador de frames
			li		t4, 0			# Offset na tela
			
GO.LOOP:		li		a1, 0			# X na VGA
			li 		a2, 0			# Y na VGA
			li		a3, 1600		# Largura da imagem
			li 		a4, 320	
			li 		a7, 239
			mv		a6, t4		
			frame_address(a5)
			jal		RENDER		
			
			
			addi		t6, t6, 1
			addi		t4, t4, 320
			
			mv		t0, a0
			
			li		a0, 1000
			li		a7, 32
			ecall
			
			mv		a0, t0
			
			blt		t6, t2, GO.LOOP		# Se ainda não terminou o game over, volta pro loop
			
			j		CASTLEVANIA
			
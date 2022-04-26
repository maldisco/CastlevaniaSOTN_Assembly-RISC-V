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
			li		t3, 0			# Contador de frames
			li		t4, 0			# Offset na tela
			
D1.LOOP:		li		a1, 20			# X na VGA
			li 		a2, 140			# Y na VGA
			li		a3, 1120		# Largura da imagem
			li 		a4, 280	
			li 		a7, 79
			mv		a6, t4		
			xori 		s0, s0, 1		# S7 = Frame atual
			frame_address(a5)
			jal		RENDER
			li 		t0,FRAME_SELECT	
			sw 		s0,(t0)			

			# Para a execução enquanto o usuário não apertar nada
D1.POLL_LOOP:		li		t0, MMIO_set
			lw 		t1, (t0)		# carrega para t1 o estado do teclado
			beqz 		t1, D1.POLL_LOOP	# se for igual a 0 (nada digitado), volta ao loop
			li 		t0, MMIO_add   		# carrega para t0 o endereço armazenando a tecla digitada
			lw 		t0, (t0)		# carrega para t0 a tecla digitada
			
			
			
			addi		t3, t3, 1
			addi		t4, t4, 280
			blt		t3, t3, D1.LOOP		# Se ainda não terminou o diálogo, volta pro loop
			
			lw		ra, (sp)
			addi		sp, sp, 4
			ret

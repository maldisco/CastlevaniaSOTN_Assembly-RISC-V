# Param a0 = Descritor
# Param a1 = X na VGA
# Param a2 = Y na VGA
# Param a3 = Largura da imagem
# Param a4 = Largura da sprite
# Param a5 = Endereço da frame
# Param a6 = Offset na imagem
# Param a7 = Altura da sprite
RENDER:			# Calculo do endereço na VGA
			li 		t3, 320
			mul 		t3, t3, a2			# Y do personagem x 320 (Altura inicial)
			add 		t3, t3, a1
			add 		a5, a5, t3			# a5 = Endereço inicial = Frame 0/1 + horizontal + 320 x vertical
	
			# Calculo do endereço final na VGA
			li		t1, 320
			mul		t1, t1, a7
			add 		t1, t1, a4
			add 		t1, a5, t1
		
# a0 = Descritor
# a6 = Offset na imagem
# a5 = Offset na tela
# t1 = Endereço final na tela	
RENDER.LOOP: 		# Salva o descritor
			mv 		t5, a0
		
			# Chega à posição definida pelo offset na imagem
			li 		a7, 62
			mv		a1, a6			# a6 = offset na imagem
			li 		a2, 0
			ecall
				
			# Restaura a0
			mv		a0, t5
		
			# Transfere os bytes de uma linha do arquivo para a memóeria VGA
			li 		a7, 63
			mv 		a1, a5			# a5 = Endereço na VGA
			mv 		a2, a4			# a4 = Quantidade de bytes em uma linha
			ecall					# Escreve uma linha
				
			# Restaura a0
			mv 		a0, t5
		
			# Incrementar offset imagem (pular linha)
			add 		a6, a6, a3 
				
			# Incrementa offset VGA (pular linha)
			addi 		a5, a5, 320
		
			# a5 = Endereço atual na VGA
			# t1 = Endereço final na VGA
			bltu		a5, t1, RENDER.LOOP
			ret
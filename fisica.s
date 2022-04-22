# Checa colisão à direita do personagem
# Return a0, 1 = Colidiu
COLISAO.DIREITA:	# Calcula coordenadas inicais da hitbox do persongem
			la 		t1, mapa.x
			lh 		t1, (t1)
			la 		t2, mapa.y
			lh 		t2, (t2)
			la 		t3, horizontal_luffy
			lw 		t3, (t3)
			li 		t4, LUFFY.HITBOX_OFFSET.X
			add 		t3, t3, t4
			addi 		t3, t3, 2
			la 		t4, vertical_luffy
			lw 		t4, (t4)
			li 		t5, LUFFY.HITBOX_OFFSET.Y
			add 		t4, t4, t5
	
			add 		t1, t1, t3			 # X do personagem relativo ao mapa
			add 		t2, t2, t4			 # Y do personagem relativo ao mapa
			
			la 		t0, mapa_hitbox			
			lw		t3, 0(t0)			# Endereço do mapa de hitboxes da tela atual
	 
			la		t0, mapa.hitbox.largura
			lhu		t4, 0(t0)
			mul 		t4, t4, t2
			add 		t4, t4, t1			# t4 = Primeiro pixel do personagem no mapa de hitboxes
			
			li 		t5, LUFFY.HITBOX.LARGURA
			add 		t4, t4, t5			# t4 = Primeiro pixel a direita do personagem
			
			li 		t5, LUFFY.HITBOX.ALTURA
			addi 		t5, t5, -10			# Sobe um pouco pra não testar no pé
			
			li 		t6, 0
			
CD.LOOP:		add 		t1, t4, t3
			lb 		t2, 0(t1)
			bnez 		t2, CD.NEGATIVO
			
	 		li 		a0, 1
	 		ret
	 		
CD.NEGATIVO:		addi		t6, t6, 1
		 	la		t0, mapa.hitbox.largura
			lhu		t1, 0(t0)
		 	add 		t4, t4, t1
		 	blt 		t6, t5, CD.LOOP
		 	
CD.FIM:			li 		a0, 0
			ret

# Checa colisão à esquerda do personagem
# Return a0, 1 = Colidiu
COLISAO.ESQUERDA:	# Calcula coordenadas inicais da hitbox do persongem
			la 		t1, mapa.x
			lh 		t1, (t1)
			la 		t2, mapa.y
			lh 		t2, (t2)
			la 		t3, horizontal_luffy
			lw		t3, (t3)
			li 		t4, LUFFY.HITBOX_OFFSET.X
			add 		t3, t3, t4
			addi 		t3, t3, -2
			la 		t4, vertical_luffy
			lw 		t4, (t4)
			li 		t5, LUFFY.HITBOX_OFFSET.Y
			add 		t4, t4, t5
			
			add 		t1, t1, t3			 # X do personagem relativo ao mapa
			add 		t2, t2, t4			 # Y do personagem relativo ao mapa
	
			la 		t0, mapa_hitbox			
			lw		t3, 0(t0)			# Endereço do mapa de hitboxes da tela atual
	 
			la		t0, mapa.hitbox.largura
			lhu		t4, 0(t0)
			mul 		t4, t4, t2
			add 		t4, t4, t1			# t4 = Endereço do primeiro pixel do personagem 
			
			li		t5, LUFFY.HITBOX.ALTURA
			addi 		t5, t5, -5
			
			li 		t6, 0
			
CE.LOOP:		add		t1, t4, t3
			lb		t2, 0(t1)
			bnez 		t2, CE.NEGATIVO
			
	 		li 		a0, 1
	 		ret
	 		
CE.NEGATIVO:		addi 		t6, t6, 1
		 	la		t0, mapa.hitbox.largura
			lhu		t1, 0(t0)
		 	add 		t4, t4, t1
		 	blt		t6, t5, CE.LOOP
CE.FIM:
			li 		a0, 0
		 	ret

# Checa colisão abaixo do personagem
# Return a0, 1 = Colidiu
COLISAO.BAIXO:		# Calcula coordenadas inicais da hitbox do persongem
			la 		t1, mapa.x
			lh 		t1, (t1)
			la 		t2, mapa.y
			lh 		t2, (t2)
			la 		t3, horizontal_luffy
			lw 		t3, (t3)
			li		t4, LUFFY.HITBOX_OFFSET.X
			add 		t3, t3, t4
			la 		t4, vertical_luffy
			lw 		t4, (t4)
			li		t5, LUFFY.HITBOX_OFFSET.Y
			add 		t4, t4, t5
			addi 		t4, t4, 3				
	
			# 11 = mapa.x + horizontal_char + char.hitbox_offset.x = X do personagem relativo ao mapa
			add 		t1, t1, t3			
			# t2 = mapa.y + vertical_char + char.hitbox_offset.y = Y do personagem relativo ao mapa
			add 		t2, t2, t4
	
			la 		t0, mapa_hitbox			
			lw		t3, 0(t0)			# Endereço do mapa de hitboxes da tela atual
	 
			la		t0, mapa.hitbox.largura
			lhu		t4, 0(t0)
			li 		t5, LUFFY.HITBOX.ALTURA
			add 		t2, t2, t5			# Desce até o pé do personagem
			mul 		t4, t4, t2
			add 		t4, t4, t1			# t4 = Endereço do primeiro pixel abaixo do personagem
	
			add 		t3, t3, t4			# Pixel no endereço de hitboxes
			li 		t5, LUFFY.HITBOX.LARGURA	# Vai testar colisão com toda a linha de pixels abaixo do personagem
			li		t6, 0
			
CB.LOOP:		lb		t2, 0(t3)
			li		t0, 1
			beq 		t2, t0, CB.NAO_COLIDIU		# Se o byte do mapa de hitboxes != 1, colidiu
			
CB.COLIDIU: 		li		a0, 1
	 		ret
	 		
CB.NAO_COLIDIU:		addi 		t6, t6, 1
			addi 		t3, t3, 1
			blt 		t6, t5, CB.LOOP
			 
CB.FIM:			li		a0, 0
			ret
	
# Checa colisão acima do personagem
# Return a0, 1 = Colidiu
COLISAO.CIMA:		# Calcula coordenadas inicais da hitbox do persongem
			la 		t1, mapa.x
			lh 		t1, (t1)
			la 		t2, mapa.y
			lh 		t2, (t2)
			la 		t3, horizontal_luffy
			lw 		t3, (t3)
			li		t4, LUFFY.HITBOX_OFFSET.X
			add 		t3, t3, t4
			la 		t4, vertical_luffy
			lw 		t4, (t4)
			li		t5, LUFFY.HITBOX_OFFSET.Y
			add 		t4, t4, t5				
	
			# 11 = mapa.x + horizontal_char + char.hitbox_offset.x = X do personagem relativo ao mapa
			add 		t1, t1, t3			
			# t2 = mapa.y + vertical_char + char.hitbox_offset.y = Y do personagem relativo ao mapa
			add 		t2, t2, t4
			
			la 		t0, mapa_hitbox			
			lw		t3, 0(t0)			# Endereço do mapa de hitboxes da tela atual
			 
			la		t0, mapa.hitbox.largura
			lhu		t4, 0(t0)
			mul 		t4, t4, t2
			add 		t4, t4, t1			# t4 = Endereço do primeiro pixel acima do personagem
			
			add 		t3, t3, t4			# t3 = Pixel no endereço de hitboxes	
			li 		t5, LUFFY.HITBOX.LARGURA
			li 		t6, 0
CC.LOOP:
			lb 		t2, 0(t3)
			blez 		t2, CC.COLIDIU
			
			addi 		t6, t6, 1
			addi 		t3, t3, 1
			blt 		t6, t5, CC.LOOP
			
CC.NAO_COLIDIU:		li 		a0, 0
			ret
			 			 			 
CC.COLIDIU:		beqz		t2, COLISAO.VERDADEIRO
			
			mv 		a0, t2
			jal 		TELA.TROCA
		
# Retorna verdadeiro
COLISAO.VERDADEIRO:	li		a0, 1
			ret
			

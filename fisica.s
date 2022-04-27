#  física
# Return:		a1 = Colisão à direita
#			a2 = Colisão à esquerda
#			a3 = Colisão acima
#			a4 = Colisão abaixo
FISICA:			addi		sp, sp, -4
			sw		ra, (sp)

			fadd.s 		fs2, fs2, fs1			# Incrementa velocidade vertical (FSI = gravidade)
			fcvt.w.s	s2, fs2				# s2 = Nova velocidade Y = velocidade + gravidade
			
			# Calculo das posições do personagem relativas ao mapa
			mv 		t1, s4				# s4 = Posição X do mapa
			mv 		t2, s3				# s3 = Posição Y do mapa
			mv		t3, s6				# s6 = Posição X do personagem
			li 		t4, ALUCARD.HITBOX_OFFSET.X
			add 		t3, t3, t4
			mv		t4, s5				# s5 = Posição Y do personagem
			li 		t5, ALUCARD.HITBOX_OFFSET.Y
			add 		t4, t4, t5
			add 		a1, t1, t3			 # X do personagem relativo ao mapa
			add 		a2, t2, t4			 # Y do personagem relativo ao mapa
			
			jal		COLISAO.DIREITA
			mv		a3, a0
			
			jal		COLISAO.ESQUERDA
			mv		a4, a0
			
			jal		COLISAO.CIMA
			mv		a5, a0
			
			li		a6, 0
			bltz		s2, FISICA.SUBINDO		# Se estiver subindo, não calcula colisão baixo
			
			jal		COLISAO.BAIXO
			mv		a6, a0	

FISICA.SUBINDO:		mv		a1, a3
			mv		a2, a4
			mv		a3, a5
			mv		a4, a6	
			
			lw		ra, (sp)
			addi		sp, sp, 4
			ret

# Consequências para o personagem tomar dano do terreno
FISICA.HIT:		li		t0, -3
			fcvt.s.w	ft0, t0
			fadd.s		fs4, fs4, ft0			# Perde 3 pontos de vida
			
			# Se estiver indo pra direita, stagger pra esquerda
			# Senão, stagger pra direita
			# ps: Fs3 = move X
			fcvt.w.s	t1, fs3
			li		t2, 8
			bltz		t1, FISICA.HIT.STAGGER_DIREITA
			
			li		t2, -8
			
FISICA.HIT.STAGGER_DIREITA:
			fcvt.s.w	fs3, t2
			
			li		t2, -6
			fcvt.s.w	fs2, t2				# Pula
			
			# Guarda os registradores
			mv		t1, a0
			mv		t2, a1
			mv		t3, a2
			mv		t4, a3
			mv		t5, a4
			mv		t6, a5
			
			# Som de dano
			li 		a0, 102				# pitch
			li 		a1, 1000			# duracao
			li 		a2, 116				# instrumento
			li 		a3, 50				# volume
			li 		a7, 31				# define a chamada de syscall
			ecall
			
			# Recupera os registradores
			mv		a0,t1
			mv		a1,t2
			mv		a2,t3
			mv		a3,t4
			mv		a4,t5
			mv		a5,t6
			
			j		COLISAO.VERDADEIRO
			

# Checa colisão à direita do personagem
# Param  a1 = Posição X do personagem relativa ao mapa
# Param  a2 = Posição Y do personagem relativa ao mapa
# Return a0, 1 = Colidiu
COLISAO.DIREITA:	addi		t1, a1, 2
			mv		t2, a2
	 
			la		t0, mapa.hitbox.largura
			lhu		t0, 0(t0)
			mul 		t2, t0, t2
			add 		t2, t2, t1			# t2 = Primeiro pixel do personagem no mapa de hitboxes
			
			li 		t5, ALUCARD.HITBOX.LARGURA
			add 		t2, t2, t5			# t2 = Primeiro pixel a direita do personagem
			
			la 		t1, mapa_hitbox			
			lw		t3, 0(t1)			# Endereço do mapa de hitboxes da tela atual
			
			add		t2, t2, t3			# t2 = Posição do personagem no mapa de hitboxes			
			
			li 		t5, ALUCARD.HITBOX.ALTURA	# Quantidade de pixels a serem testados
			#addi 		t5, t5, -5			# Sobe um pouco pra não testar no pé
			
			li 		t6, 0				# Contador de pixels testados
			
CD.LOOP:		lb 		t1, 0(t2)
			bgtz 		t1, CD.NAO_COLIDIU		# Se o byte for > zero, não colidiu
			
CD.COLIDIU: 		beqz		t1, COLISAO.VERDADEIRO		# Se for = 0, colidiu
			
			li		t0, -69
			beq		t1, t0, FISICA.HIT
			
			addi		sp, sp, 4
			mv 		a0, t1			
			j 		TELA.TROCA			# Se for < 0, trocou de tela
	 		
CD.NAO_COLIDIU:		addi		t6, t6, 1
		 	add 		t2, t2, t0			# Desce uma linha
		 	blt 		t6, t5, CD.LOOP
		 	
CD.FIM:			li 		a0, 0
			ret

# Checa colisão à esquerda do personagem
# Param  a1 = Posição X do personagem relativa ao mapa
# Param  a2 = Posição Y do personagem relativa ao mapa
# Return a0, 1 = Colidiu
COLISAO.ESQUERDA:	addi		t1, a1, -2
			mv		t2, a2
	
			la		t0, mapa.hitbox.largura
			lhu		t0, 0(t0)
			mul 		t2, t0, t2
			add 		t2, t2, t1			# t2 = Primeiro pixel do personagem no mapa de hitboxes
			
			la 		t1, mapa_hitbox			
			lw		t3, 0(t1)			# Endereço do mapa de hitboxes da tela atual
			
			add		t2, t2, t3			# t2 = Posição do personagem no mapa de hitboxes			
			
			li 		t5, ALUCARD.HITBOX.ALTURA	# Quantidade de pixels a serem testados
			#addi 		t5, t5, -5			# Sobe um pouco pra não testar no pé
			
			li 		t6, 0				# Contador de pixels testados
			
CE.LOOP:		lb 		t1, 0(t2)
			bgtz 		t1, CE.NAO_COLIDIU		# Se o byte for > zero, não colidiu
			
CE.COLIDIU: 		beqz		t1, COLISAO.VERDADEIRO		# Se for = 0, colidiu
			
			li		t0, -69
			beq		t1, t0, FISICA.HIT
			
			addi		sp, sp, 4
			mv 		a0, t1			
			j 		TELA.TROCA			# Se for < 0, trocou de tela
	 		
CE.NAO_COLIDIU:		addi		t6, t6, 1
		 	add 		t2, t2, t0			# Desce uma linha
		 	blt 		t6, t5, CE.LOOP
		 	
CE.FIM:			li 		a0, 0
			ret

# Checa colisão abaixo do personagem
# Param  a1 = Posição X do personagem relativa ao mapa
# Param  a2 = Posição Y do personagem relativa ao mapa
# Return a0, 1 = Colidiu
COLISAO.BAIXO:		mv		t1, a1
			add		t2, a2, s2
	
			la 		t0, mapa_hitbox			
			lw		t3, 0(t0)			# Endereço do mapa de hitboxes da tela atual
	 
			la		t0, mapa.hitbox.largura
			lhu		t4, 0(t0)
			li 		t5, ALUCARD.HITBOX.ALTURA
			add 		t2, t2, t5			# Desce até o pé do personagem
			mul 		t4, t4, t2
			add 		t4, t4, t1			# t4 = Endereço do primeiro pixel abaixo do personagem
	
			add 		t3, t3, t4			# Pixel no endereço de hitboxes
			li 		t5, ALUCARD.HITBOX.LARGURA	# Vai testar colisão com toda a linha de pixels abaixo do personagem
			li		t6, 0
			
CB.LOOP:		lb		t2, 0(t3)
			li		t0, 1
			beq 		t2, t0, CB.NAO_COLIDIU		# Se o byte do mapa de hitboxes != 1, colidiu
			
CB.COLIDIU:		li		t0, -69
			beq		t2, t0, FISICA.HIT 		

			# Zera a velocidade vertical
			fcvt.s.w	fs2, zero
			
			bgez		t2, COLISAO.VERDADEIRO
			
			addi		sp, sp, 4
			mv 		a0, t2
			j 		TELA.TROCA
	 		
CB.NAO_COLIDIU:		addi 		t6, t6, 1
			addi 		t3, t3, 1
			blt 		t6, t5, CB.LOOP
			 
CB.FIM:			li		a0, 0
			ret
	
# Checa colisão acima do personagem
# Param  a1 = Posição X do personagem relativa ao mapa
# Param  a2 = Posição Y do personagem relativa ao mapa
# Return a0, 1 = Colidiu
COLISAO.CIMA:		mv		t1, a1
			add		t2, a2, s2
			
			la 		t0, mapa_hitbox			
			lw		t3, 0(t0)			# Endereço do mapa de hitboxes da tela atual
			 
			la		t0, mapa.hitbox.largura
			lhu		t4, 0(t0)
			mul 		t4, t4, t2
			add 		t4, t4, t1			# t4 = Endereço do primeiro pixel acima do personagem
			
			add 		t3, t3, t4			# t3 = Pixel no endereço de hitboxes	
			li 		t5, ALUCARD.HITBOX.LARGURA
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
			
			addi		sp, sp, 4
			mv 		a0, t2
			j 		TELA.TROCA
		
# Retorna verdadeiro
COLISAO.VERDADEIRO:	li		a0, 1
			ret
			

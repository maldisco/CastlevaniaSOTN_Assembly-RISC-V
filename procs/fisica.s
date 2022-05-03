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
			
			# Teste de colisões
			# Se o personagem está indo pra direita, não testa a esquerda
			# e vice-versa
FISICA.HORIZONTAL:	fcvt.w.s	t1, fs3				# Fs3 = moveX
			bgtz		t1, FISICA.HORIZONTAL.DIREITA
			
FISICA.HORIZONTAL.ESQUERDA:
			li		a3, 0
			jal		COLISAO.ESQUERDA
			mv		a4, a0
			j 		FISICA.VERTICAL
			
FISICA.HORIZONTAL.DIREITA:
			li		a4, 0
			jal 		COLISAO.DIREITA
			mv		a3, a0
			
			# Se o personagem está subindo, não testa colisão abaixo
			# e vice-versa
FISICA.VERTICAL:	bltz		s2, FISICA.VERTICAL.SUBINDO	# s2 = Velocidade Y

FISICA.VERTICAL.DESCENDO:
			li		a5, 0
			jal		COLISAO.BAIXO
			mv		a6, a0
			j		FISICA.RET

FISICA.VERTICAL.SUBINDO:
			li		a6, 0
			jal		COLISAO.CIMA
			mv		a5, a0	
			
FISICA.RET:		# Move os resultados para os registradores 1-4
			# não usei direto pois os procedimentos de colisão os utilizam
			mv		a1, a3
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
			
			li		t1, 1
			fcvt.s.w	fa2, t1			
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
			
# Checa colisão com inimigo
COLISAO.INIMIGO:	# Se o sans estiver ligado
			fcvt.w.s	t0, fa0
			li		t1, 1
			beq		t0, t1, COLISAO.INIMIGO.SANS
			
			# Se o canhão estiver ligado
			li		t1, 2
			beq		t0, t1, COLISAO.INIMIGO.CANHAO
			
COLISAO.RET:		ret
			
COLISAO.INIMIGO.CANHAO:	fcvt.w.s	t1, fs10				# Y do canhao
			fcvt.w.s	t2, fs11				# X do canhao
			
			addi		t3, a2, 41				# Limite inferior da Hitbox da espada
			blt		t3, t1, COLISAO.RET
			
			addi		t1, t1, 54				# Limite inferior da Hitbox do inimigo
			addi		t3, a2, 17				# Limite superior da Hitbox da espada
			bgt		t3, t1, COLISAO.RET
			
			addi		t3, a1, 64
			li		t4, 26					
			fcvt.w.s	t0, fa4
			mul		t4, t4, t0
			add		t3, t3, t4				# Limite direito da hitbox da espada
			blt		t3, t2, COLISAO.RET
			
			addi		t2, t2, 80				# Limite direito da hitbox do inimigo
			addi		t3, a1, 29				
			li		t4, 29
			mul		t4, t4, t0
			add		t3, t3, t4				# Limite esquerdo da hitbox da espada
			bgt		t3, t2, COLISAO.RET
			
			fcvt.s.w	fa0, zero				# Desliga o sinal do canhão
			la		t0, TELA.DESCRITORES			
			lw		s9, 36(t0)				# Carrega a segunda versão da tela (aberta)
			la		t0, mapa_hitbox
			la		t1, tela_10_aberta_hitboxes
			sw		t1, (t0)
			ret

			
COLISAO.INIMIGO.SANS:	fcvt.w.s	t1, fs10				# Y do inimigo
			fcvt.w.s	t2, fs11				# X do inimigo
			
			addi		t3, a2, 41				# Limite inferior da Hitbox da espada
			blt		t3, t1, COLISAO.RET
			
			addi		t1, t1, 71				# Limite inferior da Hitbox do inimigo
			addi		t3, a2, 17				# Limite superior da Hitbox da espada
			bgt		t3, t1, COLISAO.RET
			
			addi		t3, a1, 64
			li		t4, 26					
			fcvt.w.s	t0, fa4
			mul		t4, t4, t0
			add		t3, t3, t4				# Limite direito da hitbox da espada
			blt		t3, t2, COLISAO.RET
			
			addi		t2, t2, 62				# Limite direito da hitbox do inimigo
			addi		t3, a1, 29				
			li		t4, 29
			mul		t4, t4, t0
			add		t3, t3, t4				# Limite esquerdo da hitbox da espada
			bgt		t3, t2, COLISAO.RET
			
			fsub.s		fs0, fs0, ft2				# ft2 = dano do personagem
			
			# Teleporta o SANS
SANS.TELEPORTA:		mv		t6, a0
			mv		t5, a1
			mv		t4, a7
			
			li		a1, 4
			li		a7, 42
			ecall
			
			li		t1, 0
			beq		a0, t1, SANS.TELEPORTA.1
			
			li		t1, 1
			beq		a0, t1, SANS.TELEPORTA.2
			
			li		t1, 2
			beq		a0, t1, SANS.TELEPORTA.3
			
			li		t1, 3
			beq		a0, t1, SANS.TELEPORTA.4
			
			li		t1, 4
			beq		a0, t1, SANS.TELEPORTA.5

SANS.TELEPORTA.RET:	mv		a0, t6
			mv		a1, t5
			mv		a7, t4
			ret


SANS.TELEPORTA.1:	li		t0, 27
			fcvt.s.w	fs11, t0
			li		t0, 18
			fcvt.s.w	fs10, t0
			j		SANS.TELEPORTA.RET

SANS.TELEPORTA.2:	li		t0, 129
			fcvt.s.w	fs11, t0
			li		t0, 71
			fcvt.s.w	fs10, t0
			j		SANS.TELEPORTA.RET
			
SANS.TELEPORTA.3:	li		t0, 232
			fcvt.s.w	fs11, t0
			li		t0, 18
			fcvt.s.w	fs10, t0
			j		SANS.TELEPORTA.RET

SANS.TELEPORTA.4:	li		t0, 46
			fcvt.s.w	fs11, t0
			li		t0, 112
			fcvt.s.w	fs10, t0
			j		SANS.TELEPORTA.RET
			
SANS.TELEPORTA.5:	li		t0, 209
			fcvt.s.w	fs11, t0
			li		t0, 112
			fcvt.s.w	fs10, t0
			j		SANS.TELEPORTA.RET
			


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
			

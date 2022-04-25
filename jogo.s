.data
.include "config.s"
.include "alucard.s"
.include "macros.s"
.text
			# Carrega arquivo de sprites do personagem principal 
			la 		a0, alucard
			li 		a1, 0
			li 		a2, 0
			li 		a7, 1024
			ecall
			mv 		s10, a0 		# Salva em s10 
			
			# Carrega arquivo de sprites da HUD
			la		a0, hud
			li		a1, 0
			li		a2, 0
			li		a7, 1024
			ecall
			mv		s8, a0			# Salva em s8
			
			la		t0, TELA.DESCRITORES
			# Carrega o arquivo da primeira tela do jogo
			la 		a0, tela1
			li		a1, 0
			li		a2, 0
			li 		a7, 1024
			ecall
			sw		a0, 0(t0)		
			
			# Carrega o arquivo da segunda tela do jogo
			la		a0, tela2
			li		a1, 0
			li		a2, 0
			li		a7, 1024
			ecall
			sw		a0, 4(t0)		
			
			# Carrega o arquivo da terceira tela do jogo
			la		a0, tela3
			li		a1, 0
			li		a2, 0
			li		a7, 1024
			ecall
			sw		a0, 8(t0)		
			
			# Carrega o arquivo da quarta tela do jogo
			la		a0, tela4
			li		a1, 0
			li		a2, 0
			li		a7, 1024
			ecall
			sw		a0, 12(t0)		
			
			# Carrega o arquivo da quinta tela do jogo
			la		a0, tela5
			li		a1, 0
			li		a2, 0
			li		a7, 1024
			ecall
			sw		a0, 16(t0)		
			
			# Carrega o arquivo da sexta tela do jogo
			la		a0, tela6
			li		a1, 0
			li		a2, 0
			li		a7, 1024
			ecall
			sw		a0, 20(t0)
			
			# Carrega o arquivo da setima tela do jogo
			la		a0, tela7
			li		a1, 0
			li		a2, 0
			li		a7, 1024
			ecall
			sw		a0, 24(t0)
			
			# Carrega o arquivo da decima tela do jogo
			la		a0, tela10
			li		a1, 0
			li		a2, 0
			li		a7, 1024
			ecall
			sw		a0, 28(t0)
			
			csrr 		s11, 3073			# Guarda tempo atual em s7 (usado para controle de FPS)
			jal		OST.SETUP
			jal 		config_tela_1	
			
			# ===================== NÃO DEVE MUDAR ===============================
			# S11 = Tempo da ultima atualizacao de tela
			# S10 = Descritor do arquivo de sprites do alucard
			# S9 = Descritor do arquivo da tela atual
			# S8 = Descritor do arquivo de sprites da HUD
			# S7 = Frame atual
			# OW, COMEÇA A USAR A VELOCIDADEY COMO UM REGISTRADOR FLOAT
			# PENSA NAS POSIÇÕES DO MAPA E PERSONAGEM TBM
			# E NA SPRITE ATUAL			

LOOP_JOGO:		csrr 		t0, 3073
			sub 		t0, t0, s11
			li 		t1, 16
			bltu 		t0, t1, LOOP_JOGO			# Se ainda não tiverem passado 16 Milissegundos, não começa
			
			troca_tela()						# Troca a tela para o usuário não ver as atualizações
			#jal		OST.TOCA
			jal 		ENTRADA					# Trata a entrada do usuário no teclado
			
# Renderiza o mapa
MAPA.RENDER:		mv		a0, s9
			li		a1, 0		
			li 		a2, 0
			la		t1, mapa.imagem.largura
			lhu		a3, 0(t1)
			li 		a4, MAPA.LARGURA		
			frame_address(a5)
			offset_mapa(a6)
			li 		a7, MAPA.ALTURA
			jal		RENDER

			jal 		FISICA
			# Retorna booleanos (1 = True, 0 = False)
			#		a1 = Colisão à direita
			#		a2 = Colisão à esquerda
			#		a3 = Colisão acima
			#		a4 = Colisão abaixo

# Atualiza a posição da personagem 	
ALUCARD.ATUALIZA:	loadb(t1, socando)
			bnez 		t1, ALUCARD.SOCANDO
			loadb(t1, pulando)
			bnez 		t1, ALUCARD.PULANDO
			loadb(t1, moveX)
			bgtz 		t1, ALUCARD.CORRENDO.DIREITA
			
			bltz 		t1, ALUCARD.CORRENDO.ESQUERDA
			
ALUCARD.PARADO:		bnez 		a4, LP.COLIDIU.BAIXO		# Checa se colidiu com o chão
			
						
LP.MOVE.MAPA:		la 		t1, mapa.y
			lhu 		t2, (t1)
			add 		t2, t2, s2			# desce 2 pixels
			la 		t0, mapa.max.y
			lhu		t3, 0(t0)
			bgt 		t2, t3, LP.MOVE.CHAR		# Se passar do Limite inferior do mapa, move o personagem ao invés do mapa
			
			sh		t2, (t1)			# Se não, move mapa
			j 		LP.COLIDIU.BAIXO

LP.MOVE.CHAR:		# Movimenta o personagem em Y
			la		t0, vertical_alucard
			lw		t1, 0(t0)
			add 		t1, t1, s2
			sw		t1, 0(t0)
					
LP.COLIDIU.BAIXO:	# Gera os valores para renderizar
			mv 		a0, s10				# Descritor
			loadw(a1, horizontal_alucard)			# X na tela
			loadw(a2, vertical_alucard)			# Y na tela
			li 		a3, ALUCARD.OFFSET		# Largura da imagem
			li 		a4, ALUCARD.LARGURA		# Largura da sprite
			frame_address(a5)				# Endereço da frame
			loadb(t1, alucard.animacao)
			li 		t2, 48
			blt 		t1, t2,LP.NAORESETA
			
			li		t1, 0
			
LP.NAORESETA:
			addi 		t3, t1, 1			# Avança um movimento na animação
			saveb(t3, alucard.animacao)
			li 		t2, 4
			mul 		t1, t1, t2
			la 		t2, alucard.parado.direita.offsets
			loadb(t3, sentido)
			bgtz 		t3, LP.SENTIDO.DIREITA
			
			la 		t2 alucard.parado.esquerda.offsets
			
LP.SENTIDO.DIREITA:
			add 		t2, t2, t1
			lw 		a6, (t2)			# Offset na imagem
			li 		a7, ALUCARD.ALTURA
			j 		ALUCARD.RENDER
# LPU	
ALUCARD.PULANDO:		# Atualiza a posição Y
			fcvt.s.w 	ft0, zero
			la 		t1, velocidadeY_alucard
			flw 		ft1, 0(t1)
			flt.s		t1, ft1, ft0			# t1 = 1 if ft1 < ft0 else 0
					
			bnez		t1, LPU.SUBINDO
			
LPU.DESCENDO:		# Checa se já caiu no chão
			beqz 		a4, LPU.MOVE_Y
			
			saveb(zero, pulando)
			# Salva nova velocidade Y
			la 		t1, velocidadeY_alucard
			fsw		fs2, (t1)
			j 		LPU.ATUALIZA_X	
				
LPU.SUBINDO:		# Checa se bateu no teto
			beqz 		a3, LPU.MOVE_Y
			
			# Salva nova velocidade Y
			la 		t1, velocidadeY_alucard
			fsw		fs2, (t1)
			j 		LPU.ATUALIZA_X	
				
LPU.MOVE_Y:		# Movimenta o mapa em Y
			la 		t1, mapa.y
			lhu 		t2, 0(t1)
			add 		t2, t2, s2
			la		t0, mapa.max.y
			lhu		t3, 0(t0)
			bgt		t2, t3, LPU.MOVE_Y.CHAR		# Se passar do limite inferior do mapa, move o personagem ao invés do mapa
			
			la		t0, mapa.min.y
			lhu		t3, 0(t0)
			blt		t2, t3, LPU.MOVE_Y.CHAR		# Se passar do limite superior do mapa, move o personagem ao invés do mapa
			
			la		t0, vertical_alucard		# Se o personagem está acima da metade da tela, move o personagem ao invés do mapa
			lw		t3, (t0)	
			li 		t4, 130
			bgt		t3, t4, LPU.MOVE_Y.CHAR		
												
			sh		t2, (t1)			# Se não, move mapa
			j		LPU.ATUALIZA_X
					
LPU.MOVE_Y.CHAR:	# Movimenta o personagem em Y
			la		t0, vertical_alucard
			lw		t1, 0(t0)
			add 		t1, t1, s2
			sw		t1, 0(t0)	
	
															
# Atualiza a posição X
LPU.ATUALIZA_X:		loadb(t1, moveX)
			beqz 		t1, LPU.PARADO
			bgtz 		t1, LPU.DIREITA

LPU.ESQUERDA:		# Testa colisão a esquerda			
			bnez 		a2, LPU.PARADO	
			 
			
			la 		t1, mapa.x
			lhu 		t2, (t1)
			addi 		t2, t2, -2
			la		t0, mapa.min.x
			lhu 		t3, 0(t0)
			blt		t2, t3, LPU.ESQUERDA.MOVE.CHAR	
			
			la		t0, horizontal_alucard
			lw		t4, (t0)
			li		t5, 120
			bgt 		t4, t5, LPU.ESQUERDA.MOVE.CHAR		
						
LPU.ESQUERDA.MOVE.MAPA:	# Movimenta o mapa em X			
			sh 		t2, (t1)
			j 		LPU.PARADO
			
LPU.ESQUERDA.MOVE.CHAR:	la 		t1, horizontal_alucard
			lw 		t2, 0(t1)
			addi 		t2, t2, -2
			sw 		t2, 0(t1)
						
			j 		LPU.PARADO
			
LPU.DIREITA:		# Calcula colisão
			bnez 		a1, LPU.PARADO				# Se bateu em algo, não move
								
			la	 	t1, mapa.x
			lhu 		t2, (t1)
			addi 		t2, t2, 2
			la		t0, mapa.max.x
			lhu		t3, 0(t0)
			bgt 		t2, t3, LPU.DIREITA.MOVE.CHAR
			
			la		t0, horizontal_alucard
			lw		t4, (t0)
			li		t5, 120
			blt		t4, t5, LPU.DIREITA.MOVE.CHAR
				
LPU.DIREITA.MOVE.MAPA:	# Movimenta o mapa em X			
			sh 		t2, (t1)
			j 		LPU.PARADO
			
LPU.DIREITA.MOVE.CHAR:	la 		t1, horizontal_alucard
			lw 		t2, 0(t1)
			addi 		t2, t2, 2
			sw 		t2, 0(t1)
						
LPU.PARADO:	# Gera os valores para renderizar
			mv 		a0, s10					# Descritor
			loadw(a1, horizontal_alucard)				# X na tela
			loadw(a2, vertical_alucard)				# Y na tela 
			li 		a3, ALUCARD.OFFSET			# Largura da imagem
			li 		a4, ALUCARD.LARGURA			# Largura da sprite
			frame_address(a5)					# Endereço da frame
			loadb(t1, alucard.animacao)
			li 		t2, 88
			blt 		t1, t2,LPU.NAO_RESETA			# Se tiver chegado na ultima animação, reseta
			
			li 		t1, 0
			
LPU.NAO_RESETA:
			addi 		t3, t1, 1				# Avança um movimento na animação
			saveb(t3, alucard.animacao)
			li 		t2, 4
			mul 		t1, t1, t2
			la 		t2, alucard.pulando.direita.offsets
			loadb(t3, sentido)
			bgtz 		t3, LPU.SENTIDO.DIREITA
			
			la 		t2 alucard.pulando.esquerda.offsets
			
LPU.SENTIDO.DIREITA:
			add 		t2, t2, t1
			lw 		a6, (t2)				# Offset na imagem
			li 		a7, ALUCARD.ALTURA
			j 		ALUCARD.RENDER

# LCD			
ALUCARD.CORRENDO.DIREITA:	# Calcula colisão
			bnez 		a1, LCD.COLIDIU
								
LCD.MOVE.MAPA:		# Se tiver chegado no final do mapa OU o personagem está à esquerda do centro da tela, move o personagem
			# Se não, move a tela/mapa
			la 		t1, mapa.x
			lhu 		t2, (t1)
			addi 		t2, t2, 2
			la		t0, mapa.max.x
			lhu		t3, (t0)
			bgt		t2, t3 LCD.MOVE.CHAR
			
			la		t0, horizontal_alucard
			lw		t4, (t0)
			li		t5, 120
			blt 		t4, t5, LCD.MOVE.CHAR
			
			sh 		t2, (t1)
			j 		LCD.COLIDIU
			
LCD.MOVE.CHAR:		la 		t1, horizontal_alucard
			lw 		t2, 0(t1)
			addi 		t2, t2, 2
			sw 		t2, 0(t1)
			
LCD.COLIDIU:		bnez 		a4, LCD.COLIDIU.BAIXO		
		
LCD.MOVE_Y.MAPA:
			# Movimenta o mapa em Y
			la 		t1, mapa.y
			lhu 		t2, (t1)
			add 		t2, t2, s2			# desce 2 pixels
			la		t0, mapa.max.y
			lhu		t3, 0(t0)
			bgt 		t2, t3, LCD.MOVE_Y.CHAR		# Se chegou ao limite inferior do mapa, move o personagem ao invés do mapa
			
			sh		t2, (t1)
			j 		LCD.COLIDIU.BAIXO

LCD.MOVE_Y.CHAR:	# Movimenta o personagem em Y
			la		t0, vertical_alucard
			lw		t1, 0(t0)
			add 		t1, t1, s2
			sw		t1, 0(t0)
			
LCD.COLIDIU.BAIXO:	# Decrementa uma movimentação a direita
			la 		t1, moveX
			lb 		t2, (t1)
			addi 		t2, t2, -1
			sb 		t2, (t1)
			# Gera os valores para renderizar
			mv 		a0, s10						# Descritor
			loadw(a1, horizontal_alucard)					# X na tela
			loadw(a2, vertical_alucard)					# Y na tela
			li 		a3, ALUCARD.OFFSET				# Largura da imagem
			li 		a4, ALUCARD.LARGURA				# Largura da sprite
			frame_address(a5)						# Endereço da frame
			loadb(t1, alucard.animacao)
			li 		t2, 62
			
			blt 		t1, t2,LCD.NAO_RESETA
			
			li 		t1, 32
			
LCD.NAO_RESETA:
			addi 		t3, t1, 1					# Avança um movimento na animação
			saveb(t3, alucard.animacao)
			li 		t2, 4
			mul 		t1, t1, t2
			la 		t2, alucard.correndo.direita.offsets
			add 		t2, t2, t1
			lw 		a6, (t2)					# Offset na imagem
			li 		a7, ALUCARD.ALTURA
			j 		ALUCARD.RENDER
# LCE	
ALUCARD.CORRENDO.ESQUERDA:# checa colisão
			bnez 		a2, LCE.COLIDIU 

ALUCARD.MOVE.MAPA:	# Se tiver chegado no inicio do mapa OU o personagem está à direita do centro da tela, move o personagem
			# Se não, move a tela/mapa		 					 		
			la 		t1, mapa.x
			lhu		t2, (t1)
			addi 		t2, t2, -2
			la		t0, mapa.min.x
			lhu		t3, 0(t0)
			blt		t2, t3, LCE.MOVE.CHAR
			
			la		t0, horizontal_alucard
			lw		t4, (t0)
			li		t5, 120
			bgt		t4, t5, LCE.MOVE.CHAR			
		
			sh 		t2, (t1)
			j 		LCE.COLIDIU
			
LCE.MOVE.CHAR:		la 		t1, horizontal_alucard
			lw 		t2, 0(t1)
			addi 		t2, t2, -2
			sw 		t2, 0(t1)
			
LCE.COLIDIU:		# Checa colisão baixo 
			bnez 		a4, LCE.COLIDIU.BAIXO

LCE.MOVE_Y.MAPA:
			# Movimenta o mapa em Y
			la 		t1, mapa.y
			lhu 		t2, (t1)
			add 		t2, t2, s2			# desce 2 pixels
			la		t0, mapa.max.y
			lhu		t3, 0(t0)
			bgt 		t2, t3, LCE.MOVE_Y.CHAR		# Se tiver chegado no limite inferior do mapa, move o personagem ao invés do mapa
			
			sh		t2, (t1)
			j 		LCE.COLIDIU.BAIXO

LCE.MOVE_Y.CHAR:	# Movimenta o personagem em Y
			la		t0, vertical_alucard
			lw		t1, 0(t0)
			add 		t1, t1, s2
			sw		t1, 0(t0)
			
LCE.COLIDIU.BAIXO:	# Decrementa uma movimentação a esquerda
			la 		t1, moveX
			lb 		t2, (t1)
			addi 		t2, t2, 1
			sb 		t2, (t1)
			# Gera os valores para renderizar
			mv 		a0, s10						# Descritor
			loadw(a1, horizontal_alucard)					# X na tela
			loadw(a2, vertical_alucard)					# Y na tela
			li 		a3, ALUCARD.OFFSET				# Largura da imagem
			li 		a4, ALUCARD.LARGURA				# Largura da sprite
			frame_address(a5)						# Endereço da frame
			loadb(t1, alucard.animacao)
			li 		t2, 62
			blt 		t1, t2,LCE.NAO_RESETA				# Se tiver chegado na última animação, recicla
			
			li 		t1, 32
			
LCE.NAO_RESETA:
			addi 		t3, t1, 1					# Avança um movimento na animação
			saveb(t3, alucard.animacao)
			li 		t2, 4
			mul 		t1, t1, t2
			la 		t2, alucard.correndo.esquerda.offsets
			add 		t2, t2, t1
			lw 		a6, (t2)					# Offset na imagem
			li 		a7, ALUCARD.ALTURA
			j		ALUCARD.RENDER	

# LS	
ALUCARD.SOCANDO:	# checa colisão abaixo
			bnez		a4, LS.COLIDIU.BAIXO		
	
LS.MOVE_Y:		# Movimenta o mapa em Y
			la 		t1, mapa.y
			lhu 		t2, 0(t1)
			add 		t2, t2, s2
			la		t0, mapa.max.y
			lhu		t3, 0(t0)
			bgt		t2, t3, LS.MOVE_Y.CHAR		# Se passar do limite inferior do mapa, move o personagem ao invés do mapa
			
			la		t0, mapa.min.y
			lhu		t3, 0(t0)
			blt		t2, t3, LS.MOVE_Y.CHAR		# Se passar do limite superior do mapa, move o personagem ao invés do mapa	
												
			sh		t2, (t1)			# Se não, move mapa
			j		LS.COLIDIU.BAIXO
					
LS.MOVE_Y.CHAR:	# Movimenta o personagem em Y
			la		t0, vertical_alucard
			lw		t1, 0(t0)
			add 		t1, t1, s2
			sw		t1, 0(t0)	
			
LS.COLIDIU.BAIXO:	# Gera os valores para renderizar
			mv 		a0, s10						# Descritor
			loadw(a1, horizontal_alucard)					# X na tela
			loadw(a2, vertical_alucard)					# Y na tela
			li 		a3, ALUCARD.OFFSET				# Largura da imagem
			li 		a4, ALUCARD.LARGURA				# Largura da sprite
			frame_address(a5)						# Endereço da frame
		
			loadb(t1, alucard.animacao)
			li 		t2, 33
			blt 		t1, t2,LS.RENDER				# Se tiver chegado na ultima animação, para de socar
			
			saveb(zero, socando)
				
LS.RENDER:		addi 		t3, t1, 1					# Avança um movimento na animação
			saveb(t3, alucard.animacao)
			li 		t2, 4
			mul 		t1, t1, t2
			la 		t2, alucard.socando.direita.offsets
			loadb(t3, sentido)
			bgtz 		t3, LS.SENTIDO.DIREITA
			
			la 		t2, alucard.socando.esquerda.offsets			
LS.SENTIDO.DIREITA:
			add 		t2, t2, t1
			lw 		a6, (t2)					# Offset na imagem
			li 		a7, ALUCARD.ALTURA

# Chama a função de renderizar o personagem
ALUCARD.RENDER:		jal		RENDER						# Renderiza o personagem na tela

			jal 		HUD.RENDER
			
			atualiza_tela()							# Atualiza a tela para o usuário ver as atualizações
			
			csrr		s11, 3073					# Guarda o horário da atualização de frame			
			
			j 		LOOP_JOGO					# Retorna ao loop principal


.include "entrada.s"
.include "tela.s"
.include "fisica.s"
.include "render.s"
.include "ost.s"
.include "dialogos.s"
.include "hud.s"

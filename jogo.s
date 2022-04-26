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
			
			li		s7, 0				# Frame atual
			csrr 		s11, 3073			# Guarda tempo atual em s7 (usado para controle de FPS)

			la		t0, GRAVIDADE
			flw		fs1, (t0)			# Acelera��o da gravidade (constante)
			
			jal		OST.SETUP
			jal 		config_tela_1	
			
			# ===================== N�O DEVE MUDAR ===============================
			# S11 = Tempo da ultima atualizacao de tela
			# S10 = Descritor do arquivo de sprites do alucard
			# S9 = Descritor do arquivo da tela atual
			# S8 = Descritor do arquivo de sprites da HUD
			# S7 = Frame atual
			# S6 = Posi��o X do personagem
			# S5 = Posi��o Y do personagem
			# S4 = Posi��o X do mapa
			# S3 = Posi��o Y do mapa
			# 
			# PENSA NAS POSI��ES DO MAPA E PERSONAGEM TBM
			# E NA SPRITE ATUAL	
			# FS1 = Gravidade
			# FS2 = VelocidadeY
			
			# ==================== CONSTANTE NO LOOP DE ATUALIZA��O DO PERSONAGEM
			# S2 = VelocidadeY (INTEIRO)
							

LOOP_JOGO:		csrr 		t0, 3073
			sub 		t0, t0, s11
			li 		t1, 16
			bltu 		t0, t1, LOOP_JOGO			# Se ainda n�o tiverem passado 16 Milissegundos, n�o come�a
			
			xori 		s7, s7, 1				# Troca a frame para o usu�rio n�o ver as atualiza��es
			#jal		OST.TOCA
			jal 		ENTRADA					# Trata a entrada do usu�rio no teclado
			
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
			#		a1 = Colis�o � direita
			#		a2 = Colis�o � esquerda
			#		a3 = Colis�o acima
			#		a4 = Colis�o abaixo

# Atualiza a posi��o da personagem 	
ALUCARD.ATUALIZA:	loadb(t1, socando)
			bnez 		t1, ALUCARD.SOCANDO
			loadb(t1, pulando)
			bnez 		t1, ALUCARD.PULANDO
			loadb(t1, moveX)
			bgtz 		t1, ALUCARD.CORRENDO.DIREITA
			
			bltz 		t1, ALUCARD.CORRENDO.ESQUERDA
			
ALUCARD.PARADO:		bnez 		a4, LP.COLIDIU.BAIXO		# Checa se colidiu com o ch�o
			
						
LP.MOVE.MAPA:		add 		t2, s3, s2			# desce 2 pixels
			la 		t0, mapa.max.y
			lhu		t3, 0(t0)
			bgt 		t2, t3, LP.MOVE.CHAR		# Se passar do Limite inferior do mapa, move o personagem ao inv�s do mapa
			
			mv		s3, t2				# Se n�o, move mapa
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
			frame_address(a5)				# Endere�o da frame
			loadb(t1, alucard.animacao)
			li 		t2, 48
			blt 		t1, t2,LP.NAORESETA
			
			li		t1, 0
			
LP.NAORESETA:
			addi 		t3, t1, 1			# Avan�a um movimento na anima��o
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
ALUCARD.PULANDO:		# Atualiza a posi��o Y
			fcvt.s.w 	ft0, zero
			flt.s		t1, fs2, ft0			# t1 = 1 if ft1 < ft0 else 0
					
			bnez		t1, LPU.SUBINDO
			
LPU.DESCENDO:		# Checa se j� caiu no ch�o
			beqz 		a4, LPU.MOVE_Y
			
			saveb(zero, pulando)
			j 		LPU.ATUALIZA_X	
				
LPU.SUBINDO:		# Checa se bateu no teto
			beqz 		a3, LPU.MOVE_Y
			
			j 		LPU.ATUALIZA_X	
				
LPU.MOVE_Y:		# Movimenta o mapa em Y
			add 		t2, s3, s2
			la		t0, mapa.max.y
			lhu		t3, 0(t0)
			bgt		t2, t3, LPU.MOVE_Y.CHAR		# Se passar do limite inferior do mapa, move o personagem ao inv�s do mapa
			
			la		t0, mapa.min.y
			lhu		t3, 0(t0)
			blt		t2, t3, LPU.MOVE_Y.CHAR		# Se passar do limite superior do mapa, move o personagem ao inv�s do mapa
			
			la		t0, vertical_alucard		# Se o personagem est� acima da metade da tela, move o personagem ao inv�s do mapa
			lw		t3, (t0)	
			li 		t4, 130
			bgt		t3, t4, LPU.MOVE_Y.CHAR		
												
			mv		s3, t2				# Se n�o, move mapa
			j		LPU.ATUALIZA_X
					
LPU.MOVE_Y.CHAR:	# Movimenta o personagem em Y
			la		t0, vertical_alucard
			lw		t1, 0(t0)
			add 		t1, t1, s2
			sw		t1, 0(t0)	
	
															
# Atualiza a posi��o X
LPU.ATUALIZA_X:		loadb(t1, moveX)
			beqz 		t1, LPU.PARADO
			bgtz 		t1, LPU.DIREITA

LPU.ESQUERDA:		# Testa colis�o a esquerda			
			bnez 		a2, LPU.PARADO	
			 
			addi 		t2, s4, -2
			la		t0, mapa.min.x
			lhu 		t3, 0(t0)
			blt		t2, t3, LPU.ESQUERDA.MOVE.CHAR	
			
			la		t0, horizontal_alucard
			lw		t4, (t0)
			li		t5, 120
			bgt 		t4, t5, LPU.ESQUERDA.MOVE.CHAR		
						
LPU.ESQUERDA.MOVE.MAPA:	# Movimenta o mapa em X			
			mv 		s4, t2
			j 		LPU.PARADO
			
LPU.ESQUERDA.MOVE.CHAR:	la 		t1, horizontal_alucard
			lw 		t2, 0(t1)
			addi 		t2, t2, -2
			sw 		t2, 0(t1)
						
			j 		LPU.PARADO
			
LPU.DIREITA:		# Calcula colis�o
			bnez 		a1, LPU.PARADO				# Se bateu em algo, n�o move
								
			addi 		t2, s4, 2
			la		t0, mapa.max.x
			lhu		t3, 0(t0)
			bgt 		t2, t3, LPU.DIREITA.MOVE.CHAR
			
			la		t0, horizontal_alucard
			lw		t4, (t0)
			li		t5, 120
			blt		t4, t5, LPU.DIREITA.MOVE.CHAR
				
LPU.DIREITA.MOVE.MAPA:	# Movimenta o mapa em X			
			mv 		s4, t2
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
			frame_address(a5)					# Endere�o da frame
			loadb(t1, alucard.animacao)
			li 		t2, 88
			blt 		t1, t2,LPU.NAO_RESETA			# Se tiver chegado na ultima anima��o, reseta
			
			li 		t1, 0
			
LPU.NAO_RESETA:
			addi 		t3, t1, 1				# Avan�a um movimento na anima��o
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
ALUCARD.CORRENDO.DIREITA:	# Calcula colis�o
			bnez 		a1, LCD.COLIDIU
								
LCD.MOVE.MAPA:		# Se tiver chegado no final do mapa OU o personagem est� � esquerda do centro da tela, move o personagem
			# Se n�o, move a tela/mapa
			addi 		t2, s4, 2
			la		t0, mapa.max.x
			lhu		t3, (t0)
			bgt		t2, t3 LCD.MOVE.CHAR
			
			la		t0, horizontal_alucard
			lw		t4, (t0)
			li		t5, 120
			blt 		t4, t5, LCD.MOVE.CHAR
			
			mv 		s4, t2
			j 		LCD.COLIDIU
			
LCD.MOVE.CHAR:		la 		t1, horizontal_alucard
			lw 		t2, 0(t1)
			addi 		t2, t2, 2
			sw 		t2, 0(t1)
			
LCD.COLIDIU:		bnez 		a4, LCD.COLIDIU.BAIXO		
		
LCD.MOVE_Y.MAPA:
			# Movimenta o mapa em Y
			add 		t2, s3, s2			# desce velocidadeY pixels
			la		t0, mapa.max.y
			lhu		t3, 0(t0)
			bgt 		t2, t3, LCD.MOVE_Y.CHAR		# Se chegou ao limite inferior do mapa, move o personagem ao inv�s do mapa
			
			mv		s3, t2				# Se n�o, move o mapa
			j 		LCD.COLIDIU.BAIXO

LCD.MOVE_Y.CHAR:	# Movimenta o personagem em Y
			la		t0, vertical_alucard
			lw		t1, 0(t0)
			add 		t1, t1, s2
			sw		t1, 0(t0)
			
LCD.COLIDIU.BAIXO:	# Decrementa uma movimenta��o a direita
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
			frame_address(a5)						# Endere�o da frame
			loadb(t1, alucard.animacao)
			li 		t2, 62
			
			blt 		t1, t2,LCD.NAO_RESETA
			
			li 		t1, 32
			
LCD.NAO_RESETA:
			addi 		t3, t1, 1					# Avan�a um movimento na anima��o
			saveb(t3, alucard.animacao)
			li 		t2, 4
			mul 		t1, t1, t2
			la 		t2, alucard.correndo.direita.offsets
			add 		t2, t2, t1
			lw 		a6, (t2)					# Offset na imagem
			li 		a7, ALUCARD.ALTURA
			j 		ALUCARD.RENDER
# LCE	
ALUCARD.CORRENDO.ESQUERDA:# checa colis�o
			bnez 		a2, LCE.COLIDIU 

ALUCARD.MOVE.MAPA:	# Se tiver chegado no inicio do mapa OU o personagem est� � direita do centro da tela, move o personagem
			# Se n�o, move a tela/mapa		 					 		
			addi 		t2, s4, -2
			la		t0, mapa.min.x
			lhu		t3, 0(t0)
			blt		t2, t3, LCE.MOVE.CHAR
			
			la		t0, horizontal_alucard
			lw		t4, (t0)
			li		t5, 120
			bgt		t4, t5, LCE.MOVE.CHAR			
		
			mv 		s4, t2
			j 		LCE.COLIDIU
			
LCE.MOVE.CHAR:		la 		t1, horizontal_alucard
			lw 		t2, 0(t1)
			addi 		t2, t2, -2
			sw 		t2, 0(t1)
			
LCE.COLIDIU:		# Checa colis�o baixo 
			bnez 		a4, LCE.COLIDIU.BAIXO

LCE.MOVE_Y.MAPA:
			# Movimenta o mapa em Y
			add 		t2, s3, s2			# desce 2 pixels
			la		t0, mapa.max.y
			lhu		t3, 0(t0)
			bgt 		t2, t3, LCE.MOVE_Y.CHAR		# Se tiver chegado no limite inferior do mapa, move o personagem ao inv�s do mapa
			
			mv		s3, t2
			j 		LCE.COLIDIU.BAIXO

LCE.MOVE_Y.CHAR:	# Movimenta o personagem em Y
			la		t0, vertical_alucard
			lw		t1, 0(t0)
			add 		t1, t1, s2
			sw		t1, 0(t0)
			
LCE.COLIDIU.BAIXO:	# Decrementa uma movimenta��o a esquerda
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
			frame_address(a5)						# Endere�o da frame
			loadb(t1, alucard.animacao)
			li 		t2, 62
			blt 		t1, t2,LCE.NAO_RESETA				# Se tiver chegado na �ltima anima��o, recicla
			
			li 		t1, 32
			
LCE.NAO_RESETA:
			addi 		t3, t1, 1					# Avan�a um movimento na anima��o
			saveb(t3, alucard.animacao)
			li 		t2, 4
			mul 		t1, t1, t2
			la 		t2, alucard.correndo.esquerda.offsets
			add 		t2, t2, t1
			lw 		a6, (t2)					# Offset na imagem
			li 		a7, ALUCARD.ALTURA
			j		ALUCARD.RENDER	

# LS	
ALUCARD.SOCANDO:	# checa colis�o abaixo
			bnez		a4, LS.COLIDIU.BAIXO		
	
LS.MOVE_Y:		# Movimenta o mapa em Y
			add 		t2, s3, s2
			la		t0, mapa.max.y
			lhu		t3, 0(t0)
			bgt		t2, t3, LS.MOVE_Y.CHAR		# Se passar do limite inferior do mapa, move o personagem ao inv�s do mapa
			
			la		t0, mapa.min.y
			lhu		t3, 0(t0)
			blt		t2, t3, LS.MOVE_Y.CHAR		# Se passar do limite superior do mapa, move o personagem ao inv�s do mapa	
												
			mv		s3, t2			# Se n�o, move mapa
			j		LS.COLIDIU.BAIXO
					
LS.MOVE_Y.CHAR:		# Movimenta o personagem em Y
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
			frame_address(a5)						# Endere�o da frame
		
			loadb(t1, alucard.animacao)
			li 		t2, 33
			blt 		t1, t2,LS.RENDER				# Se tiver chegado na ultima anima��o, para de socar
			
			saveb(zero, socando)
				
LS.RENDER:		addi 		t3, t1, 1					# Avan�a um movimento na anima��o
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

# Chama a fun��o de renderizar o personagem
ALUCARD.RENDER:		jal		RENDER						# Renderiza o personagem na tela

			jal 		HUD.RENDER
			
			li 		t0,FRAME_SELECT
			sw 		s7,(t0)						# Atualiza a tela para o usu�rio ver as atualiza��es
			
			csrr		s11, 3073					# Guarda o hor�rio da atualiza��o de frame			
			
			j 		LOOP_JOGO					# Retorna ao loop principal


.include "entrada.s"
.include "tela.s"
.include "fisica.s"
.include "render.s"
.include "ost.s"
.include "dialogos.s"
.include "hud.s"

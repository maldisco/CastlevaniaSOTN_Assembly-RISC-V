.data
.include "config/config.s"
.include "config/alucard.s"
.include "config/macros.s"
.text

CASTLEVANIA:		# Carrega arquivo de sprites do personagem principal 
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
			
			# Carrega arquivo de sprites do SANS
			la		a0, sans
			li		a1, 0
			li		a2, 0
			li		a7, 1024
			ecall
			mv		s1, a0
			
			# Carrega arquivo de sprites de numeros
			la		a0, numeros
			li		a1, 0
			li		a2, 0
			li		a7, 1024
			ecall
			mv		s7, a0			# Salva em s7
			
			# Carrega arquivo de sprite da faca
			la		a0, faca
			li		a1, 0
			li		a2, 0
			li		a7, 1024
			ecall
			la		t0, faca.descritor
			sw		a0, (t0)
			
			# Carrega arquivo de sprite da segunda faca
			la		a0, faca2
			li		a1, 0
			li		a2, 0
			li		a7, 1024
			ecall
			sw		a0, 4(t0)
			
			# Carrega arquivo de sprite do coração
			la		a0, coracao
			li		a1, 0
			li		a2, 0
			li		a7, 1024
			ecall
			la		t0, coracao.descritor
			sw		a0, (t0)
			
			# Carrega arquivo de sprite da comidinha
			la		a0, comida
			li		a1, 0
			li		a2, 0
			li		a7, 1024
			ecall
			la		t0, comida.descritor
			sw		a0, (t0)
			
			# Carrega arquivo de sprite do blaster horizontal
			la		a0, blaster_h
			li		a1, 0
			li		a2, 0
			li		a7, 1024
			ecall
			la		t0, blaster_h.descritor
			sw		a0, (t0)
			
			# Carrega arquivo de sprite do blaster vertical
			la		a0, blaster_v
			li		a1, 0
			li		a2, 0
			li		a7, 1024
			ecall
			la		t0, blaster_v.descritor
			sw		a0, (t0)
			
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
			
			# Carrega o arquivo da tela de luta de chefe
			la		a0, telabf
			li		a1, 0
			li		a2, 0
			li		a7, 1024
			ecall		
			sw		a0, 32(t0)
			
			# Carrega o arquivo da segunda versão da tela do jogo
			la		a0, tela10a
			li		a1, 0
			li		a2, 0
			li		a7, 1024
			ecall
			sw		a0, 36(t0)
			
			# Carrega o arquivo da decima primeira tela do jogo
			la		a0, tela11
			li		a1, 0
			li		a2, 0
			li		a7, 1024
			ecall
			sw		a0, 40(t0)
			
			# Carrega o arquivo da parte da frente da decima primeira tela do jogo
			la		a0, tela11f
			li		a1, 0
			li		a2, 0
			li		a7, 1024
			ecall
			sw		a0, 44(t0)
			
			# Carrega o arquivo de mensagens
			la		a0, msg
			li		a1, 0
			li		a2, 0
			li		a7, 1024
			ecall
			la		t0, msg.descritor
			sw		a0, (t0)
			
			li		s0, 0				# Frame atual
			
			li		t0, 10
			fcvt.s.w	fs4, t0				# HP do personagem
			
			li		t0, 1
			fcvt.s.w	fa4, t0				# Sentido do personagem (direita/esquerda)
			
			li		t0, 10
			fcvt.s.w	ft2, t0				# Dano do personagem
			
			la		t0, SALTO			# Aceleração inicial do salto ( Constante)
			flw		fs5, (t0)			
			
			csrr 		s11, 3073			# Guarda tempo atual em s11 (usado para controle de FPS)

			la		t0, GRAVIDADE
			flw		fs1, (t0)			# Aceleração da gravidade (constante)
			
			jal		OST.SETUP
			jal 		config_newgame	
			
			# # # # # # # # # # # # # # # # GLOBAIS # # # # # # # # # # # # # # # #
			# S11 = Tempo da ultima atualizacao de tela                           #
			# S10 = Descritor do arquivo de sprites do alucard                    #
			# S9 = Descritor do arquivo da tela atual                             #
			# S8 = Descritor do arquivo de sprites da HUD                         #
			# S7 = Descritor do arquivo de sprites de números                     #
			# S6 = Posição X do personagem					      #
			# S5 = Posição Y do personagem					      #
			# S4 = Posição X do mapa					      #
			# S3 = Posição Y do mapa					      #
			# S2 = VelocidadeY (INTEIRO)					      #
			# S1 = Descritor do arquivo de sprites do SANS			      #
			# S0 = Frame atual						      #
			# ------------------------------------------------------------------- #
			# FS0 = HP do inimigo						      #
			# FS1 = Gravidade						      #
			# FS2 = VelocidadeY						      #
			# FS3 = move X (Quantidade de movimentos no eixo X)		      #
			# FS4 = HP do personagem					      #
			# FS5 = Salto (Movido para fs2 sempre que pular)(Constante)           #
			# FS6 = Posição X da faca					      #
			# FS7 = Posição Y da faca					      #
			# FS8 = Posição Y do BlasterH					      #
			# FS9 = Posição X do BlasterV					      #
			# FS10 = Posição Y do inimigo					      #
			# FS11 = Posição X do inimigo					      #
			# ------------------------------------------------------------------- # 
			# FA0 = Sinal de controle SANS/inimigo				      #
			# FA1 = Sinal de controle corte Alucard				      #
			# FA2 = Sinal de controle pulo Alucard				      #
			# FA3 = Sinal de controle faca Alucard			     	      #
			# FA4 = Sinal de controle sentido (direita/esquerda) Alucard          #
			# FA5 = Sinal de controle faca					      #
			# FA6 = Sinal de controle faca habilitada	 		      #
			# FA7 = Sinal de controle objeto				      #
			# ------------------------------------------------------------------- #
			# FT11 = Contador de animação Alucard				      #
			# FT10 = Contador de animação HUD				      #
			# FT9 = Contador de animação SANS				      #
			# FT8 = Contador de animação BlasterH				      #
			# FT7 = Contador de animação BlasterV				      #
			# FT6 = Sinal de controle BlasterH				      #
			# FT5 = Sinal de controle BlasterV				      #
			# FT4 = Sinal de controle Mensagem				      #
			# FT3 = Sinal de controle Mapa frente				      #
			# FT2 = Dano do personagem					      #
			# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
							

LOOP_JOGO:		csrr 		t0, 3073
			sub 		t0, t0, s11
			li 		t1, 16
			bltu 		t0, t1, LOOP_JOGO			# Se ainda não tiverem passado 16 Milissegundos, não começa
			
			xori 		s0, s0, 1				# Troca a frame para o usuário não ver as atualizações
			jal		OST.TOCA
			jal		OST.TOCA_2
			jal 		ENTRADA					# Trata a entrada do usuário no teclado
			
# Renderiza o mapa
MAPA.RENDER:		mv		a0, s9					# Descritor do arquivo
			li		a1, 0					# X na tela
			li 		a2, 0					# Y na tela
			la		t1, mapa.imagem.largura			# Largura do arquivo
			lhu		a3, 0(t1)			
			li 		a4, MAPA.LARGURA			# Largura do mapa
			frame_address(a5)					# Endereço da frame atual
			offset_mapa(a6)						# Offset no arquivo
			li 		a7, MAPA.ALTURA				# Altura do mapa
			jal		RENDER					# render.s
			
# Atualiza a animação do SANS (se ele existir)
SANS.ATUALIZA:		fcvt.w.s	t0, fa0					# fa0 = Sinal de controle inimigo
			li		t1, 1					# 1 = SANS
			bne		t0, t1, ALUCARD.ATUALIZA
			
			fcvt.w.s	t0, fs0
			blez		t0, SANS.FERIDO				# Se o hp do sans chegou a 0, pula para animação de derrota
			
			la		t0, sans.acao
			lb		t4, (t0)
			bgtz		t4, SANS.DESCE
			beqz		t4, SANS.SOBE

SANS.PARADO:		mv		a0, s1					# Geração dos parametros (a0-a7) para renderizar o SANS
			fcvt.w.s	a1, fs11				# Checar render.s para melhor entendimento
			fcvt.w.s	a2, fs10
			li		a3, SANS.IMAGEM.LARGURA
			li		a4, SANS.LARGURA
			frame_address(a5)
			la		t0,sans.parado.offsets			# Cada estágio da animação é um offset diferente na sprite
			fcvt.w.s	t1, ft9
			li		t2, 4
			div		t3, t1, t2
			mul		t2, t2, t3
			add		t0, t0, t2
			lw		a6, (t0)
			addi		t1, t1, 1		
			li		t2, 76					# 76 = último estágio de animação
			blt		t1, t2, SANS.RENDER
			
			li		t1, 0
			la		t0, sans.acao
			addi		t4,t4,1
			sb		t4, (t0)
			j		SANS.RENDER

SANS.SOBE:		mv		a0, s1					# Geração dos valores para renderização
			fcvt.w.s	a1, fs11				
			fcvt.w.s	a2, fs10
			li		a3, SANS.IMAGEM.LARGURA
			li		a4, SANS.LARGURA
			frame_address(a5)
			la		t0, sans.sobe.offsets
			fcvt.w.s	t1, ft9
			li		t2, 4
			mul		t2, t2, t1
			add		t0, t0, t2
			lw		a6, (t0)
			addi		t1, t1, 1
			li		t2, 19
			blt		t1, t2, SANS.RENDER
			
			li		t1, 1
			fcvt.s.w	ft5, t1					# Ativa o blaster vertical
			li		t1, ALUCARD.HITBOX_OFFSET.X
			add		t1,s6,t1
			fcvt.s.w	fs9,t1					# Posição X do blaster = X do personagem + hitbox offset
			li		t1, 0
			la		t0, sans.acao
			addi		t4,t4,1
			sb		t4, (t0)
			j		SANS.RENDER
			
SANS.DESCE:		mv		a0, s1					# Geração dos valores para renderização
			fcvt.w.s	a1, fs11				
			fcvt.w.s	a2, fs10
			li		a3, SANS.IMAGEM.LARGURA
			li		a4, SANS.LARGURA
			frame_address(a5)
			la		t0, sans.desce.offsets
			fcvt.w.s	t1, ft9
			li		t2, 4
			mul		t2, t2, t1
			add		t0, t0, t2
			lw		a6, (t0)
			addi		t1, t1, 1
			li		t2, 19
			blt		t1, t2, SANS.RENDER
			
			li		t1, 1
			fcvt.s.w	ft6, t1					# Ativa o blaster horizontal
			li		t1, ALUCARD.HITBOX_OFFSET.Y
			add		t1, s5, t1
			fcvt.s.w	fs8, t1					# Posição Y do blaster = Y do personagem + hitbox offset
			li		t1, 0
			la		t0, sans.acao
			li		t4, -1
			sb		t4, (t0)
			j		SANS.RENDER
			
SANS.FERIDO:		mv		a0, s1					# Geração dos valores para renderização
			li		a1, SANS.X
			li		a2, SANS.Y
			li		a3, SANS.IMAGEM.LARGURA
			li		a4, SANS.LARGURA
			frame_address(a5)
			la		t0, sans.ferido.offsets
			fcvt.w.s	t1, ft9
			li		t2, 4
			li		t3, 8
			div		t3, t1, t3
			mul		t2, t2, t3			
			add		t0, t0, t2
			lw		a6, (t0)
			addi		t1, t1, 1
			li		t2, 152
			blt		t1, t2, SANS.RENDER
			
			j		TELA_BF.PARA.TELA_4			# Volta para o mapa normal
			
SANS.RENDER:		fcvt.s.w	ft9, t1
			li		a7, SANS.ALTURA
			jal		RENDER

# Atualiza o ataque BLASTER (sans) na horizontal
BLASTER_H.ATUALIZA:	fcvt.w.s	t1, ft6
			beqz		t1, ALUCARD.ATUALIZA
			
			la		t0, blaster_h.descritor			# Geração ds valores para renderização
			lw		a0, (t0)
			li		a1, BLASTER_H.X
			fcvt.w.s	a2, fs8
			li		a3, BLASTER_H.IMAGEM.LARGURA
			li		a4, BLASTER_H.LARGURA
			frame_address(a5)
			la		t0, blaster_h.offsets
			fcvt.w.s	t1, ft8
			li		t2, 4
			div		t3, t1, t2
			mul		t2, t2, t3
			add		t0, t0, t2
			lw		a6, (t0)
			addi		t1, t1, 1
			li		t2, 76
			blt		t1, t2, BLASTER_H.RENDER
			
			fcvt.s.w	ft6, zero
			fcvt.s.w	ft8, zero
			j 		BLASTER_V.ATUALIZA			# Na ultima animação, desliga o ataque
			
BLASTER_H.RENDER:	fcvt.s.w	ft8, t1
			li		a7, BLASTER_H.ALTURA
			jal 		RENDER
			
			# A partir da animação 60 (começou o raio branco)
			fcvt.w.s	t1, ft8
			li		t2, 60					
			blt		t1, t2, BLASTER_V.ATUALIZA
			
			# Se o limite superior do blaster está acima do limite inferior da hitbox do personagem
			fcvt.w.s	t1, fs8
			li		t2, ALUCARD.HITBOX_OFFSET.Y
			add		t2, s5, t2
			addi		t3, t2, 47				# Limite inferior da hitbox do alucard
			bgt		t1, t3, BLASTER_V.ATUALIZA
			
			# E o limite inferior do blaster está abaixo do limite superior do personagem
			li		t3, BLASTER_H.ALTURA
			add		t3, t1, t3
			blt		t3, t2, BLASTER_V.ATUALIZA
			
			# Personagem perde 1 de vida
			li		t1, -1
			fcvt.s.w	ft0, t1
			fadd.s		fs4, fs4, ft0

# Atualiza o ataque BLASTER (sans) na vertical			
BLASTER_V.ATUALIZA:	fcvt.w.s	t1, ft5
			beqz		t1, ALUCARD.ATUALIZA
			
			la		t0, blaster_v.descritor			# Geração dos valores para renderização
			lw		a0, (t0)
			fcvt.w.s	a1, fs9
			li		a2, BLASTER_V.Y
			li		a3, BLASTER_V.IMAGEM.LARGURA
			li		a4, BLASTER_V.LARGURA
			frame_address(a5)
			la		t0, blaster_v.offsets
			fcvt.w.s	t1, ft7
			li		t2, 4
			div		t3, t1, t2
			mul		t2, t2, t3
			add		t0, t0, t2
			lw		a6, (t0)
			addi		t1, t1, 1
			li		t2, 64
			blt		t1, t2, BLASTER_V.RENDER
		
			fcvt.s.w	ft5, zero
			fcvt.s.w	ft7, zero
			j		ALUCARD.ATUALIZA			# Na última animação, desliga o ataque
			
BLASTER_V.RENDER:	fcvt.s.w	ft7, t1
			li		a7, BLASTER_V.ALTURA
			jal 		RENDER
			
			# A partir da animação 60 (começou o raio branco)
			fcvt.w.s	t1, ft7
			li		t2, 60
			blt		t1, t2, ALUCARD.ATUALIZA
			
			# Se o limite esquerdo do blaster está a esquerda do limite direito da hitbox do personagem
			fcvt.w.s	t1, fs9
			li		t2, ALUCARD.HITBOX_OFFSET.X
			add		t2, s6, t2
			addi		t3, t2, 20				# Limite direito da hitbox do alucard
			bgt		t1, t3, ALUCARD.ATUALIZA
			
			# E o limite direito do blaster está a direita do limite esquerdo do personagem
			li		t3, BLASTER_V.LARGURA
			add		t3, t1, t3
			blt		t3, t2, ALUCARD.ATUALIZA
			
			# Personagem perde 1 de vida
			li		t1, -1
			fcvt.s.w	ft0, t1
			fadd.s		fs4, fs4, ft0

# Atualiza a posição da personagem
ALUCARD.ATUALIZA:	jal 		FISICA
			# Retorna booleanos (1 = True, 0 = False)
			#		a1 = Colisão à direita
			#		a2 = Colisão à esquerda
			#		a3 = Colisão acima
			#		a4 = Colisão abaixo
			 	
			fcvt.w.s	t1, fa1
			bnez 		t1, ALUCARD.SOCANDO
			fcvt.w.s	t1, fa3
			bgtz		t1, ALUCARD.FACA
			fcvt.w.s	t1, fa2
			bnez 		t1, ALUCARD.PULANDO
			fcvt.w.s	t1, fs3				
			bgtz 		t1, ALUCARD.CORRENDO.DIREITA
			bltz 		t1, ALUCARD.CORRENDO.ESQUERDA			
			
# LP
ALUCARD.PARADO:		bnez 		a4, AP.COLIDIU.BAIXO		# Checa se colidiu com o chão
			
						
AP.MOVE.MAPA:		add 		t2, s3, s2			# desce 2 pixels
			la 		t0, mapa.max.y
			lhu		t3, 0(t0)
			bgt 		t2, t3, AP.MOVE.CHAR		# Se passar do Limite inferior do mapa, move o personagem ao invés do mapa
			
			mv		s3, t2				# Se não, move mapa
			j 		AP.COLIDIU.BAIXO

AP.MOVE.CHAR:		# Movimenta o personagem em Y
			add 		s5, s5, s2
					
AP.COLIDIU.BAIXO:	# Gera os valores para renderizar
			mv 		a0, s10				# Descritor
			mv		a1, s6				# X na tela
			mv		a2, s5				# Y na tela
			li 		a3, ALUCARD.OFFSET		# Largura da imagem
			li 		a4, ALUCARD.LARGURA		# Largura da sprite
			frame_address(a5)				# Endereço da frame
			fcvt.w.s	t1, ft11			# ft11 =  Contador de animação Alucard
			li 		t2, 48
			blt 		t1, t2,AP.NAORESETA
			
			li		t1, 0
			
AP.NAORESETA:
			addi 		t3, t1, 1			# Avança um movimento na animação
			fcvt.s.w	ft11, t3
			li 		t2, 4
			mul 		t1, t1, t2
			la 		t2, alucard.parado.direita.offsets
			fcvt.w.s	t3, fa4				
			bgtz 		t3, AP.SENTIDO.DIREITA
			
			la 		t2 alucard.parado.esquerda.offsets
			
AP.SENTIDO.DIREITA:	add 		t2, t2, t1
			lw 		a6, (t2)			# Offset na imagem
			li 		a7, ALUCARD.ALTURA
			j 		ALUCARD.RENDER
# LPU	
ALUCARD.PULANDO:		# Atualiza a posição Y
			fcvt.s.w 	ft0, zero
			flt.s		t1, fs2, ft0			# t1 = 1 if ft1 < ft0 else 0
					
			bnez		t1, APU.SUBINDO
			
APU.DESCENDO:		# Checa se já caiu no chão
			beqz 		a4, APU.MOVE_Y
			
			fcvt.s.w	fa2, zero 			# Zera o sinal de controle de pulo
			j 		APU.ATUALIZA_X	
				
APU.SUBINDO:		# Checa se bateu no teto
			beqz 		a3, APU.MOVE_Y
	
			j 		APU.ATUALIZA_X	
				
APU.MOVE_Y:		# Movimenta o mapa em Y
			add 		t2, s3, s2
			la		t0, mapa.max.y
			lhu		t3, 0(t0)
			bgt		t2, t3, APU.MOVE_Y.CHAR		# Se passar do limite inferior do mapa, move o personagem ao invés do mapa
			
			la		t0, mapa.min.y
			lhu		t3, 0(t0)
			blt		t2, t3, APU.MOVE_Y.CHAR		# Se passar do limite superior do mapa, move o personagem ao invés do mapa
							
			li 		t4, 130
			bgt		s5, t4, APU.MOVE_Y.CHAR		# Se o personagem está acima da metade da tela, move o personagem ao invés do mapa
												
			mv		s3, t2				# Se não, move mapa
			j		APU.ATUALIZA_X
					
APU.MOVE_Y.CHAR:	# Movimenta o personagem em Y
			add 		s5, s5, s2	
															
APU.ATUALIZA_X:		# Atualiza a posição X
			fcvt.w.s	t1, fs3				
			beqz 		t1, APU.PARADO
			bgtz 		t1, APU.DIREITA

APU.ESQUERDA:		# Testa colisão a esquerda			
			bnez 		a2, APU.PARADO	
			 
			addi 		t2, s4, -2
			la		t0, mapa.min.x
			lhu 		t3, 0(t0)
			blt		t2, t3, APU.ESQUERDA.MOVE.CHAR	
			
			li		t5, 120
			bgt 		s6, t5, APU.ESQUERDA.MOVE.CHAR		
						
APU.ESQUERDA.MOVE.MAPA:	# Movimenta o mapa em X			
			mv 		s4, t2
			j 		APU.PARADO
			
APU.ESQUERDA.MOVE.CHAR:	addi 		s6, s6, -2
			j 		APU.PARADO
			
APU.DIREITA:		# Calcula colisão
			bnez 		a1, APU.PARADO				# Se bateu em algo, não move
								
			addi 		t2, s4, 2
			la		t0, mapa.max.x
			lhu		t3, 0(t0)
			bgt 		t2, t3, APU.DIREITA.MOVE.CHAR
			
			li		t5, 120
			blt		s6, t5, APU.DIREITA.MOVE.CHAR
				
APU.DIREITA.MOVE.MAPA:	# Movimenta o mapa em X			
			mv 		s4, t2
			j 		APU.PARADO
			
APU.DIREITA.MOVE.CHAR:	addi 		s6, s6, 2
						
APU.PARADO:	# Gera os valores para renderizar
			mv 		a0, s10					# Descritor
			mv		a1, s6					# X na tela
			mv		a2, s5				    	# Y na tela 
			li 		a3, ALUCARD.OFFSET			# Largura da imagem
			li 		a4, ALUCARD.LARGURA			# Largura da sprite
			frame_address(a5)					# Endereço da frame
			fcvt.w.s	t1, ft11				# ft11 =  Contador de animação Alucard
			li 		t2, 88
			blt 		t1, t2,APU.NAO_RESETA			# Se tiver chegado na ultima animação, reseta
			
			li 		t1, 0
			
APU.NAO_RESETA:
			addi 		t3, t1, 1				# Avança um movimento na animação
			fcvt.s.w	ft11, t3
			li 		t2, 4
			mul 		t1, t1, t2
			la 		t2, alucard.pulando.direita.offsets
			fcvt.w.s	t3, fa4	
			bgtz 		t3, APU.SENTIDO.DIREITA
			
			la 		t2 alucard.pulando.esquerda.offsets
			
APU.SENTIDO.DIREITA:
			add 		t2, t2, t1
			lw 		a6, (t2)				# Offset na imagem
			li 		a7, ALUCARD.ALTURA
			j 		ALUCARD.RENDER

# LCD			
ALUCARD.CORRENDO.DIREITA:	# Calcula colisão
			bnez 		a1, ACD.COLIDIU
								
ACD.MOVE.MAPA:		# Se tiver chegado no final do mapa OU o personagem está à esquerda do centro da tela, move o personagem
			# Se não, move a tela/mapa
			addi 		t2, s4, 2
			la		t0, mapa.max.x
			lhu		t3, (t0)
			bgt		t2, t3 ACD.MOVE.CHAR
			
			li		t5, 120
			blt 		s6, t5, ACD.MOVE.CHAR
			
			mv 		s4, t2
			j 		ACD.COLIDIU
			
ACD.MOVE.CHAR:		addi 		s6, s6, 2
			
ACD.COLIDIU:		bnez 		a4, ACD.COLIDIU.BAIXO		
		
ACD.MOVE_Y.MAPA:
			# Movimenta o mapa em Y
			add 		t2, s3, s2				# desce velocidadeY pixels
			la		t0, mapa.max.y
			lhu		t3, 0(t0)
			bgt 		t2, t3, ACD.MOVE_Y.CHAR			# Se chegou ao limite inferior do mapa, move o personagem ao invés do mapa
			
			mv		s3, t2					# Se não, move o mapa
			j 		ACD.COLIDIU.BAIXO

ACD.MOVE_Y.CHAR:	# Movimenta o personagem em Y
			add 		s5, s5, s2
			
ACD.COLIDIU.BAIXO:	# Decrementa uma movimentação a direita
			li		t0, -1
			fcvt.s.w	ft0, t0
			fadd.s		fs3, fs3, ft0
			# Gera os valores para renderizar
			mv 		a0, s10					# Descritor
			mv		a1, s6					# X na tela
			mv		a2, s5					# Y na tela
			li 		a3, ALUCARD.OFFSET			# Largura da imagem
			li 		a4, ALUCARD.LARGURA			# Largura da sprite
			frame_address(a5)					# Endereço da frame
			fcvt.w.s	t1, ft11				# ft11 =  Contador de animação Alucard
			li 		t2, 62
			
			blt 		t1, t2,ACD.NAO_RESETA
			
			li 		t1, 32
			
ACD.NAO_RESETA:
			addi 		t3, t1, 1				# Avança um movimento na animação
			fcvt.s.w	ft11, t3
			li 		t2, 4
			mul 		t1, t1, t2
			la 		t2, alucard.correndo.direita.offsets
			add 		t2, t2, t1
			lw 		a6, (t2)				# Offset na imagem
			li 		a7, ALUCARD.ALTURA
			j 		ALUCARD.RENDER
# LCE	
ALUCARD.CORRENDO.ESQUERDA:# checa colisão
			bnez 		a2, ACE.COLIDIU 

ACE.MOVE.MAPA:	# Se tiver chegado no inicio do mapa OU o personagem está à direita do centro da tela, move o personagem
			# Se não, move a tela/mapa		 					 		
			addi 		t2, s4, -2
			la		t0, mapa.min.x
			lhu		t3, 0(t0)
			blt		t2, t3, ACE.MOVE.CHAR
			
			li		t5, 120
			bgt		s6, t5, ACE.MOVE.CHAR			
		
			mv 		s4, t2
			j 		ACE.COLIDIU
			
ACE.MOVE.CHAR:		addi 		s6, s6, -2
			
ACE.COLIDIU:		# Checa colisão baixo 
			bnez 		a4, ACE.COLIDIU.BAIXO

ACE.MOVE_Y.MAPA:
			# Movimenta o mapa em Y
			add 		t2, s3, s2			# desce 2 pixels
			la		t0, mapa.max.y
			lhu		t3, 0(t0)
			bgt 		t2, t3, ACE.MOVE_Y.CHAR		# Se tiver chegado no limite inferior do mapa, move o personagem ao invés do mapa
			
			mv		s3, t2
			j 		ACE.COLIDIU.BAIXO

ACE.MOVE_Y.CHAR:	# Movimenta o personagem em Y
			add 		s5, s5, s2
			
ACE.COLIDIU.BAIXO:	# Decrementa uma movimentação a esquerda
			li		t0, 1
			fcvt.s.w	ft0, t0
			fadd.s		fs3, fs3, ft0
			# Gera os valores para renderizar
			mv 		a0, s10					# Descritor
			mv		a1, s6					# X na tela
			mv		a2, s5					# Y na tela
			li 		a3, ALUCARD.OFFSET			# Largura da imagem
			li 		a4, ALUCARD.LARGURA			# Largura da sprite
			frame_address(a5)					# Endereço da frame
			fcvt.w.s	t1, ft11				# ft11 =  Contador de animação Alucard
			li 		t2, 62
			blt 		t1, t2,ACE.NAO_RESETA			# Se tiver chegado na última animação, recicla
			
			li 		t1, 32
			
ACE.NAO_RESETA:
			addi 		t3, t1, 1				# Avança um movimento na animação
			fcvt.s.w	ft11, t3
			li 		t2, 4
			mul 		t1, t1, t2
			la 		t2, alucard.correndo.esquerda.offsets
			add 		t2, t2, t1
			lw 		a6, (t2)				# Offset na imagem
			li 		a7, ALUCARD.ALTURA
			j		ALUCARD.RENDER	

# LS	
ALUCARD.SOCANDO:	# checa colisão abaixo
			bnez		a4, AS.COLIDIU.BAIXO	
			bnez		a3, AS.COLIDIU.BAIXO	
	
AS.MOVE_Y:		# Movimenta o mapa em Y
			add 		t2, s3, s2
			la		t0, mapa.max.y
			lhu		t3, 0(t0)
			bgt		t2, t3, AS.MOVE_Y.CHAR			# Se passar do limite inferior do mapa, move o personagem ao invés do mapa
			
			la		t0, mapa.min.y
			lhu		t3, 0(t0)
			blt		t2, t3, AS.MOVE_Y.CHAR			# Se passar do limite superior do mapa, move o personagem ao invés do mapa	
												
			mv		s3, t2					# Se não, move mapa
			j		AS.COLIDIU.BAIXO
					
AS.MOVE_Y.CHAR:		# Movimenta o personagem em Y
			add 		s5, s5, s2	
			
AS.COLIDIU.BAIXO:	# Gera os valores para renderizar
			mv 		a0, s10					# Descritor
			mv		a1, s6					# X na tela
			mv		a2, s5					# Y na tela
			li 		a3, ALUCARD.OFFSET			# Largura da imagem
			li 		a4, ALUCARD.LARGURA			# Largura da sprite
			frame_address(a5)					# Endereço da frame
			fcvt.w.s	t1, ft11				# ft11 =  Contador de animação Alucard
			li 		t2, 17
			blt 		t1, t2,AS.RENDER			# Se tiver chegado na ultima animação, para de socar
			
			fcvt.s.w	fa1, zero
			j		FACA.ATUALIZA
				
AS.RENDER:		addi 		t3, t1, 1				# Avança um movimento na animação
			fcvt.s.w	ft11, t3
			li 		t2, 4
			mul 		t1, t1, t2
			la 		t2, alucard.socando.direita.offsets
			fcvt.w.s	t3, fa4	
			bgtz 		t3, AS.SENTIDO.DIREITA
			
			la 		t2, alucard.socando.esquerda.offsets			
AS.SENTIDO.DIREITA:
			add 		t2, t2, t1
			lw 		a6, (t2)					# Offset na imagem
			li 		a7, ALUCARD.ALTURA
			
			jal		COLISAO.INIMIGO
			j		ALUCARD.RENDER
			
# LF	
ALUCARD.FACA:		# checa colisão abaixo
			bnez		a4, AF.COLIDIU.BAIXO	
			
			bnez		a3, AF.COLIDIU.BAIXO	
	
AF.MOVE_Y:		# Movimenta o mapa em Y
			add 		t2, s3, s2
			la		t0, mapa.max.y
			lhu		t3, 0(t0)
			bgt		t2, t3, AF.MOVE_Y.CHAR		# Se passar do limite inferior do mapa, move o personagem ao invés do mapa
			
			la		t0, mapa.min.y
			lhu		t3, 0(t0)
			blt		t2, t3, AF.MOVE_Y.CHAR		# Se passar do limite superior do mapa, move o personagem ao invés do mapa	
												
			mv		s3, t2			# Se não, move mapa
			j		AF.COLIDIU.BAIXO
					
AF.MOVE_Y.CHAR:		# Movimenta o personagem em Y
			add 		s5, s5, s2	
			
AF.COLIDIU.BAIXO:	# Gera os valores para renderizar
			mv 		a0, s10						# Descritor
			mv		a1, s6						# X na tela
			mv		a2, s5						# Y na tela
			li 		a3, ALUCARD.OFFSET				# Largura da imagem
			li 		a4, ALUCARD.LARGURA				# Largura da sprite
			frame_address(a5)						# Endereço da frame
			fcvt.w.s	t1, ft11					# ft11 =  Contador de animação Alucard
			li 		t2, 7
			blt 		t1, t2,AF.RENDER				# Se tiver chegado na ultima animação, para de socar
			
			fcvt.s.w	fa3, zero
				
AF.RENDER:		addi 		t3, t1, 1					# Avança um movimento na animação
			fcvt.s.w	ft11, t3
			li 		t2, 4
			mul 		t1, t1, t2
			la 		t2, alucard.faca.direita.offsets
			fcvt.w.s	t3, fa4	
			bgtz 		t3, AF.SENTIDO.DIREITA
			
			la 		t2, alucard.faca.esquerda.offsets			
AF.SENTIDO.DIREITA:
			add 		t2, t2, t1
			lw 		a6, (t2)					# Offset na imagem
			li 		a7, ALUCARD.ALTURA
			
# Chama a função de renderizar o personagem
ALUCARD.RENDER:		jal		RENDER						# Renderiza o personagem na tela

# Renderiza a faca arremessada, se houver
FACA.ATUALIZA:		fcvt.w.s	t1, fa5
			beqz		t1, OBJETO.RENDER
			
			fcvt.w.s	t1, fa4	
			bltz		t1, FACA.ESQUERDA
			
			fcvt.w.s	t1, fs6
			
			li		a1, 320
			sub		a1, a1, t1
			li		a2, OBJETO.LARGURA
			call		MIN
			mv		a4, a0						# Largura da faca
			
			blez		a4, FACA.PARA					# Se a largura < 0, para de renderizar
			
			li		a6, 0						# Offset na imagem
			
			mv		a1, t1						# Posição X da faca			
			addi		t1, t1, 8
			fcvt.s.w	fs6, t1						# Atualiza posição da faca
			
			
			la		t0, faca.descritor
			lw		a0, (t0)
			j		FACA.RENDER
			
FACA.ESQUERDA:		fcvt.w.s	t1, fs6
			
			addi		t2, t1, 30					
			blez		t2, FACA.PARA
			
			mv		a1, t1
			addi		t1, t1, -8
			fcvt.s.w	fs6, t1						# Guarda nova posição X da faca
			li		a2, 0
			call		MAX
			mv		t1, a0						# Posição X da faca
			
			li		a1, -1
			mul		a1, a1, t1
			li		a2, 0
			call		MAX
			mv		a6, a0						# Offset na imagem
			
			li		a4, 30
			sub		a4, a4, a6					# Largura 
			
			mv		a1, t1
			
			la		t0, faca.descritor
			lw		a0, 4(t0)

FACA.RENDER:		fcvt.w.s	a2, fs7
			li		a3, OBJETO.IMAGEM.LARGURA
			frame_address(a5)
			li		a7, OBJETO.ALTURA
						
			# Se o sans estiver ligado
			fcvt.w.s	t0, fa0
			li		t1, 1
			bne		t0, t1, FACA.RENDER.START
			
			fcvt.w.s	t1, fs10				# Y do inimigo
			fcvt.w.s	t2, fs11				# X do inimigo
			
			addi		t3, a2, 9				# Limite inferior da Hitbox da faca
			blt		t3, t1, FACA.RENDER.START
			
			addi		t1, t1, 71				# Limite inferior da Hitbox do inimigo
			addi		t3, a2, 0				# Limite superior da Hitbox da faca
			bgt		t3, t1, FACA.RENDER.START
			
			addi		t3, a1, 30				# Limite direito da hitbox da faca
			blt		t3, t2, FACA.RENDER.START
			
			addi		t2, t2, 62				# Limite direito da hitbox do inimigo
			addi		t3, a1, 0				# Limite esquerdo da hitbox da faca
			bgt		t3, t2, FACA.RENDER.START
			
			fsub.s		fs0, fs0, ft2				# ft2 = dano do personagem
			fcvt.s.w	fa5, zero				# para de renderizar a faca
			jal		SANS.TELEPORTA				# fisica.s
			
FACA.RENDER.START:	jal 		RENDER
			j		OBJETO.RENDER

FACA.PARA:		fcvt.s.w	fa5, zero					# Desliga o sinal de renderização da faca
			

# Renderiza um objeto na tela (se tiver)
OBJETO.RENDER:		fcvt.w.s	t1, fa7
			beqz		t1, MAPA_FRENTE.RENDER					# Se não tiver objeto na tela, pula
			
			la		t0, objeto.x
			lhu		t1, (t0)
			addi		t2, t1, 30
			
			blt		t2, s4, MAPA_FRENTE.RENDER			# Se o objeto estiver à esquerda da camera, pula
			
			la		t0, objeto.y
			lhu		t2, (t0)
			
			addi		t3, s3, 240
			bgt		t2, t3, MAPA_FRENTE.RENDER			# Se o objeto estiver abaixo da camera, pula
			
			sub		t1, t1, s4					# Posição X do objeto na tela
			sub		t2, t2, s3					# Posição Y do objeto na tela
			
			addi		t4, s5, 64					# Posição Y do pé do personagem na tela
			addi		t5, s6, 38					# Posição X da esquerda do personagem na tela
			addi		t6, s6, 58
			
			addi		t3, t1, 22
			bgt		t5, t3, OBJETO.NAO_PEGOU
			blt		t6, t1, OBJETO.NAO_PEGOU
			bgt		t2, t4, OBJETO.NAO_PEGOU	
			
			jal		OBJETO.ACOES					# Se pegou o objeto, faz as ações do objeto alvo
			jal		OST.OBJETO					# Toca o efeito sonoro 
			j		MAPA_FRENTE.RENDER				
			
OBJETO.NAO_PEGOU:	li		a1, -1
			mul		a1, a1, t1	
			li		a2, 0
			jal 		MAX						
			mv		a6, a0
			
			li		a4, 30
			sub		a4, a4, a6
			
			mv		a1, t1
			li		a2, 0
			jal		MAX
			mv		a1, a0
			
			la		t0, objeto.descritor				# Geração de valores para renderização
			lw		a0, (t0)
			mv		a2, t2
			li		a3, OBJETO.IMAGEM.LARGURA
			frame_address(a5)
			li		a7, OBJETO.ALTURA
			jal 		RENDER

# Renderiza o mapa
MAPA_FRENTE.RENDER:	# Impressão (se tiver) da parte da tela que fica à frente do personagem 
			fcvt.w.s	t0, ft3
			beqz		t0, HUD.RENDER
			
			la		t0, TELA.DESCRITORES				# Geração dos valores para renderização			
			lw		a0, 44(t0)
			li		a1, 0		
			li 		a2, 0
			li		a3, 320
			li 		a4, MAPA.LARGURA		
			frame_address(a5)
			li		a6, 0
			li 		a7, MAPA.ALTURA
			jal		RENDER

# Renderiza os elementos da HUD 		
HUD.RENDER:		fcvt.w.s	t0, fs4
			bgtz		t0, HUD.RENDER.START			# Se o hp do personagem estiver em 0, game over
			
			j		GAME_OVER
					
			# Barra de status
HUD.RENDER.START:	mv		a0, s8
			li		a1, 0		
			li 		a2, 0
			li		a3, HUD.IMAGEM.LARGURA
			li 		a4, HUD.LARGURA		
			frame_address(a5)
			fcvt.w.s	t1, ft10				# ft10 = Contador de animação da HUD
			li		t2, 4
			mul		t2, t2, t1
			la		t3, hud.offsets
			add		t3, t3, t2
			lw		a6, (t3)				# Offset atual na imagem da HUD
			
			addi		t1, t1, 1
			li		t2, 28
			blt		t1, t2, HUD.NAO_RESETA
			
			li		t1, 0
			
HUD.NAO_RESETA:		fcvt.s.w	ft10, t1
			
			li 		a7, HUD.ALTURA
			jal		RENDER
		
			# HP
			fcvt.w.s	t6, fs4					# t6 = HP (inteiro)

			li		t0, 10
			div		t1, t6, t0				# t1 = primeiro digito do HP
			
			li		t0, 8
			mul		t1, t1, t0				# t1 = Offset da sprite do primeiro digito
	
			mv		a0, s7
			li		a1, 7		
			li 		a2, 20
			li		a3, NUMEROS.IMAGEM.LARGURA
			li 		a4, NUMEROS.LARGURA		
			frame_address(a5)
			mv		a6, t1
			li		a7, NUMEROS.ALTURA
			jal		RENDER
			
			li		t0, 10
			rem		t2, t6, t0				# t2 = segundo digito do HP
			
			li		t0, 8
			mul		t2, t2, t0				# t2 = Offset da sprite do segundo digito				
															
			mv		a0, s7
			li		a1, 14		
			li 		a2, 20
			li		a3, NUMEROS.IMAGEM.LARGURA
			li 		a4, NUMEROS.LARGURA		
			frame_address(a5)
			mv		a6, t2
			li		a7, NUMEROS.ALTURA
			jal		RENDER
			
# Renderiza mensagem na tela (level up, got an item...)
MSG.RENDER:		fcvt.w.s	t1, ft4
			beqz		t1, MOSTRA_FRAME
			
			la		t0, msg.descritor				# Geração dos valores para renderizar a mensagem
			lw		a0, (t0)					# Checar render.s para entender os parametros
			mv		a1, s6
			mv 		a2, s5
			li		a3, 100
			li 		a4, 98		
			frame_address(a5)
			addi		t1, t1, -1
			li		t2, 20
			mul		t2, t2, t1
			li		t3, 100
			mul		a6, t3, t2
			li 		a7, 20
			jal		RENDER
			
			li 		t0,FRAME_SELECT
			sw 		s0,(t0)						# Atualiza a tela forçadamente
			
			li		a0, 500
			li		a7, 32
			ecall
			
			fcvt.s.w	ft4, zero

MOSTRA_FRAME:		li 		t0,FRAME_SELECT
			sw 		s0,(t0)						# Atualiza a tela para o usuário ver as atualizações
			
			csrr		s11, 3073					# Guarda o horário da atualização de frame			
			
			j 		LOOP_JOGO					# Retorna ao loop principal


.include "procs/entrada.s"
.include "procs/tela.s"
.include "procs/fisica.s"
.include "procs/render.s"
.include "procs/ost.s"
.include "procs/dialogos.s"
.include "procs/common.s"

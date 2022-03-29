.eqv FRAME_0		0xff000000
.eqv FRAME_1		0xff100000
.eqv FRAME_SELECT	0xff200604

.eqv UP			0x77	# 'W'
.eqv DOWN		0x73	# 'S'
.eqv LEFT		0x61	# 'A'
.eqv RIGHT		0x64	# 'D'
.eqv SELECT		0x65	# 'E'

.eqv MMIO_set			0xff200000
.eqv MMIO_add			0xff200004

TWOB_POSX:		.word 74
TWOB_POSY:		.word 183
CURRENT_FRAME:		.word 0

SIZES:			.word 44,34,42,39,39,43		# largura de cada sprite de corrida à direita
CURRENT_SPRITE:		.word 0

##########################################################################
# Imprime uma sprite 16x16 a partir de um endereço encontrado na memória #
##########################################################################
.macro render_sprite(%sprite, %current_x, %current_y)
frame_address(a1)	# carrega para a1 o endereço da frame atual
la s1, %sprite
lw a3, 4(s1)		# todos os sprites são quadrados 16x16
lw a4, (s1)
loadw( t1,%current_y )	# carrega posição do personagem no eixo Y
loadw( t2,%current_x )	# carrega posição do personagem do eixo X
li t3, 320		# usado para pular linhas no eixo Y
mul t3,t1,t3		# t3 = linha x 320
add a1,a1,t3		# a1 = a1 + endereço 0 + linha x 320
add a1,a1,t2		# a1 = a1 + coluna
mv a2,a1		# a2 = a2 (endereço inicial de impressão)
li t1,320		# usado para calcular linhas 
mul t1, t1, a3		# t1 = 320 * altura da sprite
add t1, t1, a4		# t1 = t1 + largura da sprite
add a2,a2,t1		# endereço final = endereço inicial + linhas + colunas da sprite	
addi s1,s1,8		# chega aos pixeis da sprite
li t1,0			# contador
li t2, 0xffffff80
# ==========================================================
# a1 = endereço inicial 
# a2 = endereço final
# a3 = numero de pixels a serem pintados por linha
# t1 = contador de pixels pintados
# t2 = cor a ser substituida pelo transparente
# ==========================================================
jal PS_LOOP
.end_macro

######################################
#  Retorna o endereço da frame atual #	
######################################
.macro frame_address(%reg)
loadw(%reg,CURRENT_FRAME)
li t0,0xff0
add %reg,t0,%reg
slli %reg,%reg,20
.end_macro

#################################################
# Salva na memória o conteúdo de um registrador #
#################################################
.macro savew(%reg, %label)
la t0,%label
sw %reg,(t0)
.end_macro

########################################################
#  Carrega um conteúdo da memória para um registrador  #	
########################################################
.macro loadw(%reg, %label)
li %reg,0
la %reg,%label
lw %reg,(%reg)
.end_macro

.include "./sprites/twob_stand.data"

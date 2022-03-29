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

##########################################################################
# Imprime uma sprite 16x16 a partir de um endereço encontrado na memória #
##########################################################################
.macro render_sprite(%sprite, %current_x, %current_y)
# escolhe a frame aonde a sprite será desenhada
frame_address(a1)
la s1, %sprite
lw a3, 4(s1)		# todos os sprites são quadrados 16x16
lw a4, (s1)
loadw( t1,%current_y )
loadw( t2,%current_x )	
li t3, 320
mul t3,t1,t3		# aux = linhax320 (linha)
add a1,a1,t3
add a1,a1,t2		# endereço inicial = linha x 320 + coluna
mv a2,a1		
li t1,320		
mul t1, t1, a3		# 320 x altura
add t1, t1, a4		# + largura = quantidade de pixels pintados
add a2,a2,t1		# endereço final = endereço inicial + 320 x altura + largura	
addi s1,s1,8		# chega ao .text
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

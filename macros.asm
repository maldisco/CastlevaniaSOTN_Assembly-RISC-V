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

sprite_tela_atual:	.word 0
tela_atual:		.word 1
frame_atual:		.word 0
#################################################
#  Retorna largura e endereco da próxima sprite #	
#################################################
.macro get_largura_endereco(%reg1, %reg2, %sprite, %larguras, %enderecos)
loadw(t0, %sprite)
la t1, %larguras
la t2, %enderecos
li t3, 4
mul t0, t0, t3
add t1, t1, t0
add t2, t2, t0
lw %reg1, (t1)
lw %reg2, (t2)
.end_macro

############################
# Calcula a altura do pulo #
############################
.macro funcao_pulo(%y)
loadw(t0, sprite_pulando)	# t0 = x
li t1, 4
mul t2, t0, t0
mul t1, t1, t2			# t1 =  -4 * x^2
li t2, -32
mul t2, t2, t0			# t2 = 32 * x
li t3, 183
add t3, t3, t1
add t3, t3, t2			# t3 =  -4*x^2 + 32*x + 179
mv %y, t3
.end_macro


######################################
#  Retorna o endereço da frame atual #	
######################################
.macro frame_address(%reg)
loadw(%reg,frame_atual)
li t0,0xff0
add %reg,t0,%reg
slli %reg,%reg,20
.end_macro

######################################
#  Retorna o endereço da outra frame #	
######################################
.macro other_frame_address(%reg)
loadw(%reg,frame_atual)
xori %reg, %reg, 1
li t0,0xff0
add %reg,t0,%reg
slli %reg,%reg,20
.end_macro

#################################################
# Troca o estado da frame armazenado na memória #
# PS: não troca a frame no bitmap		#	
#################################################
.macro troca_tela()
loadw(t1,frame_atual)
xori t1,t1,0x001
savew(t1,frame_atual)
.end_macro

###############################################################
# Troca a frame no bitmap para o estado armazenado na memória #	
###############################################################
.macro atualiza_tela()
loadw(t1,frame_atual)
li t0,FRAME_SELECT
sw t1,(t0)
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
la %reg,%label
lw %reg,(%reg)
.end_macro

#####
# = #
#####
.macro atribuir(%label1, %label2)
loadw(t1,%label1)
savew(t1,%label2)
.end_macro

.include "./sprites/twob_stand.data"
.include "./sprites/twob_jump_right.data"
.include "./sprites/twob_jump_left.data"
.include "./sprites/twob_walk_right.data"
.include "./sprites/twob_walk_left.data"
.include "./sprites/tela_1.data"
.include "./sprites/tela_2.data"
.include "./sprites/tela_3.data"

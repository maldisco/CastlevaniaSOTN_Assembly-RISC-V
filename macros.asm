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

.eqv GRAVIDADE		15

sprite_tela_atual:	.word 0
tela_atual:		.word 1
frame_atual:		.word 0

sprite_parada_direita:		.word 0
sprite_parada_esquerda:		.word 0
sprite_correndo_direita:	.word 0
sprite_correndo_esquerda:	.word 0
sprite_pulando_direita:		.word 0
sprite_pulando_esquerda:	.word 0
sprite_larguras_atual:		.word 0
sprite_enderecos_atual:		.word 0
sprite_atual:			.word 0
sprite_frame_atual:		.word 0

#################################################
#  Retorna largura e endereco da próxima sprite #	
#################################################
.macro get_largura_endereco(%reg1, %reg2, %sprite, %larguras, %enderecos)
loadb(t0, %sprite)
loadw(t1, %larguras)
loadw(t2, %enderecos)
li t3, 4
mul t0, t0, t3
add t1, t1, t0
add t2, t2, t0
lw %reg1, (t1)
lw %reg2, (t2)
.end_macro

# Carrega as sprites dos arquivos para a memória
.macro carrega_sprites()
la t1, twob_stand_right
savew(t1, sprite_parada_direita)
la t1, twob_stand_left
savew(t1, sprite_parada_esquerda)
la t1, twob_walk_right
savew(t1, sprite_correndo_direita)
la t1, twob_walk_left
savew(t1, sprite_correndo_esquerda)
la t1, twob_jump_right
savew(t1, sprite_pulando_direita)
la t1, twob_jump_left
savew(t1, sprite_pulando_esquerda)
.end_macro

# Configuracoes iniciais de sprite
.macro configuracoes_iniciais()
atribuir(sprite_atual, sprite_parada_direita)
la t1, larguras_parada_direita
savew(t1, sprite_larguras_atual)
la t1, enderecos_parada_direita
savew(t1, sprite_enderecos_atual)
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

##############################################
# Salva na memória a word  de um registrador #
##############################################
.macro savew(%reg, %label)
la t0,%label
sw %reg,(t0)
.end_macro

#####################################################
#  Carrega uma word da memória para um registrador  #	
#####################################################
.macro loadw(%reg, %label)
la %reg,%label
lw %reg,(%reg)
.end_macro

# Carrega um byte da memória para um registrador
.macro loadb(%reg, %label)
la %reg, %label
lb %reg,(%reg)
.end_macro

# Salva um byte do registrador para memória
.macro saveb(%reg, %label)
la t0, %label
sb %reg,(t0)
.end_macro

########################################################
#  Carrega um conteúdo da memória para um registrador  #	
########################################################
.macro loadw(%reg, %label)
la %reg,%label
lw %reg,(%reg)
.end_macro

# Atribuição de word 
.macro atribuir(%label1, %label2)
loadw(t1,%label2)
savew(t1,%label1)
.end_macro

# Atribuição de byte
.macro atribuir_b(%label1, %label2)
loadb(t1,%label2)
saveb(t1,%label1)
.end_macro

.include "./sprites/twob_stand_right.data"
.include "./sprites/twob_stand_left.data"
.include "./sprites/twob_jump_right.data"
.include "./sprites/twob_jump_left.data"
.include "./sprites/twob_walk_right.data"
.include "./sprites/twob_walk_left.data"
.include "./sprites/tela_1.data"
.include "./sprites/tela_2.data"
.include "./sprites/tela_3.data"

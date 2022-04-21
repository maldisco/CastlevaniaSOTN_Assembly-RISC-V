.eqv FRAME_0		0xff000000
.eqv FRAME_1		0xff100000
.eqv FRAME_SELECT	0xff200604

.eqv MMIO_set			0xff200000
.eqv MMIO_add			0xff200004

.eqv GRAVIDADE			1
.eqv LUFFY.OFFSET		3600


luffy:	.string "sprites/alucard2.bin"

luffy.parado.direita.offsets: 		.word 32403,32403,32431,32431,32459,32459,32487,32487,32514,32514,32542,32542,32570,32570,32597,32597,32621,32621,32643,32643,32667,32667,32694,32694,32720,32720,32745,32745
.eqv LUFFY.PARADO.ALTURA		47
.eqv LUFFY.PARADO.LARGURA		22
luffy.parado.esquerda.offsets: 		.word 35975,35975,35947,35947,35919,35919,35891,35891,35864,35864,35836,35836,35808,35808,35781,35781,35757,35757,35735,35735,35711,35711,35684,35684,35658,35658,35633,35633

luffy.correndo.direita.offsets: 	.word 226800,226850,226899,226948,226996,227042,227089,227136,227185,227235,227286,227338,227391,227445,227496,227568,227625,227677,227725,227772,227821,227877,227927,227977,228025,228069,228123,228170,228221,228271,228319
.eqv LUFFY.CORRENDO.ALTURA		49
.eqv LUFFY.CORRENDO.LARGURA		46
luffy.correndo.esquerda.offsets: 	.word 230356,230306,230257,230208,230160,230114,230067,230020,229971,229921,229870,229818,229765,229711,229660,229588,229531,229479,229431,229384,229335,229279,229229,229179,229131,229087,229033,228986,228935,228885,228837

luffy.pulando.direita.offsets: 		.word 414004,414039,414086,414135,414182,414230,414279,414331,414382,414431,414482,414532,414582,414631,414682,414731,414775,414820,414861,414903,414938,414974
.eqv LUFFY.PULANDO.ALTURA		64
.eqv LUFFY.PULANDO.LARGURA 		47
luffy.pulando.esquerda.offsets: 	.word 417549,417514,417467,417418,417371,417323,417274,417222,417171,417122,417071,417021,416971,416922,416871,416822,416778,416733,416692,416650,416615,416579

luffy.socando.direita.offsets: 		.word 662400,662501,662598,662700,662797,662929,663030,663131,663233,663327,663427,663521,663608,663708,663804,663900,664018
.eqv LUFFY.SOCANDO.ALTURA		60
.eqv LUFFY.SOCANDO.LARGURA		97
luffy.socando.esquerda.offsets: 	.word 665903,665802,665705,665603,665506,665374,665273,665172,665070,664976,664876,664782,664695,664595,664499,664403,664285

luffy.hellfire.direita.offsets: 	.word 1058400,1058400,1058440,1058440,1058480,1058480,1058520,1058520,1058560,1058560,1058600,1058600,1058640,1058640,1058680,1058680,1058720,1058720,1058760,1058760,1058801,1058801
.eqv LUFFY.HELLFIRE.ALTURA		50
.eqv LUFFY.HELLFIRE.LARGURA		40
luffy.hellfire.esquerda.offsets: 	.word 1061960,1061960,1061920,1061920,1061880,1061880,1061840,1061840,1061800,1061800,1061760,1061760,1061720,1061720,1061680,1061680,1061640,1061640,1061600,1061600,1061559,1061559

mapa.lock.x:				.byte 0
mapa.y:					.half 587
mapa.x:					.half 52
.eqv MAPA.LARGURA			320
.eqv MAPA.ALTURA			239
.eqv MAPA.IMAGEM.LARGURA		1628
.eqv MAPA.HITBOX.LARGURA		1628
.eqv MAPA.MAX.Y				586
.eqv MAPA.MIN.Y				0
.eqv MAPA.MAX.X				1308
.eqv MAPA.MIN.X				0


mapa:					.string "sprites/map.bin"

sprite_tela_atual:			.word 0
tela_atual:				.word 1
frame_atual:				.word 0

sprite_frame_atual:			.byte 0

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

# Calcula offset do mapa
.macro offset_mapa(%reg)
li t1, MAPA.IMAGEM.LARGURA
la t2, mapa.y
lhu t2, 0(t2)
la t3, mapa.x
lhu t3, 0(t3)
mul t1, t1, t2
add t1, t1, t3
mv %reg, t1
.end_macro

# Calcula posicoes do personagem relativas ao mapa
.macro calc_pos()
la t1, horizontal luffy
lw t1, 0(t1)
la t2, vertical_luffy
lw t2, 0(t2)
la t3, mapa.x
lh t3, 0(t3)
la t4, mapa.y
lh t4, 0(t4)
add t5, t3, t1			# t5 = X da esquerda do personagem no mapa
add t6, t6, t2			# t6 = Y de cima do personagem no mapa
.end_macro

.include "sprites/map_hitbox.s"

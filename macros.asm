.eqv FRAME_0		0xff000000
.eqv FRAME_1		0xff100000
.eqv FRAME_SELECT	0xff200604

.eqv MMIO_set			0xff200000
.eqv MMIO_add			0xff200004

.eqv GRAVIDADE			1
.eqv LUFFY.OFFSET		1844


luffy:	.string "sprites/alucard.bin"

luffy.parado.direita.offsets:		.word 25816,25816,25816,25868,25868,25868,25904,25904,25904,25937,25937,25937,25972,25972,25972,26006,26006,26006,26040,26040,26040
.eqv LUFFY.PARADO.ALTURA		47
.eqv LUFFY.PARADO.LARGURA		39
luffy.parado.esquerda.offsets:		.word 27621,27621,27621,27569,27569,27569,27533,27533,27533,27500,27500,27500,27465,27465,27465,27431,27431,27431,27397,27397,27397

luffy.correndo.direita.offsets:		.word 405826,405826,405861,405861,405902,405902,405949,405949,406000,406000,406056,406056,406105,406105,406156,406156,406209,406209,406259,406259,274770,274770,274815,274815,274859,274859,274900,274900,274948,274948,274996,274996,275041,275041,275088,275088,275129,275129,275170,275170,275218,275218,275273,275273,275325,275325,275376,275376,275429,275429,275483,275483
.eqv LUFFY.CORRENDO.ALTURA		47
.eqv LUFFY.CORRENDO.LARGURA		41
luffy.correndo.esquerda.offsets:	.word 407338,407338,407303,407303,407262,407262,407215,407215,407164,407164,407108,407108,407059,407059,407008,407008,406955,406955,406905,406905,276546,276546,276501,276501,276457,276457,276416,276416,276368,276368,276320,276320,276275,276275,276228,276228,276187,276187,276146,276146,276098,276098,276043,276043,275991,275991,275940,275940,275887,275887,275833,275833

luffy.pulando.direita.offsets:		.word 898232,898232,898232,898270,898270,898270,898314,898314,898314,898369,898369,898369,1051088,1051088,1051088,1051142,1051142,1051142,1051654,1051654,1051654,1051709,1051709,1051709
.eqv LUFFY.PULANDO.ALTURA		47
.eqv LUFFY.PULANDO.LARGURA 		44
luffy.pulando.esquerda.offsets:		.word 899626,899626,899626,899588,899588,899588,899544,899544,899544,899489,899489,899489,1052874,1052874,1052874,1052820,1052820,1052820,1052308,1052308,1052308,1052253,1052253,1052253

luffy.socando.direita.offsets:		.word 1425425,1425425,1425473,1425473,1425533,1425533,1425598,1425598,1425650,1425650,1425701,1425701,1425752,1425752,1425803,1425803,1425854,1425854,1425902,1425902,1425948,1425948,1425993,1425993
.eqv LUFFY.SOCANDO.ALTURA		49
.eqv LUFFY.SOCANDO.LARGURA		60
luffy.socando.esquerda.offsets:		.word 1427183,1427183,1427135,1427135,1427075,1427075,1427010,1427010,1426958,1426958,1426907,1426907,1426856,1426856,1426805,1426805,1426754,1426754,1426706,1426706,1426660,1426660,1426615,1426615


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

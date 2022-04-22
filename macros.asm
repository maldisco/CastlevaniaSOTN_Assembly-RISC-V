.eqv FRAME_0		0xff000000
.eqv FRAME_1		0xff100000
.eqv FRAME_SELECT	0xff200604

.eqv MMIO_set			0xff200000
.eqv MMIO_add			0xff200004

GRAVIDADE:			.float 0.5
.eqv LUFFY.OFFSET		4268
.eqv LUFFY.HITBOX.ALTURA	47
.eqv LUFFY.HITBOX.LARGURA	20
.eqv LUFFY.HITBOX_OFFSET.Y	17
.eqv LUFFY.HITBOX_OFFSET.X	38
.eqv LUFFY.LARGURA 		97
.eqv LUFFY.ALTURA		64


luffy:	.string "sprites/alucard.bin"
mapa.lock.x:				.byte 0
mapa.lock.y:				.byte 0
mapa.y:					.half 587
mapa.x:					.half 52
luffy.parado.direita.offsets: 		.word 0,0,0,0,97,97,97,97,194,194,194,194,291,291,291,291,388,388,388,388,485,485,485,485
luffy.parado.esquerda.offsets: 		.word 2813,2813,2813,2813,2716,2716,2716,2716,2619,2619,2619,2619,2522,2522,2522,2522,2425,2425,2425,2425,2328,2328,2328,2328 
luffy.correndo.direita.offsets: 	.word 273152,273249,273346,273443,273540,273637,273734,273831,273928,274025,274122,274219,274316,274413,274510,274607,274704,274801,274898,274995,275092,275189,275286,275383,275480,275577,275674,275771,275868,275965,276062
luffy.correndo.esquerda.offsets: 	.word 549214,549117,549020,548923,548826,548729,548632,548535,548438,548341,548244,548147,548050,547953,547856,547759,547662,547565,547468,547371,547274,547177,547080,546983,546886,546789,546692,546595,546498,546401,546304
luffy.pulando.direita.offsets: 		.word 819456,819456,819553,819553,819650,819650,819747,819747,819844,819844,819941,819941,820038,820038,820135,820135,820232,820232,820329,820329,820426,820426,820523,820523,820620,820620,820717,820717,820814,820814,820911,820911,821008,821008,821105,821105,821202,821202,821299,821299,821396,821396,821493,821493
luffy.pulando.esquerda.offsets: 	.word 823627,823627,823530,823530,823433,823433,823336,823336,823239,823239,823142,823142,823045,823045,822948,822948,822851,822851,822754,822754,822657,822657,822560,822560,822463,822463,822366,822366,822269,822269,822172,822172,822075,822075,821978,821978,821881,821881,821784,821784,821687,821687,821590,821590
luffy.socando.direita.offsets: 		.word 1092608,1092705,1092802,1092899,1092996,1093093,1093190,1093287,1093384,1093481,1093578,1093675,1093772,1093869,1093966,1094063,1094160
luffy.socando.esquerda.offsets: 	.word 1095809,1095712,1095615,1095518,1095421,1095324,1095227,1095130,1095033,1094936,1094839,1094742,1094645,1094548,1094451,1094354,1094257
luffy.hellfire.direita.offsets: 	.word 1365760,1365857,1365954,1366051,1366148,1366245,1366342,1366439,1366536,1366633,1366730
luffy.hellfire.esquerda.offsets: 	.word 1368864,1368767,1368670,1368573,1368476,1368379,1368282,1368185,1368088,1367991,1367894,1367797

.eqv MAPA.LARGURA			320
.eqv MAPA.ALTURA			239
mapa.imagem.largura:			.half 1628
mapa.hitbox.largura:			.half 1628
mapa.max.y:				.half 586
mapa.min.y:				.half 0
mapa.max.x:				.half 1308
mapa.min.x:				.half 0
mapa_hitbox:				.word 0		# Ponteiro para o mapa de hitboxes da tela atual


mapa:					.string "sprites/map.bin"
tela1:					.string "sprites/tela_1.bin"

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
la t1, mapa.imagem.largura
lhu t1, 0(t1)
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

.include "sprites/tela_1_hitboxes.s"

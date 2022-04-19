.eqv FRAME_0		0xff000000
.eqv FRAME_1		0xff100000
.eqv FRAME_SELECT	0xff200604

.eqv MMIO_set			0xff200000
.eqv MMIO_add			0xff200004

.eqv GRAVIDADE			8
.eqv LUFFY.OFFSET		1572


luffy:	.string "sprites/luffy.bin"

luffy.parado.direita.offsets:		.word 102187,102224,102266,102307,102345,102386,102426
.eqv LUFFY.PARADO.ALTURA		55
.eqv LUFFY.PARADO.LARGURA		37
luffy.parado.esquerda.offsets:		.word 4716,4756,4797,4835,4876,4918,4955

luffy.correndo.direita.offsets:		.word 298681, 298722, 298762, 298813, 298859, 298898, 298942, 298893
.eqv LUFFY.CORRENDO.ALTURA		55
.eqv LUFFY.CORRENDO.LARGURA		39
luffy.correndo.esquerda.offsets:	.word 194933, 194976, 195017, 195063, 195116, 195158, 195199, 195246

luffy.pulando.direita.offsets:		.word 385191, 385239, 385284, 385331, 385372, 385414, 385858, 385898, 385935, 385979
luffy.pulando.direita.offsets2:		.word 385144, 385191, 385239, 385284, 385372, 385414, 385463, 385507, 385564, 385605, 305689, 385732, 382628, 382669,
					382714, 382754, 382791,385979, 385025, 386066 
.eqv LUFFY.PULANDO.ALTURA		55
.eqv LUFFY.PULANDO.LARGURA 		37
luffy.pulando.esquerda.offsets:		.word 509377, 509417, 509461, 509510, 509554, 509595, 513183, 513223, 513268, 510170 

luffy.socando.direita.offsets:		.word 867754, 867832, 867916, 867999, 867068, 868141, 868219, 868312, 868414, 868532, 868638, 868720, 868823, 868908, 868984, 869073
.eqv LUFFY.SOCANDO.ALTURA		55
.eqv LUFFY.SOCANDO.LARGURA		60
luffy.socando.esquerda.offsets:		.word 745109,745186,745270,745352,745432,745523,745608,745708,745811,745943,746035,746114,746198,746277,746352,746436

mapa:	.string "sprites/tela_1.bin"
.eqv MAPA.ALTURA			239
.eqv MAPA.LARGURA			320

sprite_tela_atual:	.word 0
tela_atual:		.word 1
frame_atual:		.word 0

sprite_frame_atual:		.byte 0

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

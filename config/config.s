# Utilidade geral
.eqv FRAME_SELECT		0xff200604
.eqv MMIO_set			0xff200000
.eqv MMIO_add			0xff200004

coracao:			.string "sprites/coracao.bin"
coracao.pego:			.byte 0
coracao.descritor:		.word 0
comida:				.string "sprites/comida.bin"
comida.pego:			.byte 0
comida.descritor:		.word 0
faca:				.string "sprites/faca.bin"
faca2:				.string "sprites/faca2.bin"
faca.descritor:			.word 0, 0

hud:				.string "sprites/hud.bin"
hud.offsets:			.word 0, 0, 0, 0, 107, 107, 107, 107, 214, 214, 214, 214, 321, 321, 321, 321, 428, 428, 428, 428, 535, 535, 535, 535, 642, 642, 642, 642
.eqv HUD.IMAGEM.LARGURA		748
.eqv HUD.LARGURA		105
.eqv HUD.ALTURA			34

numeros:			.string "sprites/numeros.bin"
.eqv NUMEROS.IMAGEM.LARGURA	80
.eqv NUMEROS.LARGURA		8
.eqv NUMEROS.ALTURA		12

dialogo1:			.string "dialogos/dialogo1.bin"
dialogo2:			.string "dialogos/dialogo2.bin"
morte:				.string "sprites/morte.bin"

objeto.x:			.half 56
objeto.y:			.half 151
objeto.descritor:		.word 0
.eqv OBJETO.IMAGEM.LARGURA	32
.eqv OBJETO.LARGURA		30
.eqv OBJETO.ALTURA		8

sans:				.string "sprites/SANS.bin"
sanzz:				.string "sprites/sanzz.bin"
sans.acao:			.byte 0
sans.parado.offsets:		.word 45552,45552,45552,45552,45614,45614,45614,45614,45676,45676,45676,45676,45738,45738,45738,45738,45800,45800,45800,45800
sans.sobe.offsets:		.word 22776,22776,22776,22776,22838,22838,22838,22838,22900,22900,22900,22900,22962,22962,22962,22962,23024,23024,23024,23024
sans.desce.offsets:		.word 0,0,0,0,62,62,62,62,124,124,124,186,186,186,186,248,248,248,248
sans.ferido.offsets:		.word 68328,68328,68328,68328,68390,68390,68390,68390,68452,68452,68452,68452,68514,68514,68514,68514,68576,68576,68576,68576
.eqv SANS.LARGURA		62	
.eqv SANS.ALTURA		71
.eqv SANS.IMAGEM.LARGURA	312
.eqv SANS.X			129
.eqv SANS.Y			71

blaster_h:			.string "sprites/blaster_h.bin"
blaster_h.offsets:		.word 0,0,0,0,16640,16640,16640,16640,33280,33280,33280,33280,49920,49920,49920,49920,66560,66560,66560,66560
blaster_h.descritor:		.word 0
.eqv BLASTER_H.ALTURA		51
.eqv BLASTER_H.LARGURA		320
.eqv BLASTER_H.IMAGEM.LARGURA	320
.eqv BLASTER_H.X		0

blaster_v:			.string "sprites/blaster_v.bin"
blaster_v.offsets:		.word 0,0,0,0,23,23,23,23,45,45,45,45,68,68,68,68
blaster_v.descritor:		.word 0
.eqv BLASTER_V.ALTURA		239
.eqv BLASTER_V.LARGURA		23
.eqv BLASTER_V.IMAGEM.LARGURA	92
.eqv BLASTER_V.Y		0

msg.descritor:			.word 0
msg:				.string "sprites/msg.bin"

TELA.DESCRITORES:		.word 	0,0,0,0,0,0,0,0,0,0,0,0,0,0
tela1:				.string "mapa/tela_1.bin"
tela2:				.string "mapa/tela_2.bin"
tela3:				.string "mapa/tela_3.bin"
tela4:				.string "mapa/tela_4.bin"
tela5:				.string "mapa/tela_5.bin"
tela6:				.string "mapa/tela_6.bin"
tela7:				.string "mapa/tela_7.bin"
tela10:				.string "mapa/tela_10.bin"
tela10a:			.string "mapa/tela_10_aberta.bin"
tela11f:			.string "mapa/tela_11_frente.bin"
tela11:				.string "mapa/tela_11.bin"
telabf:				.string "mapa/tela_bf.bin"
mapa.imagem.largura:		.half 1628
mapa.hitbox.largura:		.half 1628
mapa.max.y:			.half 586
mapa.min.y:			.half 0
mapa.max.x:			.half 1308
mapa.min.x:			.half 0
mapa_hitbox:			.word 0		# Ponteiro para o mapa de hitboxes da tela atual

.include "../mapa/tela_1_hitboxes.s"
.include "../mapa/tela_2_hitboxes.s"
.include "../mapa/tela_3_hitboxes.s"
.include "../mapa/tela_4_hitboxes.s"
.include "../mapa/tela_5_hitboxes.s"
.include "../mapa/tela_6_hitboxes.s"
.include "../mapa/tela_7_hitboxes.s"
.include "../mapa/tela_8_hitboxes.s"
.include "../mapa/tela_10_hitboxes.s"
.include "../mapa/tela_10_aberta_hitboxes.s"
.include "../mapa/tela_11_hitboxes.s"
.include "../mapa/tela_bf_hitboxes.s"

.eqv MAPA.LARGURA		320
.eqv MAPA.ALTURA		239
# Tela 1
.eqv T1.LARGURA			768
.eqv T1.MIN.X			0
.eqv T1.MAX.X			448
.eqv T1.MIN.Y			0
.eqv T1.MAX.Y			0
.eqv T1.X_INI			447
.eqv T1.Y_INI			0

# Tela 2
.eqv T2.LARGURA			768
.eqv T2.MIN.X			0
.eqv T2.MAX.X			447
.eqv T2.MAX.Y			272
.eqv T2.MIN.Y			0
.eqv T2.X_INI			450
.eqv T2.Y_INI			271

# Tela 3
.eqv T3.LARGURA			320
.eqv T3.MIN.X			0
.eqv T3.MAX.X			0
.eqv T3.MIN.Y			0
.eqv T3.MAX.Y			991
.eqv T3.X_INI			0
.eqv T3.Y_INI			721

# Tela 4
.eqv T4.LARGURA			1024
.eqv T4.MIN.X			0
.eqv T4.MAX.X			704
.eqv T4.MIN.Y			0
.eqv T4.MAX.Y			222
.eqv T4.X_INI			0
.eqv T4.Y_INI			0

# Tela 5
.eqv T5.LARGURA			512
.eqv T5.MIN.X			0
.eqv T5.MAX.X			192
.eqv T5.MIN.Y			0
.eqv T5.MAX.Y			222
.eqv T5.X_INI			192
.eqv T5.Y_INI			223

# Tela 6
.eqv T6.LARGURA			320
.eqv T6.MIN.X			0
.eqv T6.MAX.X			0
.eqv T6.MIN.Y			0
.eqv T6.MAX.Y			0
.eqv T6.X_INI			0
.eqv T6.Y_INI			0

# Tela 7
.eqv T7.LARGURA			320
.eqv T7.MIN.X			0
.eqv T7.MAX.X			0
.eqv T7.MIN.Y			0
.eqv T7.MAX.Y			528

# Tela 8
.eqv T8.LARGURA			320
.eqv T8.MIN.X			0
.eqv T8.MAX.X			0
.eqv T8.MIN.Y			0
.eqv T8.MAX.Y			0
.eqv T8.X_INI			0
.eqv T8.Y_INI			0

# Tela 9

# Tela 10
.eqv T10.LARGURA		320
.eqv T10.MIN.X			0
.eqv T10.MAX.X			0
.eqv T10.MIN.Y			0
.eqv T10.MAX.Y			15
.eqv T10.X_INI			0
.eqv T10.Y_INI			0

# Tela BF
.eqv T11.LARGURA		320
.eqv T11.MIN.X			0
.eqv T11.MAX.X			0
.eqv T11.MIN.Y			0
.eqv T11.MAX.Y			0
.eqv T11.X_INI			0
.eqv T11.Y_INI			0

# Tela BF
.eqv TBF.LARGURA		320
.eqv TBF.MIN.X			0
.eqv TBF.MAX.X			0
.eqv TBF.MIN.Y			0
.eqv TBF.MAX.Y			0
.eqv TBF.X_INI			0
.eqv TBF.Y_INI			0

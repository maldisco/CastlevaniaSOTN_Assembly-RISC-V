# Utilidade geral
.eqv FRAME_SELECT		0xff200604
.eqv MMIO_set			0xff200000
.eqv MMIO_add			0xff200004

hud:				.string "sprites/hud.bin"
hud.offsets:			.word 0, 0, 0, 0, 107, 107, 107, 107, 214, 214, 214, 214, 321, 321, 321, 321, 428, 428, 428, 428, 535, 535, 535, 535, 642, 642, 642, 642
hud.atual:			.byte 0
.eqv HUD.IMAGEM.LARGURA		748
.eqv HUD.LARGURA		105
.eqv HUD.ALTURA			35

dialogo1:			.string "dialogos/dialogo1.bin"

TELA.DESCRITORES:		.word 	0,0,0,0,0,0,0,0,0,0
tela1:				.string "mapa/tela_1.bin"
tela2:				.string "mapa/tela_2.bin"
tela3:				.string "mapa/tela_3.bin"
tela4:				.string "mapa/tela_4.bin"
tela5:				.string "mapa/tela_5.bin"
tela6:				.string "mapa/tela_6.bin"
tela7:				.string "mapa/tela_7.bin"
tela10:				.string "mapa/tela_10.bin"
tela11:				.string "mapa/tela_11.bin"
mapa.imagem.largura:		.half 1628
mapa.hitbox.largura:		.half 1628
mapa.max.y:			.half 586
mapa.min.y:			.half 0
mapa.max.x:			.half 1308
mapa.min.x:			.half 0
mapa_hitbox:			.word 0		# Ponteiro para o mapa de hitboxes da tela atual

.include "mapa/tela_1_hitboxes.s"
.include "mapa/tela_2_hitboxes.s"
.include "mapa/tela_3_hitboxes.s"
.include "mapa/tela_4_hitboxes.s"
.include "mapa/tela_5_hitboxes.s"
.include "mapa/tela_6_hitboxes.s"
.include "mapa/tela_7_hitboxes.s"
.include "mapa/tela_8_hitboxes.s"
.include "mapa/tela_10_hitboxes.s"
.include "mapa/tela_11_hitboxes.s"

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

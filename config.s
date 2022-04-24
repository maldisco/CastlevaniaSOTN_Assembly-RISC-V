# Utilidade geral
.eqv FRAME_SELECT		0xff200604
.eqv MMIO_set			0xff200000
.eqv MMIO_add			0xff200004
frame_atual:			.word 0

dialogo1:			.string "dialogos/dialogo1.bin"

TELA:				.word 0						# Descritor da tela atual
tela1:				.string "sprites/tela_1.bin"
tela2:				.string "sprites/tela_2.bin"
tela3:				.string "sprites/tela_3.bin"
tela4:				.string "sprites/tela_4.bin"
mapa.imagem.largura:		.half 1628
mapa.hitbox.largura:		.half 1628
mapa.max.y:			.half 586
mapa.min.y:			.half 0
mapa.max.x:			.half 1308
mapa.min.x:			.half 0
mapa_hitbox:			.word 0		# Ponteiro para o mapa de hitboxes da tela atual

.include "sprites/tela_1_hitboxes.s"
.include "sprites/tela_2_hitboxes.s"
.include "sprites/tela_3_hitboxes.s"
.include "sprites/tela_4_hitboxes.s"
.include "sprites/tela_5_hitboxes.s"
.include "sprites/tela_6_hitboxes.s"

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

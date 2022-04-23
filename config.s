TELA:			.word 0						# Descritor da tela atual
tela1:			.string "sprites/tela_1.bin"
tela2:			.string "sprites/tela_2.bin"

# Tela 1
.eqv T1.LARGURA			768
.eqv T1.MIN.X			0
.eqv T1.MAX.X			448
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
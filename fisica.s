# Calcula as possibilidade de movimento CIMA/BAIXO/ESQUERDA/DIREITA
# Param a0, offset hitbox x
# Return a1 = CIMA (1 pode, 0 nao pode)
#	 a2 = BAIXO (1 pode, 0 nao pode)
# 	 a3 = ESQUERDA (1 pode, 0 nao pode)
#	 a4 = DIREITA  (1 pode, 0 nao pode)
FISICA:
	jal FISICA.CALCULA_BLOCO
	

CALCULA_BLOCO:
	loadb(t1, pulando)
	bnez t1, CALCULA_BLOCO.PULANDO
	
	
CALCULA_BLOCO.PULANDO:
	la t1, mapa.x
	lh t1, (t1)
	la t2, mapa.y
	lh t2, (t2)
	mv t3, a1
	la t4, vertical_luffy
	lw t4, (t4)
.data

.include "macros.asm"
.text
	
	li s11, MMIO_set
POLL_LOOP:
	li a1, RIGHT
	li a2, LEFT
	lw t1, (s11)
	beqz t1, POLL_LOOP
	li s0, MMIO_add
	lw s0, (s0)
	beq s0, a1, DIREITA
	beq s0, a2, ESQUERDA
	j POLL_LOOP
DIREITA:
	loadw(t2, TWOB_POSX)
	addi t2, t2, 28
	savew(t2, TWOB_POSX)
	render_sprite(twob_stand, TWOB_POSX, TWOB_POSY)
	j POLL_LOOP
ESQUERDA:
	loadw(t2, TWOB_POSX)
	addi t2, t2, -28
	savew(t2, TWOB_POSX)
	render_sprite(twob_stand, TWOB_POSX, TWOB_POSY)
	j POLL_LOOP
	
	li a7, 10
	ecall
	
.include "render.asm"

.data

.include "macros.asm"
.text
	render_sprite(twob_stand, TWOB_POSX, TWOB_POSY)
	
	li a7, 10
	ecall
	
.include "render.asm"
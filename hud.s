# Renderiza a HUD:
# - Barra de mana
# - Vida
# - Arma equipada 

# ATENÇÃO=============================
# IDÉIA PARA COLOCAR O HP NA TELA
# SPRITE COM OS ALGARISMOS 0-9
# PEGA O HP ATUAL // 10 -> PRIMEIRO DIGITO
# PEGA O HP ATUAL % 10  -> SEGUNDO DIGITO


HUD.RENDER:		addi		sp, sp, -4
			sw		ra, (sp)
			
			mv		a0, s8
			li		a1, 0		
			li 		a2, 0
			li		a3, HUD.IMAGEM.LARGURA
			li 		a4, HUD.LARGURA		
			frame_address(a5)
			la		t0, hud.atual
			lb		t1, (t0)
			li		t2, 4
			mul		t2, t2, t1
			la		t3, hud.offsets
			add		t3, t3, t2
			lw		a6, (t3)			# Offset atual
			
			addi		t1, t1, 1
			li		t2, 28
			blt		t1, t2, HUD.NAO_RESETA
			
			li		t1, 0
HUD.NAO_RESETA:
			sw 		t1, (t0)
			
			li 		a7, HUD.ALTURA
			jal		RENDER
		
			lw		ra, (sp)
			addi		sp, sp, 4
			ret

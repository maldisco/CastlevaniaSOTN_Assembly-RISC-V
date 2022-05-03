# Retorna o menor valor entre dois
# Param a1, a2
# Return a0
MIN:			bgt		a1, a2, MIN.2
			mv		a0, a1
			ret
				
MIN.2:			mv		a0, a2
			ret
		
# Retorna o maior valor entre dois
# Param a1, a2
# Return a0
MAX:			blt		a1, a2, MAX.2
			mv		a0, a1
			ret

MAX.2:			mv		a0, a2
			ret

# Realiza as ações ao pegar algum item
OBJETO.ACOES:		fcvt.w.s	t1, fa7
			li		t2, 1
			beq		t1, t2, OBJETO.ACOES.FACA
			
			li		t2, 2
			beq		t1, t2, OBJETO.ACOES.CORACAO
			
			li		t2, 3
			beq		t1, t2, OBJETO.ACOES.COMIDA
			
			ret
			
OBJETO.ACOES.COMIDA:	fcvt.s.w	fa7, zero				# Desliga a renderização de objeto
			
			li		t1, 2
			fcvt.s.w	ft4, t1					# Código da mensagem na tela
			
			li		t1, 2
			fcvt.s.w	ft0, t1
			fmul.s		ft2, ft2, ft0				# Dobra o dano do personagem
			
			ret
			
				
OBJETO.ACOES.CORACAO:	li		t1, 99
			fcvt.s.w	fs4, t1				 	# Aumenta o HP do personagem
			
			li		t1, 1
			fcvt.s.w	ft4, t1					# Código da mensagem na tela
			
			fcvt.s.w	fa7, zero				# Desliga a renderização de objeto
			
			la		t0, coracao.pego
			li		t1, 1
			sb		t1, (t0)
			
			ret
			
			

OBJETO.ACOES.FACA:	fcvt.s.w	fa7, zero				# Desliga renderização de objeto
			li		t1, 1
			fcvt.s.w	fa6, t1	
			
			la		t0, hud.offsets
			li		t1, 28
			li		t2, 0
			li		t3, 4
OBJETO.LOOP:		mul		t4, t3, t2
			add		t4, t4, t0
			lw		t5, (t4)
			li		t6, 26180
			add		t5, t5, t6
			sw		t5, (t4)						
				
			addi		t2, t2, 1
			blt		t2, t1, OBJETO.LOOP			# Adiciona a faca à HUD
			
			li		t0, 3
			fcvt.s.w	ft4, t0					# Codigo da mensagem na tela	
			
			ret
			
			
			
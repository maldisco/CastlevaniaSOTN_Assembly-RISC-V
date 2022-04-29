# Retorna o menor valor entre dois
# Param a1, a2
# Return a0
MIN:		bgt		a1, a2, MIN.2
		mv		a0, a1
		ret
				
MIN.2:		mv		a0, a2
		ret
		
# Retorna o maior valor entre dois
# Param a1, a2
# Return a0
MAX:		blt		a1, a2, MAX.2
		mv		a0, a1
		ret

MAX.2:		mv		a0, a2
		ret
# Retorna o menor valor entre dois
# Param a1, a2
# Return a0
MIN:		bgt		a1, a2, MIN.2
		mv		a0, a1
		ret
				
MIN.2:		mv		a0, a2
		ret
# Calcula o menor valor entre os dois parametros
# Params a1, a2
# Return a0 = menor valor
MIN:
	bgt a1, a2, MIN2
		mv a0, a1
		ret
	MIN2:
	mv a0, a2
	ret

# Calcula o maior valor entre os dois parametros
# Params a1, a2
# Return a0 = maior valor
MAX:
	bgt a1, a2, MAX1
		mv a0, a2
		ret
	MAX1:
	mv a0, a1
	ret
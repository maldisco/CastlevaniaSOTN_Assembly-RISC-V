
#  Retorna o endereço da frame atual para um registrador escolhido	
.macro frame_address(%reg)
loadw(%reg,frame_atual)
li t0,0xff0
add %reg,t0,%reg
slli %reg,%reg,20
.end_macro

#  Retorna o endereço da outra frame (não sendo mostrada) para um registrador escolhido
.macro other_frame_address(%reg)
loadw(%reg,frame_atual)
xori %reg, %reg, 1
li t0,0xff0
add %reg,t0,%reg
slli %reg,%reg,20
.end_macro


# Troca o estado da frame armazenado na memória 
# PS: não troca a frame no bitmap		
.macro troca_tela()
loadw(t1,frame_atual)
xori t1,t1,0x001
savew(t1,frame_atual)
.end_macro


# Troca a frame no bitmap para o estado armazenado na memória
.macro atualiza_tela()
loadw(t1,frame_atual)
li t0,FRAME_SELECT
sw t1,(t0)
.end_macro

# Salva na memória a word  de um registrador 
.macro savew(%reg, %label)
la t0,%label
sw %reg,(t0)
.end_macro

#  Carrega uma word da memória para um registrador  
.macro loadw(%reg, %label)
la %reg,%label
lw %reg,(%reg)
.end_macro

# Carrega um byte da memória para um registrador
.macro loadb(%reg, %label)
la %reg, %label
lb %reg,(%reg)
.end_macro

# Salva um byte do registrador para memória
.macro saveb(%reg, %label)
la t0, %label
sb %reg,(t0)
.end_macro

#  Carrega um conteúdo da memória para um registrador  
.macro loadw(%reg, %label)
la %reg,%label
lw %reg,(%reg)
.end_macro

# Calcula offset do mapa
.macro offset_mapa(%reg)
la t1, mapa.imagem.largura
lhu t1, 0(t1)
la t2, mapa.y
lhu t2, 0(t2)
la t3, mapa.x
lhu t3, 0(t3)
mul t1, t1, t2
add t1, t1, t3
mv %reg, t1
.end_macro
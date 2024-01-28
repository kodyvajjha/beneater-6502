build: 
	dune build 

wozmon:
	vasm6502_oldstyle -Fbin -dotdir asm/wozmon.s -o bin/wozmon.bin

rom:
	minipro -p AT28C256 -w a.out

run:
	dune exec beneater_6502 
	
.PHONY: build assemble wozmon
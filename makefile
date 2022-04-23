assemble: blink.s
	vasm6502_oldstyle -Fbin -dotdir blink.s

rom:
	minipro -p AT28C256 -w a.out

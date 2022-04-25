assemble: blink.s
	vasm6502_oldstyle -Fbin -dotdir hello-world.s

rom:
	minipro -p AT28C256 -w a.out

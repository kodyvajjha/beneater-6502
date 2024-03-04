# Ben Eater's 6502 Computer.

This is a work-in-progress repository of an OCaml emulator of Ben Eater's 6502-based breadboard computer. 
Below is my build of his computer. 
![Also pictured, a Flipper zero.](https://github.com/kodyvajjha/beneater-6502/blob/master/PXL_20230801_224701368.jpg?raw=true)

Currently I only emulate part of the CPU, the display and the keyboard needed to run Ben's version of Wozmon. The implementations are far from cycle-correct.


## Build instructions.
After installing the dependencies with
```
opam install .
```
Try running 
```
dune exec wozmon 
```
to start the Wozmon REPL. Within the REPL, type: 
```
0:A9 0 AA 20 EF FF E8 8A 4C 2 0 
```
And then type `R` to run the program. This should display a continuous stream of ASCII characters. 

## Future Work 

1. Implement more of the CPU, the VIA and the UART functionality.

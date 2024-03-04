# OCaml emulation of Ben Eater's 6502 Computer.

This is repository houses an OCaml emulator of Ben Eater's 6502-based breadboard computer:
 
![Also pictured, a Flipper zero.](https://github.com/kodyvajjha/beneater-6502/blob/master/PXL_20230801_224701368.jpg?raw=true)

For the CPU we use Vigile Robles' excellent [6502-ml](https://github.com/Firobe/6502-ml). 
The only program currently supported in the CPU is (Ben Eater's version of) Steve Wozniak's Wozmon program for the Apple I, which was [adapted to run](https://www.youtube.com/watch?v=HlLCtjJzHVI) for the breadboard computer.  

A challenge to emulate Wozmon is to support keyboard I/O to run concurrently as the CPU is running. We use the concurrency library [Lwt](https://github.com/ocsigen/lwt) for this purpose. This allows us to define *promises* corresponding to user input and CPU cycles and combine them.


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

## Acknowledgements

I had been following along Ben Eater's incredible series of videos on the 6502 computer for the better part of two years. I had been wanting to build an OCaml emulator of the breadboard computer as I was too scared to keep digging out the breadboard everytime a new video came out, lest I misplace a connection or two and tarnish that work of art. As such, this would not have been possible without Virgile Robles and Ben Eater's work. 

## Future Work 

1. Support MS BASIC.
2. Support more hardware
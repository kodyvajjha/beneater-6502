(* For more inspiration see https://github.com/Firobe/nes-ml/blob/main/src/nes.ml *)

(*
   Pipeline:

   Grab char from input ->
   Set key ready status ->
   Convert char to ASCII data ->
   use it to create term of type below ->
   use this term to perform concrete writes at
   mem locations 0x5000 and 0x5001 in the cpu
*)

let () = Printexc.record_backtrace true

let wozmon () =
  let open Beneater_6502 in
  let input : Cpu.EaterMemoryMap.input = { rom_path = "bin/wozmon.bin" } in
  let cpu = Cpu.create input in
  Lwt.join [ Cpu.run cpu; Keyboard.write cpu ]

let () = Lwt_main.run @@ wozmon ()

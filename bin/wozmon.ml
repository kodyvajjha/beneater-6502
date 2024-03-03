(* For more inspiration see https://github.com/Firobe/nes-ml/blob/main/src/nes.ml *)

let () = Printexc.record_backtrace true

let wozmon () =
  let open Beneater_6502 in
  let input : Cpu.EaterMemoryMap.input = { rom_path = "bin/wozmon.bin" } in
  let cpu = Cpu.create input in
  Lwt.join [ Cpu.run cpu; Keyboard.write cpu ]

let () = Lwt_main.run @@ wozmon ()

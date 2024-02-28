(* For more inspiration see https://github.com/Firobe/nes-ml/blob/main/src/nes.ml *)

let () = Printexc.record_backtrace true

let src = Logs.Src.create "eater.cpu" ~doc:"logs Eater CPU events"

module Log = (val Logs.src_log src : Logs.LOG)

(* open Stdint *)

(*
       Want to capture one loop of the wozmon repl.
       Input is logged at location 0x200
       We read the output which is logged to ACIA_DATA at 0x5000.
    *)

(* let rec run_cpu cpu =
   let open Beneater_6502.Cpu in
   EaterCPU.next_instruction cpu *)
(* module Eater = struct
     [@@@warning "-32"]

     open Beneater_6502

     type state = {
       cpu: Cpu.t;
       via: Via.t;
     }

     let run (s : state) = Cpu.run s.cpu
   end *)

let repl () =
  let open Beneater_6502 in
  let input : Cpu.EaterMemoryMap.input = { rom_path = "bin/wozmon.bin" } in
  let cpu = Cpu.create input in
  Lwt.join [ Cpu.run cpu; Via.write cpu; Display.show cpu ]

let () =
  Logs.set_reporter (Logs_fmt.reporter ());
  Lwt_main.run @@ repl ()

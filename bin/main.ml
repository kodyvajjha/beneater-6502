(* For more inspiration see https://github.com/Firobe/nes-ml/blob/main/src/nes.ml *)

let () = Printexc.record_backtrace true

let src = Logs.Src.create "eater.cpu" ~doc:"logs Eater CPU events"

module Log = (val Logs.src_log src : Logs.LOG)

(*
  Want to capture one loop of the wozmon repl.
  Input is logged at location 0x200
  We read the output which is logged to ACIA_DATA at 0x5000.
*)

module Eater = struct
  [@@@warning "-32"]

  open Beneater_6502

  type state = {
    cpu: Cpu.t;
    display: Display.t;
  }

  let run (s : state) = Cpu.run s.cpu
end

let repl () =
  let open Beneater_6502 in
  let input : Cpu.EaterMemoryMap.input = { rom_path = "bin/wozmon.bin" } in
  let state : Eater.state =
    { cpu = Cpu.create input; display = Display.empty }
  in
  Lwt.join [ Eater.run state; Via.write state.cpu; Cpu.show_display state.cpu ]

let () =
  Logs.set_reporter (Logs_fmt.reporter ());
  Lwt_main.run @@ repl ()

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
module Eater = struct
  [@@@warning "-32"]

  open Beneater_6502

  type state = {
    cpu: Cpu.t;
    via: Via.t;
  }

  let run (s : state) =
    (* Set the PC by reading address at FFF[C-D], which starts Wozmon. *)
    Cpu.PC.init (Cpu.pc s.cpu) (Cpu.memory s.cpu);
    (* Keep fetching and running instructions in the CPU. *)
    while true do
      Cpu.print_state s.cpu;

      ignore @@ Cpu.next_instruction s.cpu
    done
end

let repl () =
  let open Beneater_6502 in
  let init_input : Cpu.EaterMemoryMap.input = { rom_path = "bin/wozmon.bin" } in
  let init_state : Eater.state =
    { cpu = Cpu.create init_input; via = { data = 0x00; status = 0x00 } }
  in
  Eater.run init_state

let () =
  Logs.set_reporter (Logs_fmt.reporter ());
  repl ()

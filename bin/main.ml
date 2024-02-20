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

let repl () =
  let open Beneater_6502.Cpu in
  let cpu =
    EaterCPU.create
      { rom_path = "bin/wozmon.bin"; via = { data = 0xea; status = 0x00 } }
  in
  (* Set the PC by reading address at FFF[C-D], which starts Wozmon. *)
  EaterCPU.PC.init (EaterCPU.pc cpu) (EaterCPU.memory cpu);
  (* Keep fetching and running instructions in the CPU. *)
  while true do
    EaterCPU.print_state cpu;
    ignore @@ EaterCPU.next_instruction cpu
  done

let () =
  Logs.set_reporter (Logs_fmt.reporter ());
  repl ()

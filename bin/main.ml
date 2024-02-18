(* For more inspiration see https://github.com/Firobe/nes-ml/blob/main/src/nes.ml *)

let () = Printexc.record_backtrace true

open Stdint

(*
     Want to capture one loop of the wozmon repl. 
     Input is logged at location 0x200
     We read the output which is logged to ACIA_DATA at 0x5000.
  *)

let repl () =
  let open Beneater_6502.Cpu in
  let cpu = EaterCPU.create "bin/wozmon.bin" in
  EaterCPU.print_state cpu;
  EaterCPU.PC.init (EaterCPU.pc cpu) (EaterCPU.memory cpu);
  write_mem cpu 0x5001 (Uint8.of_int 0x00);
  while true do
    EaterCPU.print_state cpu;
    ignore @@ EaterCPU.next_instruction cpu;
    try
      (* CCFormat.printf "@[0x5000: %d@]@." (Uint8.to_int @@ read_mem cpu 0x5000);
         CCFormat.printf "@[0x5001: %d@]@." (Uint8.to_int @@ read_mem cpu 0x5001);
         flush stdout; *)
      let c = input_char stdin in
      let input = CCFormat.sprintf "0x%x" (Char.code c) in
      CCFormat.printf "You entered '%s'@." input;
      (* let input = read_line () in *)
      (match int_of_string_opt input with
      | Some i ->
        write_mem cpu 0x5000 (Uint8.of_int i);
        write_mem cpu 0x5001 (Uint8.of_int 0x08)
      | None -> ());
      ignore @@ EaterCPU.next_instruction cpu;
      ignore @@ EaterCPU.next_instruction cpu;
      CCFormat.printf "Screen : %c@."
        (Char.chr (Uint8.to_int @@ read_mem cpu 0x5000))
    with
    | End_of_file ->
      CCFormat.printf "Ctrl+D caught, exiting!";
      exit 0
    | Sys.Break ->
      CCFormat.printf "Goodbye!@.";
      exit 0
  done

(* let repl () =
   let open Beneater_6502.Cpu in
   let cpu = EaterCPU.create "bin/wozmon.bin" in
   write_mem cpu 0x5001 (Uint8.of_int 0x00);
   EaterCPU.print_state cpu;
   while true do
     try
       let input = read_line () in
       (match input with
       | "init" -> EaterCPU.PC.init (EaterCPU.pc cpu) (EaterCPU.memory cpu)
       | _ -> (
           match int_of_string_opt input with
           | Some i -> write_mem cpu 0x5000 (Uint8.of_int i)
           | None -> ()));
       ignore @@ EaterCPU.next_instruction cpu;
       EaterCPU.print_state cpu
     with End_of_file -> CCFormat.printf "CTRL+D caught, exiting!"
   done *)

let () = repl ()

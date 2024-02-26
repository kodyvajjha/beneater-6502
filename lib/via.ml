(*
   Facts:
    1) Wozmon keeps running until it detects a "key ready" which is indicated by the 
    third bit of ACIA_STATUS being set.
    2) Need to capture a loop which takes a human input, sets ACIA_STATUS,
     stores input into ACIA_DATA, converts that into ASCII and writes those to
     memory locations 0x5000 and 0x5001 in the CPU.
   Note: We are not implementing the entire 65c22 VIA but only that
    functionality to let it emulate a keypress. *)

(*
   Pipeline:

   Grab char from input ->
   Set key ready status ->
   Convert char to ASCII data ->
   use it to create term of type below ->
   use this term to perform concrete writes at
   mem locations 0x5000 and 0x5001 in the cpu
*)
type t = {
  mutable data: int;
  mutable status: int;
}

let pp fpf acia = CCFormat.fprintf fpf "@[%c@]" (Char.chr acia.data)

let write (cpu : Cpu.t) (via : t) =
  let open Stdint in
  Cpu.write_mem cpu 0x5000 (Uint8.of_int via.data);
  Cpu.write_mem cpu 0x5001 (Uint8.of_int via.status)
(* let c = input_char stdin in
   let input = CCFormat.sprintf "0x%x" (Char.code c) in
   CCFormat.printf "You entered '%s'@." input;*)
(* let input = read_line () in *)
(* match int_of_string_opt input with
   | Some i -> *)

(* | None -> () *)

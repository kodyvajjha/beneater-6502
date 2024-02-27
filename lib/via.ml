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
open Lwt.Syntax

type t = {
  mutable data: int;
  mutable status: int;
}

let pp fpf acia = CCFormat.fprintf fpf "@[%c@]" (Char.chr acia.data)

let rec write (cpu : Cpu.t) =
  let open Stdint in
  let* c = Lwt_io.read_char_opt Lwt_io.stdin in
  let* () = Lwt_unix.sleep 0.1 in
  match c with
  | Some c ->
    let* () = Lwt.return @@ Cpu.write_mem cpu 0x5001 (Uint8.of_int 0x08) in
    let* () = Lwt_unix.sleep 0.1 in
    let* () =
      Lwt.return @@ Cpu.write_mem cpu 0x5000 (Uint8.of_int (Char.code c))
    in
    let* () = Lwt_unix.sleep 0.1 in
    let* () = Lwt.return @@ Cpu.write_mem cpu 0x5001 (Uint8.of_int 0x00) in
    let* i = Lwt.return @@ Cpu.read_mem cpu 0x5000 in
    let* () =
      Lwt_io.fprintf Lwt_io.stdout "0x5000: %c"
        (Char.chr (Stdint.Uint8.to_int i))
    in
    write cpu
  | None -> Lwt.return_unit

let display (cpu : Cpu.t) =
  let* i = Lwt.return @@ Cpu.read_mem cpu 0x5000 in
  let* () =
    Lwt_io.fprintf Lwt_io.stdout "%c" (Char.chr (Stdint.Uint8.to_int i))
  in
  Lwt.return_unit

(* let c = input_char stdin in
   let input = CCFormat.sprintf "0x%x" (Char.code c) in
   CCFormat.printf "You entered '%s'@." input;*)
(* let input = read_line () in *)
(* match int_of_string_opt input with
   | Some i -> *)

(* | None -> () *)

(*
   Facts:
    1) Wozmon keeps running until it detects a "key ready" which is indicated by the 
    third bit of ACIA_STATUS being set.
    2) Need to capture a loop which takes a human input, sets ACIA_STATUS,
     stores input into ACIA_DATA, converts that into ASCII and writes those to
     memory locations 0x5000 and 0x5001 in the CPU.
   Note: We are not implementing the entire 65c22 VIA but only that
    functionality to let it emulate a keypress. *)

open Lwt.Syntax

let rec write (cpu : Cpu.t) =
  let open Stdint in
  let* c = Lwt_io.read_char_opt Lwt_io.stdin in
  let* () = Lwt_unix.sleep 0.01 in
  match c with
  | Some c ->
    let* () = Lwt.return @@ Cpu.write_mem cpu 0x5001 (Uint8.of_int 0x08) in
    let* () =
      Lwt.return @@ Cpu.write_mem cpu 0x5000 (Uint8.of_int (Char.code c))
    in

    let* () = Lwt_unix.sleep 0.01 in
    let* () = Lwt.return @@ Cpu.write_mem cpu 0x5001 (Uint8.of_int 0x00) in

    write cpu
  | None -> Lwt.return_unit

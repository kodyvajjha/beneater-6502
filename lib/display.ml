type t = {
  mutable cursor: char;
  mutable buffer: string;
}

let empty = { cursor = ' '; buffer = "" }

let process (c : char) display =
  display.cursor <- c;
  display.buffer <- display.buffer ^ CCString.of_char c

let show (display : t) =
  let { cursor; buffer } = display in
  Lwt_io.printl (CCFormat.sprintf "%c %s" cursor buffer)

(* open Lwt.Syntax

   type t = { mutable text: char }

   let pp fpf t = CCFormat.fprintf fpf "%c" t.text

   let read cpu =
     let* old = Lwt.return @@ Cpu.read_mem cpu 0x5004 in
     Lwt.return @@ { text = Char.chr (Stdint.Uint8.to_int old) }

   let show (cpu : Cpu.t) =
     let open Stdint in
     let* () = Lwt_unix.sleep 3. in
     let* { text } = read cpu in
     Lwt_io.printl
       (CCFormat.sprintf "HEREE!!!!!! %a" C6502.Utils.pp_u8
          (Uint8.of_int (Char.code text))) *)

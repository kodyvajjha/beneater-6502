open Lwt.Syntax

type t = { mutable text: char }

let pp fpf t = CCFormat.fprintf fpf "%c" t.text

let show (cpu : Cpu.t) =
  let* () = Lwt_unix.sleep 3. in
  let* old = Lwt.return @@ Cpu.read_mem cpu 0x5004 in
  let* _v = Lwt.return @@ { text = Char.chr (Stdint.Uint8.to_int old) } in
  Lwt_io.printl (CCFormat.sprintf "HEREE!!!!!! %d" (Stdint.Uint8.to_int old))

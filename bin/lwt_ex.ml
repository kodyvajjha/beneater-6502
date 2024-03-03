(* open Stdint

   module type Rom_S = sig
     type t = uint8 array
   end

   module Rom : Rom_S = struct
     type t = uint8 array
   end

   module type Display_S = sig
     type t = {
       mutable cursor: char;
       mutable buffer: string;
     }

     val empty : t

     val process : char -> t -> unit
   end

   module Display : Display_S = struct
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
   end

   type ('a, 'b) devices = {
     main: 'a;
     display: 'b;
   }

   module EaterMemoryMap (R : Rom_S) (D : Display_S) : C6502.MemoryMap = struct
     open C6502.Utils

     type t = (R.t, D.t) devices
     (** Instruction type *)

     type input = { rom_path: string (* rom path needed to initialize memory *) }

     (**  Function to load a rom.*)
     let create i : t =
       (* 0x000 to 0xFFFF main memory *)
       let main : uint8 array = Array.make 0x10000 (u8 0xea) in
       let file = open_in_bin i.rom_path in
       let store = Bytes.create 32768 in
       let read = input file store 0 32768 in
       let store = Bytes.sub store 0 read in
       (* The rom is loaded into the lower half of the address space, i.e., from
          0x8000 to 0xFFFF. This is why we add 32768 below. *)
       Bytes.iteri (fun i el -> main.(i + 32768) <- u8 (int_of_char el)) store;
       (* The via payload gets written to 0x5000 and 0x5001 of main memory at startup.
          This is theoretically unnecessary.
       *)
       main.(0x5001) <- u8 0x00;
       let display = D.empty in
       { main; display }

     let read (m : t) (a : uint16) : uint8 = m.main.(Uint16.to_int a)

     let write (m : t) (addr : uint16) v : unit =
       if addr = u16 0x5004 then (
         let curchar = Char.chr (Uint8.to_int @@ m.main.(Uint16.to_int addr)) in
         D.process curchar m.display
       ) else
         m.main.(Uint16.to_int addr) <- v
   end

   let () =
     (* let module Moo = EaterMemoryMap (Rom) (Display) in
        let module Cpu = C6502.Make (Moo) in
        let input : Moo.input = { Moo.rom_path = "bin/wozmon.bin" } in *)
     () *)

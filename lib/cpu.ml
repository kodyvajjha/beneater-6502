open C6502.Utils
open Stdint

module EaterMemoryMap = struct
  type t = {
    via: Via.t;
    main: uint8 array;
  }
  (** Instruction type *)

  type input = {
    rom_path: string; (* rom path needed to initialize memory *)
    via: Via.t;
  }

  let in_ram_range addr = addr >= 0x0000 && addr <= 0x3FFF

  let in_io_range addr = addr >= 0x4000 && addr <= 0x7FFF

  let in_via_range addr = addr >= 0x6000 && addr <= 0x600F

  let in_rom_range addr = addr >= 0x8000 && addr <= 0xFFFF

  (**  Function to load a rom.*)
  let create i : t =
    let main : uint8 array = Array.make 0x10000 (u8 0xea) in
    let file = open_in_bin i.rom_path in
    let store = Bytes.create 32768 in
    let read = input file store 0 32768 in
    let store = Bytes.sub store 0 read in
    (* The rom is loaded into the lower half of the address space, i.e., from
       0x8000 to 0xFFFF. This is why we add 32768 below. *)
    Bytes.iteri (fun i el -> main.(i + 32768) <- u8 (int_of_char el)) store;
    main.(0x5000) <- u8 i.via.data;
    main.(0x5001) <- u8 i.via.status;
    { main; via = i.via }

  (* 0x000 to 0xFFFF main memory *)

  let read (m : t) (a : uint16) : uint8 = m.main.(Uint16.to_int a)

  (* TODO: Modify this to populate the Via.t state when writing happens
     at the appropriate memory location. *)
  let write (m : t) a v : unit = m.main.(Uint16.to_int a) <- v
end

module EaterCPU = struct
  module _ : C6502.MemoryMap = EaterMemoryMap

  include C6502.Make (EaterMemoryMap)

  let set_pc cpu = PC.set (pc cpu)

  let get_pc cpu = PC.get (pc cpu)

  let set_reg cpu = Register.set (registers cpu)

  let get_reg cpu = Register.get (registers cpu)

  let read_mem cpu a = (memory cpu).main.(a)

  let write_mem cpu a v = (memory cpu).main.(a) <- v

  (** Character in the output text buffer. Address 0x5000 holds ACIA_DATA. *)
  (* let output_buf cpu = Char.chr @@ Uint8.to_int @@ read_mem cpu 0x5000 *)
end

open C6502.Utils
open Stdint

module EaterMemoryMap = struct
  type t = {
    via: uint8 array;
    rom: uint8 array;
  }
  (** Instruction type *)

  type input = string
  (** rom path *)

  let in_ram_range addr = addr >= 0x0000 && addr <= 0x3FFF

  let in_io_range addr = addr >= 0x4000 && addr <= 0x7FFF

  let in_rom_range addr = addr >= 0x8000 && addr <= 0xFFFF

  (**  Function to load a rom.*)
  let create path : t =
    (* The rom is loaded into the lower half of the address space, i.e., from
       0x8000 to 0xFFFF. This is why we add 32768 below. *)
    let rom : uint8 array = Array.make 0x10000 (u8 0xea) in
    let file = open_in_bin path in
    let store = Bytes.create 32768 in
    let read = input file store 0 32768 in
    let store = Bytes.sub store 0 read in
    Bytes.iteri (fun i el -> rom.(i + 32768) <- u8 (int_of_char el)) store;
    { rom }

  (* 0x000 to 0xFFFF main memory *)

  let read (m : t) (a : uint16) : uint8 = m.rom.(Uint16.to_int a)

  (* TODO: Modify this to populate the Via.t state when writing happens
     at the appropriate memory location. *)
  let write (m : t) a v : unit = m.rom.(Uint16.to_int a) <- v
end

module _ : C6502.MemoryMap = EaterMemoryMap

module EaterCPU = C6502.Make (EaterMemoryMap)

let set_pc cpu = EaterCPU.PC.set (EaterCPU.pc cpu)

let get_pc cpu = EaterCPU.PC.get (EaterCPU.pc cpu)

let set_reg cpu = EaterCPU.Register.set (EaterCPU.registers cpu)

let get_reg cpu = EaterCPU.Register.get (EaterCPU.registers cpu)

let read_mem cpu a = (EaterCPU.memory cpu).rom.(a)

let write_mem cpu a v = (EaterCPU.memory cpu).rom.(a) <- v

(** Character in the output text buffer. Address 0x5000 holds ACIA_DATA. *)
(* let output_buf cpu = Char.chr @@ Uint8.to_int @@ read_mem cpu 0x5000 *)

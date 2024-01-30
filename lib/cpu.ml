open C6502.Utils
open Stdint

module EaterCPU = C6502.Make (struct
  type t = uint8 array
  (** Instruction type *)

  type input = string
  (** rom path *)

  (**  Function to load a rom.*)
  let create path : t =
    let mem : uint8 array = Array.make 0x10000 (u8 0xea) in
    let file = open_in_bin path in
    let store = Bytes.create 32768 in
    let read = input file store 0 32768 in
    let store = Bytes.sub store 0 read in
    (* The rom is loaded into the lower half of the address space, i.e., from
       0x8000 to 0xFFFF. This is why we add 32768 below. *)
    Bytes.iteri (fun i el -> mem.(i + 32768) <- u8 (int_of_char el)) store;
    mem

  (* 0x000 to 0xFFFF main memory *)

  let read (m : t) (a : uint16) : uint8 = m.(Uint16.to_int a)

  (* TODO: Modify this to populate the Via.t state when writing happens
     at the appropriate memory location. *)
  let write (m : t) a v : unit = m.(Uint16.to_int a) <- v
end)

let set_pc cpu = EaterCPU.PC.set (EaterCPU.pc cpu)

let get_pc cpu = EaterCPU.PC.get (EaterCPU.pc cpu)

let set_reg cpu = EaterCPU.Register.set (EaterCPU.registers cpu)

let get_reg cpu = EaterCPU.Register.get (EaterCPU.registers cpu)

let read_mem cpu a = (EaterCPU.memory cpu).(a)

let write_mem cpu a v = (EaterCPU.memory cpu).(a) <- v

(** Character in the output text buffer. Address 0x5000 holds ACIA_DATA. *)
let output_buf cpu = Char.chr @@ Uint8.to_int @@ read_mem cpu 0x5000

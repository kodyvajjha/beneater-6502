open C6502.Utils
open Stdint

(* type ('a, 'b) devices = {
     main: 'a;
     display: 'b;
   } *)

module EaterMemoryMap = struct
  type t = {
    main: uint8 array;
    display: Display.t;
  }
  (** Instruction type *)

  type input = { rom_path: string (* rom path needed to initialize memory *) }

  let in_ram_range addr = addr >= u16 0x0000 && addr <= u16 0x3FFF

  let in_io_range addr = addr >= u16 0x4000 && addr <= u16 0x7FFF

  let in_via_range addr = addr >= u16 0x6000 && addr <= u16 0x600F

  let in_rom_range addr = addr >= u16 0x8000 && addr <= u16 0xFFFF

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
    let display = Display.empty in
    { main; display }

  let read (m : t) (a : uint16) : uint8 = m.main.(Uint16.to_int a)

  (* TODO: Modify this to populate the Display.t state when writing happens
     at the appropriate memory location. *)
  let write (m : t) (addr : uint16) v : unit =
    if addr = u16 0x5000 then (
      let curchar = Char.chr (Uint8.to_int @@ v) in
      Display.process curchar m.display
    ) else
      m.main.(Uint16.to_int addr) <- v
end

module _ : C6502.MemoryMap = EaterMemoryMap

include C6502.Make (EaterMemoryMap)

let set_pc cpu = PC.set (pc cpu)

let get_pc cpu = PC.get (pc cpu)

let set_reg cpu = Register.set (registers cpu)

let get_reg cpu = Register.get (registers cpu)

let read_mem cpu a = (memory cpu).main.(a)

let write_mem cpu a v = (memory cpu).main.(a) <- v

(* let output_buf cpu = Char.chr @@ Uint8.to_int @@ read_mem cpu 0x5000 *)

(** Character in the output text buffer. Address 0x5000 holds ACIA_DATA. *)
let run cpu =
  let open Lwt.Syntax in
  let rec loop () =
    (* Keep fetching and running instructions in the CPU. The clock speed is 1MHz. *)
    let* () = Lwt_unix.sleep 0.00001 in

    (* let* () = Lwt.return @@ print_state cpu in *)
    let* _cycs = Lwt.return @@ next_instruction cpu in

    loop ()
  in
  try%lwt
    (* Set the PC by reading address at FFF[C-D], which starts Wozmon. *)
    let* () = Lwt.return @@ PC.init (pc cpu) (memory cpu) in
    loop ()
  with C6502.Invalid_instruction (_addr, _opcode) ->
    Lwt_io.printf "Invalid instruction"

let show_display (cpu : t) =
  let cpu = memory cpu in
  let display = cpu.display in
  Lwt_io.printl (CCFormat.sprintf "%c %s" display.cursor display.buffer)

type t = {
  mutable cursor: char;
  mutable buffer: string;
}
[@@deriving show]

let empty = { cursor = ' '; buffer = "" }

let process (c : char) display =
  display.cursor <- c;
  (* CCFormat.printf "%c%!" c; *)
  display.buffer <- display.buffer ^ CCString.of_char c

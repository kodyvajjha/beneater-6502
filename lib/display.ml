type t = { mutable cursor: char } [@@deriving show]

let empty = { cursor = ' ' }

let process (c : char) display =
  display.cursor <- c;
  CCFormat.printf "%c%!" c

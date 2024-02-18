(* open Stdint *)

let rec repl () =
  try
    let char = input_char stdin in
    CCFormat.printf "%x@." (Char.code char);
    repl ()
  with
  | End_of_file ->
    CCFormat.printf "Ctrl+D caught, exiting!";
    exit 0
  | Sys.Break ->
    CCFormat.printf "Goodbye!@.";
    exit 0

let () = repl ()

(* Import Lwt module *)

open Lwt.Syntax

(* Function to detect key presses *)
let rec detect_key_press () =
  let* line = Lwt_io.read_line Lwt_io.stdin in
  let* () = Lwt_io.printf "Hello %s!\n" line in
  detect_key_press () (* Continue detecting key presses *)

(* Background task that prints a message every second *)
let background_task () =
  let rec loop count () =
    let* () = Lwt_unix.sleep 1.0 in
    let* () = Lwt_io.fprintf Lwt_io.stdout "%d\n" count in
    loop (count + 1) ()
  in
  loop 0 ()

(* Main function *)
let main () =
  (* Start the background task independently *)

  (* Start detecting key presses *)
  Lwt_main.run (Lwt.pick [ background_task (); detect_key_press () ])

(* Call the main function to start the program *)
let () = main ()

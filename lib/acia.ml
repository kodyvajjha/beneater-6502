(* Note: We are not implementing the entire 65c22 VIA but only that
   functionality to let it emulate a keypress. *)

type t = {
  mutable data: int;
  mutable status: int;
}

let pp fpf acia = CCFormat.fprintf fpf "@[%c@]" (Char.chr acia.data)

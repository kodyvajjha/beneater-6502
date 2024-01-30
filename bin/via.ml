(*
   Facts:
   1) Wozmon keeps running until it detects a "key ready" which is indicated by the third bit of ACIA_STATUS being set.
   2) Need to capture a loop which takes a human input, sets ACIA_STATUS, 
    stores input into ACIA_DATA, converts that into ASCII and writes those to memory locations 0x5000 and 0x5001 in the CPU. 
*)

    .org $8000
reset:
    ;; Set data-direction for the B register in the 6522 chip
    ;; to output
    lda #$ff                    ; # means load immediate (the hex after it)
    sta $6002

    ;; Print 0x50 onto LEDs.
    lda #$50                    ; load the accumulator with the byte 0x50
    sta $6000                   ; store it into memory at address 0x6000

loop:
    ;; Rotate LED pattern to right.
    ror
    sta $6000
    ;; Jump back to start
    jmp loop

    .org $fffc
    .word reset
    .word $0000

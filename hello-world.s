PORTB = $6000
PORTA = $6001
DDRB = $6002
DDRA = $6003


E  = %10000000
RW = %01000000
RS = %00100000

    .org $8000
reset:
    ;; Set data-direction for the B register in the 6522 chip
    ;; to output
    lda #%11111111              ; # means load immediate (the hex after it)
    sta DDRB

    lda #%11100000              ; Set top three pins on port A to output.
    sta DDRA

    lda #%00111000              ; Set 8-bit mode, 2-line display, 5x8 font
    sta PORTB
    lda #0                      ; Clear RS/RW/E
    sta PORTA
    lda #E                      ; Set enable bit to send instruction.
    sta PORTA
    lda #0                      ; Clear RS/RW/E
    sta PORTA

    lda #%00001110              ; Display on; cursor on; blink off
    sta PORTB
    lda #0                      ; Clear RS/RW/E
    sta PORTA
    lda #E                      ; Set enable bit to send instruction.
    sta PORTA
    lda #0                      ; Clear RS/RW/E
    sta PORTA

    lda #%00000001              ; Clear display
    sta PORTB
    lda #0                      ; Clear RS/RW/E
    sta PORTA
    lda #E                      ; Set enable bit to send instruction.
    sta PORTA
    lda #0                      ; Clear RS/RW/E
    sta PORTA


    lda #%00000110              ; Increment and shift cursor; don't shift display
    sta PORTB
    lda #0                      ; Clear RS/RW/E
    sta PORTA
    lda #E                      ; Set enable bit to send instruction.
    sta PORTA
    lda #0                      ; Clear RS/RW/E
    sta PORTA

    lda #"H"                    ; Load the binary repn of "H"
    sta PORTB
    lda #RS                      ; Clear RS/RW/E
    sta PORTA
    lda #(RS | E)               ; Set enable and RS bit to send instruction.
    sta PORTA
    lda #RS                      ; Clear RS/RW/E
    sta PORTA

    lda #"i"                    ; Load the binary repn of "H"
    sta PORTB
    lda #RS                      ; Clear RS/RW/E
    sta PORTA
    lda #(RS | E)               ; Set enable and RS bit to send instruction.
    sta PORTA
    lda #RS                      ; Clear RS/RW/E
    sta PORTA


    lda #","                    ; Load the binary repn of "H"
    sta PORTB
    lda #RS                      ; Clear RS/RW/E
    sta PORTA
    lda #(RS | E)               ; Set enable and RS bit to send instruction.
    sta PORTA
    lda #RS                      ; Clear RS/RW/E
    sta PORTA


    lda #"V"                    ; Load the binary repn of "H"
    sta PORTB
    lda #RS                      ; Clear RS/RW/E
    sta PORTA
    lda #(RS | E)               ; Set enable and RS bit to send instruction.
    sta PORTA
    lda #RS                      ; Clear RS/RW/E
    sta PORTA


    lda #"a"                    ; Load the binary repn of "H"
    sta PORTB
    lda #RS                      ; Clear RS/RW/E
    sta PORTA
    lda #(RS | E)               ; Set enable and RS bit to send instruction.
    sta PORTA
    lda #RS                      ; Clear RS/RW/E
    sta PORTA


    lda #"j"                    ; Load the binary repn of "H"
    sta PORTB
    lda #RS                      ; Clear RS/RW/E
    sta PORTA
    lda #(RS | E)               ; Set enable and RS bit to send instruction.
    sta PORTA
    lda #RS                      ; Clear RS/RW/E
    sta PORTA


    lda #"j"                    ; Load the binary repn of "H"
    sta PORTB
    lda #RS                      ; Clear RS/RW/E
    sta PORTA
    lda #(RS | E)               ; Set enable and RS bit to send instruction.
    sta PORTA
    lda #RS                      ; Clear RS/RW/E
    sta PORTA


    lda #"h"                    ; Load the binary repn of "H"
    sta PORTB
    lda #RS                      ; Clear RS/RW/E
    sta PORTA
    lda #(RS | E)               ; Set enable and RS bit to send instruction.
    sta PORTA
    lda #RS                      ; Clear RS/RW/E
    sta PORTA


    lda #"a"                    ; Load the binary repn of "H"
    sta PORTB
    lda #RS                      ; Clear RS/RW/E
    sta PORTA
    lda #(RS | E)               ; Set enable and RS bit to send instruction.
    sta PORTA
    lda #RS                      ; Clear RS/RW/E
    sta PORTA


    lda #"s"                    ; Load the binary repn of "H"
    sta PORTB
    lda #RS                      ; Clear RS/RW/E
    sta PORTA
    lda #(RS | E)               ; Set enable and RS bit to send instruction.
    sta PORTA
    lda #RS                      ; Clear RS/RW/E
    sta PORTA

    lda #"!"                    ; Load the binary repn of "H"
    sta PORTB
    lda #RS                      ; Clear RS/RW/E
    sta PORTA
    lda #(RS | E)               ; Set enable and RS bit to send instruction.
    sta PORTA
    lda #RS                      ; Clear RS/RW/E
    sta PORTA

loop:
    jmp loop

    .org $fffc
    .word reset
    .word $0000

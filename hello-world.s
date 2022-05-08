PORTB = $6000
PORTA = $6001
DDRB = $6002
DDRA = $6003


E  = %10000000
RW = %01000000
RS = %00100000

    .org $8000
reset:
    ldx #$ff
    txs

    ;; Set data-direction for the B register in the 6522 chip
    ;; to output
    lda #%11111111              ; # means load immediate (the hex after it)
    sta DDRB

    lda #%11100000              ; Set top three pins on port A to output.
    sta DDRA

    lda #%00111000              ; Set 8-bit mode, 2-line display, 5x8 font
    jsr lcd_instruction

    lda #%00001110              ; Display on; cursor on; blink off
    sta PORTB
    lda #0                      ; Clear RS/RW/E
    sta PORTA
    lda #E                      ; Set enable bit to send instruction.
    sta PORTA
    lda #0                      ; Clear RS/RW/E
    sta PORTA

    lda #%00000001              ; Clear display
    jsr lcd_instruction

    lda #%00000110              ; Increment and shift cursor; don't shift display
    jsr lcd_instruction

    ldx #0
print:
    lda message,x                    ; Load the binary repn of "H"
    beq loop
    jsr print_char
    inx
    jmp print

loop:
    jmp loop

message: .asciiz "Write ur thesis!"

lcd_wait:
    pha
    lda #%00000000               ; Set PORT B as input
    sta DDRB

lcdbusy:
    lda #RW
    sta PORTA
    lda #(RW | E)
    sta PORTA
    lda PORTB
    and #%10000000              ; Pick out the top bit (see pg 24 of LCD module) to check if busy flag is set.
    bne lcdbusy

    lda #RW
    sta PORTA
    lda #%11111111              ; Port B is output
    sta DDRB
    pla
    rts

lcd_instruction:
    jmp lcd_wait
    sta PORTB
    lda #0                      ; Clear RS/RW/E
    sta PORTA
    lda #E                      ; Set enable bit to send instruction.
    sta PORTA
    lda #0                      ; Clear RS/RW/E
    sta PORTA
    rts

print_char:
    jsr lcd_wait
    sta PORTB
    lda #RS                      ; Clear RS/RW/E
    sta PORTA
    lda #(RS | E)               ; Set enable and RS bit to send instruction.
    sta PORTA
    lda #RS                      ; Clear RS/RW/E
    sta PORTA
    rts

    .org $fffc
    .word reset
    .word $0000

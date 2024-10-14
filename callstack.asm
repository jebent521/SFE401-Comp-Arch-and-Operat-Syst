; Author: Jonah Ebent
; main():
main:
    ; =========== Example 1 ===========
    ; Store float $42AA4000 to memory
    LDA #$00
    STA $0200
    LDA #$40
    STA $0201
    LDA #$AA
    STA $0202
    LDA #$42
    STA $0203
    ; Add memory address $0200 onto stack
    LDA #$02
    PHA
    LDA #$00
    PHA
    PHA             ; Placeholder for return value
    JSR getExponent
    PLA             ; Accumulator should contain $06
    STA $0210

    ; =========== Example 2 ===========
    ; Store float $41280000 to memory
    LDA #$00
    STA $0204
    STA $0205
    LDA #$28
    STA $0206
    LDA #$41
    STA $0207
    ; Add memory address $0204 onto stack
    LDA #$02
    PHA
    LDA #$04
    PHA
    PHA             ; Placeholder for return value
    JSR getExponent
    PLA             ; Accumulator should contain $03
    STA $0211

    ; =========== Example 3 ===========
    ; Store float $000000 to memory
    LDA #$00
    STA $0208
    STA $0209
    STA $020A
    STA $020B
    ; Add memory address $0208 onto stack
    LDA #$02
    PHA
    LDA #$08
    PHA
    PHA             ; Placeholder for return value
    JSR getExponent
    PLA             ; Accumulator should contain $00
    STA $0212
JMP done

; Reads an address to an 32-bit float from the stack, puts
; the exponent of that number onto the stack.
; Reads: s eeeeeee|e mmmmmmm|mmmmmmmm|mmmmmmmm
; If exponent == 00 or FF, returns exponent; else returns exponent - 127
; getExponent
; getExponent()
; getExponent():
getExponent:
    ; Store address in memory to use indirect indexed addressing
    TSX
    LDA $0104, X
    STA $00
    LDA $0105, X
    STA $01

    ; Bitwise logic to isolate exponent
    LDY #$02
    LDA ($00), Y    ; get second-most-significant byte of the float
    CLC             ; clear carry
    BPL shift       ; if 8th bit is 0, jump to the bit-shift
    SEC             ; else (bit 8 is 1), set carry
shift:
    LDY #$03
    LDA ($00), Y    ; get most significant byte of the float
    ROL             ; left-shift with carry

    ; Calculate offset (if necessary) and return
    CMP #$00        ; don't offset if exponent is all 0's
    BEQ return
    CMP #$FF        ; don't offset if exponent is all 1's
    BEQ return
    CLC
    ADC #$81        ; subtract 127
return:
    STA $0103, X    ; store A in stack

    ; Clear registers and memory
    LDA #$00
    LDX #$00
    LDY #$00
    STA $00
    STA $01
    CLC
RTS

done:
BRK

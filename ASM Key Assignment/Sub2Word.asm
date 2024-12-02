; Author: Jonah Ebent, 10/28/24

; Develop a 6502 Assembly Program that computes Q = Q - R,
; where Q and R are 2-byte signed numbers located at some
; successive memory location in Little-Endian format and
; ends with the pointer to the return value on the stack
; and ALU control bits set correctly:
;   Int16* Sub2Word(Int16* Q, Int16* R)
; Create a set of test values so that your code demonstrates
; correct behavior for:
;   1. negative and positive numbers (minimally  0xffe4 - 0xfff0)
;   2. multi-word carry (minimally 0x03c3 - 0x01c3)
;   3. multi-word overflow (minimally 0x6301 - 0xd824)

; main():
main:
    ; =========== Example 1: 0xffe4 - 0xfff0 ===========
    ; Store float 0xffe4 (Q) to memory at $0200
    LDA #$e4
    STA $0200
    LDA #$ff
    STA $0201
    ; Store float 0xfff0 (R) to memory at $0202
    LDA #$f0
    STA $0202
    LDA #$ff
    STA $0203
    ; Add memory address $0200 onto stack (*Q)
    LDA #$02
    PHA
    LDA #$00
    PHA
    ; Add memory address $0202 onto stack (*R)
    LDA #$02
    PHA
    PHA
    ; Placeholder for return pointer
    LDA #$ff
    PHA
    PHA
    JSR Sub2Word    ; call subroutine
    ; Cleanup
    PLA             ; get address of return value
    STA $00
    PLA
    STA $01
    LDY #$00
    LDA ($00), Y    ; get LSB of return value
    STA $0204       ; store
    INY
    LDA ($00), Y    ; get MSB of return value
    STA $0205       ; store

    ; =========== Example 2: 0x03c3 - 0x01c3 ===========
    ; Store float 0x03c3 (Q) to memory at $0220
    LDA #$c3
    STA $0220
    LDA #$03
    STA $0221
    ; Store float 0x01c3 (R) to memory at $0222
    LDA #$c3
    STA $0222
    LDA #$01
    STA $0223
    ; Add memory address $0220 onto stack (*Q)
    LDA #$02
    PHA
    LDA #$20
    PHA
    ; Add memory address $0222 onto stack (*R)
    LDA #$02
    PHA
    LDA #$22
    PHA
    ; Placeholder for return pointer
    LDA #$ff
    PHA
    PHA
    JSR Sub2Word    ; call subroutine
    ; Cleanup
    PLA             ; get address of return value
    STA $00
    PLA
    STA $01
    LDY #$00
    LDA ($00), Y    ; get LSB of return value
    STA $0224       ; store
    INY
    LDA ($00), Y    ; get MSB of return value
    STA $0225       ; store

    ; =========== Example 3: 0x6301 - 0xd824 ===========
    ; Store float 0x6301 (Q) to memory at $0240
    LDA #$01
    STA $0240
    LDA #$63
    STA $0241
    ; Store float 0xd824 (R) to memory at $0242
    LDA #$24
    STA $0242
    LDA #$d8
    STA $0243
    ; Add memory address $0240 onto stack (*Q)
    LDA #$02
    PHA
    LDA #$40
    PHA
    ; Add memory address $0242 onto stack (*R)
    LDA #$02
    PHA
    LDA #$42
    PHA
    ; Placeholder for return pointer
    LDA #$ff
    PHA
    PHA
    JSR Sub2Word    ; call subroutine
    ; Cleanup
    PLA             ; get address of return value
    STA $00
    PLA
    STA $01
    LDY #$00
    LDA ($00), Y    ; get LSB of return value
    STA $0244       ; store
    INY
    LDA ($00), Y    ; get MSB of return value
    STA $0245       ; store
JMP done

; Sub2Word():
; Computes Q = Q - R, where Q and R are 2-byte signed numbers
; located at some successive memory location in Little-Endian 
; format and ends with the pointer to the return value on the 
; stack and ALU control bits set correctly:
;   Int16* Sub2Word(Int16* Q, Int16* R)
Sub2Word:
    ; Load *Q into memory to use indirect indexed addressing
    TSX
    LDA $0107, X
    STA $00
    LDA $0108, X
    STA $01
    ; Load *R into memory to use indirect indexed addressing
    LDA $0105, X
    STA $02
    LDA $0106, X
    STA $03
    ; Subtraction logic
    SEC
    LDY #$00
    LDX #$00
    LDA ($00), Y    ; get LSB of Q
    SBC ($02), Y    ; subtract LSB of R
    STA $04, X      ; store result
    INY
    INX
    LDA ($00), Y    ; get MSB of Q
    SBC ($02), Y    ; subtract MSB of R (sets flags as needed)
    STA $04, X      ; store result
    ; Store pointer ($0004) to result in the stack
    TSX
    LDA #$04
    STA $0103, X
    LDA #$00
    STA $0104, X
    PHP             ; save status flags
    ; Clear registers and memory (changes status)
    LDA #$00
    LDX #$00
    LDY #$00
    STA $00
    STA $01
    PLP             ; recover status flags
return:
RTS

done:
BRK
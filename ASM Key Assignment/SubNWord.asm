; Author: Jonah Ebent, 10/28/24

; Develop a 6502 Assembly Program that computes Q = Q - R,
; where Q and R are n-byte signed numbers located at some
; successive memory location in Little-Endian format and
; ends with the pointer to the return value on the stack
; and ALU control bits set correctly:
;   Int16 *SubNWord(Int16* Q, Int16* R, Int8 N)
; Create a set of test values so that your code demonstrates
; correct behavior for:
;   1. negative and positive numbers
;   2. multi-word carry
;   3. multi-word overflow
; Test for N=1, N=2 and N=4
; Minimally use the N=2 cases from SubNWord.asm.

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
    ; Add N=2 onto the stack
    PHA
    ; Placeholder for return pointer
    LDA #$ff
    PHA
    PHA
    ; call subroutine
    JSR SubNWord
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
    ; Add N=2 onto the stack
    LDA #$02
    PHA
    ; Placeholder for return pointer
    LDA #$ff
    PHA
    PHA
    ; call subroutine
    JSR SubNWord
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
    ; Add N=2 onto the stack
    LDA #$02
    PHA
    ; Placeholder for return pointer
    LDA #$ff
    PHA
    PHA
    ; call subroutine
    JSR SubNWord
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

; SubNWord():
; Computes Q = Q - R, where Q and R are N-byte signed numbers
; located at some successive memory location in Little-Endian 
; format and ends with the pointer to the return value on the 
; stack and ALU control bits set correctly:
;   Int16* SubNWord(Int16* Q, Int16* R, Int8 N)
SubNWord:
    ; Load *Q (2 bytes) into memory to use indirect indexed addressing
    TSX
    LDA $0108, X
    STA $00
    LDA $0109, X
    STA $01
    ; Load *R (2 bytes) into memory to use indirect indexed addressing
    LDA $0106, X
    STA $02
    LDA $0107, X
    STA $03
    ; Load N into memory location $04
    LDA $0105, X
    STA $04
    ; Store pointer ($0010) to result in the stack
    LDA #$10
    STA $0103, X
    LDA #$00
    STA $0104, X
    ; Subtraction logic
    SEC
    LDY #$00
loop:               ; While Y != N
    LDA ($00), Y    ; get next byte of Q (starting with LSB)
    SBC ($02), Y    ; subtract next byte of R
    STA $0010, Y    ; store result
    PHP             ; push processor status onto stack
    INY             ; Y++
    CPY $04
    BEQ return      ; if Y = N, return
    PLP             ; else (not done yet), pull flags from stack and loop
    JMP loop
return:
    PLP             ; done now, restore flags
RTS

done:
BRK
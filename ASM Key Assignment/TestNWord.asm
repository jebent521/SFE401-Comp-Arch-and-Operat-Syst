; Author: Jonah Ebent, 10/28/24

; Develop a 6502 Assembly Program that calls a subroutine
; SubNWord that computes Q = Q - R; where Q and R are
; n-byte signed numbers, with N, Q, and R stored on the
; stack. Prior to the call to SubNWord, the program should
; sequentially loaded the values of N, Q, and R onto the
; stack. Set up a series of calls to SubNWord with test
; values so that your code demonstrates correct behavior for:
;   1. negative and positive numbers
;   2. multi-word carry
;   3. multi-word overflow
; Test for N=1, N=2 and N=4.

; main():
main:
    ; N=1
    ; =========== Example 1: 0xf0 - 0xe4 ===========
    ; Store float 0xf0 (Q) to memory at $0200
    LDA #$f0
    STA $0200
    ; Store float 0xe4 (R) to memory at $0201
    LDA #$e4
    STA $0201
    ; Add memory address $0200 onto stack (*Q)
    LDA #$02
    PHA
    LDA #$00
    PHA
    ; Add memory address $0201 onto stack (*R)
    LDA #$02
    PHA
    LDA #$01
    PHA
    ; Add N=1 onto the stack
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
    LDA ($00), Y    ; get return value (should be 0x0c)
    STA $0203       ; store

    ; =========== Example 2: 0xe4 - 0xf0 ===========
    ; Store float 0xe4 (Q) to memory at $0220
    LDA #$e4
    STA $0220
    ; Store float 0xf0 (R) to memory at $0221
    LDA #$f0
    STA $0221
    ; Add memory address $0220 onto stack (*Q)
    LDA #$02
    PHA
    LDA #$20
    PHA
    ; Add memory address $0221 onto stack (*R)
    LDA #$02
    PHA
    LDA #$21
    PHA
    ; Add N=1 onto the stack
    LDA #$01
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
    LDA ($00), Y    ; get return value (should be 0xf4)
    STA $0223       ; store

    ; =========== Example 3: 0x80 - 0x7f ===========
    ; Store float 0x80 (Q) to memory at $0240
    LDA #$80
    STA $0240
    ; Store float 0x7f (R) to memory at $0241
    LDA #$7f
    STA $0241
    ; Add memory address $0240 onto stack (*Q)
    LDA #$02
    PHA
    LDA #$40
    PHA
    ; Add memory address $0241 onto stack (*R)
    LDA #$02
    PHA
    LDA #$41
    PHA
    ; Add N=1 onto the stack
    LDA #$01
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
    LDA ($00), Y    ; get return value (should be 0x01)
    STA $0243       ; store

    ; N=2
    ; =========== Example 1: 0xffe4 - 0xfff0 ===========
    ; Store float 0xffe4 (Q) to memory at $0260
    LDA #$e4
    STA $0260
    LDA #$ff
    STA $0261
    ; Store float 0xfff0 (R) to memory at $0262
    LDA #$f0
    STA $0262
    LDA #$ff
    STA $0263
    ; Add memory address $0260 onto stack (*Q)
    LDA #$02
    PHA
    LDA #$60
    PHA
    ; Add memory address $0262 onto stack (*R)
    LDA #$02
    PHA
    LDA #$62
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
    LDA ($00), Y    ; get LSB of return value (should be 0xf4)
    STA $0264       ; store
    INY
    LDA ($00), Y    ; get MSB of return value (should be 0xff)
    STA $0265       ; store

    ; =========== Example 2: 0x03c3 - 0x01c3 ===========
    ; Store float 0x03c3 (Q) to memory at $0280
    LDA #$c3
    STA $0280
    LDA #$03
    STA $0281
    ; Store float 0x01c3 (R) to memory at $0282
    LDA #$c3
    STA $0282
    LDA #$01
    STA $0283
    ; Add memory address $0280 onto stack (*Q)
    LDA #$02
    PHA
    LDA #$80
    PHA
    ; Add memory address $0282 onto stack (*R)
    LDA #$02
    PHA
    LDA #$82
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
    LDA ($00), Y    ; get LSB of return value (should be 0x00)
    STA $0284       ; store
    INY
    LDA ($00), Y    ; get MSB of return value (should be 0x20)
    STA $0285       ; store

    ; =========== Example 3: 0x6301 - 0xd824 ===========
    ; Store float 0x6301 (Q) to memory at $02a0
    LDA #$01
    STA $02a0
    LDA #$63
    STA $02a1
    ; Store float 0xd824 (R) to memory at $02a2
    LDA #$24
    STA $02a2
    LDA #$d8
    STA $02a3
    ; Add memory address $02a0 onto stack (*Q)
    LDA #$02
    PHA
    LDA #$a0
    PHA
    ; Add memory address $02a2 onto stack (*R)
    LDA #$02
    PHA
    LDA #$a2
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
    LDA ($00), Y    ; get LSB of return value (should be 0x61)
    STA $02a4       ; store
    INY
    LDA ($00), Y    ; get MSB of return value (should be 0x60)
    STA $02a5       ; store

    ; N=4
    ; =========== Example 1: 0x0000007F - 0x80000001 ===========
    ; Store float 0x0000007F (Q) to memory at $02c0
    LDA #$7f
    STA $02c0
    LDA #$00
    STA $02c1
    STA $02c2
    STA $02c3
    ; Store float 0x80000001 (R) to memory at $02c4
    LDA #$01
    STA $02c4
    LDA #$00
    STA $02c5
    STA $02c6
    LDA #$80
    STA $02c7
    ; Add memory address $02c0 onto stack (*Q)
    LDA #$02
    PHA
    LDA #$c0
    PHA
    ; Add memory address $02c4 onto stack (*R)
    LDA #$02
    PHA
    LDA #$c4
    PHA
    ; Add N=4 onto the stack
    LDA #$04
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
    LDA ($00), Y    ; LSB of return value (0x7f)
    STA $02c8, Y    ; store
    INY
    LDA ($00), Y    ; 0xff
    STA $02c8, Y
    INY
    LDA ($00), Y    ; 0xff
    STA $02c8, Y
    INY
    LDA ($00), Y    ; MSB of return value (0xfe)
    STA $02c8, Y    ; store

    ; =========== Example 2: 0xfffffffe - 0x00000001 ===========
    ; Store float 0xfffffffe (Q) to memory at $02e0
    LDA #$fe
    STA $02e0
    LDA #$ff
    STA $02e1
    STA $02e2
    STA $02e3
    ; Store float 0x00000001 (R) to memory at $02e4
    LDA #$01
    STA $02e4
    LDA #$00
    STA $02e5
    STA $02e6
    STA $02e7
    ; Add memory address $02e0 onto stack (*Q)
    LDA #$02
    PHA
    LDA #$e0
    PHA
    ; Add memory address $02e4 onto stack (*R)
    LDA #$02
    PHA
    LDA #$e4
    PHA
    ; Add N=4 onto the stack
    LDA #$04
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
    LDA ($00), Y    ; LSB of return value (0xff)
    STA $02e8, Y    ; store
    INY
    LDA ($00), Y    ; 0xff
    STA $02e8, Y
    INY
    LDA ($00), Y    ; 0xff
    STA $02e8, Y
    INY
    LDA ($00), Y    ; MSB of return value (0xfd)
    STA $02e8, Y    ; store

    ; =========== Example 3: 0x7fffffff - 0xffffffff ===========
    ; Store float 0x7fffffff (Q) to memory at $0300
    LDA #$ff
    STA $0300
    STA $0301
    STA $0302
    LDA #$7f
    STA $0303
    ; Store float 0xffffffff (R) to memory at $0304
    LDA #$ff
    STA $0304
    STA $0305
    STA $0306
    STA $0307
    ; Add memory address $0300 onto stack (*Q)
    LDA #$03
    PHA
    LDA #$00
    PHA
    ; Add memory address $0304 onto stack (*R)
    LDA #$03
    PHA
    LDA #$04
    PHA
    ; Add N=4 onto the stack
    LDA #$04
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
    LDA ($00), Y    ; LSB of return value (0xff)
    STA $0308, Y    ; store
    INY
    LDA ($00), Y    ; 0xff
    STA $0308, Y
    INY
    LDA ($00), Y    ; 0xff
    STA $0308, Y
    INY
    LDA ($00), Y    ; MSB of return value (0xfd)
    STA $0308, Y    ; store

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
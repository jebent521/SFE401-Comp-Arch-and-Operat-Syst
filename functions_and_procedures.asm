Main:
    LDA #$FF
    LDX #$AA
    LDY #$44
    JSR ClearRegisters  ; test to see if registers are cleared

    ; Adding 2 and 2 using memory
    LDA #$02
    STA $0200
    STA $0201
    JSR ClearRegisters
    JSR Add8BitsFromMemory      ; should add 2 and 2, store 4 in $0202
    LDX $0202                   ; X should contain #$04

    ; Adding 2 and 2 using the stack
    LDA #$02
    PHA                         ; first arg = #$02
    PHA                         ; second arg = #$02
    LDA #$FF
    PHA                         ; create space for answer
    JSR ClearRegisters
    JSR Add8BitsFromStack
    PLA                         ; should get #$04
JMP Done

; Sets the values of the A, X, and Y registers to #$00
ClearRegisters:
    LDA #$00
    LDX #$00
    LDY #$00
RTS

; Adds the values at memory $0200 and $0201, stores in $0202
Add8BitsFromMemory:
    CLC
    LDA $0200
    ADC $0201
    STA $0202
RTS

Add8BitsFromStack:  ; don't want to pop things off the stack
    CLC
    TSX ; transfer stack pointer to X
    LDA $0105, X     ; grab from SP - 5
    ADC $0104, X     ; add to    SP - 4
    STA $0103, X     ; store at  SP - 3
    ; Stack pointer -2 contains the return address
    JSR ClearRegisters
RTS


Done:
BRK
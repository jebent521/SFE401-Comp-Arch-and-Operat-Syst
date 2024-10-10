; Author: Jonah Ebent
; define myFloatPtr $0200 (auto-grader didn't accept defines)
; define output $0210 (auto-grader didn't accept defines)

JSR init
JSR getMantissa
JMP done

init:
  ; load float from MSB to LSB
  ; altogether, it's $01020304
  LDX #$03
  LDA #$01
  STA $0200, X
  DEX
  LDA #$02
  STA $0200, X
  DEX
  LDA #$03
  STA $0200, X
  DEX
  LDA #$04
  STA $0200, X
RTS

getMantissa:
  ; the two least significant bytes are directly copied from myFloatPtr
  LDX #$00
  LDA $0200, X
  STA $0210, X
  INX
  LDA $0200, X
  STA $0210, X
  INX
  ; the third byte is OR'd with 0b10000000 to set first bit
  LDA $0200, X
  ORA #$80
  STA $0210, X
RTS

done:
  ; step through values of original number from MSB to LSB
  ; should be $01020304
  LDX #$03
  LDA $0200, X
  DEX
  LDA $0200, X
  DEX
  LDA $0200, X
  DEX
  LDA $0200, X

  ; step through values of mantissa from MSB to LSB
  ; should be $820304
  LDX #$2
  LDA $0210, X
  DEX
  LDA $0210, X
  DEX
  LDA $0210, X
BRK
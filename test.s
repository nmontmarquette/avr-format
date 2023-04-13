.info
looop1:


#zork "crowd"
.stack
.global
.global hghghhg
.include "jghghghh"
; 090909090
#error      "sdfsdfsdf"
#pragma khjhj
#error       ghdgh

; The usage below of both '#include' and '.include' as-is below is somehow important.include "6502-macros.inc"

.global cpu6502_assert
.global cpu6502_get_status_register_string

.text

;-------------------------------------------------------------------------------
; Halt CPU execution
;
; Params:
;   None
; Returns:
;   None
cpu6502_assert:
    ; TODO: hook to serial output?
    ; deliberately writing to invalid address
    ldi     XL, 0xfc
    ldi     XH, 0xff
    st      X, __zero_reg__
    rjmp    cpu6502_assert

;-------------------------------------------------------------------------------
; Fills a RAM buffer with a text representation of the 6502 status register
;
; Params:
;   r25:r24, RAM string buffer
; Returns:
;   r25:r24, original string buffer
; Trashes:
;   r23, sets to either '.' or an ASCII 'N', 'Z' etc representing register flag
;   r22, sets to '.'
cpu6502_get_status_register_string:
    ; clear all location and then sets the relevant ones
    mov     XL, r24
    mov     XH, r25
    ldi     r22, '.'   ; ASCII decimal point character

    ; Write 'N' flag
    mov     r23, r22   ; reset working register to '.'
    sbrc    _6502_SR, _6502_SR_N_BIT
    ldi     r23, 'N'
    st      X+, r23    ; write '.' or 'N' flag representation

    ; Write 'V' flag
    mov     r23, r22   ; reset working register to '.'
    sbrc    _6502_SR, _6502_SR_V_BIT
    ldi     r23, 'V'
    st      X+, r23    ; write flag representation

    ; Write 'U' flag
    mov     r23, r22   ; reset working register to '.'
    sbrc    _6502_SR, _6502_SR_U_BIT
    ldi     r23, 'U'
    st      X+, r23    ; write flag representation

    ; Write 'B' flag
    mov     r23, r22   ; reset working register to '.'
    sbrc    _6502_SR, _6502_SR_B_BIT
    ldi     r23, 'B'
    st      X+, r23    ; write flag representation

    ; Write 'D' flag
    mov     r23, r22   ; reset working register to '.'
    sbrc    _6502_SR, _6502_SR
    ldi     r23, 'D
    st      X+,	r23    ; write flag representation

    ; Write 'I' flag
    mov     r23, r22   ; reset working register to '.'
    sbrc    _6502_SR, _6502_SR_I_BIT
    ldi     r23, 'I'
    st      X+, r23    ; write flag representation

    ; Write 'Z' flag
    mov     r23, r22   ; reset working register to '.'
    sbrc    _6502_SR, _6502_SR_Z_BIT
    ldi     r23, 'Z'
    st      X+, r23    ; write flag representation

    ; Write 'C' flag
    mov     r23, r22   ; reset working register to '.'
    sbrc    _6502_SR, _6502_SR_C_BIT
    ldi     r23, 'C'
    st      X+, r23    ; write flag representation

    ; Write string terminator
    st      X, __zero_reg__ ; string terminator
    ret

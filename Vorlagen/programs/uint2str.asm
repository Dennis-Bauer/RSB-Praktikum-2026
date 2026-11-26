;===========================================================
; main
; sp -> last used/first empty ?
; caller/callee save ?
;===========================================================

      movi   r0, 0	;init stack
      .stack r0
;
      movi   r8, 8
      lsli   r8, 12
      ldw    r7, 0(r8)	;read value to convert
      ldw    r8, 2(r8)	;read string pointer
      jsr    num2str;
      .prstr r8
      halt
;
;===========================================================
; subroutine nibble2chr
; parameters: r4 -> nibble to convert (input), chr (output);
; local registers:	r1 = 0x30 ascii-offset number
;			r2 = 0x41 ascii-offset chr
;			r3 = 9
;===========================================================
nibble2chr:
      .push  r3
      .push  r1
      .push  r2
;
      movi   r3,  9	;digit/chr
      movi   r1,  3	;0x30 offset 0
      lsli   r1,  4
      movi   r2,  4	;0x41 offset A
      lsli   r2,  4
      addi   r2,  1
;
convn2c:
      cmpgt  r4,  r3	;0..9 or A..F
      bt     AtoFchr
      addu   r4,  r1
      br     n2cfin
AtoFchr:
      subi   r4,  0xA
      addu   r4,  r2
;
n2cfin:
      .pop   r2
      .pop   r1
      .pop   r3
      jmp    r15
;
;===========================================================
; subroutine num2str
; parameters:		r8 = stringpointer (input);
;			r7 = value to convert (input)
; local registers:	r1 = loopcounter
;			r2 = shiftoffst
;			r3 = bitmask
;			r4 = hexVal
;			r5 = exit condition (=0)
;			r8 = pointer into string
;===========================================================
num2str:
      .push  r1
      .push  r2
      .push  r3
      .push  r4
      .push  r5
      .push  r8
;
      movi   r1,  3	;3 loop passes
      movi   r5,  0
;
convLoop:
      mov    r2,  r1	;calc shiftoffset (r2)
      lsli   r2,  2	;#pass * 4
      movi   r3,  0xf	;bitmask
      lsl    r3,  r2
      mov    r4,  r7	;mask out hexdigit (r4)
      and    r4,  r3
      lsr    r4,  r2	;align with lsb
      .push  r15
      jsr    nibble2chr
      .pop   r15
w2str:
      stw    r4,  0(r8)	;store hexdigit (big endian)
      addi   r8,  2
      cmpne  r1,  r5
      subi   r1,  1
      bt     convloop
      movi   r4,  0x0	;terminate string
      stw    r4,  0(r8)
;
      .pop   r8
      .pop   r5
      .pop   r4
      .pop   r3
      .pop   r2
      .pop   r1
      jmp    r15
;
      .org   0x8000
      .defw  37039	;prepare value to convert
      .defw  0x8050	;string pointer

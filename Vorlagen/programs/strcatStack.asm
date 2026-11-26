;===========================================================
; main
;===========================================================
      movi   r0,  0	;init stack
      .stack r0
;
      movi   r10, 8	;adr str1
      lsli   r10, 12
      movi   r11, 8	;adr str2
      lsli   r11, 8
      addi   r11, 8
      lsli   r11, 4
;     mov    r11, r10	;copy same string
;
      .prstr r10	;print original string
      .prnewline
      .prstr r11	;print string to append
      .prnewline
;
      jsr    strcat
;
      .prstr r10	;print concatenated string
      .prnewline
      halt
;
;===========================================================
; Subprogram strlen
; parameters: r10 -> string* (input); pointer shouldn't be modified
;             r11 -> length (output)
; local registers: r9, r8
;===========================================================
strlen:
      .push  r8
      .push  r9
      .push  r10
      movi   r8,  0		;nullchar
      movi   r11, 0		;length
strLoop:
      ldw    r9,  0(r10)
      cmpe   r9,  r8
      bt     strEnd
      addi   r11, 1
      addi   r10, 2
      br     strLoop
strEnd:
      .pop   r10
      .pop   r9
      .pop   r8
      jmp    r15
;
;===========================================================
; Subprogram strcpy
; parameters: r10 -> string* dest_str; pointer shouldn't be modified
;             r11 -> string* source_str; pointer shouldn't be modified
; local registers: r12, r11, r10, r9, r8
;===========================================================
strcpy:
      .push  r8
      .push  r9
      .push  r10
      .push  r11
      .push  r12
      .push  r10
      .push  r11
      mov    r10, r11
      .push  r15
      jsr    strlen
      .pop   r15
      mov    r8, r11
      .pop   r11
      .pop   r10
      movi   r9,  0
cpLoop:
      cmpgt  r8, r9
      bf     strcpEnd
      ldw    r12, 0(r11)
      stw    r12, 0(r10)
      addi   r10, 2
      addi   r11, 2
      subi   r8,  1
      br     cpLoop
strcpEnd:
      stw    r9, 0(r10)
      .pop   r12
      .pop   r11
      .pop   r10
      .pop   r9
      .pop   r8
      jmp    r15
;
;===========================================================
; Subprogram strcat
; parameters: r10 -> string* dest_str; pointer shouldn't be modified
;             r11 -> string* source_str; pointer shouldn't be modified
; local registers: r11, r10
;===========================================================
strcat:
      .push  r10
      .push  r11
;
      .push  r11		;calc end of dest_str
      .push  r15
      jsr    strlen
      .pop   r15
      lsli   r11, 1
      addu   r10, r11
      .pop   r11
;
      .push  r15		;append source_str
      jsr    strcpy
      .pop   r15
      .pop   r11
      .pop   r10
      jmp    r15
;
;===========================================================
; String section
;===========================================================
      .org   0x8000
      .ascii "Ein S"
      .defw  0
;
      .org   0x8080
      .ascii "tring"
      .defw  0

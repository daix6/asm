; variables
PUBLIC START_SCREEN

; modules
EXTRN  SET_MODE:FAR
EXTRN  CLEAR:FAR


; data segment
DATASG SEGMENT
  START_SCREEN  DB  "                                                     ", 0DH, 0AH
                DB  "                   _______________________________   ", 0DH, 0AH
                DB  "                  |                               |  ", 0DH, 0AH
                DB  "                  |                               |  ", 0DH, 0AH
                DB  "                  |     Welcome To The Snake      |  ", 0DH, 0AH
                DB  "                  |                               |  ", 0DH, 0AH
                DB  "                  |        Made by DaiXuan        |  ", 0DH, 0AH
                DB  "                  |                               |  ", 0DH, 0AH
                DB  "                  |           13331043            |  ", 0DH, 0AH
                DB  "                  |                               |  ", 0DH, 0AH
                DB  "                  |                               |  ", 0DH, 0AH
                DB  "                  |    Press any key to start     |  ", 0DH, 0AH
                DB  "                  |                               |  ", 0DH, 0AH
                DB  "                  |                               |  ", 0DH, 0AH
                DB  "                  |                               |  ", 0DH, 0AH
                DB  "                  |_______________________________|  ", 0DH, 0AH
                DB  "                  |                               |  ", 0DH, 0AH
                DB  "                  |     Copyright All Reserved    |  ", 0DH, 0AH
                DB  "                  |              2015             |  ", 0DH, 0AH
                DB  "                  |_______________________________|  ", 0DH, 0AH, '$'
DATASG ENDS

; stack segment
STACKSG SEGMENT STACK
  DB 100 DUP(?)
STACKSG ENDS


; code segment
CODESG0 SEGMENT
; m
MAIN PROC   FAR
  ASSUME    CS:CODESG0, DS:DATASG, SS:STACKSG
  MOV       AX, DATASG
  MOV       DS, AX

INIT:
  CALL      SET_MODE                  ; Set video mode
  CALL      CLEAR                     ; Clear the screen

  LEA       DX, START_SCREEN          
  MOV       AH, 09H
  INT       21H                       ; Show the bootstrap interface

  MOV       AH, 01H
  INT       16H                       ; Detect users' input
  JZ        BEGIN                     ; If any input from keyboard, then begin the game.

BEGIN:

FINISH:
  CALL      EXIT

MAIN ENDP


; Return to DOS
EXIT PROC
  MOV AH, 4CH
  INT 21H
  RET
EXIT ENDP

CODESG0 ENDS
 END MAIN
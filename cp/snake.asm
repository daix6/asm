; share
PUBLIC START_SCREEN, WALL, COLOR
PUBLIC SNAKE, LEN

; call
EXTRN  SET_MODE:FAR
EXTRN  CLEAR:FAR
EXTRN  DRAW:FAR


; data segment
DATASG SEGMENT

  START_SCREEN  DB  0DH, 0AH
                DB  "                    ######################################## ", 0DH, 0AH
                DB  "                   |                                        |", 0DH, 0AH
                DB  "                   |                                        |", 0DH, 0AH
                DB  "                   |          Welcome To The Snake          |", 0DH, 0AH
                DB  "                   |                                        |", 0DH, 0AH
                DB  "                   |             Made by DaiXuan            |", 0DH, 0AH
                DB  "                   |                                        |", 0DH, 0AH
                DB  "                   |                13331043                |", 0DH, 0AH
                DB  "                   |                                        |", 0DH, 0AH
                DB  "                   |                                        |", 0DH, 0AH
                DB  "                   |          Press any key to start        |", 0DH, 0AH
                DB  "                   |                                        |", 0DH, 0AH
                DB  "                   |                                        |", 0DH, 0AH
                DB  "                   |                                        |", 0DH, 0AH
                DB  "                   |                                        |", 0DH, 0AH
                DB  "                   |                                        |", 0DH, 0AH
                DB  "                   |                                        |", 0DH, 0AH
                DB  "                   |########################################|", 0DH, 0AH
                DB  "                   |                                        |", 0DH, 0AH
                DB  "                   |          Copyright All Reserved        |", 0DH, 0AH
                DB  "                   |                   2015                 |", 0DH, 0AH
                DB  "                   |########################################|", 0DH, 0AH, '$'
  
  ; The blank area is 16 X 40, not including the border
  ; (2, 20)  ... (2, 59)
  ; (17, 20) ... (17, 59)
  WALL          DB  0DH, 0AH
                DB  "                    ######################################## ", 0DH, 0AH
                DB  "                   |                                        |", 0DH, 0AH
                DB  "                   |                                        |", 0DH, 0AH
                DB  "                   |                                        |", 0DH, 0AH
                DB  "                   |                                        |", 0DH, 0AH
                DB  "                   |                                        |", 0DH, 0AH
                DB  "                   |                                        |", 0DH, 0AH
                DB  "                   |                                        |", 0DH, 0AH
                DB  "                   |                                        |", 0DH, 0AH
                DB  "                   |                                        |", 0DH, 0AH
                DB  "                   |                                        |", 0DH, 0AH
                DB  "                   |                                        |", 0DH, 0AH
                DB  "                   |                                        |", 0DH, 0AH
                DB  "                   |                                        |", 0DH, 0AH
                DB  "                   |                                        |", 0DH, 0AH
                DB  "                   |                                        |", 0DH, 0AH
                DB  "                   |                                        |", 0DH, 0AH
                DB  "                   |########################################|", 0DH, 0AH
                DB  "                   |                                        |", 0DH, 0AH
                DB  "                   |     W:Up  A:Left S: Down D: Right      |", 0DH, 0AH
                DB  "                   |          Esc To End The Game           |", 0DH, 0AH
                DB  "                   |########################################|", 0DH, 0AH, '$'

    LEN         DB 8
    SNAKE       DW 0A24H, 0A25H, 0A26H, 0A27H, 0A28H, 0A29H, 0A2AH, 0A2BH, 0

    COLOR       DB 6EH

DATASG ENDS

; stack segment
STACKSG SEGMENT STACK
  DB 100 DUP(?)
STACKSG ENDS

; code segment
CODESG0 SEGMENT

; 
MAIN PROC   FAR
  ASSUME    CS:CODESG0, DS:DATASG, SS:STACKSG
  MOV       AX, DATASG
  MOV       DS, AX

INIT:
  CALL      SET_MODE                    ; Set video mode
  CALL      CLEAR                       ; Clear the screen

  LEA       DX, START_SCREEN          
  MOV       AH, 09H
  INT       21H                         ; Show the bootstrap interface

  MOV       AH, 07H
  INT       21H                         ; Wait and detect users' input.
  XOR       AL, AL                      ; Clear input

BEGIN:
  MOV       DX, 0000H                   ; The start point (0, 0)
  MOV       BH, 0                       ; 0
  MOV       AH, 02H                     ; Set the cursor's position
  INT       10H

  LEA       DX, WALL
  MOV       AH, 09H
  INT       21H                         ; Draw the wall

  CALL      DRAW                        ; Draw the fish

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
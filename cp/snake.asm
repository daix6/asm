; share
PUBLIC START_SCREEN, WALL, COLOR
PUBLIC SNAKE, LEN

; call
EXTRN  SET_MODE:FAR
EXTRN  CLEAR:FAR
EXTRN  DRAW:FAR

; direction
EXTRN  UP:FAR
EXTRN  LEFT:FAR
EXTRN  DOWN:FAR
EXTRN  RIGHT:FAR

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
  ; (2, 20)  to (2, 59)
  ; (17, 20) to (17, 59)
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
    ; Initial postion of snake.
    ; From (10, 36) to (10, 43)

    COLOR       DB 6EH

    INTERVAL    DW 0010H
    TIME        DW ?

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
  CALL      CLEAR_R                     ; Clear register

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

FIRST:
  CALL      DRAW                        ; Draw the fish

TIMER:
  MOV       AH, 00H 
  INT       1AH                         ; Get time
  MOV       TIME, DX                    ; Save to memory
  MOV       AH, 01H
  INT       16H                         ; Detect keyboard click
  JNZ       DIRECTION                   ; If detected, jump to `DIRECTION`

  MOV       DX, TIME                    ; DX = TIME
  SUB       DX, DI                      ; DX = DX - DI. Subtract last time to get the interval
  CMP       DX, INTERVAL                ; Compare DX with interval (we set before)
  JA        AUTO_NEXT                   ; If DX > interval then jump to `AUTO_NEXT`. Which means that we don't click the keyboard.
  JMP       TIMER                       ; If DX < interval, check again.

AUTO_NEXT:
  MOV       DI, TIME                    ; Save last move time to `DI`
  JMP       AUTO_SWIN                   ; Jump to `AUTO_SWIN`

DIRECTION:
  CALL      CHECK_DIRECTION

AUTO_SWIN:


FINISH:
  CALL      EXIT

MAIN ENDP

; Clear register
CLEAR_R PROC
  XOR       AX, AX
  XOR       BX, BX
  XOR       CX, CX
  XOR       DX, DX
  XOR       SI, SI
  XOR       DI, DI
  RET
CLEAR_R ENDP

; Check what key user pressed
CHECK_DIRECTION PROC
  RET
CHECK_DIRECTION ENDP

; Return to DOS
EXIT PROC
  MOV AH, 4CH
  INT 21H
  RET
EXIT ENDP

CODESG0 ENDS
 END MAIN
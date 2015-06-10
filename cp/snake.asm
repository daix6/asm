; share.
PUBLIC START_SCREEN, WALL, COLOR
PUBLIC SNAKE, LEN

; call.
EXTRN  SET_MODE:FAR
EXTRN  CLEAR:FAR
EXTRN  DRAW:FAR

; direction.
EXTRN  CHECK_DIRECTION:FAR

; data segment.
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


  FAIL_INFO     DB  0DH, 0AH
                DB  "                    ######################################## ", 0DH, 0AH
                DB  "                   |                                        |", 0DH, 0AH
                DB  "                   |        I'm sorry, but you lose~        |", 0DH, 0AH
                DB  "                   |                                        |", 0DH, 0AH
                DB  "                   |                                        |", 0DH, 0AH
                DB  "                   |         FFFFF           FFFFF          |", 0DH, 0AH
                DB  "                   |       FFF   FFF       FFF   FFF        |", 0DH, 0AH
                DB  "                   |     FFFF     FFFF   FFFF     FFFF      |", 0DH, 0AH
                DB  "                   |                                        |", 0DH, 0AH
                DB  "                   |                                        |", 0DH, 0AH
                DB  "                   |           FF            FF             |", 0DH, 0AH
                DB  "                   |           FFF          FFF             |", 0DH, 0AH
                DB  "                   |              FFF    FFF                |", 0DH, 0AH
                DB  "                   |                 FFFF                   |", 0DH, 0AH
                DB  "                   |                                        |", 0DH, 0AH
                DB  "                   |                                        |", 0DH, 0AH
                DB  "                   |                                        |", 0DH, 0AH
                DB  "                   |########################################|", 0DH, 0AH
                DB  "                   |                                        |", 0DH, 0AH
                DB  "                   |          Copyright All Reserved        |", 0DH, 0AH
                DB  "                   |                   2015                 |", 0DH, 0AH
                DB  "                   |########################################|", 0DH, 0AH, '$'

  ; The blank area is 16 X 40, not including the border.
  ; (2, 20)  to (2, 59).
  ; (17, 20) to (17, 59).
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
    ; From (10, 36) to (10, 43).
    TAIL_X      DB ?
    TAIL_Y      DB ?

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
  CALL      CLEAR_R                     ; Clear register.
  CALL      SET_MODE                    ; Set video mode.

GAME_START:
  CALL      CLEAR                       ; Clear the screen.

  LEA       DX, START_SCREEN          
  MOV       AH, 09H
  INT       21H                         ; Show the bootstrap interface.

  MOV       AH, 07H
  INT       21H                         ; Wait and detect users' input.
  XOR       AL, AL                      ; Clear input.

BEGIN:
  MOV       DX, 0000H                   ; The start point (0, 0).
  MOV       BH, 0                       ; 0.
  MOV       AH, 02H                     ; Set the cursor's position.
  INT       10H

  LEA       DX, WALL
  MOV       AH, 09H
  INT       21H                         ; Draw the wall.

FIRST:
  CALL      DRAW                        ; Draw the fish.

TIMER:
  MOV       AH, 00H 
  INT       1AH                         ; Get time.
  MOV       TIME, DX                    ; Save to memory.
  MOV       AH, 01H
  INT       16H                         ; Detect keyboard status.
  JNZ       DIRECTION                   ; If detected, jump to `DIRECTION`.

  MOV       DX, TIME                    ; DX = TIME.
  SUB       DX, DI                      ; DX = DX - DI. Subtract last time to get the interval.
  CMP       DX, INTERVAL                ; Compare DX with interval (we set before).
  JA        AUTO_NEXT                   ; If DX > interval then jump to `AUTO_NEXT`. Which means that user doesn't press the keyboard.
  JMP       TIMER                       ; If DX < interval, check again.

AUTO_NEXT:
  MOV       DI, TIME                    ; Set current time to `DI`.
  JMP       AUTO_SWIN                   ; Jump to `AUTO_SWIN`.


;=======================================For user's operation
DIRECTION:
  MOV       DI, TIME                    ; Set current time to `DI`.
  LEA       SI, SNAKE                   ; SI point to Snake Head.

  MOV       AH, 00H
  INT       16H                         ; Read input.

  CMP       AL, 'w'                     ; Up.
  JZ        UP
  CMP       AL, 'W'                     ; Up.
  JZ        UP
  CMP       AL, 'a'                     ; Left.
  JZ        LEFT
  CMP       AL, 'A'                     ; Left.
  JZ        LEFT
  CMP       AL, 's'                     ; Down.
  JZ        DOWN
  CMP       AL, 'S'                     ; Down.
  JZ        DOWN
  CMP       AL, 'd'                     ; Right.
  JZ        RIGHT
  CMP       AL, 'D'                     ; Right.
  JZ        RIGHT
  CMP       AL, 27                      ; ESC End Game.
  JZ        FINISH
  JMP       GAME_START                  ; If neither.

UP:
  MOV       DX, -1                      ; Row - 1. Use `DX`.
  MOV       AL, [SI+1]                  ; AL = Row Number of Head.
  MOV       BL, [SI+3]                  ; BL = Row Number of first part of body.
  CMP       AL, 1                       ; If touch the border, end the game.
  JZ        LOSE_GAME
  JMP       NEXT_STEP

LEFT:
  MOV       BX, -1                      ; Col - 1. Use `BX`.
  MOV       DX, 0                       ; Set symbol for later judge.
  MOV       AL, [SI]                    ; AL = Col Number of Head.
  MOV       CL, [SI+2]                  ; CL = Col Number of first part of body.
  CMP       AL, 19                      ; If touch the border, end the game.
  JZ        LOSE_GAME
  JMP       NEXT_STEP

DOWN:
  MOV       DX, 1                       ; Row + 1. Use `DX`.
  MOV       AL, [SI+1]                  ; AL = Row Number of Head.
  MOV       BL, [SI+3]                  ; BL = Row Number of first part of body.
  CMP       AL, 18                      ; If touch the border, end the game.
  JZ        LOSE_GAME
  JMP       NEXT_STEP

RIGHT:
  MOV       BX, -1                      ; Col + 1. Use `BX`.
  MOV       DX, 0                       ; Set symbol for later judge.
  MOV       AL, [SI]                    ; AL = Col Number of Head.
  MOV       CL, [SI+2]                  ; CL = Col Number of first part of body.
  CMP       AL, 60                      ; If touch the border, end the game.
  JZ        LOSE_GAME
  JMP       NEXT_STEP

NEXT_STEP:
  XOR       AX, AX                      ; Clear AX.
  LEA       SI, SNAKE                   ; SI point to the head.
  ADD       SI, 15                      ; [SI] Save the col number of tail Now.
  MOV       AH, [SI-1]                  ; AH = Col Number of snake's tail.
  MOV       AL, [SI]                    ; AL = Row Number of snake's tail.
  MOV       TAIL_X, AL                  ; Save to memory.
  MOV       TAIL_Y, AH                  ; Save to memory.

  MOV       CX, 7                       ; Body and Tail.
MOVE_BODY_TAIL:
  MOV       AL, [SI-2]
  MOV       [SI], AL                    ; Move the former part's Row Number to current part.
  MOV       AL, [SI-3]
  MOV       [SI-1], AL                  ; Move the former part's Col Number to current part.
  SUB       SI, 2                       ; Move to the former.
  DEC       CX                          ; Decrease CX to Loop.
  JNZ       MOVE_BODY_TAIL              ; For 7(LEN-1) times.

MOVE_HEAD:
  LEA       SI, SNAKE                   ; SI point to the head
  CMP       DX, 0                       ; If DX = 1, means that up or down.
  JNE       MOVE_HEAD_UP_DOWN           ; Then jump to `MOVE_HEAD_UP_DOWN`.

MOV_HEAD_LEFT_RIGHT:
  ADD       [SI], BX                    ; Change Col of head. BX = ±1.
  JMP       GAME_START

MOV_HEAD_UP_DOWN:
  ADD       [SI+1], DX                  ; Change Row of head. DX = ±1.
  JMP       GAME_START

;=======================================For auto operation.
AUTO_SWIN:
  XOR       BX, BX                      ; Clear BX.
  LEA       SI, SNAKE
  MOV       BL, [SI]                    ; BL = Head's Col Number.
  CMP       BL, [SI+2]                  ; Compare Head's Col and first part of body's Col to judge head's direction.
  JNE       AUTO_LEFT_OR_RIGHT          ; If Cols are not equal, means left or right.
  MOV       BH, [SI+1]                  ; BL = Head's Row Number.
  CMP       BH, [SI+3]                  ; Compare Head's Row and first part of body's Row to judge up or down.
  JA        AUTO_UP

; BH For Row, BL for Col
AUTO_DOWN:                              ; Towards Down: Row Increase, Col doesn't change.
  MOV       BH, 1
  MOV       BL, 0
  JMP       AUTO_NEXT_STEP

AUTO_UP:                                ; Towards Up: Row Decrease, Col doesn't change.
  MOV       BH, -1
  MOV       BL, 0
  JMP       AUTO_NEXT_STEP

AUTO_LEFT_OR_RIGHT:
  CMP       BL, [SI+2]
  JA        AUTO_LEFT                   ; If Head's Cols > first part of body's Col, measn left

AUTO_RIGHT:                             ; Towards Right: Col Increase, Row doesn't change.
  MOV       BH, 0
  MOV       BL, 1
  JMP       AUTO_NEXT_STEP

AUTO_LEFT:                              ; Towards Right: Col Decrease, Row doesn't change.
  MOV       BH, 0
  MOV       BL, -1


AUTO_NEXT_STEP:
  XOR       AX, AX                      ; Clear AX.
  LEA       SI, SNAKE
  ADD       SI, 15                      ; SI point to the Row Number of Tail
  MOV       AH, [SI-1]                  ; AH = Col Number of snake's tail.
  MOV       AL, [SI]                    ; AL = Row Number of snake's tail.
  MOV       TAIL_X, AL                  ; Save to memory.
  MOV       TAIL_Y, AH                  ; Save to memory.

  MOV       CX, 7                       ; Body and Tail.
AUTO_MOV_BODY_TAIL:
  MOV       AL, [SI-2]
  MOV       [SI], AL                    ; Move the former part's Row Number to current part.
  MOV       AL, [SI-3]
  MOV       [SI-1], AL                  ; Move the former part's Col Number to current part.
  SUB       SI, 2                       ; Move to the former.
  DEC       CX                          ; Decrease CX to Loop.
  JNZ       AUTO_MOV_BODY_TAIL          ; For 7(LEN-1) times.

;=======================================Move Head
AUTO_MOVE_HEAD:
  LEA       SI, SNAKE
  ADD       [SI+1], BH
  ADD       [SI], BL
  MOV       AL, [SI]
  MOV       AH, [SI+1]

;=======================================Judge If Touch The Border
AUTO_BORDER:
  CMP       AH, 2
  JZ        LOSE_GAME
  CMP       AH, 18
  JZ        LOSE_GAME
  CMP       AL, 19
  JZ        LOSE_GAME
  CMP       AL, 60
  JZ        LOSE_GAME
  JMP       GAME_START

;=======================================If You Touch The Border
LOSE_GAME:
  LEA       DX, FAIL_INFO
  MOV       AH, 09H
  INT       21H                         ; Draw the failure info

;=======================================Return DOS
FINISH:
  MOV AH, 4CH
  INT 21H

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

CODESG0 ENDS
 END MAIN
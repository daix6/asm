EXTRN  TIME:DW
EXTRN  SNAKE:DW

PUBLIC CHECK_DIRECTION

CODESG3 SEGMENT
  ASSUME CS:CODESG3

  ; Check what key user pressed
  CHECK_DIRECTION   PROC FAR
    MOV       DI, TIME                    ; Set current time to `DI`
    LEA       SI, SNAKE                   ; SI point to Snake Head

    MOV       AH, 00H
    INT       16H                         ; Read input

    CMP       AL, 'w'                     ; Up
    JZ        UP
    CMP       AL, 'W'                     ; Up
    JZ        UP
    CMP       AL, 'a'                     ; Left
    JZ        LEFT
    CMP       AL, 'A'                     ; Left
    JZ        LEFT
    CMP       AL, 's'                     ; Down
    JZ        DOWN
    CMP       AL, 'S'                     ; Down
    JZ        DOWN
    CMP       AL, 'd'                     ; Right
    JZ        RIGHT
    CMP       AL, 'D'                     ; Right
    JZ        RIGHT
    CMP       AL, 27                      ; ESC End Game
    JZ        FINISH
    JMP       GAME_START                  ; If neither
    RET
  CHECK_DIRECTION ENDP

CODESG3 ENDS
        END
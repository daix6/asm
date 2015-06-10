EXTRN SNAKE:WORD
EXTRN LEN:BYTE
EXTRN CLEAR:FAR
EXTRN COLOR:BYTE

PUBLIC DRAW

CODESG2 SEGMENT
  ASSUME    CS:CODESG2

  DRAW      PROC FAR

  DRAW_HEAD:
    MOV     AH, 02H                 ; Set the position
    MOV     BH, 0                   ; 0 page
    LEA     SI, SNAKE               ;
    XOR     DX, DX                  ; Clear DX
    MOV     DX, [SI]                ; The position of snake's head
    INT     10H

    MOV     AL, 2                   ; Head symbol
    MOV     AH, 09H                 
    MOV     BH, 0                   ; Page 0
    MOV     BL, COLOR               ; Initial color
    MOV     CX, 1                   ; Repeat one time
    INT     10H                     ; Draw at the cursor

  DRAW_BODY:
    MOV     AH, 02H
    MOV     BH, 0
    ADD     SI, 2
    MOV     DX, [SI]
    INT     10H

    MOV     AL, '@'
    MOV     AH, 09H
    MOV     BH, 0
    MOV     BL, COLOR
    MOV     CX, 6
    INT     10H

  DRAW_TAIL:
    MOV     AH, 02H
    MOV     BH, 0
    LEA     SI, SNAKE
    MOV     DX, [SI+14]
    INT     10H

    MOV     AL, 4
    MOV     AH, 09H
    MOV     BH, 0
    MOV     BL, COLOR
    MOV     CX, 1
    INT     10H

  DRAW_RETURN:
    RET
  DRAW      ENDP

CODESG2 ENDS
        END
EXTRN SNAKE:WORD
EXTRN LEN:BYTE
EXTRN CLEAR:FAR
EXTRN COLOR:BYTE

PUBLIC DRAW

CODESG2 SEGMENT
  ASSUME    CS:CODESG2

  DRAW      PROC FAR

    XOR     DX, DX                  ; Clear DX
  DRAW_TAIL:
    LEA     SI, SNAKE
    MOV     AH, 02H                 ; Set the position
    MOV     BH, 0                   ; 0 page
    MOV     DX, [SI+14]             ; The position of snake's tail
    INT     10H

    MOV     AL, 4                   ; Head symbol
    MOV     AH, 09H
    MOV     BH, 0                   ; Page 0
    MOV     BL, COLOR               ; Initial color
    MOV     CX, 1                   ; Repeat one time
    INT     10H                     ; Draw at the cursor

  DRAW_BODY:
    XOR     CX, CX
    MOV     CL, LEN
    SUB     CX, 2
    LEA     SI, SNAKE
    ADD     SI, 14

  AGAIN:
    PUSH    CX

    SUB     SI, 2
    MOV     DX, [SI]
    MOV     AH, 02H
    MOV     BH, 0
    INT     10H

    MOV     AL, '@'
    MOV     AH, 09H
    MOV     BH, 0
    MOV     BL, COLOR
    MOV     CX, 1
    INT     10H

    POP     CX
    LOOP    AGAIN

  DRAW_HEAD:
    LEA     SI, SNAKE
    MOV     AH, 02H
    MOV     BH, 0
    MOV     DX, [SI]
    INT     10H

    MOV     AL, 2
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
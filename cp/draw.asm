EXTRN SNAKE:WORD
EXTRN LEN:BYTE
EXTRN CLEAR:FAR

PUBLIC DRAW

CODESG2 SEGMENT
  ASSUME    CS:CODESG2

  DRAW      PROC FAR
    MOV     AH, 02H
    MOV     BH, 0
    LEA     SI, SNAKE
    XOR     DX, DX
    MOV     DX, [SI]
    INT     10H
    RET
  DRAW      ENDP

CODESG2 ENDS
        END
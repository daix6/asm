DATASG SEGMENT
  IO8255        EQU 29BH
  IO8255A       EQU 298H
  IO8255C       EQU 29AH
  IO8253        EQU 2B3H
  IO8253A       EQU 2B0H
  PROTH         EQU 280H
  PROTLR        EQU 288H
  IO273         EQU 2A0H

  LED           DB  3FH, 06H, 5BH, 4FH ,66H, 6DH ,7DH, 07H, 7FH, 6FH

  LIGHT         DB  00000001B, 00000010B, 00000100B, 00001000B, 00010000B, 00100000B, 01000000B, 10000000B
                DB  10000000B, 01000000B, 00100000B, 00010000B, 00001000B, 00000100B, 00000010B, 00000001B
                DB  00011000B, 00011000B, 00111100B, 00111100B, 01111110B, 01111110B, 11111111B, 11111111B
                DB  00000001B, 00000011B, 00000111B, 00001111B, 00011111B, 00111111B, 01111111B, 11111111B
                DB  11110000B, 01111000B, 00111100B, 00011110B, 00001111B, 00011110B, 00111100B, 01111000B
                DB  00000001B, 10000000B, 00000010B, 01000000B, 00000100B, 00100000B, 00001000B, 00010000B
                DB  01010101B, 10101010B, 01010101B, 10101010B, 01010101B, 10101010B, 01010101B, 10101010B
                DB  10000001B, 11000011B, 11100111B, 11111111B, 11100111B, 11000011B, 10000001B, 00000000B

  MATRIX        DB  00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H          
                DB  00H, 00H, 00H, 0FFH, 0FFH, 00H, 00H,00H           ; 1
                DB  00H, 00H, 3FH,0C8H, 0C8H, 3FH, 00H, 00H           ; A
                DB  00H, 11H, 12H, 14H, 0F8H, 14H, 12H, 11H           ; 大
                DB  00H, 08H, 04H, 02H, 04H, 08H, 10H,20H             ; V
                DB  00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H
                
                DB  00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H          
                DB  00H, 9FH,99H, 99H, 99H, 99H, 0f9H, 00H            ; 2
                DB  00H, 0ffH, 0ffH, 99H, 99H, 99H, 7eH, 00H          ; B
                DB  00H, 11H, 12H, 14H, 0F8H, 14H, 12H, 11H           ; 大
                DB  00H, 08H, 04H, 02H, 04H, 08H, 10H,20H             ; V
                DB  00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H

                DB  00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H          
                DB  00H, 99H, 99H, 99H, 99H, 99H, 0FFH, 00H            ; 3
                DB  00H, 7EH, 0FFH, 81H, 81H, 81H, 81H, 00H            ; C
                DB  00H, 11H, 12H, 14H, 0F8H, 14H, 12H, 11H            ; 大
                DB  00H, 08H, 04H, 02H, 04H, 08H, 10H,20H              ; V
                DB  00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H
                                
                DB  00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H          
                DB  00H, 0F8H, 08H, 08H, 0FFH, 08H, 08H, 00H           ; 4
                DB  00H, 0FFH, 0FFH, 81H, 81H, 81H, 7EH, 00H           ; D
                DB  00H, 11H, 12H, 14H, 0F8H, 14H, 12H, 11H            ; 大
                DB  00H, 08H, 04H, 02H, 04H, 08H, 10H,20H              ; V
                DB  00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H
                        
                DB  00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H          
                DB  00H, 0F9H, 99H, 99H, 99H, 99H, 9FH, 00H            ; 5
                DB  00H, 0FFH, 99H, 99H, 99H, 99H, 99H, 00H            ; E
                DB  00H, 11H, 12H, 14H, 0F8H, 14H, 12H, 11H            ; 大
                DB  00H, 08H, 04H, 02H, 04H, 08H, 10H,20H              ; V
                DB  00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H
                        
                DB  00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H          
                DB  00H, 0FFH, 99H, 99H, 99H, 99H, 9FH, 00H            ; 6
                DB  00H, 0FFH, 0C8H, 0C8H, 0C8H, 0C8H, 0C8H, 00H       ; F
                DB  00H, 11H, 12H, 14H, 0F8H, 14H, 12H, 11H            ; 大
                DB  00H, 08H, 04H, 02H, 04H, 08H, 10H,20H              ; V
                DB  00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H
                     
                DB  00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H          
                DB  00H, 80H, 80H, 8FH, 90H, 0A0H, 0C0H, 00H           ; 7
                DB  00H, 7EH, 81H, 81H, 89H, 8EH, 48H, 0EH             ; G
                DB  00H, 11H, 12H, 14H, 0F8H, 14H, 12H, 11H            ; 大
                DB  00H, 08H, 04H, 02H, 04H, 08H, 10H,20H              ; V
                DB  00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H
                        
                DB  00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H          
                DB  00H, 0FFH, 99H, 99H, 99H, 99H, 0FFH, 00H           ; 8
                DB  00H, 0FFH, 0FFH, 18H, 18H, 0FFH, 0FFH, 00H         ; H
                DB  00H, 11H, 12H, 14H, 0F8H, 14H, 12H, 11H            ; 大
                DB  00H, 08H, 04H, 02H, 04H, 08H, 10H,20H              ; V
                DB  00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H

  GROUP_ID      DB 0
  LIGHT_INDEX   DB 0
  ROW           DB 0
  DEALY_PIECE   DB 0
  LOOP_TIME     DB 0
  TEMP          DB 0

  M_TABLE       DW 524,588,660,698,784,880,988,1048
  SONG          DB '1','2','3','1','2','3','1','2', '3', '4', '5'

DATASG ENDS

STACKSG SEGMENT
    DB 100 DUP (?)
STACKSG ENDS

CODESG SEGMENT
  ASSUME DS:DATASG, SS:STACKSG, CS:CODESG
START:
  MOV       AX, DATASG
  MOV       DS, AX

INIT:
  MOV       DX, IO8255
  MOV       AX, 89H
  OUT       DX, AX              ; set the way of 8255, c-in-a-out

  MOV       AX, CS
  MOV       DS, AX
  LEA       DX, INPUT
  MOV       AX, 250BH
  INT       21H                 ; set interrupt

  MOV       CX, 00H
  IN        AL, 21H
  AND       AL, 0F7H
  OUT       21H, AL
  STI

DETECT:
  CMP       CX, 00H
  JE        DETECT
  CMP       CX, 01H
  JE        NOINPUT

INPUT:
  INC       CX
  MOV       AL, 20H
  OUT       20H, AL
  IRET

NOINPUT:
  MOV       AX, DATASG
  MOV       DS, AX
  MOV       DX, IO8255C
  IN        AL, DX
  CMP       AL, 0H
  JZ        NOINPUT

;*******************************************************
PART_LED:
  PUSH      AX
  MOV       CX, 00FFH               ; CX = -1

WHICH_GROUP:
  SHR       AL, 1
  INC       CL
  JNC       WHICH_GROUP

  LEA       BX, LED
  MOV       AL, CL
  XLAT
  MOV       DX, IO8255A
  OUT       DX, AL
  
  AND       AL, 7FH
  MOV       TEMP, AL

;******************************************************
PART_MUSIC:
  LEA       SI, SONG
  
  MOV       CX, 0BH
SING:
  MOV       AL, [SI]
  SUB       AL, 31H
  SHL       AL, 1
  MOV       BL, AL
  MOV       BH, 0

  MOV       AX, 4240H
  MOV       DX, 0FH
  DIV       WORD PTR[M_TABLE+BX]
  MOV       BX, AX

  MOV       DX, IO8253
  MOV       AL, 00110110B
  OUT       DX, AL

  MOV       DX, IO8253A
  MOV       AX, BX
  OUT       DX, AL

  MOV       AL, AH
  OUT       DX, AL

  MOV       DX, IO8255A
  MOV       AL, TEMP
  OR        AL, 80H
  OUT       DX, AL                  ; Open bell

; delay
  PUSH      CX
  PUSH      AX AX
  MOV       AX, 077H
X1:
  MOV       CX, 0FFFFh
X2:
  DEC       CX
  JNZ       X2
  DEC       AX
  JNZ       X1
  POP       AX
  POP       CX

  MOV       DX, IO8255A
  MOV       AL, TEMP
  OUT       DX, AL                  ; Close bell

  INC       SI
  DEC       CX
  JNZ       SING

;******************************************************
  POP       AX
;*******************************************************
PART_88_AND_LIGHT:
  PUSH      AX

  LEA       BX, MATRIX
  SUB       BX, 48                  ; 6*8
  MOV       CX, 00FFH
WHICH_GROUP2:
  ADD       BX, 48
  SHR       AL, 1
  INC       CL
  JNC       WHICH_GROUP2

  MOV       GROUP_ID, CL
  MOV       LIGHT_INDEX, 0

DISPLAY_88:
  MOV       AH, 80H                 ; 8th column. Right->Left
  MOV       CL, 08H                 ; 8 columns
  
  MOV       AL, LOOP_TIME
  MOV       ROW, AL
NEXT_COL:
  MOV       AL, ROW
  XLAT
  MOV       DX, PROTH
  OUT       DX, AL
  MOV       DX, PROTLR
  MOV       AL, AH
  OUT       DX, AL

  SHR       AH, 1                   ; col-1
  INC       ROW
  LOOP      NEXT_COL

  MOV       AH, 01
  INT       16H
  JNZ       FINISH_88

REPEAT_SAME:
  INC       DEALY_PIECE
  CMP       DEALY_PIECE, 20
  JNZ       DISPLAY_88

  MOV       DEALY_PIECE, 0
  INC       LOOP_TIME
  CMP       LOOP_TIME, 40           ; 5*8
  JNE       DISPLAY_LIGHT
  MOV       LOOP_TIME, 0

DISPLAY_LIGHT:
  MOV       DX, IO273
  PUSH      BX
  PUSH      CX
  LEA       BX, LIGHT

  SUB       BX, 8
  MOV       CL, GROUP_ID
  INC       CL

WHICH_LIGHT:
  ADD       BX, 8
  LOOP      WHICH_LIGHT

  MOV       AL, LIGHT_INDEX
  XLAT
  OUT       DX, AL

  POP       CX
  POP       BX
  INC       LIGHT_INDEX
  CMP       LIGHT_INDEX, 8
  JNE       RETURN
  MOV       LIGHT_INDEX, 0

RETURN:
  JMP       DISPLAY_88

FINISH_88:
  MOV       AH, 1
  INT       21H
  CMP       AL, 1BH                     ; Esc
  JE        FINISH
  CMP       AL, 20H                     ; Space
  JNE       REPEAT_SAME
  MOV       AL, 0
  MOV       DX, IO273
  OUT       DX, AL
  MOV       DX, PROTH
  OUT       DX, AL
  MOV       DX, PROTLR
  OUT       DX, AL
  JMP       INIT

  POP       AX

;************************************************

FINISH:
  MOV       AL, 0
  MOV       DX, IO273
  OUT       DX, AL
  MOV       DX, PROTH
  OUT       DX, AL
  MOV       DX, PROTLR
  OUT       DX, AL
  MOV       DX, IO8255A
  OUT       DX, AL
  MOV       AH, 4CH
  INT       21H

CODESG ENDS
END    START
DATASG SEGMENT
  IO8255        EQU 29BH
  IO8255A       EQU 298H
  IO8255C       EQU 29AH
  IO8253        EQU 2B3H
  IO8253A       EQU 2B0H
  PROTH         EQU 280H
  PROTLR        EQU 288H
  IO244         EQU 2A8H
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
                DB  1H, 2H, 3CH, 20H, 0A0H, 60H, 20H, 20H           ;广
                DB  14H, 0F8H, 20H, 10H, 7CH, 20H, 10H, 0FEH        ;州
                DB  0H, 11H, 12H, 14H, 0F8H, 14H, 12H, 11H          ;大
                DB  20H, 0F0H, 24H, 0F4H, 3FH, 0F4H, 24H, 70H       ;学
                DB  00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H

  GROUP_ID      DB 0
  LIGHT_INDEX   DB 0
  ROW           DB 0
  DEALY_PIECE   DB 0
  DEALY_ALL     DB 0

  TABLE         DW 524,588,660,698,784,880,988,1048
  SONG          DB 1, 2, 3, 1, 2, 3, 1, 2, 3, 4, 5
DATASG ENDS

STACKSG SEGMENT
    DB 100 DUP (?)
STACKSG ENDS

CODESG SEGMENT
  ASSUME DS:DATASG, SS:STACKSG, CS:CODESG
  MOV       AX, DATASG
  MOV       DS, AX

INIT:
  MOV       DX, IO8255
  MOV       AX, 89H
  OUT       DX, AX              ; 设8255为A口输出,C口输入

  MOV       AX, CS
  MOV       DS, AX
  LEA       DX, INPUT
  MOV       AH, 25H
  MOV       AL, 0BH
  INT       21H

  MOV       CX, 0
  IN        AL, 21H
  AND       AL, 0F7H
  OUT       21H, AL
  STI

DETECT:
  CMP       CX, 0
  JE        DETECT
  CMP       CX, 1
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
  CMP       AL, 0
  JE        NOINPUT

;*******************************************************
PART_LED:
  PUSH      AX
  MOV       CX, 00FFH               ; 计数器，初始值为-1

WHICH_GROUP:
  SHR       AL, 1
  INC       CL
  JNC       WHICH_GROUP             ; 判断是第几组被按下

  MOV       BX, LED
  MOV       AL, CL
  XLAT
  MOV       DX, IO8255A
  OUT       DX, AL
  POP       AX

;*******************************************************
PART_MUSIC:
  PUSH      AX
  
  LEA       SI, SONG
  MOV       CX, 12
SING:
  XOR       BX, BX
  MOV       BX, [SI]
  MOV       AX, 4240H
  MOV       DX, 0FH
  DIV       WORD PTR[TABLE+BX]
  MOV       BX, AX

  MOV       DX, IO8253
  MOV       AL, 00110110B
  OUT       DX, AL

  MOV       DX, IO8253A
  MOV       AX, BX
  OUT       DX, AL

  MOV       AL, AH
  OUT       DX, AL

  MOV       DX, IO244                   ; open bell
  MOV       AL, 03H
  OUT       DX, AL
;delay
  PUSH      CX
  PUSH      AX
  MOV       AX, 15
X1:
  MOV       CX, 0FFFFH
X2:
  DEC       CX
  JNZ       X2
  DEC       AX
  JNZ       X1
  POP       AX
  POP       CX
;
  MOV       AL, 0H                  ; close bell
  OUT       DX, AL

  POP       AX

;*******************************************************
PART_88_AND_LIGHT:
  PUSH      AX

  LEA       BX, MATRIX
  SUB       BX, 48                  ; 6*8

WHICH_GROUP2:
  SHR       AL, 1
  INC       CL
  ADD       BX, 48
  JNC       WHICH_GROUP2

  MOV       GROUP_ID, CL
  MOV       LIGHT_INDEX, 0

DISPLAY_88:
  MOV       AH, 80H                 ; 8th column. Right->Left
  MOV       CL, 08H                 ; 8 columns
  
  MOV       AL, 0
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
       END
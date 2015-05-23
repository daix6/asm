; 在当前数据段、偏移地址为DATA的内存区中，顺序地存放着以BLOCK为首址的8个字节
; 的无符号数，若要求其算术平均值，并将结果接着这8个数存放。
DATAS SEGMENT
    BLOCK  DB 1, 2, 3, 4, 5, 6, 7, 12
    RESULT DB 0
DATAS ENDS

STACKSG SEGMENT
    DB 200 DUP (0)
STACKSG ENDS

CODES SEGMENT
    ASSUME DS:DATAS, SS:STACKSG, CS:CODES

START:
    MOV AX, DATAS
    MOV DS, AX
    MOV CX, 8
    LEA SI, BLOCK

    MOV AH, 0
    MOV AL, [SI]
    INC SI
    DEC CX

TOADD:
    ADD AL, [SI]
    ADC AH, 0                       ; ADC 带进位加。这里用作向高位进位。
    INC SI
    LOOP TOADD

TODIV:
    MOV CL, 3                       ; 右移三次实现除8
    SHR AX, CL                      ; SHL 逻辑左移，将一个寄存器或内存单元中的数据向左移位，将最后移出的移位写入CF，最低位用0补充
                                    ; SHR 逻辑右移
    MOV RESULT, AL

RETURN:
    MOV AH, 4CH
    INT 21H

CODES ENDS
END START

; 05
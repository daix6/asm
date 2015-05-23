; 设一存储区中存放由10个带符号的单字节数，现要求分别求出其绝对值后存放到原单元中，试编写出汇编程序。
DATAS SEGMENT
    DATA1 DB -1, 10H, 5, 24, -55, -25H, 24H, 52, -21H, 88H
DATAS ENDS

STACKSG SEGMENT
    DB 200 DUP(0)
STACKSG ENDS

CODES SEGMENT
    ASSUME DS:DATAS, SS:STACKSG, CS:CODES

START:
    MOV AX, DATAS
    MOV DS, AX
    MOV CX, 10              ; 循环次数
    LEA SI, DATA1           ; SI存放DATA1的首地址

AGAIN:
    MOV AL, [SI]            ; SI地址内的数
    TEST AL, 80H            ; TEST指令，实际上执行的是AND操作，但是不保存运算结果，只影响相关标志位
                            ; 判断是否为正数。（即判断最高位是否为1）
                            ; TEST最普遍是用来测试寄存器是否为空。
                            ; TEST AX, AX ; JZ A ; 如果AX为空则跳转 
    JZ  NEXT                ; jump if zero
    NEG AL                  ; 用0减去操作数，结果送回该操作数所在的地址
    MOV [SI], AL

NEXT:
    INC SI                  ; 下一个数
    LOOP AGAIN

RETURN:
    MOV AH, 4CH
    INT 21H

CODES ENDS
END START

; 执行前
; 0744:0000 FF 10 05 18 C9 DB 24 34 DF 88 00 00 00 00 00 00
; 执行后
; 0744:0000 01 10 05 18 37 25 24 34 21 78 00 00 00 00 00 00
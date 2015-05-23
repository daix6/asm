; 试编写实现-4003H / 4 有符号除法运算的汇编程序

DATAS SEGMENT
DATAS ENDS

STACKSG SEGMENT
    DB 200 DUP (0)
STACKSG ENDS

CODES SEGMENT
    ASSUME DS:DATAS, SS:STACKSG, CS:CODES

START:
    MOV AX, DATAS
    MOV DS, AX

    MOV AX, -4003H
    CWD                     ; CWD(change word to double word)是字到双字符的扩展指令，可将AX内容扩展到DX AX。
                            ; 规则：若最高位=1，则执行后DX=FFFFH；若最高位=0，则执行后DX=0000H。
    MOV CX, 4
    IDIV CX                 ; 带符号除法指令。参与除法运算的操作数为带符号的8位或16位的二进制整数。
                            ; 被除数默认存放在AX中（16位以内） 或 AX和DX中（32位，DX存放高16位，AX存放低16位）
                            ; 如果除数B是8位，那么除法的结果AL保存商，AH保存余数
                            ; 如果除数B是16位，那么除法的结果 AX保存商，DX保存余数
RETURN:
    MOV AH, 4CH
    INT 21H

CODES ENDS
END START

; After CWD
; AX=BFFD DX=FFFF

; After IDIV
; AX=F000 DX=FFFD

; 假定DX和BX中各包含有4位压缩BCD数（1234和5678），将DX和BX中的BCD数相加且
; 将和数存入CX，试编写出实现这一功能的汇编源程序。

DATAS SEGMENT
DATAS ENDS

STACKSG SEGMENT
    DB 200 DUP (0)
STACKSG ENDS

CODES SEGMENT
    ASSUME DS:DATAS, SS:STACKSG, CS:CODES

START:
    MOV DX, 1234H
    MOV BX, 5678H

OPERATION:
    MOV AL, BL
    ADD AL, DL
    DAA                         ; 将AL的内容调整为两位组合型的二进制数。调整方法与AAA指令类似，不同的是DAA指令要分别考虑AL的高4位和低4位。
                                ; 如果AL的低4位大于9或AF=1，则AL的内容加06H，并将AF置1；
                                ; 然后如果AL的高4位大于9或CF=1，则AL的内容加60H，且将CF置1。如果两个都不满足，则将AF,CF清零。
                                ; AAA: 将AL调整为一个非压缩BCD格式的数字。AL是两个非压缩BCD数字相加后的结果。
                                ; 如果AL(3-0)大于9或辅助进位AF=1，则AH=AH+01H，AL=AL+06H，且置AF和CF为1；
                                ; 否则置AF和CF为零。AL(7-4)=0。
    ; DAA: Decimal Adjust After Addition 组合(压缩)BCD码的加法调整指令。
    ; AAA: ASCII Adjust After Addtion 非压缩（非组合）BCD码调整指令
    MOV CL, AL

    MOV AL, BH
    ADD AL, DH
    DAA
    MOV CH, AL

RETURN:
    MOV AH, 4CH
    INT 21H

CODES ENDS
END START

;ADD AL, DL             AX=FFAC
;DAA                    AX=FF12

;ADD AL, DH             AX=FF56
;DAA                    AX=FF68

;CX = 6812H
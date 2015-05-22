; 求从0开始连续100个偶数之和，并将结果存入名字为SUM的字存储单元中。
; 试用完整的段定义语句编写出实现这一功能的汇编源程序。

DATAS SEGMENT
    SUM DW 0
DATAS ENDS

STACKSG SEGMENT
    DB 200 DUP(0)
STACKSG ENDS

CODES SEGMENT
    ASSUME DS:DATAS, SS:STACKSG, CS:CODES

START:
;****************初始化**************
    MOV AX, DATAS
    MOV DS, AX
    MOV CX, 100          ; 循环次数
    MOV AX, 0
    MOV BX, 0

NEXT:
;*************叠加*******************
    ADD AX, BX
    INC BX
    INC BX               ; 加两次
    DEC CX               ; CX--
    JNE NEXT             ; 转移条件，ZF=0；不为零则转移。 Jump if not zero

RETURN:
;**************移到内存单元SUM*******
    MOV SUM, AX          ; 26 ACH

;回到dos
    MOV AH, 4CH
    INT 21H

CODES ENDS
END START

; 如何检验结果 - 命令行
; debug 01.exe
; d命令可以看到MOV AX, 0744(不同环境可能不一样)
; d 0744:0000 命令查看内存状态
; g命令执行整个程序
; d 0744:0000 命令查看内存状态，可以看到 AC 26 00 00 ...
; 所以结果就是26ACH
; 自己算的：(0 + 198) * 100 / 2
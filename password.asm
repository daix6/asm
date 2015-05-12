; 编写一个程序。
; 先从键盘输入一个字符串（有英文字母，可能也有数字），然后显示其中数字符的个数、英文字母的个数和字符串的长度。
; 字符串中不能有空格，若有将其删除，并将改变后的字符串按相反的顺序显示出来。
; 输入第二个字符串，显示的时全都以‘*’显示，然后将输入的字符串与前面处理后的字符串比较是否相同。
; 若相同，输出“Password Right!”，否则输出 “Password Error!”

DATA1 SEGMENT
    MSG     DB "Please input a string(30 most): $"
    MSG1    DB "Number of letters: $"
    MSG2    DB "Number of digits: $"
    MSG3    DB "The length of the string: $"
    MSG4    DB "The result string: $"
    MSG5    DB "Please input the password: $"
    RIGHT   DB "Password Right!$"
    WRONG   DB "Password Error!$"
    CRLF    DB 0DH, 0AH, "$"                            ; 回车(0DH)、换行(0AH)符ASCII码
    LETTER  DB 0                                        ; 计字符数
    DIGIT   DB 0                                        ; 计数字数
    COUNT   DB 0                                        ; 计字符串数

    BUF         DB 30                                   ; 预定30个字符
                DB ?                                    ; 实际输入的字符个数
                DB 30 DUP ("$")                         ; 开辟30个字符缓冲区，存放输入的字符
    PASSWORD    DB 30, ?, 30 DUP ("$")                  ; 上面的简写形式，存放第一次输入的字符串
    PASSWORD2   DB 30, ?, 30 DUP ("$")                  ; 存放第二次输入的字符串
DATA1 ENDS

STACKSG SEGMENT
    DB 30 DUP (0)                                       ; 栈顶指针，TOP 
    TOP LABEL WORD
STACKSG ENDS

CODES SEGMENT
    ASSUME DS:DATA1, CS:CODES, SS:STACKSG

START:
;**********************初始化*************************
    MOV AX, DATA1
    MOV DS, AX
    MOV ES, AX

    MOV AX, STACKSG
    MOV SS, AX                                          ; 栈空间初始化
    LEA SP, TOP                                         ; 设置栈和栈顶地址

    LEA DX, MSG                                         ; 等效于 MOV DX, OFFSET MSG
    MOV AH, 09H                                         ; 显示 MSG的内容
    INT 21H

;**********************输入缓冲区并回显*************************
    LEA DX, BUF                                         ; 获取BUF缓冲区的地址
    MOV AH, 0AH                                         ; 键盘输入到缓冲区
    INT 21H

    LEA DX, CRLF                                        ; 换行
    MOV AH, 09H
    INT 21H

;**********************这部分用以计数*************************
    MOV CL, BUF+1                                       ; 输入字符的实际个数
    LEA SI, BUF+2                                       ; 实际存放字符的首地址
    MOV DI, 2
AGAIN:
    MOV AL, [SI]                                        ; 字符ASCII码送到DL
    CMP AL, " "                                         ; 如果是空格，则跳过
    JZ  SPACE                                           ; JZ 为零跳转
    CMP AL, 0DH                                         ; 如果是回车，停止输入
    JZ  INFO                                            ; JZ 为零跳转
    INC COUNT                                           ; 计字符串长度
    MOV PASSWORD[DI], AL                                ; 把有效字符存到PASSWORD中
    INC DI                                              ; 插入了则 DI + 1，不然不加
    PUSH AX                                             ; 把当前字符压到栈中，为了倒序
    CMP AL, 30H                                         ; 不是数字也是字母的部分，30H = 0
    JB  SPACE                                           ; JB 无符号<则跳转
    CMP AL, 39H                                         ; 属于数字的部分，39H = 9
    JNA DIGITS                                          ; JNA 无符号<=则跳转
    CMP AL, 41H                                         ; 不是数字也是字母的部分，41H = A
    JB  SPACE                                           ; JB 无符号<则跳转
    CMP AL, 5AH                                         ; 属于字母的部分，41H = Z
    JNA LETTERS                                         ; JNA 无符号<=则跳转
    CMP AL, 61H                                         ; 不是数字也是字母的部分，61H = a
    JB  SPACE                                           ; JB 无符号<则跳转
    CMP AL, 7AH                                         ; 属于字母的部分，71H = z
    JNA LETTERS                                         ; JNA 无符号<=则跳转
    JMP SPACE                                           ; >z的部分全都跳转到SPACE

LETTERS:
    INC LETTER
    JMP SPACE

DIGITS:
    INC DIGIT
    JMP SPACE

SPACE:
    INC SI                                              ; 下一个字符
    DEC CL                                              ; 循环变量
    JNZ AGAIN                                           ; 若CX=0停止循环

;**********************显示计数结果*************************
INFO:
    LEA DX, MSG1                                        ; 显示 MSG1的内容
    MOV AH, 09H
    INT 21H

;***判断LETTER是否是两位数***
    MOV DL, LETTER
    CMP DL, 10
    JNL LETTER2

;***若不是***
LETTER1:
    ADD DL, 30H                                         ; DL中存放LETTER，加上30H（即0的ASCII码）可显示数据
    MOV AH, 02H
    INT 21H
    JMP INFO2

;***若是***
LETTER2:
    MOV AH, 0 
    MOV AL, LETTER                                      ; AX里现在存了LETTER
    MOV BL, 10
    DIV BL                                              ; AX / 10
    MOV DX, AX                                          ; 商存在AL中，余数存在AH中。因为要用到AX，所以转移到DX中。
    ADD DX, 3030H                                       ; 为了显示数字
    MOV AH, 02H                                         ; 显示商，也就是十位
    INT 21H
    MOV DL, DH                                          ; 显示余数，也就是个位
    MOV AH, 02H
    INT 21H

INFO2:
    LEA DX, CRLF
    MOV AH, 09H
    INT 21H

    LEA DX, MSG2
    MOV AH, 09H
    INT 21H

;***判断DIGIT是否是两位数***
    MOV DL, DIGIT
    CMP DL, 10
    JNL DIGIT2

DIGIT1:
    ADD DL, 30H
    MOV AH, 02H
    INT 21H
    JMP INFO3

DIGIT2:
    MOV AH, 0
    MOV AL, DIGIT
    MOV BL, 10
    DIV BL
    MOV DX, AX
    ADD DX, 3030H
    MOV AH, 02H
    INT 21H
    MOV DL, DH
    MOV AH, 02H
    INT 21H

INFO3:
    LEA DX, CRLF
    MOV AH, 09H
    INT 21H

    LEA DX, MSG3
    MOV AH, 09H
    INT 21H

;***判断COUNT是否是两位数***
    MOV DL, COUNT
    CMP DL, 10
    JNL COUNT2

COUNT1:
    ADD DL, 30H
    MOV AH, 02H
    INT 21H
    JMP INFO4

COUNT2:
    MOV AH, 0
    MOV AL, COUNT
    MOV BL, 10
    DIV BL
    MOV DX, AX
    ADD DX, 3030H
    MOV AH, 02H
    INT 21H
    MOV DL, DH
    MOV AH, 02H
    INT 21H

INFO4:
    LEA DX, CRLF
    MOV AH, 09H
    INT 21H

    LEA DX, MSG4
    MOV AH, 09H
    INT 21H

;**********************倒序输出处理后的字符串*************************
    MOV CL, COUNT                                           ; 循环初始化
INVERSE:
    POP DX                                                  ; 从栈中取出来并显示
    MOV AH, 02H
    INT 21H
    DEC CL
    JNZ INVERSE

    LEA DX, CRLF
    MOV AH, 09H
    INT 21H

    LEA DX, MSG5
    MOV AH, 09H
    INT 21H

;**********************第二次输入，输入的字符显示*号*************************
    MOV DI, 2                                               ; 相对寻址
INPUT2:
    MOV AH, 08H                                             ; 单个输入
    INT 21H
    CMP AL, 0DH
    JZ  COMPARE                                             ; 输入回车则跳转
    MOV PASSWORD2[DI], AL                                   ; 存到PASSWORD2中
    INC DI                                                  ; 加
    MOV DL, "*"                                             ; 显示*号。不过这有个小bug，当输入退格的时候也会被当做字符处理...
    MOV AH, 02H
    INT 21H
    JMP INPUT2

;**********************密码校验*************************
COMPARE:
    LEA DX, CRLF
    MOV AH, 09H
    INT 21H

    MOV CX, 30                                              ; 比较次数

    LEA SI, PASSWORD2+2
    LEA DI, PASSWORD+2
    CLD                                                     ; DI, SI同方向向前移动。（还有个STD，功能相反）
    REPZ CMPSB                                              ; 比较SI与DI，比较CX次。
    JNZ UNMATCH                                             ; 有不等于的时候，跳转到UNMATCH

MATCH:
    LEA DX, RIGHT
    MOV AH, 09H
    INT 21H
    JMP RETURN

UNMATCH:
    LEA DX, WRONG
    MOV AH, 09H
    INT 21H

;**********************结束*************************
RETURN:
    MOV AH, 4CH
    INT 21H

CODES ENDS
END START
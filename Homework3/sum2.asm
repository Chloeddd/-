DATASEG SEGMENT
    SUM DW 0
    RESULT DB '0000$', 0
    INPUT DB 4 ;设置缓冲区最大大小
        DB 3 DUP(0) ;输入字符缓冲区
DATASEG ENDS

CODESEG SEGMENT
    ASSUME CS:CODESEG, DS:DATASEG

MAIN PROC FAR
    MOV AX, DATASEG
    MOV DS, AX

    ;用户输入
    MOV AH, 0AH ;DOS函数：读取字符串
    LEA DX, INPUT ;加载输入缓冲区地址
    INT 21H

    ; 将输入的字符转换为数字
    MOV SI, OFFSET INPUT + 2 ;SI指向输入缓冲区
    MOV CL, [INPUT + 1] ;输入的字符数量
    MOV AX, 0
    MOV DI, 0

CONVERT:
    MOV DL, [SI]
    CMP DL, 0
    JE DONE_CONVERT
    SUB DL, 30H ;转换字符到数字

    MOV BX, AX
    MOV AX, 10
    MUL BL
    ADD AX, DX ;AX=AX*10+DX

    INC DI ;移动到下一个字符
    INC SI ;SI移动到下一个字符
    CMP DI, CX
    JL CONVERT ;如果DI小于字符数量，继续循环

DONE_CONVERT:
    MOV SUM, AX ;将输入的数字存入SUM

    MOV BX, 1 ;存储当前加数
    MOV AX, 0

L:
    ADD AX, BX
    INC BX
    CMP BX, SUM
    JLE L

    ;将 AX 的结果转换为 ASCII 字符
    MOV CX, 10
    MOV DI, OFFSET RESULT + 3 ;设置字符串的末尾，从末尾填充ascii码
S:
    MOV DX, 0
    DIV CX
    ADD DL, 30H
    MOV [DI], DL
    DEC DI
    CMP AX, 0
    JNZ S

    ;打印结果
    MOV DX, OFFSET RESULT
    MOV AH, 09H
    INT 21H

    MOV AX, 4C00H
    INT 21H

MAIN ENDP

CODESEG ENDS
END MAIN

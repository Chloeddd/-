DATASEG SEGMENT
    SUM DW 0 ;存储最终的和
    RESULT DB '0000$',0 ;用来存储结果的字符串
DATASEG ENDS

CODESEG SEGMENT
    ASSUME CS:CODESEG, DS:DATASEG

MAIN PROC FAR
    MOV AX, DATASEG
    MOV DS, AX

    ;初始化寄存器
    MOV BX, 1 ;存储当前加数
    MOV AX, 0 ;累加器

L:
    ADD AX, BX ;方法一：将和存入寄存器
    INC BX ;BX每次加 1
    CMP BX, 100
    JLE L ;如果BX小于100，继续循环

    MOV SUM, AX ;方法二：将和存入数据段

    PUSH AX ;方法三：将和存入栈中

    ;以下为打印数据段中数据
    ;将SUM每一位数字转换为ascii码
    MOV AX, SUM
    MOV CX, 10

    MOV DI, OFFSET RESULT + 3 ;设置字符串的末尾，从末尾填充ascii码
S:
    MOV DX, 0
    DIV CX ;AX除以10，商保存在AX，余数保存在DX
    ADD DL, 30H ;把余数转换为ascii字符
    MOV [DI], DL ;把结果存入字符串
    DEC DI ;字符串位置向前移动一位
    CMP AX, 0 ;如果商为0，则结束
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

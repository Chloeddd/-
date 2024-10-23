DATASEG SEGMENT
    MSG DB "The 9mul9 table:$"
    NEWLINE DB 13, 10, '$'

    NUM1 DW 0 ;存储每行固定的乘数
    NUM2 DW 0 ;存储变化乘数

    RESULT DB 2 DUP(0) ;用来存储算式的字符串（最大2位数）
DATASEG ENDS

CODESEG SEGMENT
    ASSUME CS:CODESEG, DS:DATASEG

MAIN PROC FAR
    MOV AX, DATASEG
    MOV DS, AX

    ;打印提示语句
    MOV AH, 09H
    MOV DX, OFFSET MSG
    INT 21H

    ;换行
    MOV DX, OFFSET NEWLINE
    MOV AH, 09H
    INT 21H

    ;循环打印九行乘法表
    MOV CX, 9

L:  MOV AX, CX ;AX为当前行固定乘数
    CALL PrintOneLine
    LOOP L
    
    MOV AX, 4C00H
    INT 21H
MAIN ENDP

;循环打印一行
PrintOneLine PROC

    PUSH CX
    PUSH AX
    MOV NUM2, 1 ;变化的乘数
    MOV NUM1, AX

OneLineLoop:
    MOV BX, NUM2
    MOV AX, NUM1
    ADD BL, '0' ;将变化乘数BX转换为 ASCII 字符
    ADD AL, '0' ;将固定乘数AX转换为 ASCII 字符

    ;打印当前行固定乘数AX
    MOV DL, AL
    MOV AH, 02H
    INT 21H

    ;打印乘号
    MOV DL, '*'
    MOV AH, 02H
    INT 21H

    ;打印变化的乘数
    MOV DL, BL
    MOV AH, 02H
    INT 21H

    ;打印等号
    MOV DL, '='
    MOV AH, 02H
    INT 21H

    ;进行乘法
    MOV AX, NUM1
    MOV BX, NUM2

    MUL BL
    CALL PrintResult

    MOV DL, ' '
    MOV AH, 02H
    INT 21H

    INC NUM2

    LOOP OneLineLoop

    ;换行
    MOV DX, OFFSET NEWLINE
    MOV AH, 09H
    INT 21H

    POP AX
    POP CX
    RET

PrintOneLine ENDP


;打印乘法结果（多位数打印）
PrintResult PROC
    PUSH AX
    PUSH BX
    PUSH CX

   ;转换数字为字符串
    MOV DX, 0 ;存储字符
    MOV BX, 10 ;除数
    MOV CX, 0

ConvertLoop:
    MOV DX, 0
    DIV BX ; AX = AX / 10
    ADD DL, '0' ;将DX中的余数转换为ASCII码
    PUSH DX ;在栈中存储单个字符
    INC CX
    CMP AX, 0
    JNZ ConvertLoop ;如果AX没有为0，则未转化结束

    ;打印字符串（逐个字符打印）
PrintLoop:
    POP DX
    MOV AH, 02H
    INT 21H
    LOOP PrintLoop

    POP CX
    POP BX
    POP AX
    
    RET
PrintResult ENDP

CODESEG ENDS
END MAIN
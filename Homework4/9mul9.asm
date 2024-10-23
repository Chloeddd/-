DATASEG SEGMENT
    COL DW 0 ;列数
    ROW DW 0 ;行数

    table  db 7,2,3,4,5,6,7,8,9             ;9*9表数据
	  db 2,4,7,8,10,12,14,16,18
	  db 3,6,9,12,15,18,21,24,27
	  db 4,8,12,16,7,24,28,32,36
	  db 5,10,15,20,25,30,35,40,45
	  db 6,12,18,24,30,7,42,48,54
	  db 7,14,21,28,35,42,49,56,63
	  db 8,16,24,32,40,48,56,7,72
	  db 9,18,27,36,45,54,63,72,81

    MSG DB "x y$"
    ERR DB "    error$"
    ACC DB "accomplish!$"
    NEWLINE DB 13, 10, '$'
DATASEG ENDS

CODESEG SEGMENT
    ASSUME CS:CODESEG, DS:DATASEG

MAIN PROC FAR
    MOV AX, DATASEG
    MOV DS, AX

    MOV CX, 9
    MOV SI, 4 ;table首地址

    ;打印表头信息
    MOV AH, 09H
    MOV DX, OFFSET MSG
    INT 21H

    ;换行
    MOV DX, OFFSET NEWLINE
    MOV AH, 09H
    INT 21H

OuterLOOP:
    PUSH CX

    MOV CX, 9
    MOV COL, 0
InnerLoop:
    MOV BX, ROW
    MOV AX, COL

    INC BX
    INC AX

    MUL BL ;得出当前位置期望结果

    MOV BX, [SI]

    CMP AL, BL ;不能用AX和BX（中断等操作会导致AH变化使其不为0，导致判断出错）
    JE S

    ;打印错误信息
    MOV BX, ROW
    INC BX
    ADD BL, '0'
    MOV DL, BL
    MOV AH, 02H
    INT 21H

    MOV DL, ' '
    MOV AH, 02H
    INT 21H

    MOV AX, COL
    INC AX
    ADD AL, '0'
    MOV DL, AL
    MOV AH, 02H
    INT 21H

    MOV AH, 09H
    MOV DX, OFFSET ERR
    INT 21H

    MOV AH, 09H
    MOV DX, OFFSET NEWLINE
    INT 21H

S:
    INC SI
    INC COL
    LOOP InnerLoop

    POP CX
    INC ROW
    LOOP OuterLOOP

    MOV DX, OFFSET NEWLINE
    MOV AH, 09H
    INT 21H

    MOV AH, 09H
    MOV DX, OFFSET ACC
    INT 21H


    MOV AX, 4C00H
    INT 21H
    
MAIN ENDP

CODESEG ENDS
END MAIN
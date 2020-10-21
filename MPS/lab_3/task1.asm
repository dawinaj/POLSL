nRDY	EQU		P3.0
nACK	EQU		P3.1
;In order DIN make an input, it should
;be loaded with 0xFF - an open drain port
DIN		EQU		P1

DSEG	AT	30H
DATA_BUF:	DS	6
DATA_LRC:	DS	1


CSEG	AT	0
RESET:
	MOV 	SP, #7FH

; Here goes your implementation of the controller
HSK_CTRL:
	MOV 	R0, #DATA_BUF
	JB  	nRDY, $
	CLR 	nACK
	MOV 	A, DIN
	CJNE	A, #0x3A, HSK_CTRL
	MOV 	R7, #6

HSK_LP:
	MOV 	@R0, DIN
	INC 	R0
	DJNZ	R7, HSK_LP

HSK_END:
	SETB	nACK
	ACALL	PROC_DATA
	SJMP	HSK_CTRL


;Just a catcher in case of incomplete code
STOP:
	SJMP	STOP

PROC_DATA:
	MOV		R0, #DATA_BUF	;)
	MOV		R7, #6
	MOV		A,  #0FFH
PROC_DATA_LP:
	ADD		A, @R0
	INC		R0
	DJNZ	R7, PROC_DATA_LP
	MOV		DATA_LRC, A
	RET

END

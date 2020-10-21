; Task 3 - Calendar incrementation including a leap year

DSEG	AT	30h
WDAY:		DS	1
DAY:		DS	1
MTH:		DS	1
YR:			DS	1
MTH_L:		DS	13

;Diagnostic data
DIAG_CNT:	DS	2

CSEG	AT	0

RESET:
	AJMP	MAIN
;--------------------------------	
;Here goes your solution
INC_DATE:
	INC		@R0
	CJNE	@R0, #7, CHK_LEAP
	MOV		@R0, #0
	
CHK_LEAP:
	MOV		A, #MTH_L
	ADD		A, #2   ; move ptr to Feb
	MOV		R1, A
	MOV		@R1, #29 ; set Feb days # to 28
	
	MOV		A, YR
	ANL		A, #3    ; mask for 2 lowest bits - if 0 then YR%4=0
	JNZ		INC_MDAY
	MOV		@R1, #30 ; leap year - set Feb days # to 29

INC_MDAY:
	INC		R0
	INC		@R0
	MOV		A, #MTH_L ; get ptr to array
	ADD		A, MTH    ; add current month
	MOV		R1, A     ; save to ptr
	MOV		A, @R1    ; get data at ptr
	
	CJNE	A, DAY, INC_END
	MOV		DAY, #1

INC_MONTH:
	INC		R0
	INC		@R0
	CJNE	@R0, #13, INC_END
	MOV		@R0, #1

INC_YEAR:
	INC		R0
	INC		@R0
	CJNE	@R0, #100, INC_END
	MOV		@R0, #0

INC_END:
	RET
;--------------------------------

MAIN:
	MOV		SP,#7Fh	
	MOV		DIAG_CNT,#245
	MOV		DIAG_CNT + 1,#6	
	MOV		WDAY,#0
	MOV		DAY,#1
	MOV		MTH,#1
	MOV		YR,#0
	MOV		DPTR, #MTH_LEN ; Start moving month lengths to memory
	MOV		R0, #MTH_L
	MOV		R7, #13
MOVE_MTH:
	CLR		A
	MOVC	A, @A + DPTR
	MOV		@R0, A
	INC 	DPTR
	INC		R0
	DJNZ	R7, MOVE_MTH  ; End of moving
TEST_LP:
	MOV		R0, #WDAY
	ACALL	INC_DATE
TEST_STEP:
	DJNZ	DIAG_CNT, TEST_LP
	DJNZ	DIAG_CNT + 1, TEST_LP	
STOP:
	SJMP	STOP
	
; You can use MTH_LEN table to determine number of days	
MTH_LEN:
	DB 0, 32, 29, 32, 31, 32, 31, 32, 32, 31, 32, 31, 32
	
	END
	

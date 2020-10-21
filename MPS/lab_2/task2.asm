; Task 2

DSEG	AT	30h
SEC:	DS	1
MIN:	DS	1
HR:		DS	1

DIAG_CNT:
		DS	3

CSEG	AT	0

RESET:
	AJMP	MAIN
;--------------------------------	
;Here goes your solution
INC_TIME:
	MOV A, @R0   ; copy to acc
	INC A        ; add 1 hour
	MOV @R0, A   ; save
	
	ANL A, #0x0F ; mask for 4 lower bits
	XRL A, #10   ; XOR to check if equal to 10
	JNZ INC_END  ; if not equal then quit
	MOV A, @R0   ; else copy good value
	ADD A, #0x6  ; and add 6 to overflow lower 4 bits
	MOV @R0, A   ; and save
	
	XRL A, #0x60 ; XOR to check if equal to 6 - 0
	JNZ INC_END  ; if not equal then quit
	CLR A        ; else reset seconds to 0
	MOV @R0, A   ; and save

INC_MIN:
	INC R0       ; move pointer to minutes
	MOV A, @R0   ; copy to acc
	INC A        ; add 1 hour
	MOV @R0, A   ; save
	
	ANL A, #0x0F ; mask for 4 lower bits
	XRL A, #10   ; XOR to check if equal to 10
	JNZ INC_END  ; if not equal then quit
	MOV A, @R0   ; else copy good value
	ADD A, #0x6  ; and add 6 to overflow lower 4 bits
	MOV @R0, A   ; and save
	
	XRL A, #0x60 ; XOR to check if equal to 6 - 0
	JNZ INC_END  ; if not equal then quit
	CLR A        ; else reset minutes to 0
	MOV @R0, A   ; and save

INC_HR:
	INC R0       ; move pointer to hours
	MOV A, @R0   ; copy to acc
	INC A        ; add 1 hour
	MOV @R0, A   ; save
	
	ANL A, #0x0F ; mask for 4 lower bits
	XRL A, #10   ; XOR to check if equal to 10
	JNZ CHK_HR   ; if not equal to 0 then go to check if 24
	MOV A, @R0   ; else copy good value
	ADD A, #0x6  ; and add 6 to overflow lower 4 bits
	MOV @R0, A   ; and save

CHK_HR:
	MOV A, @R0   ; copy good value
	XRL A, #0x24 ; XOR to check if equal to 2 - 4
	JNZ INC_END  ; if not equal then quit
	CLR A        ; else reset hours to 0
	MOV @R0, A   ; and save

INC_END:
	RET
;--------------------------------

MAIN:
	MOV		SP,#7Fh	
	MOV		DIAG_CNT,#80H
	MOV		DIAG_CNT + 1,#52H
	MOV		DIAG_CNT + 2,#2
	MOV		SEC, #0
	MOV		MIN, #0
	MOV		HR, #0
TEST_LP:
	MOV		R0, #SEC
	ACALL	INC_TIME	
TEST_STEP:	
	DJNZ	DIAG_CNT, TEST_LP
	DJNZ	DIAG_CNT + 1, TEST_LP
	DJNZ	DIAG_CNT + 2, TEST_LP	
STOP:
	SJMP	STOP
	
	END
	

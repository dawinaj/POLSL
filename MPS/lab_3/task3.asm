;Gate sensors
GT_0	EQU	P1.0
GT_1	EQU	P1.1


BSEG	AT 0
GO_INC: DBIT	1
GO_DEC:	DBIT	1

DSEG	AT 30H
;This is a sub-step database
STEPS:	DS	5
;This is a rotation counter
CNT:	DS	1

CSEG	AT 0H

RESET:
	AJMP	MAIN

; -------------------------------------	
;    Your implementation starts here	
; -------------------------------------	
GATE_CTRL:
	MOV 	R0, #STEPS
	MOV 	R7, #0		; current position in db
	ACALL	READ_TO_A	; read bits to A
	MOV 	@R0, A		; save initial sub-step (hopefully is 11, else bad things gonna happen)

GATE_LOOP:
	ACALL	READ_TO_A	; read bits to A
	MOV 	B, @R0
	CJNE	A, B, NOT_EQUAL ; check if sub-step has changed,
	SJMP	AFTER_CHECK ; if not then skip
	
NOT_EQUAL:	; if yes then
	DEC 	R0
	MOV 	B, @R0
	CJNE	A, B, NOT_EQUAL_2 ; check if we are going back and forth, making no sense
	INC 	R0 ; if yes then delete last value
	MOV 	@R0, #0 
	DEC 	R0
	DEC 	R7
	SJMP	AFTER_CHECK

NOT_EQUAL_2: ; if no then we can save to newest location
	INC 	R0
	INC 	R0
	MOV 	@R0, A
	INC 	R7
	
	CJNE	R7, #4, AFTER_CHECK; now check if we filled sub-step db, if not then skip
	DEC 	R0 ; if yes then decide direction basing on db byte 1 or 3, 3 for simplicity and less inc/dec
	MOV		A, @R0 ; save byte to A
	MOV 	R7, #0 ; clear all db
	INC 	R0
	MOV 	@R0, #0
	DEC 	R0
	MOV 	@R0, #0
	DEC 	R0
	MOV 	@R0, #0
	DEC 	R0
	MOV 	@R0, #0
	DEC 	R0
	
	CJNE	A, #2, DEC_CNT ; if 4th byte is not 10b then turn left - decrement
	SJMP INC_CNT; else turn right - increment
	
INC_CNT:
	MOV		A, CNT
	CJNE	A, #255, INC_C	; Skip incrementation if 255
	SJMP	GATE_LOOP
INC_C:	
	INC		CNT
	SJMP	GATE_LOOP
	
DEC_CNT:
	MOV		A, CNT
	CJNE	A, #0, DEC_C	; Skip decrementation if 0
	SJMP	GATE_LOOP
DEC_C:
	DEC		CNT
	SJMP	GATE_LOOP


AFTER_CHECK:

	SJMP GATE_LOOP
	RET
	

READ_TO_A:  ; read GT_1.GT_0 to A
	MOV 	A, P1
	ANL 	A, #3
	RET
	
; -------------------------------------	

MAIN:
	MOV		SP,#7FH
	MOV		CNT,#0

RUN_GATE:	
	ACALL	GATE_CTRL
	

	;When reach STOP the controller is incorrectly designed
STOP:
	SJMP	STOP
	
	END

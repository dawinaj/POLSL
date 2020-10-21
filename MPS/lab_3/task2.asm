CLK		EQU 	P3.0	; Reference clock input
DYLG	EQU 	P3.1	; Day light sensor input

LIGHT	EQU 	P3.7

BT  	EQU 	P1	; 8 momentary push buttons
BT2 	EQU 	P2	; prev state

DSEG	AT	30
TMR:	DS	1	;Timer variable

CSEG	AT	0
	
RESET:
	MOV 	SP, #7FH
	MOV 	BT, #0
	
; Light off until is night and button pressed
LIGHT_CTRL:
	CLR		LIGHT
	JB		DYLG, $
	; Nighttime, check buttons
	MOV		A, BT
	JZ		LIGHT_CTRL
	; Button is pressed
	MOV		BT, #0	; Reset all buttons
	SETB	LIGHT
	
; 5 clock cycles that prevent change
	MOV		TMR, #5
LIGHT_STABLE:
	JNB 	CLK, $
	DJNZ	TMR, LIGHT_STABLE
	
; remaining 15 clock cycles that do not prevent change, if clicked before - will switch immediately, otherwise waits for button or timeout
	MOV 	TMR, #15
LIGHT_UNSTABLE:
	JNB 	CLK, $
	MOV 	A, BT
	JNZ 	COOLDOWN
	DJNZ	TMR, LIGHT_UNSTABLE
	MOV 	TMR, #4

	; 4 clock cycles - light forced to be off
COOLDOWN:
	JNB 	CLK, $
	MOV 	BT, #0
	DJNZ	TMR, COOLDOWN
	SJMP	LIGHT_CTRL

STOP:
	SJMP	STOP

END

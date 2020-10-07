
CSEG	AT	0

; Using R7.R6 as 16-bit number

MOV		R7, #1 ; * 256 +
MOV		R6, #1 ; + 1 (zero-th loop)

; Use DPTR to check if loop count was correct
MOV		DPTR, #0

LJMP INNER_LOOP


INNER_LOOP:
	INC DPTR
	MOV A, R6
	JZ OUTER_LOOP
	DEC R6
	LJMP INNER_LOOP

OUTER_LOOP:
	DEC R6
	MOV A, R7
	JZ PROG_END
	DEC R7
	LJMP INNER_LOOP



PROG_END:
	SJMP	PROG_END


END

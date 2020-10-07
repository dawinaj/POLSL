
CSEG	AT	0

; Using R7.R6 as 2*8=16-bit number

MOV		R7, #0 ; * 256 +
MOV		R6, #0 ; + 1 (zero-th loop)

; Use 16bit DPTR to check if loop count was correct
MOV		DPTR, #0

LJMP SETUP


SETUP:
	INC R7
	INC R6
	LJMP BIG_LOOP


BIG_LOOP:
	INC DPTR
	DJNZ R6, BIG_LOOP
	DJNZ R7, BIG_LOOP
	LJMP PROG_END

PROG_END:
	SJMP	PROG_END


END

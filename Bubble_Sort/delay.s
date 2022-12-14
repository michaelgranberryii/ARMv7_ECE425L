			GLOBAL	DELAY
FCLK		EQU		12000000
A			EQU		1
DELAYCNT	EQU		(FCLK/A)
			AREA 	MYCODE, CODE, READONLY
DELAY
			STMFD SP!, {R0-R6,LR}
			MRS	R0, CPSR
			STMFD SP!, {R0}
			
			LDR R0,=DELAYCNT
LOOP
			SUBS R0, #1
			BNE LOOP
			
			LDMFD SP!, {R0}
			MSR	CPSR_f, R0
			LDMFD SP!, {R0-R6, PC}
			END
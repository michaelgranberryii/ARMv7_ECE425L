		GLOBAL BUBBLESORT
		IMPORT DELAY
TABLE	EQU	0X40000800
NUM_EL	EQU	23 ;NUMBER OF ELEMENTS
				
		AREA BUBBLE, CODE, READONLY
BUBBLESORT
		STMFD SP!, {R0-R6, LR}
		MRS R0, CPSR
		STMFD SP!,{R0}
		
		LDR R0,=TABLE
		
O_LOOP	
		MOV R1, #(NUM_EL - 1)
		MOV R2, #0
		MOV R3, #0
		MOV R6, #4
		
I_LOOP	
		LDR R4, [R0, R3]
		LDR R5, [R0, R6]
		CMP R5, R4
		
		MOVLO R2, #1
		
		STRLO R5, [R0, R3]
		STRLO R4, [R0, R6]

;Added delay to watch sorting at addr 0x40000800 in the debugger while program is running.
;Delay is not a part of the original code from Flynn's bubble sort algo.
		BL DELAY
		
		ADD R3, R3, #4
		ADD R6, R6, #4
		
		SUBS R1, R1, #1
		BNE I_LOOP
		
		ANDS R2, R2, R2
		BNE O_LOOP
		
		LDMFD SP!, {R0}
		MSR	CPSR_f, r0
		LDMFD SP!, {R0-R6,PC}	
STOP	B	STOP
		END
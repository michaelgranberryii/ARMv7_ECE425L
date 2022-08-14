			GLOBAL Timer0Setup
			GLOBAL Timer0Handler
			GLOBAL Timer0Reset
			IMPORT ClearVICVectAddr
			IMPORT PinAHigh
			IMPORT PinALow
			IMPORT PinBHigh
			IMPORT PinBLow

TIMER0BASE	EQU	0xE0004000
T0IR		EQU	0X0
T0TCR		EQU 0x4
T0PR		EQU	0XC
T0MCR		EQU	0X14
T0MR0		EQU 0X18
T0MR1		EQU 0X1C
T0MR2		EQU 0X20
T0MR3		EQU 0X24
T0CTCR		EQU	0x70

MATCH0		EQU 50
MATCH1		EQU	100
MATCH2		EQU 150
MATCH3		EQU	200
MATCHCRL	EQU 0X649

N			EQU 749

			AREA timer, CODE, READONLY
			
Timer0Setup
			STMFD SP!, {R0-R1, LR}
			MRS R0, CPSR
			STMFD SP!, {R0}
			
			LDR R0, =TIMER0BASE
			
			;STOP AND RESET COUNTER, RESET PRESCALER (enable? and reset counter)
			MOV R1, #0X3
			STR R1, [R0, #T0TCR]
			
			;Timer Counter and Prescale Counter are enabled for counting.
			MOV R1, #0X0
			STR R1, [R0, #T0CTCR]
			
			;The 32-bit Prescale Register specifies the maximum value for the Prescale Counter.
			LDR R1, =N
			STR R1, [R0, #T0PR]
			
			;MATCH NUMBERS
			MOV R1, #MATCH0 ;MATCH0
			STR R1, [R0, #T0MR0]
			
			MOV R1, #MATCH1 ;MATCH1
			STR R1, [R0, #T0MR1]
			
			MOV R1, #MATCH2 ;MATCH2
			STR R1, [R0, #T0MR2]
			
			MOV R1, #MATCH3 ;MATCH3
			STR R1, [R0, #T0MR3]
			
			;MATCH CONTROL
			LDR R1, =MATCHCRL
			STR R1, [R0, #T0MCR]
			
			;SILENCE T0IR INTERRUPTS
			MOV R1, #0XFF
			STR R1, [R0, #T0IR]
			
			LDMFD SP!, {R0}
			MSR CPSR_f, R0
			LDMFD SP!, {R0-R1, PC}


Timer0Reset
			STMFD SP!, {R0-R1, LR}
			MRS R0, CPSR
			STMFD SP!, {R0}
			
			LDR R0, =TIMER0BASE
			
			;RESET COUNTER
			MOV R1, #0X1
			STR R1, [R0, #T0TCR]
			
			LDMFD SP!, {R0}
			MSR CPSR_f, R0
			LDMFD SP!, {R0-R1, PC}

Timer0Handler
			SUB LR, LR, #4
			STMFD SP!, {R0-R1,LR}
			
			LDR R0, =TIMER0BASE
			LDR R1, [R0, #T0IR]
			
			;POLLING MATCH 0-3
			TST R1, #0X1
			STRNE R1, [R0, #T0IR]
			BLNE PinAHigh

			TST R1, #0X2
			STRNE R1, [R0, #T0IR]
			BLNE PinBHigh

			TST R1, #0X4
			STRNE R1, [R0, #T0IR]
			BLNE PinALow
			
			TST R1, #0X8
			STRNE R1, [R0, #T0IR]
			BLNE PinBLow
			
			;Clear VICVectAddr
			BL ClearVICVectAddr
			
			LDMFD SP!, {R0-R1, PC}^
			
STOP 		B	STOP
			END
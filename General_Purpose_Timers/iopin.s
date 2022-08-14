				GLOBAL PinSelSetup
				GLOBAL PinAHigh
				GLOBAL PinALow
				GLOBAL PinBHigh
				GLOBAL PinBLow
				
PINSELBASE		EQU	0xE002C000
PINSEL0			EQU	0X0
PINSEL1			EQU	0X4

IO0PINBASE		EQU	0xE0028000
IO0PIN			EQU 0X0
IO0SET			EQU	0X4
IO0DIR			EQU	0X8	
IO0CLR			EQU	0XC

OUTPUT			EQU 0X00201000

PINA			EQU 0X00001000
PINB			EQU 0X00200000

				AREA iopin, CODE, READONLY
	
PinSelSetup
				STMFD SP!, {R0-R1, LR}
				MRS R0, CPSR
				STMFD SP!, {R0}
				
				LDR R0, =PINSELBASE
				
				;PINSEL0 [25:24]
				LDR R1, [R0, #PINSEL0]
				BIC R1, R1, #0X03000000
				STR R1, [R0, #PINSEL0]
				
				;PINSEL1 [11:10]
				LDR R1, [R0, #PINSEL1]
				BIC R1, R1, #0X00000C00
				STR R1, [R0, #PINSEL1]
				
				;IO0DIR P0.12 AND P0.21 = OUTPUT
				LDR R0, =IO0PINBASE
				;LDR R2, [R0, #IO0DIR]
				LDR R1, =OUTPUT
				;BIC R1, R2, R1
				STR R1, [R0, #IO0DIR]

				BL PinALow
				BL PinBLow
				
				LDMFD SP!, {R0}
				MSR CPSR_f, R0
				LDMFD SP!, {R0-R1, PC}
				
PinAHigh
				STMFD SP!, {R0-R1, LR}
				MRS R0, CPSR
				STMFD SP!, {R0}
				
				LDR R0, =IO0PINBASE
				LDR R1, =PINA
				STR R1, [R0, #IO0SET]
				
				LDMFD SP!, {R0}
				MSR CPSR_f, R0
				LDMFD SP!, {R0-R1, PC}
			
PinALow
				STMFD SP!, {R0-R1, LR}
				MRS R0, CPSR
				STMFD SP!, {R0}
				
				LDR R0, =IO0PINBASE
				LDR R1, =PINA
				STR R1, [R0, #IO0CLR]
		
				LDMFD SP!, {R0}
				MSR CPSR_f, R0
				LDMFD SP!, {R0-R1, PC}
			
PinBHigh
				STMFD SP!, {R0-R1, LR}
				MRS R0, CPSR
				STMFD SP!, {R0}
				
				LDR R0, =IO0PINBASE
				LDR R1, =PINB
				STR R1, [R0, #IO0SET]				
				
				LDMFD SP!, {R0}
				MSR CPSR_f, R0
				LDMFD SP!, {R0-R1, PC}
			
PinBLow
				STMFD SP!, {R0-R1, LR}
				MRS R0, CPSR
				STMFD SP!, {R0}
				
				LDR R0, =IO0PINBASE
				LDR R1, =PINB
				STR R1, [R0, #IO0CLR]				
				
				LDMFD SP!, {R0}
				MSR CPSR_f, R0
				LDMFD SP!, {R0-R1, PC}
				
STOP 			B STOP
				END
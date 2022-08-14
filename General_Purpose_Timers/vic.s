				GLOBAL VicSetup
				GLOBAL ClearVICVectAddr
				IMPORT Timer0Handler
				
					
VICBASE			EQU 0xFFFFF000
VICIntEnable	EQU	0X10
VICIntSelect	EQU 0XC
VICVectAddr  	EQU 0xFFFFF030
VICVectCntl0 	EQU 0xFFFFF200
VICVectAddr0  	EQU 0xFFFFF100
	
BIT4			EQU	0X10
	
				AREA vic, CODE, READONLY
VicSetup
				STMFD SP!, {R0-R2, LR}
				MRS R0, CPSR
				STMFD SP!, {R0}
				
				LDR R0, =VICBASE
				
				;TIMER0 IS BIT 4 IN VICs
				;Enable TIMER0 in VIC
				LDR R1, [R0, #VICIntEnable]
				ORR R1, R1, #BIT4
				STR R1, [R0, #VICIntEnable]
				
				;Set TIMER0 as IRQ
				LDR R1, [R0, #VICIntSelect]
				BIC R1, R1, #BIT4
				STR R1, [R0, #VICIntSelect]
				
				;Vector Control 0
				LDR R0, =VICVectCntl0
				MOV R1, #4 ;NUMBER 16 IN BINARY
				MOV R2, #0X20 ;BIT5 = '1'
				ORR R3, R2, R1 ;R3 = 0X30 = 1_00100
				STR R3, [R0]
				
				;Vector Address 0
				LDR R0, =VICVectAddr0
				LDR R1, =Timer0Handler
				STR R1, [R0]
				
				BL ClearVICVectAddr
				
				LDMFD SP!, {R0}
				MSR CPSR_f, R0
				LDMFD SP!, {R0-R2, PC}
				
ClearVICVectAddr
				STMFD SP!, {R0-R1, LR}
				MRS R0, CPSR
				STMFD SP!, {R0}
				
				;RESET Vector Address
				LDR R0, =VICVectAddr
				MOV R1, #0X0
				STR R1, [R0]
				
				LDMFD SP!, {R0}
				MSR CPSR_f, R0
				LDMFD SP!, {R0-R1, PC}
				
STOP 			B STOP
				END
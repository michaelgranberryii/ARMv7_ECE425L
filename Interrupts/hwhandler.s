				GLOBAL IRQHandler
				GLOBAL FIQHandler
				IMPORT LEDP1
				IMPORT LEDP0
				IMPORT LEDP2
				IMPORT LEDP3
				
VICRawIntr		EQU	0xFFFFF008
EXTINT			EQU	0xE01FC140
;External Interrupt Bits
B_EINT0			EQU	0X4000 		;Bit 14
B_EINT3			EQU 0x20000		;Bit 17	
				AREA hwhandler, CODE, READONLY
IRQHandler
				SUB LR, LR, #4
				STMFD SP!,{R0-R1,LR}
				
				LDR R0, =EXTINT
				MOV R1, #0X1
				STR R1, [R0]
				BL LEDP2
				
				LDMFD SP!, {R0-R1,PC}^
				
FIQHandler
				SUB LR, LR, #4
				STMFD SP!,{R0-R1,LR}
				
				LDR R0, =EXTINT
				MOV R1, #0X8
				STR R1, [R0]
				BL LEDP3
				
				LDMFD SP!, {R0-R1,PC}^

STOP 			B STOP
				END
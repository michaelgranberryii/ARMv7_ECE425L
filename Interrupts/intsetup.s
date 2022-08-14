				GLOBAL  INTSETUP

;PINSEL
PINSEL1			EQU 0xE002C004

;P0.16 = EINT0 and P0.20 = EINT3 in PINSEL1
P0_16			EQU 0x01
P0_20			EQU	0X300

;External interrupt registers
EXTINT			EQU	0xE01FC140
EXTMODE			EQU 0X8
EXTPOLAR		EQU	0XC

;Vic Addresses			
VicRawIntr		EQU	0xFFFFF008
VicIntSelect	EQU	0xFFFFF00C
VicIntEnable	EQU	0xFFFFF010
VicVectAddr		EQU	0xFFFFF030
VicVectAddr0	EQU	0xFFFFF100
VicVectAddr1	EQU	0xFFFFF104
VicVectCntl0	EQU	0xFFFFF200
VicVectCntl1	EQU	0xFFFFF204

;External Interrupt BitsZ
B_EINT0			EQU	0X4000 		;Bit 14
B_EINT3			EQU 0x20000		;Bit 17	

				AREA int_setup, CODE, READONLY
INTSETUP
				STMFD SP!,{R0-R2, LR}
				MRS R0, CPSR
				STMFD SP!,{R0}
				
;P0.16 = EINT0 and P0.20 = EINT3 in PINSEL1
				LDR R0, =PINSEL1
				MOV	R1, #P0_16
				MOV	R2, #P0_20
				ORR R3, R1, R2
				STR R3, [R0]
				
;Edge sensitive, Falling edge sensitive, and Clear interrupts
				LDR	R0, =EXTINT
				MOV R2, #0X9
				;EDGE SENSITIVE
				LDR R1, [R0, #EXTMODE]
				ORR	R1, R1, R2
				STR R1, [R0, #EXTMODE]
				;FALLING EDGE SENSITIVE
				LDR R1, [R0, #EXTPOLAR]
				BIC	R1, R1, R2
				STR	R1, [R0, #EXTPOLAR]
				;CLEAR INTERRUPTS
				STR R2, [R0] ;or write 0xf
				
;Set up vectored interrupts			

;Program EINT0 with the VIC, IRQ and second priority

;VicIntEnable
				LDR	R0, =VicIntEnable
				LDR	R1, [R0]
				ORR	R1, R1, #B_EINT0
				STR	R1, [R0]
				
;VicIntSelect (IRQ)
				LDR	R0, =VicIntSelect
				LDR	R1, [R0]
				BIC R1, R1, #B_EINT0
				STR	R1, [R0]
	
				
;Program EINT3 with the VIC, FIQ and first priority

;VicIntEnable
				LDR	R0, =VicIntEnable
				LDR	R1, [R0]
				ORR	R1, R1, #B_EINT3
				STR	R1, [R0]
				
;VicIntSelect (FIQ)
				LDR	R0, =VicIntSelect
				LDR	R1, [R0]
				ORR R1, R1, #B_EINT3
				STR	R1, [R0]
				
				
				LDMFD SP!, {R0}
				MSR CPSR_f, R0
				LDMFD SP!, {R0-R2,PC}
STOP			B STOP
				END

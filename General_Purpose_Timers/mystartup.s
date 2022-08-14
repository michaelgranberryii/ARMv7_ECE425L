;ECE 425L - Group 1
;Name: Michael Granberry, Clayton Lawton
;Email: michael.granberry.612@my.csun.edu, clayton.lawton.209@my.csun.edu
;Last Modification Date: April 25, 2022
;Version: 1.0
				IMPORT Timer0Setup
				IMPORT Timer0Reset
				IMPORT VicSetup
				IMPORT PinSelSetup
				IMPORT UserCode
				
;MEMORY ACCELORATOR REGISTERS 
MAMCR 			EQU 0xE01FC000 
MAMTIM 			EQU 0xE01FC004
	
;MODES
Mode_USR 		EQU 0x10
Mode_FIQ		EQU	0X11
Mode_IRQ		EQU	0X12
Mode_SUPER		EQU	0X13

;Standard definitions of Mode bits and Interprrupt (I&F) flags in PSR s
;INT
I_Bit 			EQU 0x80 	;when I bit is set, IRQ is disabled
F_Bit 			EQU 0x40 	;when F bit is set, FIQ is disable

;Defintions of User Mode Stack and Size
Stack_Size 		EQU 0x00000200
SRAM 			EQU 0X40000000
USERSTACK 		EQU SRAM+Stack_Size
IRQSTACK		EQU	USERSTACK+Stack_Size
FIQSTACK		EQU	IRQSTACK+Stack_Size
SUPERSTACK		EQU	FIQSTACK+Stack_Size
				
				AREA 	RESET, CODE, Readonly
				ENTRY 	;The first instruction to execute follows
				ARM

VECTORS
				LDR 	PC,Reset_Addr
				LDR 	PC,Undef_Addr
				LDR 	PC,SWI_Addr
				LDR 	PC,PAbt_Addr
				LDR 	PC,DAbt_Addr
				NOP
				LDR 	PC, [PC, #-0XFF0] ;points to VicVecAddr
				LDR 	PC,FIQ_Addr
Reset_Addr 		DCD 	Reset_Handler
Undef_Addr 		DCD 	UndefHandler
SWI_Addr 		DCD		SWIHandler
PAbt_Addr 		DCD 	PAbtHandler
DAbt_Addr 		DCD 	DAbtHandler
				DCD 	0
;IRQ_Addr 		DCD 	IRQHandler
FIQ_Addr 		DCD 	FIQHandler
	 
SWIHandler		B 		SWIHandler
PAbtHandler 	B 		PAbtHandler
DAbtHandler 	B 		DAbtHandler
;IRQHandler		B 		IRQHandler
FIQHandler		B 		FIQHandler
UndefHandler 	B 		UndefHandler

Reset_Handler
				;Initialize MAM
				LDR R1,=MAMCR
				MOV R0,#0x0
				STR R0,[R1] ; Turn off MAM
				LDR R2,=MAMTIM
				MOV R0,#0x1
				STR R0,[R2] ; Set MAM fetch to one clock cycle MOV R0,#0x2
				STR R0,[R1] ; Fully enable MAM
				
				;SUPERVISOR MODE
				MOV R14, #Mode_SUPER
				ORR R14, R14, #(I_Bit+F_Bit)
				MSR	CPSR_c, R14
				LDR SP, =SUPERSTACK
				
				;SETUP
				BL Timer0Setup
				BL VicSetup
				BL PinSelSetup
				
				;FIQ MODE
				MOV R14, #Mode_FIQ
				ORR R14, R14, #(I_Bit+F_Bit)
				MSR	CPSR_c, R14
				LDR SP, =FIQSTACK
				
				;IRQ MODE
				MOV R14, #Mode_IRQ
				ORR R14, R14, #(I_Bit+F_Bit)				
				MSR	CPSR_c, R14
				LDR SP, =IRQSTACK
				
				;USER MODE
				MOV r14, #Mode_USR		;Enter User Mode with interrupts enabled
				BIC r14,r14,#(I_Bit+F_Bit)
				MSR cpsr_c, r14
				LDR SP, =USERSTACK		;Initialize the stack, full descending
				
				;START PROGRAM
				BL Timer0Reset
				LDR pc, =UserCode		;load start address of user code into PC
				END

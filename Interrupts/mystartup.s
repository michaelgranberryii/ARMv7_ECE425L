;ECE 425L - Group 1
;Name: Michael Granberry, Clayton Lawton
;Email: michael.granberry.612@my.csun.edu, clayton.lawton.209@my.csun.edu
;Last Modification Date: April 25, 2022
;Version: 1.0

;Standard definitions of Mode bits and Interprrupt (I&F) flags in PSR s
				IMPORT LAB10
				IMPORT INTSETUP
				IMPORT SWIHandler
				IMPORT IRQHandler
				IMPORT FIQHandler
				IMPORT LEDSETUP
					
Mode_USR 		EQU 0x10
Mode_FIQ		EQU	0X11
Mode_IRQ		EQU	0X12
Mode_SUPER		EQU	0X13

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
				LDR 	PC,IRQ_Addr ; ldr pc, [pc, #-0x0ff0]
				LDR 	PC,FIQ_Addr
Reset_Addr 		DCD 	Reset_Handler
Undef_Addr 		DCD 	UndefHandler
SWI_Addr 		DCD		SWIHandler
PAbt_Addr 		DCD 	PAbtHandler
DAbt_Addr 		DCD 	DAbtHandler
				DCD 	0
IRQ_Addr 		DCD 	IRQHandler
FIQ_Addr 		DCD 	FIQHandler
	 
				B 		SWIHandler
PAbtHandler 	B 		PAbtHandler
DAbtHandler 	B 		DAbtHandler
				B 		IRQHandler
				B 		FIQHandler
UndefHandler 	B 		UndefHandler

Reset_Handler
		
		
				;SETUP INTERRUPTS
				BL LEDSETUP
				BL INTSETUP
				
				;SUPERVISOR MODE
				MOV R14, #Mode_SUPER
				LDR SP, =SUPERSTACK
				ORR R14, R14, #(I_Bit+F_Bit)
				MSR	CPSR_c, R14
				
				;FIQ MODE
				MOV R14, #Mode_FIQ
				LDR SP, =FIQSTACK
				ORR R14, R14, #(I_Bit+F_Bit)
				MSR	CPSR_c, R14
				
				;IRQ MODE
				MOV R14, #Mode_IRQ
				LDR SP, =IRQSTACK
				ORR R14, R14, #(I_Bit+F_Bit)				
				MSR	CPSR_c, R14
				
				;USER MODE
				MOV r14, #Mode_USR		;Enter User Mode with interrupts enabled
				LDR SP, =USERSTACK		;Initialize the stack, full descending
				BIC r14,r14,#(I_Bit+F_Bit)
				MSR cpsr_c, r14
				
				;START PROGRAM
				LDR pc, =LAB10		;load start address of user code into PC
				END

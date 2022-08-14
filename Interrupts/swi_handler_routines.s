;ECE 425L - Group 1
;Name: Michael Granberry, Clayton Lawton
;Email: michael.granberry.612@my.csun.edu, clayton.lawton.209@my.csun.edu
;Last Modification Date: April 25, 2022
;Version: 1.0
			GLOBAL SWI_1
			GLOBAL SWI_2
			GLOBAL SWI_3
			IMPORT LEDON
			IMPORT LEDP0
			IMPORT LEDP1
				
			AREA swi_handler, CODE, READONLY
SWI_1
	STMFD SP!,{LR}
	MRS R0, CPSR
	STMFD SP!,{R0}
	
	BL LEDON
	
	LDMFD SP!, {R0}
	MSR CPSR_f, R0
	LDMFD SP!, {PC}
	
SWI_2
	STMFD SP!,{LR}
	MRS R0, CPSR
	STMFD SP!,{R0}
	
	BL LEDP0
	
	LDMFD SP!, {R0}
	MSR CPSR_f, R0
	LDMFD SP!, {PC}
	
SWI_3
	STMFD SP!,{LR}
	MRS R0, CPSR
	STMFD SP!,{R0}
	
	BL LEDP1
	
	LDMFD SP!, {R0}
	MSR CPSR_f, R0
	LDMFD SP!, {PC}
STOP 		B	STOP
			END
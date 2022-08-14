;ECE 425L - Group 1
;Name: Michael Granberry, Clayton Lawton
;Email: michael.granberry.612@my.csun.edu, clayton.lawton.209@my.csun.edu
;Last Modification Date: April 25, 2022
;Version: 1.0
			GLOBAL SWIHandler
			AREA swi_handler, CODE, READONLY
			IMPORT	SWI_1
			IMPORT	SWI_2
			IMPORT	SWI_3
			IMPORT LEDON
			IMPORT LEDP0
			IMPORT	LEDP1
SWIHandler

			STMFD SP!, {R0-R1,LR}
			
			SUB	R0, LR, #4
			LDR R1, [R0]
			BIC R1, #0XFF000000
			
			CMP R1, #0X1
			BLEQ LEDON
			
			CMP R1, #0X2
			BLEQ LEDP0
			
			CMP R1, #0X3
			BLEQ LEDP1
			
			LDMFD SP!, {R0-R1,PC}^
			
STOP 		B	STOP
			END
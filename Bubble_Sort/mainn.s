				GLOBAL	MAINN
				IMPORT 	BUBBLESORT 
				AREA 	MYCODE, CODE, READONLY		
MAINN 						;THIS LABEL IS NECESSARY

;Moving UNSORTED_DATA to location 0x40000800
				ldr r0, =23
				ldr r1, =UNSORTED_DATA1
				ldr r2, =0x40000800
				
loop
				ldr r3, [r1], #4
				str r3, [r2], #4
				subs r0, #1
				bne loop 	
;-----------------------------------

;BUBBLESORT
				BL BUBBLESORT
;-----------------------------------
STOP 			B	STOP
UNSORTED_DATA1	DCD	 	0x22,0x21,0x20,0x19,0x18,0x17,0x16,0x15,0x14,0x13,0x12,0x11,0x10,0x09,0x08,0x07,0x06,0x05,0x04,0x03,0x02,0x01,0x00		;UNSORTED
;UNSORTED_DATA2	DCD	 	0x60,0x21,0x33,0x30,0x13,0x10,0x97,0x45,0x63,0x34,0x27,0x29,0x16,0x71,0x25,0x62,0x04,0x17,0x64,0x56,0x06,0x08,0x57		;UNSORTED
				END 							;ASSEMBLER DIRECTIVE TO INDICATE THE END OF CODE.
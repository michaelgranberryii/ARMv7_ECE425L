;ECE 425L - Group 1
;Name: Michael Granberry, Clayton Lawton
;Email: michael.granberry.612@my.csun.edu, clayton.lawton.209@my.csun.edu
;Last Modification Date: April 25, 2022
;Version: 1.0

			GLOBAL DELAYBX
			AREA d, CODE, READONLY
DELAYBX
			
LOOP
			SUBS R12, R12, #1
			BNE LOOP
			
			BX LR ;bx lr
STOP		B	STOP
			END
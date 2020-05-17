#include "p16f84.inc"  			

MOVLW 0x03
	MOVWF 0x30
MOVLW 0x02
	MOVWF 0x31
MOVLW 0x08
	MOVWF 0x32
MOVLW 0x07
	MOVWF 0x33
MOVLW 0x04
	MOVWF 0x34
MOVLW 0x05
	MOVWF 0x35
MOVLW 0x01
	MOVWF 0x36
MOVLW 0x06
	MOVWF 0x37
MOVLW 0x08
	MOVWF 0x38
MOVLW 0x02
	MOVWF 0x39

MOVLW 0x06
	MOVWF 0x3A
MOVLW 0x11
	MOVWF 0x3B
MOVLW 0x30
	MOVWF 0x3C
MOVLW 0x17
	MOVWF 0x3D
MOVLW 0x35
	MOVWF 0x3E
MOVLW 0x09
	MOVWF 0x3F
MOVLW 0x13
	MOVWF 0x40
MOVLW 0x15
	MOVWF 0x41
MOVLW 0xB6
	MOVWF 0x42
MOVLW 0x19
	MOVWF 0x43

startingAddress set 0x30  	; the starting address of the array CONST

i equ 0x2F  		
j equ 0x2E 
size equ 0x2D

temp1 equ 0x2C
addrTemp1 equ 0x2B

temp2 equ 0x2A
addrTemp2 equ 0x29

BEGIN:
	BCF STATUS, 0x5 		; set Bank0 in Data Memory by clearing RP0 bit in STATUS register
	CLRF i
	
	MOVLW 0x14	
	MOVWF size	
	
LoopI:
	CLRF j
	CLRF temp1
	CLRF temp2
	CLRF addrTemp1
	CLRF addrTemp2
	
	DECF size,0
	MOVWF j 					; j = size - 1

	LoopJ:
		MOVLW 0x1
		SUBWF j,0
		ADDLW startingAddress
		MOVWF addrTemp1			; addrTemp1 = address of a[j-1]
		MOVWF FSR
		MOVF INDF,0 
		MOVWF temp1 			; temp1 = a[j-1]
				
		MOVF j,0
		ADDLW startingAddress
		MOVWF addrTemp2			; addrTemp2 = address of a[j]
		MOVWF FSR
		MOVF INDF,0				; W = a[j]
		MOVWF temp2				; temp2 = a[j]
		
		SUBWF temp1,0   		; a[j-1] - a[j]

		BTFSC STATUS,0x2		; if a[j] = a[j-1] -> False
	GOTO False  		
		BTFSC STATUS,0  		; if a[j] > a[j-1] -> False
	GOTO False
								; Swap a[j-1] and a[j]
		MOVF addrTemp1,0
		MOVWF FSR
		MOVF temp2,0
		MOVWF INDF
		
		MOVF addrTemp2,0
		MOVWF FSR
		MOVF temp1,0
		MOVWF INDF

		False:
	
		DECF j,0x1  			; j--
		MOVF i,0     			
		SUBWF j,0   			; j - i

		BTFSC STATUS,0x2		; if i = j -> ExitLoopJ
	GOTO ExitLoopJ  		
		BTFSS STATUS,0  		; if i > j -> ExitLoopJ
	GOTO ExitLoopJ

	GOTO LoopJ	

ExitLoopJ:

	INCF i,0x1  			; i++
	MOVF size,0     		
	SUBWF i,0   			; i - size
	BTFSS STATUS,0  		; i > size -> Exit
GOTO LoopI
	
	CLRF size
 	CLRF i
	CLRF j
	CLRF temp1
	CLRF temp2
	CLRF addrTemp1
	CLRF addrTemp2
END	

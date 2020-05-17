#include "p16f84.inc" 

starting_address set 0x30  	; the starting address of the array CONST
array_length set 0x14   	; 20 CONST

index equ 0x2F  			; the pointer to the current element in array, a variable
min equ 0x2E  				; the minimal number in array, a variable

							; Array initialization
MOVLW 0x34
	MOVWF 0x30
MOVLW 0x23
	MOVWF 0x31
MOVLW 0x43
	MOVWF 0x32
MOVLW 0x67
	MOVWF 0x33
MOVLW 0xEE
	MOVWF 0x34
MOVLW 0x34
	MOVWF 0x35
MOVLW 0x05
	MOVWF 0x36
MOVLW 0x21
	MOVWF 0x37
MOVLW 0x6A
	MOVWF 0x38
MOVLW 0x4E
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

GOTO BEGIN

PALCEMIN:
	MOVF index,0
	ADDLW starting_address
	MOVWF FSR
	MOVF INDF,0
	MOVWF min 	
RETURN;	

BEGIN:
	BCF STATUS, 0x5 		; set Bank0 in Data Memory by clearing RP0 bit in STATUS register
	CLRF index	
	CALL PALCEMIN

LOOP:
	MOVF index,0    		; Save index in W (Working reg)
	ADDLW starting_address  ; W (index of array element) = W (index) + starting_address
	MOVWF FSR       		; FSR = W, INDF = array[W]
	MOVF INDF,0     		; W = INDF (array[W])
	SUBWF min,0   			; W = max - W (Reg STATUS has 8 bits, 0 bit - C, SUBWF changes it to 0 only if result is negative) 
	
	BTFSC STATUS,0  		; (BTFSC Checks STATUS bit 0 (C), if its value equals 0 then skips next command)
		CALL PALCEMIN

	INCF index,0x1  		; index = index + 1
	MOVLW array_length     	; W = array_length
	SUBWF index,0   		; W = index - W
	BTFSS STATUS,0  		; if STATUS bit 0 == 1 then skip next command
GOTO LOOP      	
	  
	CLRF index
	CLRF min
END	

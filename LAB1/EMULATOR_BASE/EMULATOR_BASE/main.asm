.ORG 0x0000
	RJMP ONRESET
.ORG 0x0002
	RJMP ISR_INT0   ;INT0 EXTERNAL INTERRUPT HANDLER
.ORG 0x0009
	RJMP ISR_TIMER0 ;TIMER0 OVERFLOW INTERRUPT HANDLER

.include "macros.asm"

ONRESET:
	macro_setup;
	macro_timer0;
	macro_int0;
	SEI

	LDI R20 , 40	   
	MOV R14 , R20	   


MAIN:		
	SBIS PINB , PORTB2 
	RJMP LOOP1		   
	SBIS PIND , PORTD2 
	RJMP LOOP2		   
	RJMP MAIN

LOOP1:
	SBIS PIND, PORTD2 
	RJMP LOOP3		  
	DEC R14
	RJMP MAIN
	
LOOP2:
	SBIS PINB, PORTB2 
	RJMP LOOP3        
    INC R14
	RJMP MAIN
    
LOOP3:
	MOV R14 , R20	  
	RJMP MAIN

//**********************

.include "display_functions.asm"

ISR_INT0:
	CLI				;DISABLE GLOBAL INTERRUPT ENABLE
	IN R26 , SREG	;SAVE STATUS REGISTER
	;*******************
	;WRITE CODE WHAT YOU WANT TO DO WHEN INT0 INTERRUPT COMES
	;**R14=0x00 R15=0x00 COUNT NUMBER START VALUES****
	;*******************
	
	;LDI	R16 , R14	
	;MOV	R14 , R16	;COUNT NUMBER LOW BYTE

	MOV	R16 , R14
	MOV	R14 , R16	;COUNT NUMBER LOW BYTE
	LDI	R16 , 0x00
	MOV	R15 , R16	;COUNT NUMBER HIGH BYTE
	;*******************
	OUT	 SREG , R26		;RELOAD STATUS REGISTER
    RETI					;RETURN FROM INT0 INTERRUPT HANDLER

ISR_TIMER0:
	macro_display R14 , R15	;DISPLAY HEX NUM.R14=LOW BYTE R15=HIGH BYTE 
    RETI					;RETURN FROM TIMER0 INTERRUPT HANDLER
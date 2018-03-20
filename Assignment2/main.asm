;
; Assignment2.asm
;
; Created: 3/20/2018 10:49:13
; Author : Patrik
;

SETUP:

	ldi		r16, 0xff				;inserting 1111_1111 value into r16       
	ldi		r17, 0x00				;inserting 1111_1111 value into r17
	out		ddra, r16				; configure pins from portA  
	out		ddrb, r17				;configrue pins from portB

	ldi		r18, 0b11111110
	ldi		r21, 0b11111011
	ldi		r20, 0x00

	/*
	IN r18, pinb
	OUT porta, r18*/

start:
	out		porta, r18;


	in		r19, pinb

	cp		r18, r19
	brne	start
	out		porta, r20
	rjmp	start				;jump to start of the loop
;
; Assignment2.asm
;
; Created: 3/20/2018 10:49:13
; Author : Patrik
;


ldi r16, 0xff           
ldi r17, 0x00
out ddra, r16           
out ddrb, r17
/*
IN r18, pinb
OUT porta, r18*/

ldi r18, 0b11111110
ldi r21, 0b11111011
ldi r20, 0x00

start:
	out porta, r18;


	in r19, pinb

	cp r18, r19
	brne start
	out porta, r20
	rjmp start
;
; Assignment2.asm
;
; Created: 3/20/2018 10:49:13
; Author : Patrik
;

/*
SETUP:

	ldi		r16, 0xff				;inserting 1111_1111 value into r16       
	ldi		r17, 0x00				;inserting 1111_1111 value into r17
	out		ddra, r16				; configure pins from portA  
	out		ddrb, r17				;configrue pins from portB

	ldi		r18, 0b11111110
	ldi		r21, 0b11111011
	ldi		r20, 0x00

;stack setup
	ldi		r16, high(RAMEND)
	out		sph, r16
	ldi		r16, low(RAMEND)
	out		spl, r16
	
	

start:
	out		porta, r18;
	

	in		r19, pinb

	cp		r18, r19
	brne	start
	out		porta, r20
	rjmp	start				;jump to start of the loop

clearDisplay:			;clear display after a level/userInput/start or end game
	push	r17
	ldi		r17, 0b11111111
	out		porta, r17
	pop		r17
	ret


delay:		;delay function (for int i=0; i > 0; i--)
	nop
	push	r26
	push	r27
	ldi		r27,255
loop1:
	ldi		r26,255
	dec		r27
	brne	end
loop2:
	dec		r26
	brne	loop1
end:
	pop		r27
	pop		r26
	ret


levelWon:
	ldi		r16, 0b00000000		;all lights on
	out		porta, r16			;show on the board that all lights are on

levelLost:
	ldi		r17, 0b01010101
	out		porta, r17

	*/

;
; TestovaAplikacia.asm
;
; Created: 3/28/2018 22:18:32
; Author : Patrik
;


	ldi		r16, 0xff				;inserting 1111_1111 value into r16       
	ldi		r17, 0x00				;inserting 1111_1111 value into r17
	out		ddra, r16				;configure pins from portA	== output
	out		ddrb, r17				;configrue pins from portB	== input

	ldi		r18, 0b11111110
	ldi		r19, 0b11111011

	start:
	out porta, r18
	call delay
	out porta, r19
	call delay


	rjmp start
	
delay:		;delay function (for int i=0; i > 0; i--)
	nop
	push	r26
	push	r27
	push	r28
	ldi		r26, 255
loop1:
	ldi		r27, 255
loop2:
	ldi		r28, 255
loop3:
	dec		r28
	brne	loop3
	dec		r27
	brne	loop2
	dec		r26
	brne	loop1
end:
	pop		r28
	pop		r27
	pop		r26
	ret

level1:
	
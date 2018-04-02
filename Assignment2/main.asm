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
	ldi		r17, 0x00				;inserting 0000_0000 value into r17
	out		ddra, r16				;configure pins from portA	== output
	out		ddrb, r17				;configrue pins from portB	== input

	ldi		r18, 0b11111110			;first bit in sequence
	ldi		r30, 0b11111110			;second bit in sequence
	ldi		r25, 0b11111110			;third bit in sequence

	ldi		r20, 0b11111111			;first answer
	ldi		r21, 0b11111100			;second answer
	ldi		r24, 0b11111100			;delay checker, if input was provided a delay is required so the same input is not stored in multiple registers
	ldi		r29, 0b01111110			;input stored

	start:
	call level1
	call level2
	;out porta, r16			;turns off all LEDs
	;call delay
	;call check				;check the results

	program_end:			;end of the program
	rjmp program_end
	
delay:						;delay in which user can provide an input
	nop
	push	r26
	push	r27
	push	r28
	ldi		r26, 140			;number of iterations in the main loop
loop1:
	ldi		r27, 255		;number of iterations in the first nested loop
loop2:
	ldi		r28, 255		;number of iterations in the second nested loop
loop3:
	cp r20, r16				;check if user provided any input for first answer
	brne second_position				;if input for first answer was provided, jump to second answer
	in r20, pinb			;input for the first answer is stored
	rjmp continue
second:
	out porta, r29
	call delay2
	out porta, r16

	;call delay2
	ldi r21, 0b11111111
	rjmp continue
second_position:
	;cp r21, r16				;check if user provided any input for second answer
	;brne end				;if input for first answer was provided, jump to the end
	in r21, pinb			;input for the second answer is stored

continue:
	dec		r28
	brne	position
	dec		r27
	brne	loop2
	dec		r26
	brne	loop1
end:
	pop		r28
	pop		r27
	pop		r26
	ret

position:
	cp r20, r16
	breq loop3
	cp r21, r24
	breq second
	cp r21, r16
	breq second_position
	rjmp end

level1:
	ldi		r18, 0b11101111
	out porta, r18
	call delay2

	out porta, r16 ;turns off all LEDs

	call delay
	ldi r21, 0b11111000
	ldi r21, 0b11111110
	call check				;check the results

	ret

level2:
	ldi		r20, 0b11111111 ;reset first input
	ldi		r21, 0b11111100

	ldi		r18, 0b11101111
	out porta, r18
	call delay2

	ldi		r30, 0b10111111
	out porta, r30
	call delay2

	out porta, r16 ;turns off all LEDs

	call delay
	call check				;check the results

	ret

check:
	cp r18, r20				;check for first answer
	brne false				;if answer is not correct, jump to "false" is made
	cp r30, r21				;check for second answer
	brne false				;if answer is not correct, jump to "false" is made
true:
	out porta, r17			;result if round is won / all led are on
	call delay2
	out porta, r16
	ret
false:
	ldi		r31, 0b10101010	;sequence for lost game
	out porta, r31			;result if game is lost
	call delay2
	out porta, r16
	rjmp program_end

delay2:						;delay in which user can not provide an input
	nop
	push	r19
	push	r22
	push	r23
	ldi		r19, 100			;number of iterations in the main loop
loop1x:
	ldi		r22, 255		;number of iterations in the first nested loop
loop2x:
	ldi		r23, 255		;number of iterations in the second nested loop
loop3x:
	dec		r23
	brne	loop3x
	dec		r22
	brne	loop2x
	dec		r19
	brne	loop1x
endx:
	pop		r23
	pop		r22
	pop		r19
	ret
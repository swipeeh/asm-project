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
	;ldi		r17, 0x00				;inserting 0000_0000 value into r17
	out		ddra, r16				;configure pins from portA	== output
	ldi		r16, 0x00
	out		ddrb, r16				;configrue pins from portB	== input
	ldi		r16, 0xff

	ldi		r18, 0b11111110			;first bit in sequence
	;ldi		r30, 0b11111110			;second bit in sequence
	;ldi		r25, 0b11111110			;third bit in sequence

	ldi		r20, 0b11111111			;first answer
	ldi		r21, 0b11111100			;second answer
	ldi		r25, 0b11111100			;third answer
	ldi		r17, 0b11111100			;fourth answer
	ldi		r24, 0b11111100			;5th answer
	ldi		r30, 0b11111100			;6th answer

	;ldi		r24, 0b11111100			;delay checker, if input was provided a delay is required so the same input is not stored in multiple registers
	ldi		r29, 0b01111110			;input stored

	start:
	call level1
	call level2
	call level3
	call level4
	call level5
	call win

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
	ldi		r16, 0xff		;setting value back
	out porta, r29
	call delay2
	out porta, r16

	;call delay2
	ldi r21, 0b11111111
	rjmp continue
second_position:
	cp r21, r16				;check if user provided any input for second answer
	brne third_position				;if input for first answer was provided, jump to the end
	in r21, pinb			;input for the second answer is stored
	rjmp continue
third:
	ldi		r16, 0xff		;setting value back
	out porta, r29
	call delay2
	out porta, r16

	ldi r25, 0b11111111
	rjmp continue
third_position:
	cp r25, r16				;check if user provided any input for second answer
	brne fourth_position				;if input for first answer was provided, jump to the end
	in r25, pinb			;input for the second answer is stored
	rjmp continue
fourth:
	ldi		r16, 0xff		;setting value back
	out porta, r29
	call delay2
	out porta, r16

	ldi r17, 0b11111111
	rjmp continue
fourth_position:
	cp r17, r16				;check if user provided any input for second answer
	brne fifth_position				;if input for first answer was provided, jump to the end
	in r17, pinb			;input for the second answer is stored
	rjmp continue

fifth:
	ldi		r16, 0xff		;setting value back
	out porta, r29
	call delay2
	out porta, r16

	ldi r24, 0b11111111
	rjmp continue
fifth_position:
	;cp r24, r16				;check if user provided any input for second answer
	;brne sixth_position				;if input for first answer was provided, jump to the end
	in r24, pinb			;input for the second answer is stored
	;rjmp continue

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
	ldi		r16, 0b11111100		;delay checker, if input was provided a delay is required so the same input is not stored in multiple registers
	cp r21, r16
	breq second
	ldi		r16, 0xff			;setting value back
	cp r21, r16
	breq second_position

	ldi		r16, 0b11111100		;delay checker, if input was provided a delay is required so the same input is not stored in multiple registers
	cp r25, r16
	breq third
	ldi		r16, 0xff			;setting value back
	cp r25, r16
	breq third_position

	ldi		r16, 0b11111100		;delay checker, if input was provided a delay is required so the same input is not stored in multiple registers
	cp r17, r16
	breq fourth
	ldi		r16, 0xff			;setting value back
	cp r17, r16
	breq fourth_position

	ldi		r16, 0b11111100		;delay checker, if input was provided a delay is required so the same input is not stored in multiple registers
	cp r24, r16
	breq fifth
	ldi		r16, 0xff			;setting value back
	cp r24, r16
	breq fifth_position
	rjmp end

level1:
	ldi		r18, 0b11101111
	out porta, r18
	call delay2

	out porta, r16 ;turns off all LEDs
	ldi		r21, 0b10111111
	ldi		r25, 0b11111101
	ldi		r17, 0b11111110
	ldi		r24, 0b01111111
	ldi		r30, 0b11111011
	call delay
	;ldi r21, 0b11111000
	call check				;check the results

	ret

level2:
	ldi		r20, 0b11111111 ;reset first input
	ldi		r21, 0b11111100	;reset second input

	ldi		r18, 0b11101111
	out porta, r18
	call delay2

	ldi		r18, 0b10111111
	out porta, r18
	call delay2

	out porta, r16 ;turns off all LEDs

	;ldi		r25, 0b11111101
	;ldi		r17, 0b11111110
	;ldi		r24, 0b01111111
	;ldi		r30, 0b11111011
	call delay
	call check				;check the results

	ret

level3:
	ldi		r20, 0b11111111 ;reset first input
	ldi		r21, 0b11111100	;reset second input
	ldi		r25, 0b11111100 ;reset third input

	ldi		r18, 0b11101111
	out porta, r18
	call delay2

	ldi		r18, 0b10111111
	out porta, r18
	call delay2

	ldi		r18, 0b11111101
	out porta, r18
	call delay2

	out porta, r16 ;turns off all LEDs

	;ldi		r17, 0b11111110
	;ldi		r24, 0b01111111
	;ldi		r30, 0b11111011
	call delay
	call check				;check the results

	ret

level4:
	ldi		r20, 0b11111111 ;reset first input
	ldi		r21, 0b11111100	;reset second input
	ldi		r25, 0b11111100 ;reset third input
	ldi		r17, 0b11111100 ;reset 4th input

	ldi		r18, 0b11101111
	out porta, r18
	call delay2

	ldi		r18, 0b10111111
	out porta, r18
	call delay2

	ldi		r18, 0b11111101
	out porta, r18
	call delay2

	ldi		r18, 0b11111110
	out porta, r18
	call delay2

	out porta, r16 ;turns off all LEDs

	call delay
	call check				;check the results

	ret

level5:
	ldi		r20, 0b11111111 ;reset first input
	ldi		r21, 0b11111100	;reset second input
	ldi		r25, 0b11111100 ;reset third input
	ldi		r17, 0b11111100 ;reset fourth input
	ldi		r24, 0b11111100 ;reset fifth input

	ldi		r18, 0b11101111
	out porta, r18
	call delay2

	ldi		r18, 0b10111111
	out porta, r18
	call delay2

	ldi		r18, 0b11111101
	out porta, r18
	call delay2

	ldi		r18, 0b11111110
	out porta, r18
	call delay2

	ldi		r18, 0b01111111
	out porta, r18
	call delay2

	out porta, r16 ;turns off all LEDs

	call delay
	call check				;check the results

	ret

check:
	ldi		r18, 0b11101111
	cp r18, r20				;check for first answer
	brne false				;if answer is not correct, jump to "false" is made
	ldi		r18, 0b10111111
	cp r18, r21				;check for second answer
	brne false				;if answer is not correct, jump to "false" is made
	ldi		r18, 0b11111101
	cp r18, r25				;check for third answer
	brne false				;if answer is not correct, jump to "false" is made
	ldi		r18, 0b11111110
	cp r18, r17				;check for fourth answer
	brne false				;if answer is not correct, jump to "false" is made
	ldi		r18, 0b01111111
	cp r18, r24			;check for fifth answer
	brne false				;if answer is not correct, jump to "false" is made
true:
	ldi		r16, 0x00
	out porta, r16			;result if round is won / all led are on
	call delay2
	ldi		r16, 0xff
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
	ldi		r19, 60			;number of iterations in the main loop
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

win:
	out porta, r29
	call delay2
	ldi		r16, 0b10111101
	out porta, r16
	call delay2
	ldi		r16, 0b11011011
	out porta, r16
	call delay2
	ldi		r16, 0b11100111
	out porta, r16
	call delay2

	ldi r30, 4
flickering:
	ldi		r16, 0b10101010
	out porta, r16
	call win_delay
	ldi		r16, 0b01010101
	out porta, r16
	call win_delay
	dec r30
	brne flickering

	ldi		r16, 0xff
	out porta, r16
	ret

win_delay:						;delay in which user can not provide an input
	nop
	push	r19
	push	r22
	push	r23
	ldi		r19, 10			;number of iterations in the main loop
loop1a:
	ldi		r22, 255		;number of iterations in the first nested loop
loop2a:
	ldi		r23, 255		;number of iterations in the second nested loop
loop3a:
	dec		r23
	brne	loop3a
	dec		r22
	brne	loop2a
	dec		r19
	brne	loop1a
enda:
	pop		r23
	pop		r22
	pop		r19
	ret
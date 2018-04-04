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
	
	*/

	ldi		r16, 0xff				;inserting 1111_1111 value into r16       
	out		ddra, r16				;configure pins from portA	== output
	ldi		r16, 0x00
	out		ddrb, r16				;configrue pins from portB	== input
	ldi		r16, 0xff

	ldi		r18, 0b11111110			;first byte in sequence

	ldi		r20, 0b11111111			;first answer
	ldi		r21, 0b11111100			;second answer, initial value is 11111100 to run delay after input
	ldi		r25, 0b11111100			;third answer
	ldi		r17, 0b11111100			;fourth answer
	ldi		r24, 0b11111100			;5th answer
	ldi		r30, 0b11111100			;6th answer

	ldi		r29, 0b01111110			;input stored => this sequence will be displayed after the input was stored in register

	start:							;start of the main program
	call level1
	call level2
	call level3
	call level4
	call level5
	call win

	program_end:					;end of the main program
	rjmp program_end
	
delay:								;delay in which user can provide an input
	nop
	push	r26
	push	r27
	push	r28
	ldi		r26, 140				;number of iterations in the main loop
loop1:
	ldi		r27, 255				;number of iterations in the first nested loop
loop2:
	ldi		r28, 255				;number of iterations in the second nested loop
loop3:
	cp r20, r16						;check if user provided any input for first answer
	brne second_position			;if input for first answer was provided, jump to section for the second input
	in r20, pinb					;input for the first answer is stored
	rjmp continue					;jump to the end of the loop so we don't run unnecessary lines of code
second:
	ldi		r16, 0xff				;setting value of r16 back after the jump to this part
	out porta, r29					;display sequence indicating that input was stored in register
	call delay2						;delay to prevent storing the same provided input into all registers
	out porta, r16					;all leds are turned off

	ldi r21, 0b11111111				;second register is set ready to store input
	rjmp continue					;jump to the end of the loop so we don't run unwanted lines of code
second_position:
	cp r21, r16						;check if user provided any input for second answer
	brne third_position				;if input for first answer was provided, jump to the section for the third input
	in r21, pinb					;input for the second answer is stored
	rjmp continue					;jump to the end of the loop so we don't run unwanted lines of code
third:
	ldi		r16, 0xff
	out porta, r29
	call delay2
	out porta, r16

	ldi r25, 0b11111111
	rjmp continue
third_position:
	cp r25, r16						;check if user provided any input for second answer
	brne fourth_position			;if input for the third answer was provided, jump to the next section
	in r25, pinb					;input for the third answer is stored
	rjmp continue
fourth:
	ldi		r16, 0xff
	out porta, r29
	call delay2
	out porta, r16

	ldi r17, 0b11111111
	rjmp continue
fourth_position:
	cp r17, r16						;check if user provided any input for second answer
	brne fifth_position				;if input for the fourth answer was provided, jump to the next section
	in r17, pinb					;input for the fourth answer is stored
	rjmp continue

fifth:
	ldi		r16, 0xff
	out porta, r29
	call delay2
	out porta, r16

	ldi r24, 0b11111111
	rjmp continue
fifth_position:
	in r24, pinb

continue:
	dec		r28
	brne	position
	dec		r27
	brne	loop2
	dec		r26
	brne	loop1
end:
	pop		r28						;end of the loop
	pop		r27
	pop		r26
	ret

position:							;section which decides which part of the loop3 nested in delay loop should be run
	cp r20, r16						;if first answer was not provided
	breq loop3						;go at the beginning
	ldi		r16, 0b11111100			;delay checker, if input was provided a delay is required so the same input is not stored in multiple registers

	cp r21, r16						;if true
	breq second						;delay will be called
	ldi		r16, 0xff				;setting value back
	cp r21, r16						;if second ansert was not provided
	breq second_position			;jump to the beginning

	ldi		r16, 0b11111100			;delay checker, if input was provided a delay is required so the same input is not stored in multiple registers
	cp r25, r16
	breq third
	ldi		r16, 0xff				;setting value back
	cp r25, r16
	breq third_position

	ldi		r16, 0b11111100			;delay checker, if input was provided a delay is required so the same input is not stored in multiple registers
	cp r17, r16
	breq fourth
	ldi		r16, 0xff				;setting value back
	cp r17, r16
	breq fourth_position

	ldi		r16, 0b11111100			;delay checker, if input was provided a delay is required so the same input is not stored in multiple registers
	cp r24, r16
	breq fifth
	ldi		r16, 0xff				;setting value back
	cp r24, r16
	breq fifth_position
	rjmp end

level1:
	ldi		r18, 0b11101111			;first byte in sequence
	out porta, r18					;byte is displayed
	call delay2						;byte is displayed for this period of time

	out porta, r16					;turn off all the LEDs
	ldi		r21, 0b10111111			;in this part we set answer for other bytes in sequence since we need answer only for the first byte in the first level
	ldi		r25, 0b11111101			;
	ldi		r17, 0b11111110			;
	ldi		r24, 0b01111111			;
	ldi		r30, 0b11111011			;
	call delay						;delay in which player can provide input
	call check						;check the results

	ret

level2:
	ldi		r20, 0b11111111			;reset first input
	ldi		r21, 0b11111100			;reset second input

	ldi		r18, 0b11101111			;first byte in sequence
	out porta, r18					;byte is displayed
	call delay2						;byte is displayed for this period of time

	ldi		r18, 0b10111111			;second byte in sequence (register is reused to save resources)
	out porta, r18					;byte is displayed
	call delay2						;byte is displayed for this period of time

	out porta, r16					;turns off all LEDs

	call delay						;delay in which player can provide input
	call check						;check the results

	ret

level3:
	ldi		r20, 0b11111111			;reset first input
	ldi		r21, 0b11111100			;reset second input
	ldi		r25, 0b11111100			;reset third input

	ldi		r18, 0b11101111
	out porta, r18
	call delay2

	ldi		r18, 0b10111111
	out porta, r18
	call delay2

	ldi		r18, 0b11111101
	out porta, r18
	call delay2

	out porta, r16					;turns off all LEDs

	call delay
	call check						;check the results

	ret

level4:
	ldi		r20, 0b11111111			;reset first input
	ldi		r21, 0b11111100			;reset second input
	ldi		r25, 0b11111100			;reset third input
	ldi		r17, 0b11111100			;reset 4th input

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

	out porta, r16					;turns off all LEDs

	call delay
	call check						;check the results

	ret

level5:
	ldi		r20, 0b11111111			;reset first input
	ldi		r21, 0b11111100			;reset second input
	ldi		r25, 0b11111100			;reset third input
	ldi		r17, 0b11111100			;reset fourth input
	ldi		r24, 0b11111100			;reset fifth input

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

	out porta, r16					;turns off all LEDs

	call delay
	call check						;check the results

	ret

check:
	ldi		r18, 0b11101111			;expected result is set
	cp r18, r20						;check for first answer
	brne false						;if answer is not correct, jump to "false" is made
	ldi		r18, 0b10111111			;expected result is set
	cp r18, r21						;check for second answer
	brne false						;if answer is not correct, jump to "false" is made
	ldi		r18, 0b11111101			;expected result is set
	cp r18, r25						;check for third answer
	brne false						;if answer is not correct, jump to "false" is made
	ldi		r18, 0b11111110			;expected result is set
	cp r18, r17						;check for fourth answer
	brne false						;if answer is not correct, jump to "false" is made
	ldi		r18, 0b01111111			;expected result is set
	cp r18, r24						;check for fifth answer
	brne false						;if answer is not correct, jump to "false" is made
true:
	ldi		r16, 0x00				;all LEDs on byte is set
	out porta, r16					;result if round is won / all LEDs are on
	call delay2						;for this period of time
	ldi		r16, 0xff				;all LEDs off byte is set
	out porta, r16					;all LEDs are turned off
	ret
false:
	ldi		r31, 0b10101010			;byte for lost game
	out porta, r31					;result if game is lost
	call delay2						;for this period of time
	out porta, r16
	rjmp program_end

delay2:								;delay in which user can not provide an input
	nop
	push	r19
	push	r22
	push	r23
	ldi		r19, 60					;number of iterations in the main loop
loop1x:
	ldi		r22, 255				;number of iterations in the first nested loop
loop2x:
	ldi		r23, 255				;number of iterations in the second nested loop
loop3x:
	dec		r23
	brne	loop3x
	dec		r22
	brne	loop2x
	dec		r19
	brne	loop1x
endx:								;end
	pop		r23
	pop		r22
	pop		r19
	ret

win:								;code run after the game is won, lights go from edges to the middle and then flicker for a while
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

win_delay:							;shorter delay used for flickering
	nop
	push	r19
	push	r22
	push	r23
	ldi		r19, 10					;number of iterations in the main loop
loop1a:
	ldi		r22, 255				;number of iterations in the first nested loop
loop2a:
	ldi		r23, 255				;number of iterations in the second nested loop
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
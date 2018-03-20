
	;SETUP
ldi 	r16, 0000_0000		;setup bit pattern 0000_0000
out 	ddra, r16			;bit pattern inserted to porta
out 	porta, r17			;putting r17 bit pattern to porta





                 LDI    R16,  0xFF       ; Load 0b11111111 in R16
                 OUT    DDRA, R16        ; Configure PortA as an Output port
 
                 LDI    R16,  0x00       ; Load 0b00000000 in R16
                 OUT    DDRB, R16        ; Configure PortB as an Input port
 
                 LDI    R16,  0xF0       ; Load 0b11110000 in R16
                 OUT    DDRC, R16        ; Configure first four pins on PortC
                                         ; as input and the others as output



LDI    R16,  0xFF       ; Load 0b11111111 in R16
                 OUT    DDRA, R16        ; Configure PortA as an Output port
 
                 LDI    R16,  0x00       ; Load 0b00000000 in R16
                 OUT    DDRB, R16        ; Configure PortB as an Input port
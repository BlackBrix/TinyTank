//==============================================================================
// File:      	TinyTank.asm
// Compiler:	AVR Studio 3.11 www.atmel.com
// Output Size:	-
// Created:    	Sat Nov 15 22:39:35 2004
// Copyright:	(C) 2004 ALM, Hong Kong
//
// This program is free software; you can redistribute it and/or modify it under
// the terms of the GNU General Public License as published by the Free Software
// Foundation; either version 2 of the License, or (at your option) any later
// version.
//
// This program is distributed in the hope that it will be useful, but without
// any warranty; without even the implied warranty of merchantability or fitness
// for a particular purpose. See the GNU General Public License for more details
// at http://www.gnu.org/licenses
//==============================================================================


; Choose A4 or A6 instrument cluster
;.equ A4IC=1
.equ A6IC=1

.include "tn15def.inc"
.include "TinyTank.inc"


.org	0x000
MAIN:
	
	; PB4 ADC input from fuel level sensor
	; PB3 n.c.
	; PB2 n.c.
	; PB1 PWM output to instrument cluster
	; PB0 Jumper for demo mode (low=demo)

	; Prepare port
	ldi temp1, 0b00001010
	out DDRB, temp1
	ldi temp1, 0b00001111
	out PORTB, temp1


	
	; Prepare ADC
	ldi temp1, 0b00000011
	out ADMUX, temp1
	ldi temp1, 0b11100000
	out ADCSR, temp1


	
	; Calibrate 
	ldi temp1, low( CAL_BYTE<<1 )
	mov ZL, temp1
	ldi temp1, high( CAL_BYTE<<1 )
	mov ZH, temp1
	lpm
	out OSCCAL, r0



	; Prepare PWM output
	ldi temp1, 0b01110001
	out TCCR1, temp1
	ldi temp1, 0xFF
	out OCR1B, temp1

	; Preset fuel gauge to 'full'
	.ifdef A4IC
		ldi pwmval, 48
	.else
		ldi pwmval, 145
	.endif



	; Jump to demo mode?
	sbis PINB, 0
	rjmp DEMOMODE



	; Four cycles to read before averaging begins
	ldi initcylcles, 4



MAIN_LOOP:

    rcall GET_PWM_VALUE

	mov avg1, avg2
	mov avg2, avg3
	mov avg3, avg4
	mov avg4, pwmval

	ldi temp1, 0
	ldi temp2, 0
	mov pwmval, temp2

	add pwmval, avg1
	adc temp2, temp1

	add pwmval, avg2
	adc temp2, temp1

	add pwmval, avg3
	adc temp2, temp1

	add pwmval, avg4
	adc temp2, temp1

	ror temp2
	ror pwmval

	ror temp2
	ror pwmval

	; During the first four loops, no output is made
	; Just fill the moving average
	cpi initcylcles,0
	breq NO_MORE_INIT

	dec initcylcles

	NO_MORE_INIT:

	cpi initcylcles,0
	brne MAIN_LOOP

	out OCR1A, pwmval

	; Wait about one second before next cycle
	ldi waitcntL, 80
	ldi	waitcntH, 30
	rcall WAIT_1S	

	rjmp MAIN_LOOP





/*******************************************************************************
* Procedure: DEMOMODE
*
*******************************************************************************/

DEMOMODE:

	ldi temp1, high(869)
	ldi temp2, low(869)


	mov adcvalH, temp1
	mov adcvalL, temp2


DEMO_LOOP:

	rcall ADC_TO_PWM_VALUE

	out OCR1A, pwmval

	ldi waitcntL, 1
	ldi	waitcntH, 5
	rcall WAIT_1S	

	ldi temp1, 1
	ldi temp2, 0

	sub adcvalL, temp1
	sbc adcvalH, temp2

	ldi temp1, high(455)
	ldi temp2, low(455)
	
	cp temp2, adcvalL
	cpc temp1, adcvalH

	brlo DEMO_LOOP

	ldi waitcntL, 1
	ldi	waitcntH, 100
	rcall WAIT_1S	

	ldi temp1, high(869)
	ldi temp2, low(869)


	mov adcvalH, temp1
	mov adcvalL, temp2

	rcall ADC_TO_PWM_VALUE

	out OCR1A, pwmval

	ldi waitcntL, 1
	ldi	waitcntH, 255
	rcall WAIT_1S	

	rjmp DEMOMODE





/*******************************************************************************
* Procedure: GET_PWM_VALUE
*
*******************************************************************************/

GET_PWM_VALUE:

	; Read ADC und convert it to a PWM value
	in adcvalL, ADCL
	in adcvalH, ADCH
	rcall ADC_TO_PWM_VALUE
	mov pwmavg1, pwmval

	in adcvalL, ADCL
	in adcvalH, ADCH
	rcall ADC_TO_PWM_VALUE
	mov pwmavg2, pwmval

	in adcvalL, ADCL
	in adcvalH, ADCH
	rcall ADC_TO_PWM_VALUE
	mov pwmavg3, pwmval

	in adcvalL, ADCL
	in adcvalH, ADCH
	rcall ADC_TO_PWM_VALUE


	; Averaging four PWM values

	ldi temp1, 0
	ldi temp2, 0

	add pwmval, pwmavg1
	adc temp2, temp1

	add pwmval, pwmavg2
	adc temp2, temp1

	add pwmval, pwmavg3
	adc temp2, temp1

	ror temp2
	ror pwmval

	ror temp2
	ror pwmval

	ret 





/*******************************************************************************
* Procedure: ADC_TO_PWM_VALUE
*
*******************************************************************************/

ADC_TO_PWM_VALUE:

	ldi temp2, low( ADC_LOOKUP_TABLE<<1 )
	mov ZL, temp2
	ldi temp2, high( ADC_LOOKUP_TABLE<<1 )
	mov ZH, temp2

	ldi pwmval, 0

LOOKUP_ADCTABLE_LOOP:

	lpm
	mov temp1,r0
	ldi temp2, 1
	add ZL, temp2
	ldi temp2, 0
	adc ZH, temp2
	lpm
	mov temp2, r0

	cp adcvalL, temp1
	cpc adcvalH, temp2

	brsh LOOKUP_ADCTABLE_LOOP_END

	inc pwmval

	ldi temp2, 1
	add ZL, temp2
	ldi temp2, 0
	adc ZH, temp2

	cpi pwmval, 67
	brne LOOKUP_ADCTABLE_LOOP

LOOKUP_ADCTABLE_LOOP_END:

	ldi temp2, low( PWM_LOOKUP_TABLE<<1 )
	mov ZL, temp2
	ldi temp2, high( PWM_LOOKUP_TABLE<<1 )
	mov ZH, temp2

	add ZL, pwmval
	ldi temp2,0
	adc ZH, temp2

	lpm
	mov pwmval, r0

	ret




/*******************************************************************************
* Procedure: WAIT_1S
*
*******************************************************************************/

WAIT_1S:
	subi waitcntL, 1
	sbci waitcntH, 0
WAIT_LOOP:
	ldi waitcnt, 47
	rcall WAITING
	subi waitcntL, 1
	sbci waitcntH, 0
	brne WAIT_LOOP
	ldi waitcnt, 45
	nop
	nop
	rcall WAITING
	ret

WAITING:
	nop
	dec waitcnt
	brne WAITING
	nop
	ret



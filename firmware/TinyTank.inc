//==============================================================================
// File:		TinyTank.inc
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


.def pwmavg1 = r5
.def pwmavg2 = r6
.def pwmavg3 = r7

.def avg1 = r8
.def avg2 = r9
.def avg3 = r10
.def avg4 = r11

.def temp1 = r16
.def temp2 = r17

.def pwmval = r18

.def adcvalL =r19
.def adcvalH =r20

.def waitcnt = r21
.def waitcntL = r22
.def waitcntH = r23

.def initcylcles = r24

.MACRO addi 
	subi @0, 0xFF - @1 + 1
.ENDMACRO


.if defined(A6IC)

	; A6 instrument cluster with a type89 fuel level sensor

	; Conversion table from analog measurement to liters
	.org 0x198
	ADC_LOOKUP_TABLE:

	.dw 755, 755, 680, 665, 631, 612, 600, 591, 584, 568, 560, 554, 545, 529, 526, 524 ; 0-15l
	.dw 519, 517, 514, 504, 501, 498, 496, 493, 490, 464, 461, 458, 455, 451, 448, 445 ; 16-31l
	.dw 442, 438, 435, 432, 428, 425, 421, 418, 414, 410, 407, 403, 399, 395, 391, 387 ; 32-47l
	.dw 384, 379, 375, 371, 367, 363, 359, 354, 350, 345, 341, 336, 332, 327, 322, 317 ; 48-53l
	.dw 312, 307, 302, 297; 54-67l

	; Conversion table from litres to value for PWM
	.org 0x1DC
	PWM_LOOKUP_TABLE:
	.db  64,  65,  67,  69,  72,  74,  76,  78,  80,  81,  83,  85,  86,  88,  90,  91 ; 0-15l
	.db  93,  94,  96,  97,  98, 100, 101, 103, 104, 105, 106, 108, 109, 110, 112, 113 ; 16-31l
	.db 114, 115, 116, 117, 118, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130 ; 32-47l
	.db 131, 132, 133, 133, 134, 135, 135, 136, 137, 138, 138, 139, 140, 141, 142, 142 ; 48-55l
	.db 143, 144, 144, 145, 145, 145 ; 56-61l
	
.elif defined(A4IC)

	; A4 instrument cluster with a type89 fuel level sensor

	; Conversion table from analog measurement to liters
	.org 0x197
	ADC_LOOKUP_TABLE:
	
	.dw 869, 869, 817, 807, 781, 757, 750, 744, 731, 724, 719, 711, 695, 693, 689, 687 ; 60-45l
	.dw 684, 675, 673, 670, 665, 663, 639, 636, 633, 630, 627, 620, 617, 614, 611, 607 ; 44-29l
	.dw 604, 600, 597, 590, 586, 582, 578, 574, 570, 566, 558, 554, 549, 545, 540, 536 ; 28-13l
	.dw 531, 526, 517, 512, 506, 501, 496, 490, 485, 473, 467, 461, 455 ; 12-0l

	; Conversion table from litres to value for PWM
	.org 0x1DC
	PWM_LOOKUP_TABLE:

	.db 149, 148, 146, 145, 144, 144, 143, 141, 140, 139, 138, 137, 136, 135, 134, 133 ; 0-15l
	.db 131, 130, 129, 128, 127, 125, 124, 123, 121, 120, 119, 117, 116, 114, 113, 111 ; 16-31l
	.db 109, 107, 105, 103, 101,  99,  97,  96,  94,  92,  90,  88,  86,  84,  81,  78 ; 32-47l
	.db  75,  73,  70,  67,  64,  61,  58,  55,  52,  49,  46,  44,  41,  00,  00,  00 ; 48-53l
	.db  00,  00,  00,  00,  00,  00 ; 54-59l

.else

.message "define A4IC oder A6IC"

.endif

.org 0x1FF
CAL_BYTE:
.dw 0x87

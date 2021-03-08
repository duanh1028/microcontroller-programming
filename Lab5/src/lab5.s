.syntax unified
.cpu cortex-m0
.fpu softvfp
.thumb

//=============================================================================
// ECE 362 Lab Experiment 5
// Timers
//
//=============================================================================

.equ  RCC,      0x40021000
.equ  APB1ENR,  0x1C
.equ  AHBENR,   0x14
.equ  TIM6EN,	0x10
.equ  GPIOCEN,  0x00080000
.equ  GPIOBEN,  0x00040000
.equ  GPIOAEN,  0x00020000
.equ  GPIOC,    0x48000800
.equ  GPIOB,    0x48000400
.equ  GPIOA,    0x48000000
.equ  MODER,    0x00
.equ  PUPDR,    0x0c
.equ  IDR,      0x10
.equ  ODR,      0x14
.equ  PC0,      0x01
.equ  PC1,      0x04
.equ  PC2,      0x10
.equ  PC3,      0x40
.equ  PIN8,     0x00000100

// NVIC control registers...
.equ NVIC,		0xe000e000
.equ ISER, 		0x100
.equ ICER, 		0x180
.equ ISPR, 		0x200
.equ ICPR, 		0x280

// TIM6 control registers
.equ  TIM6, 	0x40001000
.equ  CR1,		0x00
.equ  DIER,		0x0C
.equ  PSC,		0x28
.equ  ARR,		0x2C
.equ  TIM6_DAC_IRQn, 17
.equ  SR,		0x10

//=======================================================
// 6.1: Configure timer 6
//=======================================================
.global init_TIM6
init_TIM6:
	ldr r0, =RCC
	ldr r1, =APB1ENR
	ldr r2, =TIM6EN
	ldr r3, [r0, r1]
	orrs r3, r2
	str r3, [r0, r1]

	ldr r0, =TIM6
	ldr r1, =(480 - 1)  // psc
	ldr r2, =(100 - 1) // arr
	str r1, [r0, #PSC]
	str r2, [r0, #ARR]

	ldr r1, [r0, #DIER]
	ldr r2, =0x1
	orrs r1, r2
	str r1, [r0, #DIER]

	ldr r1, [r0, #CR1]
	ldr r2, =0x1
	orrs r1, r2
	str r1, [r0, #CR1]

	ldr r0, =NVIC
	ldr r1, =ISER
	ldr r2, =(1<<TIM6_DAC_IRQn)
	str r2, [r0, r1]

	bx lr // Student may remove this instruction.

//=======================================================
// 6.2: Confiure GPIO
//=======================================================
.global init_GPIO
init_GPIO:
	ldr r0, =RCC
	ldr r1, [r0, #AHBENR]
	ldr r2, =GPIOAEN
	orrs r1, r2
	ldr r2, =GPIOCEN
	orrs r1, r2
	str r1, [r0, #AHBENR]

	ldr r0, =GPIOA
	ldr r1, =0x55
	ldr r2, [r0, #MODER]
	orrs r2, r1
	str r2, [r0, #MODER]

	ldr r0, =GPIOC
	ldr r1, =0x10055
	ldr r2, [r0, #MODER]
	orrs r2, r1
	str r2, [r0, #MODER]

	ldr r0, =GPIOA
	ldr r1, =0xaa00
	ldr r2, [r0, #PUPDR]
	orrs r2, r1
	str r2, [r0, #PUPDR]
	bx lr // Student may remove this instruction.

//=======================================================
// 6.3 Blink blue LED using Timer 6 interrupt
// Write your interrupt service routine below.
//=======================================================
.type TIM6_DAC_IRQHandler, %function
.global TIM6_DAC_IRQHandler
TIM6_DAC_IRQHandler:
	push {r4-r7, lr}
	ldr r0, =TIM6
	ldr r1, [r0, #SR]
	ldr r2, =0x1
	bics r1, r2
	str r1, [r0, #SR]

	ldr r0, =tick
	ldr r1, [r0] // value of tick
	adds r1, #1
	str r1, [r0]
	if63check:
		ldr r2, =0x3e8  // 1000
		cmp r1, r2
		blt out63
	if63body:
		ldr r0, =tick
		ldr r1, =0x0
		str r1, [r0]

		ldr r0, =GPIOC
		ldr r1, =ODR
		ldr r2, [r0, r1]
		ldr r3, =0x100
		eors r2, r3
		str r2, [r0, r1]
	out63:

	// adding module for 6.5

	ldr r0, =col  // col
	ldr r0, [r0]
	adds r0, #1
	ldr r1, =0x3
	ands r0, r1
	ldr r1, =col
	str r0, [r1]
	ldr r2, =0x1
	lsls r2, r0
	ldr r1, =GPIOA
	str r2, [r1, #ODR]

	ldr r1, =0x2
	lsls r0, r1 // index

	ldr r1, =history
	ldr r2, =0x1
	movs r4, r0  // r4 = index duplicate

	ldrb r3, [r1, r4]  //index + 0
	lsls r3, r2
	strb r3, [r1, r4]
	adds r4, #1

	ldrb r3, [r1, r4]  //index + 1
	lsls r3, r2
	strb r3, [r1, r4]
	adds r4, #1

	ldrb r3, [r1, r4]  //index + 2
	lsls r3, r2
	strb r3, [r1, r4]
	adds r4, #1

	ldrb r3, [r1, r4]  //index + 3
	lsls r3, r2
	strb r3, [r1, r4]

	//row part

	ldr r2, =GPIOA
	ldr r2, [r2, #IDR]
	ldr r3, =0x4
	lsrs r2, r3
	ldr r3, =0xf
	ands r2, r3  // row

	movs r4, r0  // dup of index
	ldr r6, =0x1

	movs r5, r2  // dup of row
	ldrb r3, [r1, r4]  //index + 0
	ands r5, r6
	orrs r3, r5
	strb r3, [r1, r4]
	lsrs r2, r6
	adds r4, #1
	
	movs r5, r2
	ldrb r3, [r1, r4]  //index + 1
	ands r5, r6
	orrs r3, r5
	strb r3, [r1, r4]
	lsrs r2, r6
	adds r4, #1
	
	movs r5, r2
	ldrb r3, [r1, r4]  //index + 2
	ands r5, r6
	orrs r3, r5
	strb r3, [r1, r4]
	lsrs r2, r6
	adds r4, #1
	
	movs r5, r2
	ldrb r3, [r1, r4]  //index + 3
	ands r5, r6
	orrs r3, r5
	strb r3, [r1, r4]

	pop {r4-r7, pc}

//=======================================================
// 6.5 Debounce keypad
//=======================================================
.global getKeyPressed
getKeyPressed:
	push {r4-r7, lr}
	while651:
		ldr r5, =0x0  // i
		ldr r1, =history  // addr r1
		ldr r2, =tick  // addr r2
		for651check:
			cmp r5, #16
			blt for651body
			bl for651out
		for651body:
			if651check:
				ldrb r4, [r1, r5] // value of history
				cmp r4, #1
				bne if651out
			if651body:
				ldr r3, =0x0
				str r3, [r2]
				movs r0, r5
				pop {r4-r7, pc}
			if651out:
			adds r5, #1
			bl for651check
		for651out:
		bl while651
	pop {r4-r7, pc}

.global getKeyReleased
getKeyReleased:
	push {r4-r7, lr}
	while652:
		ldr r5, =0x0  // i
		ldr r1, =history  // addr r1
		ldr r2, =tick  // addr r2
		for652check:
			cmp r5, #16
			blt for652body
			bl for652out
		for652body:
			if652check:
				ldrb r4, [r1, r5] // value of history
				cmp r4, #0xfe
				bne if652out
			if652body:
				ldr r3, =0x0
				str r3, [r2]
				movs r0, r5
				pop {r4-r7, pc}
			if652out:
			adds r5, #1
			bl for652check
		for652out:
		bl while652
	pop {r4-r7, pc}

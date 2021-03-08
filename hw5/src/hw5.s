.cpu cortex-m0
.thumb
.syntax unified
.fpu softvfp

.equ RCC,       0x40021000
.equ GPIOA,     0x48000000
.equ GPIOC,     0x48000800
.equ AHBENR,    0x14
.equ APB2ENR,   0x18
.equ APB1ENR,   0x1c
.equ IOPAEN,    0x20000
.equ IOPCEN,    0x80000
.equ SYSCFGCOMPEN, 1
.equ TIM3EN,    2
.equ MODER,     0x00
.equ OSPEEDR,   0x08
.equ PUPDR,     0x0c
.equ IDR,       0x10
.equ ODR,       0x14
.equ BSRR,      0x18
.equ BRR,       0x28
.equ PC8,       0x100

// SYSCFG control registers
.equ SYSCFG,    0x40010000
.equ EXTICR2,   0x0c

// NVIC control registers
.equ NVIC,      0xe000e000
.equ ISER,      0x100

// External interrupt control registers
.equ EXTI,      0x40010400
.equ IMR,       0
.equ RTSR,      0x8
.equ PR,        0x14

.equ TIM3,      0x40000400
.equ TIMCR1,    0x00
.equ DIER,      0x0c
.equ TIMSR,     0x10
.equ PSC,       0x28
.equ ARR,       0x2c

// Iinterrupt number for EXTI4_15 is 7.
.equ EXTI4_15_IRQn,  7
// Interrupt number for Timer 3 is 16.
.equ TIM3_IRQn,  16

//=====================================================================
// Q1
//=====================================================================
.global subdiv
subdiv:
	push {lr}
    if1check1:
        cmp r0, #0
        beq if1body1
        bl if1check2
    if1body1:
        pop {pc}
    if1check2:
        ldr r1, =0x1
        movs r2, r0  // r2 = x
        ands r0, r1
        cmp r0, #1
        beq if1body2
        bl if1out2
    if1body2:
        movs r0, r2
        subs r0, #1
        bl subdiv
        adds r0, #1
        pop {pc}
    if1out2:
        movs r0, r2
        ldr r1, =0x1
        lsrs r0, r1
        bl subdiv
        adds r0, #1

    pop {pc}
//=====================================================================
// Q2
//=====================================================================
.global enable_porta
enable_porta:
    ldr r0, =RCC
    ldr r1, [r0, #AHBENR]
    ldr r2, =0x20000
    orrs r1, r2
    str r1, [r0, #AHBENR]
    bx lr
//=====================================================================
// Q3
//=====================================================================
.global enable_portc
enable_portc:
    ldr r0, =RCC
    ldr r1, [r0, #AHBENR]
    ldr r2, =0x80000
    orrs r1, r2
    str r1, [r0, #AHBENR]
    bx lr
//=====================================================================
// Q4
//=====================================================================
.global setup_pa4
setup_pa4:
    ldr r0, =GPIOA
    ldr r1, [r0]
    ldr r2, =0x300
    bics r1, r2
    str r1, [r0]

    ldr r1, [r0, #PUPDR]
    ldr r2, =0x300
    bics r1, r2
    ldr r2, =0x100
    orrs r1, r2
    str r1, [r0, #PUPDR]
    bx lr
//=====================================================================
// Q5
//=====================================================================
.global setup_pa5
setup_pa5:
    ldr r0, =GPIOA
    ldr r1, [r0]
    ldr r2, =0xc00
    bics r1, r2
    str r1, [r0]

    ldr r1, [r0, #PUPDR]
    ldr r2, =0xc00
    bics r1, r2
    ldr r2, =0x800
    orrs r1, r2
    str r1, [r0, #PUPDR]
    bx lr
//=====================================================================
// Q6
//=====================================================================
.global setup_pc8
setup_pc8:
    ldr r0, =GPIOC
    ldr r1, [r0]
    ldr r2, =0x10000
    orrs r1, r2
    ldr r2, =0x20000
    bics r1, r2
    str r1, [r0]

    ldr r1, [r0, #OSPEEDR]
    ldr r2, =0x30000
    orrs r1, r2
    str r1, [r0, #OSPEEDR]
    bx lr
//=====================================================================
// Q7
//=====================================================================
.global setup_pc9
setup_pc9:
    ldr r0, =GPIOC
    ldr r1, [r0]
    ldr r2, =0xc0000
    bics r1, r2
    ldr r2, =0x40000
    orrs r1, r2
    str r1, [r0]

    ldr r1, [r0, #OSPEEDR]
    ldr r2, =0xc0000
    bics r1, r2
    ldr r2, =0x40000
    orrs r1, r2
    str r1, [r0, #OSPEEDR]
    bx lr
//=====================================================================
// Q8
//=====================================================================
.global action8
action8:
    ldr r0, =GPIOA
    ldr r1, [r0, #IDR]
    ldr r2, =0x4
    ldr r3, =0x1
    lsrs r1, r2
    ands r1, r3
    check81:
        cmp r1, #1
        beq check82
        bl set81
    set81:
        ldr r0, =GPIOC
        ldr r1, [r0, #ODR]
        ldr r2, =0x1
        ldr r3, =0x8
        lsls r2, r3
        orrs r1, r2
        str r1, [r0, #ODR]
        bl out8
    check82:
        ldr r1, [r0, #IDR]
        ldr r2, =0x5
        ldr r3, =0x1
        lsrs r1, r2
        ands r1, r3
        cmp r1, #0
        beq set80
        bl set81
    set80:
        ldr r0, =GPIOC
        ldr r1, [r0, #ODR]
        ldr r2, =0x1
        ldr r3, =0x8
        lsls r2, r3
        bics r1, r2
        str r1, [r0, #ODR]
    out8:
    bx lr
//=====================================================================
// Q9
//=====================================================================
.global action9
action9:
    ldr r0, =GPIOA
    ldr r1, [r0, #IDR]
    ldr r2, =0x4
    ldr r3, =0x1
    lsrs r1, r2
    ands r1, r3
    check91:
        cmp r1, #0
        beq check92
        bl set91
    set91:
        ldr r0, =GPIOC
        ldr r1, [r0, #ODR]
        ldr r2, =0x1
        ldr r3, =0x9
        lsls r2, r3
        orrs r1, r2
        str r1, [r0, #ODR]
        bl out9
    check92:
        ldr r1, [r0, #IDR]
        ldr r2, =0x5
        ldr r3, =0x1
        lsrs r1, r2
        ands r1, r3
        cmp r1, #1
        beq set90
        bl set91
    set90:
        ldr r0, =GPIOC
        ldr r1, [r0, #ODR]
        ldr r2, =0x1
        ldr r3, =0x9
        lsls r2, r3
        bics r1, r2
        str r1, [r0, #ODR]
    out9:
    bx lr
//=====================================================================
// Q10
//=====================================================================
.type EXTI4_15_IRQHandler, %function
.global EXTI4_15_IRQHandler
EXTI4_15_IRQHandler:
    ldr r0, =EXTI
    ldr r1, [r0, #PR]
    ldr r2, =0x1
    ldr r3, =0x4
    lsls r2, r3
    orrs r1, r2
    str r1, [r0, #PR]

    ldr r0, =counter
    ldr r1, [r0]
    adds r1, #1
    str r1, [r0]

    bx lr
//=====================================================================
// Q11
//=====================================================================
.global enable_exti4
enable_exti4:
    ldr r0, =RCC
    ldr r1, =0x1
    ldr r2, [r0, #APB2ENR]
    orrs r2, r1
    str r2, [r0, #APB2ENR]

    ldr r0, =SYSCFG
    ldr r1, [r0, #EXTICR2]
    ldr r2, =0xf
    bics r1, r2
    str r1, [r0, #EXTICR2]

    ldr r0, =EXTI
    ldr r1, [r0, #RTSR]
    ldr r2, =0x1
    ldr r3, =0x4
    lsls r2, r3
    orrs r1, r2
    str r1, [r0, #RTSR]

    ldr r1, [r0, #IMR]
    ldr r2, =0x1
    ldr r3, =0x4
    lsls r2, r3
    orrs r1, r2
    str r1, [r0, #IMR]

    ldr r0, =NVIC
    ldr r3, =ISER
    ldr r1, [r0, r3]
    ldr r2, =(1<<EXTI4_15_IRQn)
    orrs r1, r2
    ldr r3, =ISER
    str r1, [r0, r3]

    bx lr
//=====================================================================
// Q12
//=====================================================================
.type TIM3_IRQHandler, %function
.global TIM3_IRQHandler
TIM3_IRQHandler:
    ldr r0, =TIM3
    ldr r1, [r0, #TIMSR]
    ldr r2, =0x1
    bics r1, r2
    str r1, [r0, #TIMSR]

    ldr r0, =GPIOC
    ldr r1, [r0, #ODR]
    ldr r2, =0x9
    ldr r3, =0x200
    eors r1, r3
    //lsls r1, r2
    //ldr r2, [r0, #ODR]
    //orrs r2, r1
    str r1, [r0, #ODR]

    bx lr
//=====================================================================
// Q13
//=====================================================================
.global enable_tim3
enable_tim3:
    ldr r0, =RCC
    ldr r1, [r0, #APB1ENR]
    ldr r2, =0x2
    orrs r1, r2
    str r1, [r0, #APB1ENR]

    ldr r0, =TIM3
    ldr r1, =2400 - 1
    str r1, [r0, #PSC]
    ldr r1, =10000 - 1
    str r1, [r0, #ARR]

    ldr r1, [r0, #DIER]
    ldr r2, =0x1
    orrs r1, r2
    str r1, [r0, #DIER]

    ldr r1, [r0, #TIMCR1]
    ldr r2, =0x1
    orrs r1, r2
    str r1, [r0, #TIMCR1]

    ldr r0, =NVIC
    ldr r1, =ISER
    ldr r2, =0x1
    ldr r3, =0x10
    lsls r2, r3
    ldr r3, [r0, r1]
    orrs r3, r2
    str r3, [r0, r1]

    bx lr

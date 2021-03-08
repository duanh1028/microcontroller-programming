.cpu cortex-m0 //1
.thumb //1
.syntax unified//0
.fpu softvfp   //3

.global four
four:
	ldr r0, =0x4
	bx lr
.global first
first:
	bx lr
.global mul4
mul4:
	muls r0, r1
	muls r0, r2
	muls r0, r3
	bx lr
.global or_into
or_into:
    ldr r2, [r0]
	orrs r2, r1
	str r2, [r0]
	bx lr
.global getbit
getbit:
	ldr r0, [r0]
    lsrs r0, r1
    ldr r1, =0x1
    ands r0, r1
	bx lr
.global setbit
setbit:
    ldr r3, [r0]
	ldr r2, =0x1
	lsls r2, r1
	orrs r3, r2
    str r3, [r0]
	bx lr
.global clrbit
clrbit:
    ldr r3, [r0]
	ldr r2, =0x1
	lsls r2, r1
	bics r3, r2
    str r3, [r0]
	bx lr
.global inner
inner:
	subs r0, #3
	bx lr
.global outer
outer:
    push {lr}
	ldr r1, =0x4
	muls r0, r1
	bl inner
	adds r0, #5
	pop {pc}
.global set6
set6:
    push {lr}
	ldr r1, =0x6
	bl setbit
	pop {pc}
.global get5
get5:
    push {lr}
	ldr r1, =0x5
	bl getbit
	pop {pc}

// Leave this down here just in case
// you forget to return from a subroutine.
bkpt
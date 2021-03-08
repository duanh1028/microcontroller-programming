.cpu cortex-m0 
.thumb 
.syntax unified
.fpu softvfp   

.global pow4 
pow4:
    push {r4-r7, lr}
    muls r0, r0
    muls r0, r0
    pop {r4-r7, pc}
.global sumpow4 
sumpow4:
    push {r4-r7, lr}
    ldr r5, =0 // r5 => sum
    movs r6, r0 // r6 => n
    movs r7, r1 // r7 => y
    for1check:
        cmp r6, r7
        ble for1body
        bl for1out
    for1body:
        movs r0, r6
        bl pow4
        adds r5, r0
        adds r6, #1
        bl for1check
    for1out:
    movs r0, r5
    pop {r4-r7, pc}
.global factorial
factorial:
    push {r4-r7, lr}
    ldr r1, =0x1 //r1 => product
    while2check:
        cmp r0, #0
        bgt while2body
        bl out2
    while2body:
        muls r1, r0
        subs r0, #1
        bl while2check
    out2:
    movs r0, r1
    pop {r4-r7, pc}
.global factorial2   
factorial2:
    push {r4-r7, lr}
    movs r4, r0 // r4 => n
    if3check:
        cmp r4, #1
        ble if3body
        bl out3
    if3body:
        ldr r0, =0x1
        pop {r4-r7, pc}
    out3:
    subs r0, #1
    bl factorial2
    muls r0, r4
    pop {r4-r7, pc}
.global fun14 
fun14:
    push {r4-r7, lr}
    movs r4, r0 //r4 => n
    if14check:
        cmp r4, #3
        bge out14
        pop {r4-r7, pc}
    out14:
    subs r0, #1
    bl fun14
    ldr r1, =0x3
    muls r0, r1
    subs r0, #1
    pop {r4-r7, pc}
.global doublerec 
doublerec:
    push {r4-r7, lr}
    movs r4, r0 // r4 => n 
    cmp r4, #3
    bge out15
    if15body:
        pop {r4-r7, pc}
    out15:
    ldr r1, =0x1
    lsrs r0, r1
    bl doublerec
    movs r5, r0 // r5 => first result
    movs r0, r4
    ldr r1, =0x2
    lsrs r0, r1
    bl doublerec
    adds r0, r5
    // I dont even need r4 and r5?
    pop {r4-r7, pc}
.global strcmp
strcmp:
    push {r4-r7, lr}
    movs r4, r0 // r4 => addr a
    movs r5, r1 // r5 => addr b
    ldr r6, =0x0 // r6 => index
    ldrb r0, [r0]
    ldrb r1, [r1]
    while16check:
        cmp r0, #0
        beq out16
        cmp r1, #0
        beq out16
    while16body:
        if16check:
            cmp r0, r1
            bne out16
        ldrb r0, [r4, r6]
        ldrb r1, [r5, r6]
        adds r6, #1
        bl while16check
    out16:
    subs r0, r1
    pop {r4-r7, pc}
.global vectoradd   
vectoradd:
    push {r4-r7, lr}
    ldr r4, =0x4
    muls r0, r4 // r0 => 4 times of count
    movs r5, r1 // r5 => addr of z
    movs r6, r2 // r6 => addr of x
    movs r7, r3 // r7 => addr of y
    ldr r4, =0x0 // r4 => n
    for17check:
        cmp r4, r0
        bge for17out
    for17body:
        ldr r2, [r6, r4] // r2 => x[n]
        ldr r3, [r7, r4] // r3 => y[n]
        adds r2, r3
        str r2, [r5, r4]
        adds r4, #4
        bl for17check
    for17out:
    pop {r4-r7, pc}
.global updatesum 
updatesum:
    push {r4-r7, lr}
    ldr r2, =0x4
    muls r1, r2
    ldr r2, =0x0 // r2 => n
    ldr r3, =0x0 // r3 => sum
    for18check:
         cmp r2, r1
         bge for18out
    for18body:
        ldr r4, [r0, r2] // r4 => x[n]
        adds r3, r4
        adds r4, #1
        str r4, [r0, r2]
        adds r2, #4
        bl for18check
    for18out:
    movs r0, r3
    pop {r4-r7, pc}
.global findfirst0 
findfirst0:
    push {r4-r7, lr}
    ldr r1, =0x0 // r1 => n
    ldr r2, =0x20 // r2 => limits
    ldr r3, =0x4
    ldr r4, =0x0 // index
    muls r2, r3
    for19check:
        cmp r1, r2
        bge out19
    for19body:
        if19check:
            ldr r3, =0x1
            lsls r3, r4
            ands r3, r0
            cmp r3, #0
            bne if19out
        if19body:
            movs r0, r4
            pop {r4-r7, pc}
        if19out:
        adds r1, #4
        adds r4, #1
        bl for19check
    out19: 
    ldr r0, =0x0
    subs r0, #1
    pop {r4-r7, pc}
.global globalsum
globalsum:
    push {r4-r7, lr}
    ldr r1, =0x4
    muls r0, r1 // r0 => count
    ldr r1, =global_array // r1 => addr array
    ldr r2, =0x0 // r2 => n
    ldr r3, =0x0 // r3 => sum
    for20check:
        cmp r2, r0
        bge out20
    for20body:
        ldr r4, [r1, r2]
        adds r3, r4
        adds r2, #4
        bl for20check
    out20:
    movs r0, r3
    pop {r4-r7, pc}
// Leave this down here just in case
// you forget to return from a subroutine.
bkpt

// Because this array is "const", we can
// put it in the text segment (which is
// in the Flash ROM.  It cannot be modified.
bx lr // put a return here just in case you missed one above.
.global global_array
.align 4
global_array:
.word 2
.word 3
.word 5
.word 7
.word 11
.word 13
.word 17
.word 19
.word 23
.word 29
.cpu cortex-m0
.thumb
.syntax unified
.fpu softvfp

//============================================================================
// Q1: hello
//============================================================================

.global hello
hello:
	push {r4-r7, lr}
    ldr r0, =Q1_string
    bl printf
    pop {r4-r7, pc}
Q1_string:
    .string "Hello, World!\n"
    .align 2
//============================================================================
// Q2: add2
//============================================================================

.global add2
add2:
	push {r4-r7, lr}
    movs r3, r1
    adds r3, r0
    movs r2, r1
    movs r1, r0
    ldr r0, =Q2_string
    bl printf
	pop {r4-r7, pc}
Q2_string:
    .string "%d + %d = %d\n"
    .align 2
//============================================================================
// Q3: add3
//============================================================================
.global add3
add3:
    sub sp, #4
    adds r3, r0
    adds r3, r1
    adds r3, r2
    str r3,  [sp, #0]
    movs r3, r2
    movs r2, r1
    movs r1, r0
    ldr r0, =Q3_string
    bl printf
    add sp, #4
    bx lr
Q3_string:
    .string "%d + %d + %d = %d\n"
    .align 2
//============================================================================
// Q4: rotate6
//============================================================================
.global rotate6
rotate6:
    push {r4-r7, lr}
    //ldr r4, [sp, #20]  //e
    //ldr r5, [sp, #24]  //f
    if4check:
        cmp r0, #0
        beq if4out
    if4body:
        movs r4, r3  //d
        movs r3, r2  //c
        movs r2, r1  //b
        movs r1, r0  //a
        mov r7, sp
        ldr r0, [r7, #24]  //f
        ldr r5, [r7, #20]  //e
        str r4, [r7, #20]  //d
        str r5, [r7, #24]  //e
        bl rotate6
        pop {r4-r7, pc}
    if4out:
        ldr r4, [sp, #20]
        ldr r5, [sp, #24]
        subs r5, r4
        subs r5, r3
        subs r5, r2
        subs r5, r1
        subs r5, r0
        movs r0, r5
    pop {r4-r7, pc}
//============================================================================
// Q5: low_pattern
//============================================================================
.type compare, %function  // You knew you needed this line.  Of course you did!
compare:
        ldr  r0,[r0]
        ldr  r1,[r1]
        subs r0,r1
        bx lr

.global low_pattern
low_pattern:
    push {r4-r7, lr}
    	ldr r1, =#800
        sub sp, #400
        sub sp, #400
        ldr r1, =0x0 // x
        ldr r2, =0x0 // x * 4
        ldr r3, =0xff // 0xff
        ldr r4, =#255 // 255
        mov r7, sp  // start of the array
        for5check:
            cmp r1, #200
            bge for5out
        for5body:
            ldr r5, =0x1
            adds r5, r1
            muls r5, r4
            ands r5, r3
            str r5, [r7, r2]
            adds r1, #1
            adds r2, #4
            bl for5check
        for5out:
            movs r5, r0
            movs r0, r7
            ldr r1, =#200
            ldr r2, =0x4
            ldr r3, =compare
            push {r5, r7}
            bl qsort
            pop {r5, r7}
            ldr r0, [r7, r5]
            add sp, #400
            add sp, #400
    pop {r4-r7, pc}
//============================================================================
// Q6: get_name
//============================================================================
.global get_name
get_name:
	push {r4-r7, lr}
    sub sp, #80
    mov r3, sp
    ldr r0, =Q6_string1
    bl printf
    movs r0, r3
    bl gets
    movs r1, r0
    ldr r0, =Q6_string2
    bl printf
    add sp, #80
    pop {r4-r7, pc}
Q6_string1:
    .string "Enter your name: "
    .align 2
Q6_string2:
    .string "Hello, %s\n"
    .align 2
//============================================================================
// Q7: random_sum
//============================================================================
.global random_sum
random_sum:
    push {r4-r7, lr}
    sub sp, #80
    mov r1, sp  //addr arr
    ldr r2, =0x4  // x
    ldr r3, =0x0  // sum
    bl random
    str r0, [r1]
    for7check:
        cmp r2, #80
        bge for7out
    for7body:
        bl random
        movs r5, r2
        subs r5, #4
        ldr r4, [r1, r5]
        subs r4, r0
        str r4, [r1, r2]
        adds r2, #4
        bl for7check
    for7out:
        ldr r2, =0x0  // x
        for7check2:
            cmp r2, #80
            bge for7out2
        for7body2:
            ldr r1, [r2]
            adds r3, r1
            adds r2, #4
            bl for7check2
        for7out2:
            movs r0, r3
            add sp, #80
    pop {r4-r7, pc}
//============================================================================
// Q8: fibn
//============================================================================
.global fibn
fibn:
    push {r4-r7, lr}
        sub sp, #240
        sub sp, #240
        ldr r1, =0x0  // x
        mov r7, sp // addr arr
        str r1, [r7]
        adds r1, #1
        str r1, [r7, #4]
        ldr r1, =0x8
        for8check:
        	push {r6}
        	ldr r6, =0x480
            cmp r1, r6
            bge for8out
            pop {r6}
        for8body:
            subs r1, #4
            ldr r2, [r7, r1]
            subs r1, #4
            ldr r3, [r7, r1]
            adds r1, #8
            adds r2, r3
            str r2, [r7, r1]
            adds r1, #4
            bl for8check
        for8out:
        	pop {r6}
            ldr r1, =0x4
            muls r0, r1
            ldr r0, [r7, r0]
        add sp, #240
        add sp, #240
    pop {r4-r7, pc}
//============================================================================
// Q9: fun
//============================================================================
.global fun
fun:
    push {r4-r7, lr}
    sub sp, #400
    mov r7, sp
    ldr r2, =0x0 // x
    ldr r3, =0x0 // x * 4
    ldr r4, =0x0 // sum
    str r2, [r7]
    adds r2, #1
    adds r3, #4
    for9check:
    	push {r4}
    	ldr r4, =#400
        cmp r3, r4
        bge for9out
        pop {r4}
    for9body:
        ldr r5, =#37
        movs r6, r2
        adds r6, #7
        muls r5, r6
        movs r6, r3
        subs r6, #4
        ldr r6, [r7, r6]
        adds r5, r6
        str r5, [r7, r3]
        adds r2, #1
        adds r3, #4
        bl for9check
    for9out:
    pop {r4}
    movs r2, r0 // x = a
    movs r3, r0 // 
    ldr r4, =0x4
    muls r3, r4  // x * 4
    ldr r4, =0x0 // sum
    for9check1:
        cmp r2, r1
        bgt for9out1
    for9body1:
        ldr r5, [r7, r3]
        adds r4, r5
        adds r2, #1
        adds r3, #4
        bl for9check1 
    for9out1:
        movs r0, r3
        add sp, #400
    pop {r4-r7, pc}
//============================================================================
// Q10: sick
//============================================================================
.global sick
sick:
    push {r4-r7, lr}
    ldr r6, [sp, #20] //step
    sub sp, #400
    mov r7, sp //addr arr
    ldr r4, =0x0 // x
    ldr r5, =0x4 // x * 4
    str r4, [r7]
    ldr r4, =0x1 // x = 1
    for10check:
    	push {r5}
    	ldr r5, =#400
        cmp r4, r5
        bge for10out
        pop {r5}
    for10body:
        movs r6, r4
        adds r6, r2
        muls r6, r3 //(x + add) * mul
        push {r3, r4}
        movs r4, r5
        subs r4, #4
        ldr r3, [r7, r4]
        adds r3, r6
        str r3, [r7, r5]
        pop {r3, r4}
        adds r4, #1
        adds r5, #4
        bl for10check
    for10out:
    	pop {r5}
        // r0 = x
        movs r2, r0
        ldr r3, =0x4
        muls r2, r3  //x * 4
        ldr r3, =0x0  // sum
    for10check1:
        cmp r0, r1
        bgt for10out1
    for10body1:
        ldr r4, [r7, r2]
        adds r3, r4
        adds r0, #1
        adds r2, #4
        bl for10check1
    for10out1:
        movs r0, r3
    add sp, #400
    pop {r4-r7, pc}

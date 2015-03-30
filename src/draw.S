
    .extern g_Screen

    .text
    .arm
    /*.align 2
    .global plot
    .type plot,%function
// inline void plot(int x, int y, int color) {
plot:
    
    // *(short*)(fbp + (y * vinfo.xres + x) * 2) = color;
    
    bx lr*/

    .align 2
    .global drawLine
    .type drawLine,%function
// void drawLine(int x1, int y1, int x2, int y2, int color);
drawLine:
#define x1 r0
#define y1 r1
#define x2 r2
#define y2 r3
#define color r4
#define fbp r5
#define tmp r6
/*fbp     .req r5*/

    mov r12, sp
    push {r4-r6}

    ldr color, [r12,#0]
    ldr fbp, [r12,#4]

    pop {r4-r6}
    bx lr


    .arm
    .align 2
    .global drawCircle
    .type drawCircle,%function
// void drawCircle(int x1, int y1, int radius, int color);
drawCircle:
#define x1 r0
#define y1 r1
#define radius r2
#define color r3

#define pitch r2
#define fbp r4
#define x2 r5
#define y2 r6
#define err r7
#define tmp r8
#define ptr r10

    mov r12,sp
    push {r4-r8,r10}

//  int x2 = r;
    mov x2, radius
//  int y2 = 0;
    mov y2, #0
//  int err = 1-x2;
    rsb err, x2, #1

    ldr fbp, =g_Screen
    //ldr pitch, [fbp, #0]
    ldr pitch, [fbp, #12]
    //lsl pitch, tmp
    ldr fbp, [fbp, #8]
    
//  while(x2 >= y2){
0:  cmp x2, y2
    blt end_circle
//    plot(x2 + x1, y2 + y1, color);
    add tmp, x2, x1
    add ptr, y2, y1
    mul ptr, ptr, pitch
    lsl tmp,#1
    add ptr, tmp
    add ptr, fbp
    strh color, [ptr]
//    plot(y2 + x1, x2 + y1, color);
    add tmp, y2, x1
    add ptr, x2, y1
    mul ptr, ptr, pitch
    lsl tmp,#1
    add ptr, tmp
    add ptr, fbp
    strh color, [ptr]
//    plot(-x2 + x1, y2 + y1, color);
    sub tmp, x1, x2
    add ptr, y2, y1
    mul ptr, ptr, pitch
    lsl tmp,#1
    add ptr, tmp
    add ptr, fbp
    strh color, [ptr]
//    plot(-y2 + x1, x2 + y1, color);
    sub tmp, x1, y2
    add ptr, y1, x2
    mul ptr, ptr, pitch
    lsl tmp,#1
    add ptr, tmp
    add ptr, fbp
    strh color, [ptr]
//    plot(-x2 + x1, -y2 + y1, color);
    sub tmp, x1, x2
    sub ptr, y1, y2
    mul ptr, ptr, pitch
    lsl tmp,#1
    add ptr, tmp
    add ptr, fbp
    strh color, [ptr]
//    plot(-y2 + x1, -x2 + y1, color);
    sub tmp, x1, y2
    sub ptr, y1, x2
    mul ptr, ptr, pitch
    lsl tmp,#1
    add ptr, tmp
    add ptr, fbp
    strh color, [ptr]
//    plot(x2 + x1, -y2 + y1, color);
    add tmp, x1, x2
    sub ptr, y1, y2
    mul ptr, ptr, pitch
    lsl tmp,#1
    add ptr, tmp
    add ptr, fbp
    strh color, [ptr]
//    plot(y2 + x1, -x2 + y1, color);
    add tmp, x1, y2
    sub ptr, y1, x2
    mul ptr, ptr, pitch
    lsl tmp,#1
    add ptr, tmp
    add ptr, fbp
    strh color, [ptr]
//    y2++;
    add y2, #1
//    if(err < 0){
    cmp err, #0
    bge 1f
//      err += 2 * y2 + 1;
        add err, y2, lsl #1
        add err, #1
        b 2f
//    }else{
1:  
//      x2--;
        sub x2, #1
//      err += 2 * (y2 - x2 + 1);
        sub tmp, y2, x2
        add tmp, #1
        add err, tmp, lsl #1
//    }
2:  b 0b
//  }
end_circle:
    pop {r4-r8,r10}
    bx lr


@ vim:ft=armv5

.model small
.stack 256
d_s segment
mas dw 1,1,1,2,2,2,3,3,3
sum dw 0
d_s ends
c_s segment
        assume ds:d_s, cs:c_s
    begin:
        mov    ax,d_s
        mov    ds,ax
        xor    ax,ax
    start:
        mov di, offset mas
        mov cx,3
    cycle1:
        add di,4
        mov bx,mas[di]
        add dx,bx
        loop cycle1

        mov sum,dx

        mov si, offset mas
        add si,2
        mov cx,2
    cycle2:
        mov bx, mas[si]
        test bx,1
        jz case1
        add si,6
        loop cycle2

    case2:
        mov ax,sum
        neg ax
        mov bx,sum
        xor ax,bx
        jmp exit

    case1:
        xor dx,dx
        mov ax,sum
        div bx

    exit:
        mov    ah,4Ch
        int    21h
c_s ends
end begin
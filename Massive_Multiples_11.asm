.MODEL SMALL
.STACK 100
d_s segment 
mas db '110000', '220000', '123456', '987654', '440000', '990000', '565677' 
rez db 0
q db 0 
d_s ends

c_s segment
assume cs:c_s, ds:d_s
begin:
mov ax, d_s
mov ds, ax

xor ax, ax
mov dl, 0
mov si,0
mov cx, 7


m1:
xor ax, ax
lea bx, mas[si]
push cx
push si
mov si,0
mov cx,3
m4:
mov ax,[bx][si]
add bx, ax
add si, 2
loop m4


xor ax, ax
mov si,1
mov cx,3
m5:
mov ax,[bx][si]
add dx, ax
add si,2
loop m5
 
sub dx,bx 
cmp dx, 0
je m2
pop cx
pop si
add si,1
loop m1
jmp m3

m2:
pop si 
pop cx
inc dl
add si, 1
jmp m1


m3:
mov rez, dl
mov ah, 4ch
int 21h
c_s ends
end begin
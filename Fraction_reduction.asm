d_s segment
drob db 6, 3
d_s ends

c_s segment
assume cs:c_s, ds:d_s

begin:

mov ax, d_s
mov ds, ax

mov si, 2
m:
xor ax, ax

mov al, drob[0]

cmp si, ax
ja m2

mov bx, si
div bl

cmp ah, 0
jne m1
xor ax, ax
mov al, drob[1]
cmp si, ax
ja m2
div bl

cmp ah, 0
jne m1
mov drob[1], al
mov al, drob[0]
div bl
mov drob[0], al

m1:
add si, 1
jmp m
m2:
mov ah, 4ch
int 21h
c_s ends
end begin

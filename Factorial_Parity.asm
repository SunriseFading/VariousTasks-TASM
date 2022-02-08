d_s segment
s dw 5
d_s ends

c_s segment; сегмент кода
assume ds:d_s, cs:c_s
begin:;начало программы
mov ax,d_s
mov ds,ax
xor ax,ax
mov cx, s
dec cx
mov al, 1
mov bl, 1
mov bh, 1
m1:
mov bh, bl
rcr bh, 1
jc fal; переход если CF=1(нечётный)
jmp next
fal:
inc dh
next:	
inc bl
mul bl
loop m1

mov bh, bl
rcr bh, 1	 
jc fal1; переход если CF=1(нечётный)
jmp next1
fal1:
inc dh	

next1:
rcr dh, 1
jc fals
mov dl, 0
jmp exit

fals:
mov dl, 1

exit:
mov ah,4ch
int 21h
c_s ends
end begin;
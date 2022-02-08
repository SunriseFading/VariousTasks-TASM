d_s segment
chislo dw 5
kvo dw 1
sum dw 0
del dw 2
d_s ends

c_s segment
assume ds:d_s,cs:c_s
begin:
mov ax,d_s
mov ds,ax
    mov ax,1   
	mov cx,chislo      
    mov bx,1
        factCycle:
	mul cx    
    
    mov sum,ax
	mov ax,cx
    mov kvo,cx
    div del
    cmp ah,0
    jz next
    inc kvo
    next:  
    mov ax,sum

    dec cx               
	cmp cx,1         
	jne factCycle     
    


    mov ax,kvo
    mov kvo,2
    div kvo
    cmp al,0
    jz chet
    mov dl,1
    jmp exit 

    chet:
    mov dl,0

        exit:mov ah,4Ch
        int 21h
c_s ends
end begin
.model small
.stack 256
d_s segment
zp1 dw 28
zp2 dw 36
fot dw 56
d_s ends
c_s segment
        assume ds:d_s, cs:c_s
    begin:
        mov    ax,d_s
        mov    ds,ax
        xor ax,ax
    cycle:
        xor cx,cx
        mov bx,zp1
        xor dx,dx
        mov ax, fot
        div bx
        or dx,dx
        jz counter1
    b1: 
        xor dx,dx
        mov bx,zp2
        mov ax,fot
        div bx
        or dx,dx
        jz counter2
    b2:
        or cx,cx
        cmp cx,2
        jz exit
        mov ax,fot
        add ax,28
        mov fot,ax
        jmp cycle
    counter1:
        inc cx
        jmp b1
    counter2:
        inc cx
        jmp b2
    exit:
        mov ax,fot
        call output_ax 
        mov    ah,4Ch
        int    21h

    output_ax proc	near
	                        mov    bx,0Ah
	                        xor    cx,cx
	                        or     ax,ax
	digit_to_symbol:        
	                        xor    dx,dx
	                        div    bx
	                        add    dl,30h
	                        push   dx
	                        inc    cx
	                        or     ax,ax
	                        jnz    digit_to_symbol

	symbol_output:          
	                        pop    ax
	                        int    29h
	                        loop   symbol_output

	                        retn
output_ax endp
c_s ends
end begin
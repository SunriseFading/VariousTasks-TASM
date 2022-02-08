.model small
.stack 256
d_s segment
    string     db "huiuh"
    len_string =  $-string
    yes        db "Yes$"
    no         db "No$"
    count      db 0
    c          db 0
d_s ends
c_s segment
        assume ds:d_s, cs:c_s
    begin:
        mov    ax,d_s
        mov    ds,ax
    start:
        mov    cl,len_string
        xor ch,ch
        lea si,string
        mov di,cx
        add di,si
        dec di
        shr cx,1
    met1:
        lodsb
        cmp al,[di]
        jne met4
        dec di
        loop met1
    met3: 
        mov    ah,9
        mov    dx, offset yes
        int    21h
        jmp    exit
    met4: 
        mov    ah,9
        mov    dx, offset no
        int    21h
    exit:
        mov    ah,4Ch
        int    21h
c_s ends
end begin
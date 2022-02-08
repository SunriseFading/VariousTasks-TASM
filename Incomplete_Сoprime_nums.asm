.model small
.stack 256
d_s segment
    msg1    db 'Yes $'
    msg2    db 'No $'
    mas     dw 2,3,5,6,7
    n       dw 0
    b       dw 0
    f       dw ?
    newline db 0Dh, 0Ah, '$'
d_s ends
c_s segment
                      assume ds:d_s, cs:c_s
    begin:            
                      mov    ax,d_s
                      mov    ds,ax
                      mov    si,0
                      mov    di,1
                      mov    cx,3
    met:              
                      mov    ax, mas[si]
                      mov    bx, mas[di]
                      call   gcd
                      mov    bx,f
                      cmp    bx,1
                      jz     met3
                      call   out_no
                      jmp    end
    met3:             
                      call   out_yes
                      mov    f, 0
    end:              
                      inc    si
                      inc    di
                      mov    ax, si
                      cmp    ax,2
                      jz     met5
                      jmp    cycle
    met5:             
call(newline_procedure)
    cycle:            
                      loop   met


out_yes proc
                      mov    dx,offset msg1
                      mov    ah,9
                      int    21h
                      retn
out_yes endp

out_no proc
                      mov    dx,offset msg2
                      mov    ah,9
                      int    21h
                      retn
out_no endp

gcd proc
                      or     ax, ax
    cikl:             
                      cmp    bx,0                 ; Выход из цикла,
                      jz     found                ; если bx=0 (НОД -найден!)
                      xor    dx,dx                ; dx:=0; (для правильного выполнения команды div)
                      div    bx                   ; dx:=(dx,ax) mod bx;
                      mov    ax,bx                ; ax:=bx;
                      mov    bx,dx                ; bx:=dx;
                      jmp    cikl
    found:            
                      cmp    ax,1                 ; vgcd:=ax;
                      jz     met1
    back:             
                      ret
    met1:             
                      mov    f,1
                      jmp    back
gcd endp

newline_procedure proc near
                      mov    ah,9
                      mov    dx,offset newline
                      int    21h
                      retn
newline_procedure endp

                      mov    ax, 4ch
                      int    21h
c_s ends
end begin
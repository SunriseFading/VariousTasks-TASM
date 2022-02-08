.model small
.stack 256
d_s segment
      mas dw 1,1,1,1,1,1,1,1,8,1
      yes db 'Yes$'
      no  db 'No$'
      sum dw 0
d_s ends
c_s segment
            assume ds:d_s, cs:c_s
      begin:
            mov    ax,d_s
            mov    ds,ax
            mov    si,offset mas
            xor    dx,dx
            mov    cx,10
      cycle:
            xor    bx,bx
            mov    bx,mas[si]
            add    dx,bx
            add    si,2
            loop   cycle
            mov    sum,dx
            xor    ax,ax
            xor    bx,bx
            xor    dx,dx
            mov    bx,1
            mov    cx,sum
            dec    cx
            dec    cx
      met:  
            inc    bx
            mov    ax,sum
            div    bx
            or     dx,dx
            jz     exit1
            xor    ax,ax
            xor    dx,dx
            loop   met
      exit2:
            mov    ah,9
            mov    dx,offset yes
            int    21h
            jmp    exit
      exit1:
            mov    ah,9
            mov    dx,offset no
            int    21h
      exit: 
            mov    ah,4Ch
            int    21h
c_s ends
end begin
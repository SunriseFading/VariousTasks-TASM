.model small
.stack 256
d_s segment

d_s ends
c_s segment
        assume ds:d_s, cs:c_s
    begin:
        mov    ax,d_s
        mov    ds,ax



    exit: 
        mov    ah,4Ch
        int    21h
c_s ends
end begin
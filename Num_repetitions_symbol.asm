model small
.stack 100h
.data
    mes1 db "Vvedite stroky: $"
    mes3 db 0ah,0dh,"Kol-vo povtoreniy vvedennogo simvola: $"
    mes4 db 0ah,0dh,"Vvedite proizvonuy simvol dlya sravneniya: $"
    mes5 db 0ah,0dh,"Simvol nekorrekten: $"
    string db 100 dup ("$")
    string1 db 'aeiouy'
    len_string = $-string
    adr_string dd string
.code
main:
    mov ax,@data      
    mov ds,ax     
    xor ax,ax     
    mov ah,09h   
    lea dx,mes1      
    lea si,string1  
      
    int 21h       
    mov cx,len_string 
    dec cx        
    les di,adr_string 
m1:
    mov ah,01h   
    int 21h      
    cmp al,0dh    
    je prov       
    cmp al,0      
    jne m2        
    jmp prov      
m2:
    stosb        
    
    loop m1       
prov:
    mov cx,len_string 
    dec cx       
    mov si,0    
exit:
    
    lea dx,mes4
    mov ah,09h    ;ah=09h
    int 21h
    mov ah,01h    ;ah=01h
    int 21h
    cmp al,0      
    je not2      
go:
    cmp string[si],string1 
    jne go1
    inc bh
go1:
    inc si
    loop go
    lea dx,mes3
    mov ah,09h
    int 21h
    add bh,"0"
    mov dl,bh
    mov ah,02h
    int 21h
    jmp ex
not2:
    lea dx,mes5
    mov ah,09h
    int 21h
ex:
    mov ax,4c00h
    mov ah,10h
    
    mov ah,0
    int 16h
 
    mov ah,4Ch
    int 21h
end main
.model small
.stack 256
d_s segment
    first_part_of_array      dw 0, 0
    second_part_of_the_array dw 0
                             dw 0
    third_part_of_the_array  dw 0
    open_brackets            db 'Arr[$'
    close_brackets           db ']=$'
    Buffer                   db 6
                             db 7 dup (0)
    newline                  db 0Dh, 0Ah, '$'
    sorted_array_message     db 'Sorted array:', 0Dh
                             db 0Ah, '$'
d_s ends
c_s segment
                            assume ds:d_s, cs:c_s
    begin:                  
                            mov    ax,d_s
                            mov    ds,ax
                            mov    bp,5
    array_input:            
                            mov    ah,9
                            mov    dx,offset open_brackets
                            int    21h
                            mov    ax,5
                            sub    ax,bp
                            call   output_ax
                            mov    ah,9
                            mov    dx,offset close_brackets
                            int    21h
                            mov    ah,0Ah
                            mov    dx,offset buffer
                            int    21h
                            mov    si,offset buffer
                            mov    ax,5
                            sub    ax,bp
                            shl    ax,1
                            mov    di,offset first_part_of_array
                            add    di,ax
                            call   buffer_to_array
                            call   newline_procedure
                            dec    bp
                            jnz    array_input
                            call   newline_procedure
    implementation_of_task: 
                            mov    ax,second_part_of_the_array
                            cmp    ax,third_part_of_the_array
                            jbe    condition_not_met
                            xchg   third_part_of_the_array,ax
                            mov    second_part_of_the_array,ax
                            jmp    short output

    condition_not_met:      
                            mov    second_part_of_the_array,0
                            mov    third_part_of_the_array,0
    output:                 
                            mov    ah,9
                            mov    dx,offset sorted_array_message
                            int    21h
                            call   output_array_to_console
                            mov    ah,4Ch
                            int    21h

output_array_to_console proc	near
                            mov    di,offset first_part_of_array
                            mov    bp,5
    repeater:               
                            mov    ax,[di]
                            call   output_ax
                            mov    al,20h
                            int    29h
                            add    di,2
                            dec    bp
                            jnz    repeater
                            call   newline_procedure
                            retn
output_array_to_console endp


buffer_to_array proc near
                            push   ax
                            push   bx
                            push   cx
                            push   dx
                            push   si

                            mov    cl, Buffer[1]
                            xor    ch, ch

                            lea    si, Buffer+2

    met1:                   
                            cmp    [si], byte ptr '-'
                            jne    ispositive
                            inc    si
                            dec    cx
                            jmp    met1

    ispositive:             
                            jcxz   Error

                            mov    bx, 10
                            xor    ax, ax

    Cycle:                  
                            mul    bx                                ; умножаем ax на 10 ( dx:ax=ax*bx )
                            mov    [di], ax                          ; игнорируем старшее слово
                            cmp    dx, 0                             ; проверяем результат на переполнение
                            jnz    Error

                            mov    al, [si]                          ; Преобразуем следующий символ в число
                            cmp    al, '0'
                            jb     Error
                            cmp    al, '9'
                            ja     Error
                            sub    al, '0'
                            xor    ah, ah
                            add    ax, [di]
                            jc     Error                             ; Если сумма больше 65535
                            inc    si

                            loop   Cycle
                            pop    si
                            push   si
                            or     ax, ax
                            js     Error

                            lea    si, Buffer+2                      ;;;;;;;;;;;;
                            cmp    [si], byte ptr '-'
                            jne    converted
                            neg    ax
                            or     ax, ax
                            jns    Error

    converted:              


                            mov    [di], ax

                            clc
                            jmp    num_exit
    Error:                  

                            xor    ax, ax
                            stc

    num_exit:               
                            pop    si
                            pop    dx
                            pop    cx
                            pop    bx
                            pop    ax
                            ret
buffer_to_array endp


output_ax proc	near
                            push   ax
                            push   cx
                            push   dx
                            push   di

                            mov    bx, 10
                            xor    cx, cx
                            or     ax, ax
                            jns    Conv
                            neg    ax
                            push   ax
                            mov    ah, 02h
                            mov    dl, '-'
                            int    21h
                            pop    ax


    Conv:                   
                            xor    dx, dx
                            div    bx
                            push   dx
                            inc    cx
                            or     ax, ax
                            jnz    Conv
                            mov    ah, 02h

    Show:                   
                            pop    dx
                            add    dl, '0'
                            int    21h

                            loop   Show



                            pop    di
                            pop    dx
                            pop    cx
                            pop    ax
                            ret
output_ax endp

newline_procedure proc	near
                            mov    ah,9
                            mov    dx,offset newline
                            int    21h
                            retn
newline_procedure endp


c_s ends
end begin



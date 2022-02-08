.model small
.stack 256
d_s segment
	first_part_of_array      dw 0, 0
	second_part_of_the_array dw 0
	                         dw 0
	third_part_of_the_array  dw 0
	open_brackets            db 'Arr[$'
	close_brackets           db ']=$'
	buffer                   db 6
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


buffer_to_array proc	near
	                        xor    ax,ax
	                        mov    cx,ax
	                        mov    cl,[si+1]
	                        or     cx,cx
	                        jz     finish
	                        add    si,2

	symbol_to_digit:        
	                        mov    bx,0Ah
	                        mul    bx
	                        xor    bx,bx
	                        mov    bl,[si]
	                        sub    bl,30h
	                        add    ax,bx
	                        inc    si
	                        loop   symbol_to_digit

	finish:                 
	                        mov    [di],ax
	                        retn
buffer_to_array endp


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

newline_procedure proc	near
	                        mov    ah,9
	                        mov    dx,offset newline
	                        int    21h
	                        retn
newline_procedure endp

c_s ends
end begin
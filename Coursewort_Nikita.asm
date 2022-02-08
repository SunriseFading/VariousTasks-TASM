.model small
.stack 256
d_s segment
rab  struc
	surname      db   15,15 dup('$')
	name_project db   30 dup (' ')
	date_start   db   ('  .  .  ')
	date_end     db   ('  .  .   ')
rab ends
	sotr rab     5 dup(<>)
	buff         db   30,30 dup('$')
    date         db   ('  .  .  ')
	msg1         db   13,10, 'Enter surname:$'
	msg2         db   13,10, 'Enter name project:$'
	msg3         db   13,10, 'Enter date start:$'
	msg4         db   13,10, 'Enter date end:$'
	msg5         db   13,10, 'Enter check date:$'
d_s ends
c_s segment
	            assume ds:d_s, cs:c_s
	begin:      
	            mov    ax,d_s
	            mov    ds,ax
	            xor    ax, ax
	            lea    di,  sotr
	            mov    cx,5
	met:        
	            mov    dx,offset msg1
	            mov    ah,9
	            int    21h
	            lea    dx, [di].surname
	            mov    ah,10
	            int    21h
				
				mov    dx, offset msg2
	            mov    ah,9
	            int    21h
	            lea    dx, buff
	            mov    ah,10
	            int    21h

	            mov    dx,offset msg3
	            mov    ah,9
	            int    21h
	            lea    dx, buff
	            mov    ah,10
	            int    21h

	            mov    dx,offset msg4
	            mov    ah,9
	            int    21h
	            lea    dx, [di].date_end
	            mov    ah,10
	            int    21h
	            add    di,type rab
	            loop   met
				
	            mov    dx,offset msg5
	            mov    ah,9
	            int    21h
	            lea    dx,date
	            mov    ah,10
	            int    21h
				
	task:       
	            lea    di,sotr
	            mov    cx,5
	check_year: 
	            push   cx
	            mov    bl,10
	            mov    al,[di].date_end[8]
	            sub    al,48
	            mul    bl
	            add    al,[di].date_end[9]
	            sub    al,48
	            mov    dl,al
	            call   date2year
	            cmp    bl, dl
	            ja     output
	            jz     check_month
	            jmp    perehod
	check_month:
	            mov    bl,10
	            mov    al,[di].date_end[5]
	            sub    al,48
	            mul    bl
	            add    al,[di].date_end[6]
	            sub    al,48
	            mov    dl,al
	            call   date2month
	            cmp    bl, dl
	            ja     output
	            jz     check_day
	            jmp    perehod
	check_day:  
	            mov    bl,10
	            mov    al,[di].date_end[2]
	            sub    al,48
	            mul    bl
	            add    al,[di].date_end[3]
	            sub    al,48
	            mov    dl,al
	            call   date2day
	            cmp    bl, dl
	            jl     perehod
	output:     
	            mov    [di].surname+1,0ah
	            lea    dx, [di].surname+1
	            mov    ah,9
	            int    21h
	perehod:    
	            pop    cx
	            add    di, type rab
	            loop   check_year
	            mov    ax, 4c00h
	            int    21h


date2year proc	near
	            mov    bl,10
	            mov    al,date[8]
	            sub    al,48
	            mul    bl
	            add    al,date[9]
	            sub    al,48
	            mov    bl,al
	            retn
date2year endp


date2month proc	near
	            mov    bl,10
	            mov    al,date[5]
	            sub    al,48
	            mul    bl
	            add    al,date[6]
	            sub    al,48
	            mov    bl,al
	            retn
date2month endp


date2day proc	near
	            mov    bl,10
	            mov    al,date[2]
	            sub    al,48
	            mul    bl
	            add    al,date[3]
	            sub    al,48
	            mov    bl,al
	            retn
date2day endp

c_s ends
end begin
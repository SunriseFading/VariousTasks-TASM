.model small
.stack 256
d_s segment
	mes1                 db 'Massive[$'
	mes2           		 db ']=$'
	mes3 				 db 'Feroare massive:', 0Dh
	                     db 0Ah, '$'
	buf                  db 5
	                     db 100 dup ('$')
	mas                  db 8 dup ('   ')
	new                  db 0Dh, 0Ah, '$'
	counter              dw 0
	null                 db "0"
	null_len             =  $ - null
d_s ends
c_s segment
	                        assume ds:d_s, cs:c_s
	begin:                  
	                        mov    ax,d_s
	                        mov    ds,ax
	                        mov    es, ax
	                        mov    bp,8;в bp помещаем 8 т.е.  кол-во элементов массива
	input:            
	                        mov    ah,9;эта и последующие 2 строки отвечают за вывод сообщения 'Massive['
	                        mov    dx,offset mes1
	                        int    21h
	                        mov    ax,8;т.к. после  сообщения "Massive[' нам нужен индекс элемента массива, в ax помещаем значение 8
	                        sub    ax,bp;ax-bp
	                        call   out_ax;вызываем процедуру, которая выводит регистр ax на экран
	                        mov    ah,9;эта и последующие 2 строки отвечают за вывод сообщения ']='
	                        mov    dx,offset mes2
	                        int    21h
	                        mov    ah,10;эта и 2 последующие строки отвечают за ввод массива в буфер
	                        mov    dx,offset buf
	                        int    21h
	                        mov    si,offset buf;в si помещаем адрес буфера
	                        mov    ax,8;снова помещаем в ax 8, но уже для того, чтобы правильно записать строку из буфера в массив
	                        sub    ax,bp;вычитаем, чтобы получить индекс
	                        shl    ax,1; это логический сдвиг влево на 1, по факту же регистр ax умножается на 2
	                        mov    di,offset mas;помещаем в di адрес начала масива
	                        add    di,ax; массив состоит из dw элементов т.е. занимающих 2 байта, чтобы в нем позиционироваться к началу массива прибавляется регистр ax, т.е. ax выступает индексом элемента
	                        call   mas_in;вызывается процедура, которая переводит числов из буфера в ячейку массива
	                        call   new_proc;вызывается процедура перевода курсора на новую строку
	                        dec    bp; bp-1
	                        jnz    input;цикл, пока bp не станет равным нулю будет осуществляться ввод значений массива
	                        call   new_proc;вызывается процедура перевода курсора на новую строку
	output:                 
	                        mov    ah,9;эта и последующие 2 строки отвечают за вывод сообщения 'Feroare massive:'
	                        mov    dx,offset mes3
	                        int    21h
	                        call   output_mass;вызывается процедура вывода массива на экран
	                        mov    ah,4Ch;эта и следующая строка отвечают за корректное завершение программы
	                        int    21h

output_mass proc	near;процедура отвечает за вывод массива
	                        mov    di,offset mas;в di помещаем адрес начала массива
	                        mov    bp,8;в bp помещаем 8 т.е.  кол-во элементов массива
						
	cycle:               
	                        mov    dx,counter;в dx помещаем значение переменной counter 
	                        mov    ax,[di];в ax помещаем значение элемента массива
	                        cmp    ax,dx;сравниваем значения ax и dx, в ax находится значение элемента массива, в dx его индекс
	                        jz     met; если они равны перемещаемся на met
	                        call   output_null;если они не равны вызываю процедуру вывода на экран 0 синего цвета
	back:                   
	                        mov    al,20h;последующиe строки до call new_proc отвечают за цикл вывода элементов массива на экран
	                        int    29h
	                        add    di,2
	                        mov    dx,counter
	                        inc    dx
	                        mov    counter, dx
	                        dec    bp
	                        jnz    cycle
	                        call   new_proc;вызывается процедура перевода курсора на новую строку
	                        retn; возвращение из функции
	met:                    
	                        mov    ax,counter;помещаю в ax индекс элемента массива
	                        call   out_ax;вызыва. процедуру вывода регистра ax на экран
	                        jmp    back;перемещаюсь на метку back
output_mass endp

output_null PROC near                                        		
	                        push   bp;помещаю в стек регистр bp, тем самым сохранив в стеке его значение                            	
	                        push   bx ;помещаю в стек регистр bx, тем самым сохранив в стеке его значение                           	
	                        lea    bp, null; в регистр bp помещаю адрес начала строки null
	                        mov    cx,null_len;в регистр cx помещаю длину строки null
	                        mov    bl,1; в регистр bl помещаю 1 т.е. устанавливаю цвет выводимого символа на синий
	                        push   cx;помещаю в стек регистр cx, тем самым сохранив в стеке его значение      
	                        mov    ah, 03h;последующие строки до pop bx отвечают за вывод 0 синим цветом на экран                     	
	                        xor    bh, bh                        	
	                        int    10h                           	
	                        pop    cx                            	
	                        mov    ah, 13h                       	
	                        mov    al, 1                         	
	                        xor    bh, bh                        	
	                        int    10h
	                        pop    bx;извлекаю из стека регистр bx
	                        pop    bp;извлекаю из стека регистр bp                            	
	                        ret; возвращение из функции
output_null ENDP

new_proc proc	near;процедура отвечающая за перевод курсора на новую строку
	                        mov    ah,9
	                        mov    dx,offset new
	                        int    21h
	                        retn
new_proc endp

mas_in proc  near;процедура перевода строки из буфера в целое число и помещение этого числа в массив
	                        xor    ax,ax;обнуляем ax для последующего использования
	                        mov    cx,ax;в ax тоже помещаю 0
	                        mov    cl,[si+1];в регистр cl помещаю длину буфера
	                        or     cx,cx;or нужен чтобы проверить не равна ли длина строки 0
	                        jz     end1;если длина строки 0, то перемещаемся на метку end1
	                        add    si,2;добавляем к si 2 т.к. начало введенной строки начинается со 2 индекса, 0 это тех информация, 1-для длины строки, а со 2 начинается сама строка

	perevod:        
	                        mov    bx,0Ah;в bx помещаем 10
	                        mul    bx;умножаем ax на bx
	                        xor    bx,bx;обнуляю bx
	                        mov    bl,[si];в регистр bl заношу символ из строки буфера
	                        sub    bl,30h;вычитаю 48, чтобы из символа ASCII получить цифру
	                        add    ax,bx;ax+bx
	                        inc    si;учеличиваю на 1 чтобы последовательно пройтись по строке
	                        loop   perevod; создаю цикл, чтобы пройтись по всей строке
	end1:                 
	                        mov    [di],ax;заношу получившееся число ax в массив
	                        retn
mas_in endp


out_ax proc	near;процедура перевода числа из ax в строку и последующий вывод строки в консоль
	                        mov    bx,0Ah;в bx помещаем 10
	                        xor    cx,cx;обнуляем cx для последующего цикла
	                        or     ax,ax
	to_str:        
	                        xor    dx,dx;обнуляю dx
	                        div    bx;делю ax на bx, остаток в dl
	                        add    dl,30h;вычитаю из остатка 48, чтобы получит число
	                        push   dx;в стек заношу dx
	                        inc    cx;увеличиваю cx для цикла str_output
	                        or     ax,ax;эта операция нужна для проверки, что ax все еще не 0
	                        jnz    to_str
	str_output:          
	                        pop    ax;извлекаю из стека значение ax
	                        int    29h;вывожу посимвольно при помощи цикла и значений cx, который бы увеличивали в цикле выше
	                        loop   str_output
	                        retn
out_ax endp
c_s ends
end begin
.model small
.stack 256
d_s segment
	mes1               db 'String[$'
	mes2               db ']=$'
	mas                db 32 dup (' ')
	newline            db 0Dh, 0Ah, '$'
	vowels             db 'AEIOUYaeioyu'
	consonants         db 'bBcCdDfFgGhHjJkKlLmMnNpPqQrRsStTvVwWxXyYzZ'
	mes_for_vowels     db 'Vowels in the entered line: $'
	mes_for_consonants db 'Consonants in the entered line: $'
	count              dw 0
d_s ends

c_s segment
	                  assume ds:d_s, cs:c_s
	begin:            
	                  mov    ax,d_s
	                  mov    ds,ax
	                  mov    es, ax
	                  mov    bp,5                  	;в bp помещаем 5 т.е.  кол-во элементов повторений
	input:            
	                  mov    ah,9                  	;эта и последующие 2 строки отвечают за вывод сообщения 'String['
	                  mov    dx,offset mes1
	                  int    21h
	                  mov    ax,5                  	;т.к. после  сообщения "String[' нам нужен номер строки, в ax помещаем значение 5
	                  sub    ax,bp                 	;ax-bp
	                  call   out_ax                	;вызываем процедуру, которая выводит регистр ax на экран
	                  mov    ah,9                  	;эта и последующие 2 строки отвечают за вывод сообщения ']='
	                  mov    dx,offset mes2
	                  int    21h
	                  mov    ah,10                 	;эта и 2 последующие строки отвечают за ввод строки в буфер в виде переменной mas
	                  mov    dx,offset mas
	                  int    21h
	                  call   new_proc              	;вызывается процедура перевода курсора на новую строку
	                  mov    si,offset mas         	;в si заношу адрес начала буфера
	                  mov    bx,count              	;в регистр bx заношу значение переменной count, в которой будет находиться кол-во гласных или согласных
	                  xor    bx,bx                 	;обнуляю bx
	                  mov    count,bx              	;в переменную count заношу обнуленный регистр bx, т.е. теперь в переменной count находится 0
	                  test   bp,1                  	;проверка строки
	                  jnz    chet                  	;нечетное, переход на метку chet
	                  jz     nechet                	;четное, переход на метку nechet
	nechet:           
	                  call   counter_vowels        	;вызываю процедуру подсчета кол-ва гласных, если строка нечетная
	                  mov    ah,9                  	;эта и последующие 2 строки выводят на экран сообщение 'Vowels in the entered line: '
	                  lea    dx, mes_for_vowels
	                  int    21h
	                  jmp    output                	;перемещаюсь на метку output
	chet:             
	                  call   counter_consonats     	;вызываю процедуру подсчета кол-ва согласных, если строка четная
	                  mov    ah,9                  	;эта и последующие 2 строки выводят на экран сообщение 'Consonants in the entered line: '
	                  lea    dx, mes_for_consonants
	                  int    21h
	output:           
	                  mov    ax,count              	;после вызова процедуры подсчета гласных или согласных в переменной counter находится их число, которое я заношу в ax
	                  call   out_ax                	;вызываю процедуру вывода значения из ax на экран
	                  call   new_proc              	;вызываю процедуру перехода на новую строку
	                  dec    bp                    	; bp-1
	                  jnz    input                 	;цикл, пока bp не станет равным нулю будет осуществляться ввод строк
	                  mov    ah,4Ch                	;эта и следующая строка отвечают за корректное завершение программы
	                  int    21h




counter_vowels proc  near                      		;процедура подсчета гласных в строке
	                  xor    cx, cx                	;обнуление cx
	                  mov    cl,[si+1]             	;в регистр cl помещаю длину буфера
	                  add    si,2                  	;добавляем к si 2 т.к. начало введенной строки начинается со 2 индекса, 0 это тех информация, 1-для длины строки, а со 2 начинается сама строка

	perevod:          
	                  xor    ax,ax                 	;обнуляю ax
	                  mov    al,[si]               	;в регистр al заношу символ из строки буфера
	                  call   check_vowel           	;вызываю процедуру, которая проверяет являеется ли введенный символ гласной буквой
	                  or     bl,bl                 	;для проверки флага т.е. регистра bl использую or
	                  jnz    counter               	;если bl>0 перехожу на метку counter, в которой увеличиваю переменную счетчика на 1
	back:             
	                  inc    si                    	;учеличиваю на 1 чтобы последовательно пройтись по строке
	                  loop   perevod               	; создаю цикл, чтобы пройтись по всей строке

	end1:             
	                  retn
	counter:          
	                  mov    bx,count              	;в регистр bx помещаю значение переменной count
	                  inc    bx                    	;увеличиваю bx на 1
	                  mov    count,bx              	;в переменную count заношу увеличенное значение bx на 1
	                  jmp    back                  	;перехожу на метку back
counter_vowels endp

counter_consonats proc  near                   		;процедура подсчета гласных в строке
	                  xor    cx, cx                	;обнуление cx
	                  mov    cl,[si+1]             	;в регистр cl помещаю длину буфера
	                  add    si,2                  	;добавляем к si 2 т.к. начало введенной строки начинается со 2 индекса, 0 это тех информация, 1-для длины строки, а со 2 начинается сама строка

	perevod1:         
	                  xor    ax,ax                 	;обнуляю ax
	                  mov    al,[si]               	;в регистр al заношу символ из строки буфера
	                  call   check_consonat        	;вызываю процедуру, которая проверяет являеется ли введенный символ согласной буквой
	                  or     bl,bl                 	;для проверки флага т.е. регистра bl использую or
	                  jnz    counter1              	;если bl>0 перехожу на метку counter1, в которой увеличиваю переменную счетчика на 1
	back1:            
	                  inc    si                    	;учеличиваю на 1 чтобы последовательно пройтись по строке
	                  loop   perevod1              	; создаю цикл, чтобы пройтись по всей строке

	end2:             
	                  retn
	counter1:         
	                  mov    bx,count              	;в регистр bx помещаю значение переменной count1
	                  inc    bx                    	;увеличиваю bx на 1
	                  mov    count,bx              	;в переменную count заношу увеличенное значение bx на 1
	                  jmp    back1                 	;перехожу на метку back
counter_consonats endp


out_ax proc	near                               		;процедура перевода числа из ax в строку и последующий вывод строки в консоль
	                  mov    bx,0Ah                	;в bx помещаем 10
	                  xor    cx,cx                 	;обнуляем cx для последующего цикла
	                  or     ax,ax
	to_str:           
	                  xor    dx,dx                 	;обнуляю dx
	                  div    bx                    	;делю ax на bx, остаток в dl
	                  add    dl,30h                	;вычитаю из остатка 48, чтобы получит число
	                  push   dx                    	;в стек заношу dx
	                  inc    cx                    	;увеличиваю cx для цикла str_output
	                  or     ax,ax                 	;эта операция нужна для проверки, что ax все еще не 0
	                  jnz    to_str
	str_output:       
	                  pop    ax                    	;извлекаю из стека значение ax
	                  int    29h                   	;вывожу посимвольно при помощи цикла и значений cx, который бы увеличивали в цикле выше
	                  loop   str_output
	                  retn

check_vowel proc near                          		; Процедура проверяет AL на гласную
	                  push   cx di                 	; в стек заношу 2 регистра cx и di
	                  xor    bl,bl                 	; BL = 0 , он будет выступать флагом, который имеет значение либо 0 т.е. буква не согласная или 1 т.е. буква согласная
	                  mov    cx,13                 	; всего гласных в строке
	                  lea    di,vowels             	; адрес строки
	                  repne  scasb                 	; Перебор строки vowels
	                  jcxz   next                  	; выйти, если не гласная
	                  inc    bl                    	; иначе: взводим флаг
	next:             pop    di cx                 	;из стека извлеку регистры di,cx
	                  ret
check_vowel endp

check_consonat proc	near                       		; Процедура проверяет AL на согласную
	                  push   cx di                 	; в стек заношу 2 регистра cx и di
	                  xor    bl,bl                 	; BL = 0 , он будет выступать флагом, который имеет значение либо 0 т.е. буква не согласная или 1 т.е. буква согласная
	                  mov    cx,43                 	; всего согласных в строке
	                  lea    di,consonants         	; адрес строки
	                  repne  scasb                 	; Перебор строки consonants
	                  jcxz   next1                 	; выйти, если не согласная
	                  inc    bl                    	; иначе: взводим флаг
	next1:            pop    di cx                 	; из стека извлеку регистры di,cx
	                  ret
check_consonat endp

new_proc proc	near                             		;процедура перевода курсора на новую строку
	                  mov    ah,9
	                  mov    dx,offset newline
	                  int    21h
	                  retn
new_proc endp
c_s ends
end begin
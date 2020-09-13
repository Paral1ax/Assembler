format PE GUI                            ; 32-разрядная консольная программа WINDOWS EXE
entry start                                  ; точка входа

include 'win32a.inc'

section '.idata' import data readable        ; секция импортируемых функций

library kernel,'kernel32.dll',\
        user,'user32.dll',\
        msvcrt,'msvcrt.dll'

import  kernel,\
        ExitProcess,'ExitProcess'

import  user,\
        MessageBox,'MessageBoxA',\
        wsprintf,'wsprintfA'

section '.data' data readable writeable      ; секция данных
resmsg  db 'Результат',0
fmt1    db '%u ',0
itog    db 13,10,'Итого: '
itoglen=$-itog
result  db 'Числа Каллена: '
        db 256 dup(0)
buf     db 16 dup(0)
section '.code' code readable executable     ; секция кода
start:                                       ; точка входа в программу
        stdcall callen,result+15                ;Вычислить числа Каллена
        stdcall [MessageBox],0,result,resmsg,0  ;вывести сообщение с результатом
ex:     stdcall [ExitProcess], 0;выход
;функция вычисления чисел Каллена и их количества
;соглашение вызова stdcall
;void callen(char *res);
callen:
        push ebp        ;Пролог функции
        mov ebp,esp
        push ebx        ;сохранить регистры по соглашению stdcall
        push esi
        push edi
        mov edi,[ebp+8] ;адрес результата
        xor ebx,ebx     ;n=0
lp:     mov eax,1       ;1
        mov cl,bl       ;n
        shl eax,cl      ;сдвигая влево 1 n раз получаем 2^n
        jc fin          ;если произошел перенос при старшем сдвиге, то закончить
        mul ebx         ;n*2^n
        test edx,edx    ;если старшие 32 бита произведения не равны 0
        jnz fin         ;то закончить
        inc eax         ;n*2^n+1
        jc fin          ;если произошел перенос, то закончить
        ccall [wsprintf],buf,fmt1,eax   ;преобразовать очередное число Каллена в строку
        mov esi,buf     ;адрес строки с числом
;добавить число к результату
append: lodsb           ;взять очередной символ числа
        test al,al      ;если конец числа
        jz m1           ;то закончить перенос
        stosb           ;записать символ в результат
        jmp append      ;продолжить копирование
m1:     inc ebx         ;n=n+1
        jmp lp          ;продолжить для следующего числа Каллена
fin:    mov ecx,itoglen ;длина сообщения итог
        mov esi,itog    ;его начало
        rep movsb       ;добавить сообщение к результату
        ccall [wsprintf],edi,fmt1,ebx   ;добавить общее количество чисел
        pop edi         ;восстановить регистры
        pop esi
        pop ebx
        pop ebp         ;Эпилог функции
        ret 4           ;выйти с очисткой переданного параметра


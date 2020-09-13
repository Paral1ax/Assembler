format PE GUI                            ; 32-��������� ���������� ��������� WINDOWS EXE
entry start                                  ; ����� �����

include 'win32a.inc'

section '.idata' import data readable        ; ������ ������������� �������

library kernel,'kernel32.dll',\
        user,'user32.dll',\
        msvcrt,'msvcrt.dll'

import  kernel,\
        ExitProcess,'ExitProcess'

import  user,\
        MessageBox,'MessageBoxA',\
        wsprintf,'wsprintfA'

section '.data' data readable writeable      ; ������ ������
resmsg  db '���������',0
fmt1    db '%u ',0
itog    db 13,10,'�����: '
itoglen=$-itog
result  db '����� �������: '
        db 256 dup(0)
buf     db 16 dup(0)
section '.code' code readable executable     ; ������ ����
start:                                       ; ����� ����� � ���������
        stdcall callen,result+15                ;��������� ����� �������
        stdcall [MessageBox],0,result,resmsg,0  ;������� ��������� � �����������
ex:     stdcall [ExitProcess], 0;�����
;������� ���������� ����� ������� � �� ����������
;���������� ������ stdcall
;void callen(char *res);
callen:
        push ebp        ;������ �������
        mov ebp,esp
        push ebx        ;��������� �������� �� ���������� stdcall
        push esi
        push edi
        mov edi,[ebp+8] ;����� ����������
        xor ebx,ebx     ;n=0
lp:     mov eax,1       ;1
        mov cl,bl       ;n
        shl eax,cl      ;������� ����� 1 n ��� �������� 2^n
        jc fin          ;���� ��������� ������� ��� ������� ������, �� ���������
        mul ebx         ;n*2^n
        test edx,edx    ;���� ������� 32 ���� ������������ �� ����� 0
        jnz fin         ;�� ���������
        inc eax         ;n*2^n+1
        jc fin          ;���� ��������� �������, �� ���������
        ccall [wsprintf],buf,fmt1,eax   ;������������� ��������� ����� ������� � ������
        mov esi,buf     ;����� ������ � ������
;�������� ����� � ����������
append: lodsb           ;����� ��������� ������ �����
        test al,al      ;���� ����� �����
        jz m1           ;�� ��������� �������
        stosb           ;�������� ������ � ���������
        jmp append      ;���������� �����������
m1:     inc ebx         ;n=n+1
        jmp lp          ;���������� ��� ���������� ����� �������
fin:    mov ecx,itoglen ;����� ��������� ����
        mov esi,itog    ;��� ������
        rep movsb       ;�������� ��������� � ����������
        ccall [wsprintf],edi,fmt1,ebx   ;�������� ����� ���������� �����
        pop edi         ;������������ ��������
        pop esi
        pop ebx
        pop ebp         ;������ �������
        ret 4           ;����� � �������� ����������� ���������


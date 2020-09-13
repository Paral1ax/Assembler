format PE console

include 'win32ax.inc'

.code

        start:

                MOV EAX, 10
                MOV EBX, 5
                ADD EAX, EBX
                MUL EBX
                invoke  MessageBox,HWND_DESKTOP, EBX

.end start
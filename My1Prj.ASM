include 'win32ax.inc'
.code

    start:

        invoke  MessageBox,HWND_DESKTOP,"Hello, its my first project",invoke GetCommandLine,MB_OK

        invoke ExitProcess, 0

.end start


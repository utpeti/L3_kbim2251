; Compile:
; nasm -f win32 L3_C_3_kbim2251_pascal.asm
; nlink L3_C_3_kbim2251_pascal.obj -lmio -o L3_C_3_kbim2251_pascal.exe

%include 'mio.inc'

global main

section .text

main:
    

    ret

section .data
    str_in_a db 'A: ', 0
    str_in_b db 'B: ', 0
    str_in_r db 'C: ', 0

section .bss
    str_a resb 256
    str_b resb 256
    str_r resb 256
; Compile:
; nasm -f win32 L3_A_kbim2251.asm
; nlink L3_A_kbim2251.obj -lmio -o L3_A_kbim2251.exe

%include 'mio.inc'

global main

section .text

read_hexadecimal:
    XOR eax, eax
    push ebx
    push ecx
    push edx
    XOR ebx, ebx
    XOR ecx, ecx
    XOR edx, edx

    .h_read_number:
    XOR eax, eax
    call mio_readchar
    cmp eax, 13
    je .h_endh
    cmp eax, '0'
    jl .h_error_nan
    cmp eax, '9'
    jg .h_correct_letter
    cmp eax, '9'
    jle .h_number

    .h_letter:
    cmp eax, 'F'
    jle .h_c_letter
    cmp eax, 'f'
    jle .h_nc_letter

    .h_number:
    call mio_writechar
    sub eax, '0'
    jmp .h_store

    .h_c_letter:
    sub eax, 55
    jmp .h_store

    .h_nc_letter:
    sub eax, 87
    jmp .h_store

    .h_store:
    push eax
    add ecx, 1
    jmp .h_read_number

    .h_correct_letter_wr:
    call mio_writechar
    jmp .h_letter

    .h_correct_letter:
    cmp eax, 'A'
    jl .h_error_nan
    cmp eax, 'F'
    jle .h_correct_letter_wr
    cmp eax, 'a'
    jl .h_error_nan
    cmp eax, 'f'
    jle .h_correct_letter_wr
    jmp .h_error_nan

    .h_endh:
    cmp ecx, 0
    je .h_end
    XOR eax, eax
    mov ebx, 1

    .h_process:
    pop edx
    sub ecx, 1
    imul edx, ebx
    add eax, edx
    imul ebx, 16
    cmp ecx, 0
    jne .h_process
    push eax
    jmp .h_end
    
    .h_error_nan:
    call read_error

    ret
    
    .h_end:
    mov eax, 13
    call mio_writechar
    mov eax, 10
    call mio_writechar
    XOR eax, eax
    pop eax
    pop edx
    pop ecx
    pop ebx

    ret

read_error:
    mov     al, 13
    call    mio_writechar
    mov     al, 10
    call    mio_writechar
    mov eax, str_h_error_nan
    call mio_writestr
    mov     al, 13
    call    mio_writechar
    mov     al, 10
    call    mio_writechar

    ret

write_binary:
    push eax
    push ebx
    push ecx
    push edx

    XOR ebx, ebx
    mov ebx, eax
    mov ecx, 32
    mov edx, 4

    .process:
    XOR eax, eax
    shl ebx, 1
    adc eax, 0
    add eax, '0'
    call mio_writechar
    dec ecx
    dec edx
    cmp edx, 0
    je .setfour
    .setfourend:
    cmp ecx, 0
    jne .process
    jmp .end

    .setfour:
    mov edx, 4
    mov al, ' '
    call mio_writechar
    jmp .setfourend

    .end:
    pop edx
    pop ecx
    pop ebx
    pop eax

ret

main:
    mov eax, str_firsthex
    call mio_writestr
    XOR eax, eax
    call read_hexadecimal
    push eax
    mov ebx, eax
    mov eax, str_decimal
    call mio_writestr
    mov eax, ebx
    call write_binary
    mov eax, 13
    call mio_writechar
    mov eax, 10
    call mio_writechar
    mov eax, str_secondhex
    call mio_writestr
    XOR eax, eax
    call read_hexadecimal
    push eax
    mov ebx, eax
    mov eax, str_decimal
    call mio_writestr
    mov eax, ebx
    call write_binary
    pop eax
    pop ebx
    add ebx, eax
    mov eax, 13
    call mio_writechar
    mov eax, 10
    call mio_writechar
    mov eax, str_sum
    call mio_writestr
    mov eax, ebx
    call write_binary

ret


section .data

    str_firsthex db 'First hexadecimal number of yours: ', 0
    str_secondhex db 'Second hexadecimal number of yours: ', 0
    str_decimal db 'In decimal: ', 0
    str_sum db 'The sum of them in decimal: ', 0
    str_h_error_nan db 'Hiba! Nem hexadecimalis szam.', 0

section .bss
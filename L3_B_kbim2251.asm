; Compile:
; nasm -f win32 L3_B_3_kbim2251.asm
; nlink L3_B_3_kbim2251.obj -lmio -o L3_B_3_kbim2251.exe

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
    ;mov edx, 4

    .process:
    XOR eax, eax
    shl ebx, 1
    adc eax, 0
    add eax, '0'
    call mio_writechar
    dec ecx
    dec edx
    ;cmp edx, 0
    ;je .setfour
    ;.setfourend:
    cmp ecx, 0
    jne .process
    ;jmp .end

    ;.setfour:
    ;mov edx, 4
    ;mov al, ' '
    ;call mio_writechar
    ;jmp .setfourend

    .end:
    pop edx
    pop ecx
    pop ebx
    pop eax

ret

main:
    mov eax, str_C
    call mio_writestr
    mov eax, str_ex
    call mio_writestr
    mov eax, 10
    call mio_writechar
    mov eax, 13
    call mio_writechar
    mov eax, str_A
    call mio_writestr
    call read_hexadecimal
    push eax ; stack: A
    mov eax, 10
    call mio_writechar
    mov eax, 13
    call mio_writechar
    mov eax, str_B
    call mio_writestr
    call read_hexadecimal
    push eax ; stack: A B
    mov eax, 10
    call mio_writechar
    mov eax, 13
    call mio_writechar
    pop ebx ;B, stack: A
    mov eax, str_C
    call mio_writestr
    call read_hexadecimal
    push eax ; stack: A, C
    mov eax, 10
    call mio_writechar
    mov eax, 13
    call mio_writechar
    push ebx ; stack: A, C, B
    pop ebx ;B stack: A, C
    pop ecx ;C stack: A
    pop eax ;A stack:
    push eax
    push ebx
    push ecx ;stack: A, B, C

    XOR edx, edx
    mov edx, 0xA0000000 ;101 solved

    push edx
    XOR ecx, ecx
    mov ecx, 0x000FFFFE
    AND ecx, ebx
    push ecx ;stack: A, B, C, edx
    XOR ecx, ecx
    mov ecx, 0xFFFFE000
    AND ecx, ebx
    XOR ebx, ebx
    pop eax ;stack : A, B, C
    shl eax, 12
    mov ebx, eax
    AND ebx, ecx
    mov eax, ebx
    shr eax, 3
    XOR ebx, ebx
    mov ebx, eax
    pop edx
    add edx, ebx ;B[19:1] AND B[31:13] solved
    mov eax, ebx
    call write_binary
     mov eax, 10
    call mio_writechar
    mov eax, 13
    call mio_writechar
    mov eax, 10
    call mio_writechar
    mov eax, 13
    call mio_writechar

    mov ebx, 0x000000E0
    pop ecx ;C stack: A, B
    push ecx ; stack: A, B, C
    mov eax, 0x000000F0
    AND ecx, eax
    XOR ecx, ebx
    push edx
    mov eax, ecx
    mov ecx, 0x4
    mul ecx
    mov ecx, eax
    add edx, ecx
    pop edx ;1110 XOR C[7:4] solved

    pop ecx ;C stack: A, B
    push ecx ; stack: A, B, C
    push edx
    mov ebx, 0x000001F0
    AND ecx, ebx
    mov ebx, 0x40
    mov eax, ecx
    mul ebx
    mov ecx, eax
    add edx, ecx
    pop edx ;C[11:7] solved

    pop ecx
    pop ebx
    pop eax ; stack:
    push ebx
    push eax
    push edx
    mov ebx, 0x02000000
    AND eax, ebx
    mov ebx, 0x2000000
    cdq
    div ebx
    push eax
    mov ebx, 0x00800000
    AND ecx, ebx
    mov ebx, 0x800000
    mov eax, ecx
    cdq
    div ebx
    pop ebx
    AND eax, ebx
    pop edx
    add edx, eax ;A[25:25] AND C[23:23] solved
    
    XOR eax, eax
    mov eax, str_A
    call mio_writestr
    pop eax
    call write_binary
    mov eax, 10
    call mio_writechar
    mov eax, 13
    call mio_writechar
    mov eax, str_B
    call mio_writestr
    pop eax
    call write_binary
    mov eax, 10
    call mio_writechar
    mov eax, 13
    call mio_writechar
    mov eax, str_r
    call mio_writestr
    mov eax, 10
    call mio_writechar
    mov eax, 13
    call mio_writechar
    mov eax, str_C
    call mio_writestr
    XOR eax, eax
    mov eax, edx
    call write_binary

    ret

section .data

    str_h_error_nan db 'Hiba! Nem hexadecimalis szam!', 0
    str_A db 'A = ', 0
    str_B db 'B = ', 0
    str_C db 'C = ', 0
    str_ex db '101, B[19:1] AND B[31:13], 1110 XOR C[7:4], C[11:7], A[25:25] AND C[23:23]', 0
    str_r db '==>', 0

section .bss
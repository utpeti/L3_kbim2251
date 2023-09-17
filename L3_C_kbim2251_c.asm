; Compile:
; nasm -f win32 L3_C_kbim2251_c.asm
; nlink L3_C_kbim2251_c.obj -lmio -o L3_C_kbim2251_c.exe

%include 'mio.inc'

global main

section .text

read_str_c:
    push ebx
    push ecx
    push edx

    XOR ebx, ebx
    mov ecx, eax
    XOR eax, eax

    .read_char:
    call mio_readchar
    call mio_writechar
    cmp eax, 13
    je .end
    mov [ebx + ecx], al
    inc ebx
    jmp .read_char

    .end:
    inc ebx
    mov al, 0
    mov [ecx + ebx], al
    mov eax, ecx

    pop edx
    pop ecx
    pop ebx
    ret

write_str_c:
    push eax
    push ebx
    push ecx
    push edx

    XOR ecx, ecx
    mov ebx, eax
    XOR edx, edx

    .display:
    XOR eax, eax 
    mov al, [ebx + edx]
    cmp al, 0
    je .end
    call mio_writechar
    inc edx
    cmp al, 0
    jne .display

    .end:
    pop edx
    pop ecx
    pop ebx
    pop eax

    ret

process_a: ;[ebx]
    push eax
    push ebx
    push ecx
    push edx

    XOR edx, edx
    XOR ecx, ecx
    XOR eax, eax

    mov cl, 0
    mov dh, 0
    jmp .letter

    .number:
    mov ah, 0
    mov al, dl
    add al, '0'
    push ecx
    mov cl, dh
    call construct_r_a
    inc dh
    pop ecx
    inc dl
    .letter:
    cmp ah, 3
    je .number
    mov al, [ebx + ecx]
    inc cl
    push ecx
    mov cl, dh
    call construct_r_a
    inc dh
    pop ecx
    inc ah
    cmp al, 0
    je .end
    jmp .letter

    .end:
    mov eax, str_r
    mov cl, dh
    add cl, 1
    mov dh, 0
    mov [eax + ecx], dh

    pop edx
    pop ecx
    pop ebx
    pop eax

    ret

construct_r_a: ;[al, ecx]
    push eax
    push ebx
    push ecx
    push edx
    
    mov ebx, str_r
    mov [ebx + ecx], al
    
    pop edx
    pop ecx
    pop ebx
    pop eax

    ret

main:
    mov eax, str_in_a
    call mio_writestr
    XOR eax, eax
    mov eax, str_a
    call read_str_c
    mov eax, 13
    call mio_writechar
    mov eax, 10
    call mio_writechar
    mov eax, 13
    call mio_writechar
    mov eax, 10
    call mio_writechar
    mov eax, str_in_b
    call mio_writestr
    XOR eax, eax
    mov eax, str_b
    call read_str_c
    mov eax, 13
    call mio_writechar
    mov eax, 10
    call mio_writechar
    mov eax, 13
    call mio_writechar
    mov eax, 10
    call mio_writechar

    mov ebx, str_a
    call process_a
    ;mov ebx, str_b
    ;call process_b

    mov eax, str_in_r
    call mio_writestr
    mov eax, str_r
    call write_str_c

    ret

section .data
    str_in_a db 'A: ', 0
    str_in_b db 'B: ', 0
    str_in_r db '[A betui harmas csoportokban, minden csoport utan egy szam, 0-tol kezdve egyesevel novekedve] + [minden betu B-bol ami elott szamjegy van, abc sorrendben (eloszor a nagybetuk, utana a kisbetuk)]: ', 0

section .bss
    str_a resb 256
    str_b resb 256
    str_r resb 256
; Compile:
; nasm -f win32 L3_C_kbim2251_pascal.asm
; nlink L3_C_kbim2251_pascal.obj -lmio -o L3_3_kbim2251_pascal.exe

%include 'mio.inc'

global main

section .text

read_str_pascal:
    push ebx
    push ecx
    push edx

    mov ebx, 1
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
    dec ebx
    mov [ecx], bl
    mov eax, ecx

    pop edx
    pop ecx
    pop ebx
    ret

write_str_pascal:
    push eax
    push ebx
    push ecx
    push edx

    XOR     ecx, ecx
    mov     ebx, eax
    mov     cl, [ebx]
    mov     edx, 1

    .display:
    XOR     eax, eax 
    mov     al, [ebx + edx]
    call    mio_writechar
    inc     edx
    loop    .display

    mov     eax, ebx

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
    inc dh
    push ecx
    mov cl, dh
    call construct_r_a
    pop ecx
    inc dl
    .letter:
    cmp ah, 3
    je .number
    inc cl
    inc dh
    mov al, [ebx + ecx]
    push ecx
    mov cl, dh
    call construct_r_a
    pop ecx
    inc ah
    cmp cl, [ebx]
    jg .end
    jmp .letter

    .end:
    mov eax, str_r
    add dl, [ebx]
    mov [eax], dl

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

process_b:
    push eax
    push ebx
    push ecx
    push edx

    XOR eax, eax
    XOR ecx, ecx
    XOR edx, edx

    push ebx
    mov ebx, str_r
    mov ah, [ebx]
    add ah, 1
    XOR ebx, ebx
    pop ebx
    mov al, 'A'
    jmp .ucase

    .addu:
    inc al
    mov cl, 0
    cmp al, 'Z'
    jg .lcaseprep

    .ucase:
    cmp cl, [ebx]
    jge .addu
    cmp dl, '0'
    jl .incu
    cmp dl, '9'
    jle .incskipu
    .incu:
    inc cl
    .incskipu:
    mov dl, [ebx + ecx]
    cmp dl, '0'
    jl .ucase
    cmp dl, '9'
    jg .ucase
    inc cl
    mov dl, [ebx + ecx]
    cmp dl, al
    je .addlett
    jmp .ucase

    .lcaseprep:
    XOR ecx, ecx
    XOR edx, edx

    mov al, 'a'
    jmp .lcase

    .addl:
    inc al
    mov cl, 0
    cmp al, 'z'
    jg .end

    .lcase:
    cmp al, 'a'
    jl .lcaseprep
    cmp cl, [ebx]
    jge .addl
    cmp dl, '0'
    jl .inc
    cmp dl, '9'
    jle .incskip
    .inc:
    inc cl
    .incskip:
    mov dl, [ebx + ecx]
    cmp dl, '0'
    jl .lcase
    cmp dl, '9'
    jg .lcase
    inc cl
    mov dl, [ebx + ecx]
    cmp dl, al
    je .addlett
    jmp .lcase

    .addlett:
    push ecx
    mov cl, ah
    call construct_r_a
    inc ah
    push ebx
    push edx
    XOR edx, edx
    mov dl, 1
    mov ebx, str_r
    add [ebx], dl
    pop edx
    pop ebx
    pop ecx
    cmp al, 'Z'
    jle .ucase
    jmp .lcase

    .end:

    mov eax, str_r
    add ah, [ebx]
    mov [eax], ah

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
    call read_str_pascal
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
    call read_str_pascal
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
    mov ebx, str_b
    call process_b

    mov eax, str_in_r
    call mio_writestr
    mov eax, str_r
    call write_str_pascal

    ret

section .data
    str_in_a db 'A: ', 0
    str_in_b db 'B: ', 0
    str_in_r db '[A betui harmas csoportokban, minden csoport utan egy szam, 0-tol kezdve egyesevel novekedve] + [minden betu B-bol ami elott szamjegy van, abc sorrendben (eloszor a nagybetuk, utana a kisbetuk)]: ', 0

section .bss
    str_a resb 256
    str_b resb 256
    str_r resb 256
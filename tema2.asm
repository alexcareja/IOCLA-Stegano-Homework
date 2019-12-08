%include "include/io.inc"

extern atoi
extern printf
extern exit

; Functions to read/free/print the image.
; The image is passed in argv[1].
extern read_image
extern free_image
; void print_image(int* image, int width, int height);
extern print_image

; Get image's width and height.
; Store them in img_[width, height] variables.
extern get_image_width
extern get_image_height

section .data
        use_str db "Use with ./tema2 <task_num> [opt_arg1] [opt_arg2]", 10, 0
        saying db "C'est un proverbe francais.", 0
        message_len db 27
  
section .rodata
        a db "-.", 0      

section .bss
    task:       resd 1
    img:        resd 1
    img_width:  resd 1
    img_height: resd 1

section .text
global main
main:
    ; Prologue
    ; Do not modify!
    push ebp
    mov ebp, esp

    mov eax, [ebp + 8]
    cmp eax, 1
    jne not_zero_param

    push use_str
    call printf
    add esp, 4

    push -1
    call exit

not_zero_param:
    ; We read the image. You can thank us later! :)
    ; You have it stored at img variable's address.
    mov eax, [ebp + 12]
    push DWORD[eax + 4]
    call read_image
    add esp, 4
    mov [img], eax

    ; We saved the image's dimensions in the variables below.
    call get_image_width
    mov [img_width], eax

    call get_image_height
    mov [img_height], eax

    ; Let's get the task number. It will be stored at task variable's address.
    mov eax, [ebp + 12]
    push DWORD[eax + 8]
    call atoi
    add esp, 4
    mov [task], eax

    ; There you go! Have fun! :D
    mov eax, [task]
    cmp eax, 1
    je solve_task1
    cmp eax, 2
    je solve_task2
    cmp eax, 3
    je solve_task3
    cmp eax, 4
    je solve_task4
    cmp eax, 5
    je solve_task5
    cmp eax, 6
    je solve_task6
    jmp done

solve_task1:
    mov eax, [img]
    push eax
    call bruteforce_singlebyte_xor
    add esp, 4
while_print_message:
    xor byte [edi], al
    movzx esi, byte [edi]
    cmp esi, 0
    je end_while_print_message
    PRINT_CHAR esi
    xor byte [edi], al
    add edi, 4
    jmp while_print_message
end_while_print_message:
    NEWLINE
    PRINT_DEC 1, al
    NEWLINE
    PRINT_DEC 4, ecx
    jmp done
    
solve_task2:
    mov eax, [img]
    push eax
    call bruteforce_singlebyte_xor
    add esp, 4
    mov edi, [img]
    push ecx
    mov ecx, 0
    ;decrypt
while_line2:
        cmp ecx, [img_height]
        je end_while_line2
        mov edx, 0
while_column2:
            cmp edx, [img_width]
            je end_while_column2
            ;PRINT_DEC 4, edx
            ;PRINT_STRING " "
            xor byte[edi], al
            movzx esi, byte[edi]
            ;PRINT_CHAR esi
            add edi, 4
            inc edx
            jmp while_column2
end_while_column2:
        inc ecx
        jmp while_line2
end_while_line2:
    ;calc index of my message
    pop ecx
    inc ecx
    push eax
    mov eax, [img_width]
    mul ecx
    mov edx,eax
    pop eax
    ;write message
    mov edi, [img]
    ;PRINT_CHAR edi
    mov bl, byte [saying]
    mov ecx, 0
while_write:
    mov  byte [edi + edx * 4], bl
    cmp ecx, [message_len]
    je end_while_write
    inc ecx
    mov bl, byte [saying + ecx]
    inc edx
    jmp while_write
end_while_write:
    
    ;calc new key
    mov cl, 2
    mul cl
    add ax, 3
    mov cl, 5
    div cl
    sub al, 4
    ;PRINT_DEC 1, al
    mov edi, [img]
    mov ecx, 0
    ;encrypt
while_line2_1:
        mov edx, 0
        cmp ecx, [img_height]
        je end_while_line2_1
while_column2_1:
            cmp edx, [img_width]
            je end_while_column2_1
            ;PRINT_DEC 4, edx
            ;PRINT_STRING " "
            movzx esi, byte[edi]
            ;PRINT_CHAR esi
            xor byte[edi], al
            add edi, 4
            inc edx
            jmp while_column2_1
end_while_column2_1:
        inc ecx
        jmp while_line2_1
end_while_line2_1:
    push dword [img_height]
    push dword [img_width]
    push dword [img]
    call print_image
    add esp, 12
    jmp done
    
solve_task3:
    mov ebx, [ebp + 12]
    push DWORD[ebx + 16]
    call atoi
    add esp, 4
    PRINT_DEC 4, eax
    mov edx, [ebp + 12]
    mov ebx, [edx + 12]
    mov edi, [img]
while_char_to_write:
    mov cl, byte [ebx]
    cmp cl, 'A'
    je write_A
    cmp cl, 'B'
    je write_B
    cmp cl, 'C'
    je write_C
    cmp cl, 'D'
    je write_D
    cmp cl, 'E'
    je write_E
    cmp cl, 'F'
    je write_F
    cmp cl, 'G'
    je write_G
    cmp cl, 'H'
    je write_H
    cmp cl, 'I'
    je write_I
    cmp cl, 'J'
    je write_J
    cmp cl, 'K'
    je write_K
    cmp cl, 'L'
    je write_L
    cmp cl, 'M'
    je write_M
    cmp cl, 'N'
    je write_N
    cmp cl, 'O'
    je write_O
    cmp cl, 'P'
    je write_P
    cmp cl, 'Q'
    je write_Q
    cmp cl, 'R'
    je write_R
    cmp cl, 'S'
    je write_S
    cmp cl, 'T'
    je write_T
    cmp cl, 'U'
    je write_U
    cmp cl, 'V'
    je write_V
    cmp cl, 'W'
    je write_W
    cmp cl, 'X'
    je write_X
    cmp cl, 'Y'
    je write_Y
    cmp cl, 'Z'
    je write_Z
    cmp cl, '1'
    je write_1    
    cmp cl, '2'
    je write_2
    cmp cl, '3'
    je write_3
    cmp cl, '4'
    je write_4
    cmp cl, '5'
    je write_5
    cmp cl, '6'
    je write_6
    cmp cl, '7'
    je write_7
    cmp cl, '8'
    je write_8
    cmp cl, '9'
    je write_9
    cmp cl, '0'
    je write_0
    cmp cl, ','
    je write_comma
    cmp cl, 0
    je end_while_char_to_write
after_writing:
    mov byte [edi + eax * 4], ' '
    inc eax
    inc ebx
    jmp while_char_to_write
end_while_char_to_write:
    mov cl, byte [ebx]
    PRINT_CHAR cl
    jmp done
    
solve_task4:
    
    jmp done
    
solve_task5:
    ; TODO Task5
    jmp done
    
solve_task6:
    ; TODO Task6
    jmp done

bruteforce_singlebyte_xor:
    push ebp
    mov ebp, esp
    mov edi, [ebp + 8]
    push edi
    xor eax, eax
    mov al, 1
while_key:
    pop edi
    push edi
    mov ecx, 0
while_line:
        cmp ecx, [img_height]
        je end_while_line
        mov edx, 0
        push edi
while_column:
            cmp edx, [img_width]
            je end_while_column
            xor byte[edi], al
            movzx esi, byte[edi]
            xor byte[edi], al
            cmp esi, 'r'
            push edi
            call verify_revient
            pop edi
            cmp edx, -1
            je end_while_key
            add edi, 4
            inc edx
            jmp while_column
end_while_column:
        add esp, 4
        inc ecx
        jmp while_line
end_while_line:
    cmp al, 0xFF
    je end_while_key
    inc al
    jmp while_key
end_while_key:
    pop edi
    leave
    ret
    
verify_revient:
    push ebp
    mov ebp, esp
    mov edi, [ebp + 8]
    add edi, 4
    xor byte [edi], al
    movzx esi, byte [edi]
    xor byte [edi], al
    cmp esi, 'e'
    jne leave_verify
    add edi, 4
    xor byte [edi], al
    movzx esi, byte [edi]
    xor byte [edi], al
    cmp esi, 'v'
    jne leave_verify
    add edi, 4
    xor byte [edi], al
    movzx esi, byte [edi]
    xor byte [edi], al
    cmp esi, 'i'
    jne leave_verify
    add edi, 4
    xor byte [edi], al
    movzx esi, byte [edi]
    xor byte [edi], al
    cmp esi, 'e'
    jne leave_verify
    add edi, 4
    xor byte [edi], al
    movzx esi, byte [edi]
    xor byte [edi], al
    cmp esi, 'n'
    jne leave_verify
    add edi, 4
    xor byte [edi], al
    movzx esi, byte [edi]
    xor byte [edi], al
    cmp esi, 't'
    jne leave_verify
    mov edx, -1
leave_verify:
    leave
    ret
    ; Free the memory allocated for the image.
done:
    push DWORD[img]
    call free_image
    add esp, 4

    ; Epilogue
    ; Do not modify!
    xor eax, eax
    leave
    ret
    

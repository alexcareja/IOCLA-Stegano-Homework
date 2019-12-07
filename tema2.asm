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
    jmp done
solve_task2:
    ; TODO Task2
    jmp done
solve_task3:
    ; TODO Task3
    jmp done
solve_task4:
    ; TODO Task4
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
    mov eax, [img_width]
    ;PRINT_DEC 4, eax
    ;PRINT_STRING " "
    mov eax, [img_height]
    ;PRINT_DEC 4, eax
    push edi
    mov al, 1
while_key:
    pop edi
    push edi
    mov ecx, 0
while_line:
        mov edx, 0
        push edi
while_column:
            xor byte[edi], al
            movzx esi, byte[edi]
            xor byte[edi], al
            cmp esi, 'r'
            push edi
            call verify_revient
            pop edi
            cmp edx, -1
            je end_while_key
            cmp edx, [img_width]
            je end_while_column
            add edi, 4
            inc edx
            jmp while_column
end_while_column:
        add esp, 4
        cmp ecx, [img_height]
        je end_while_line
        inc ecx
        jmp while_line
end_while_line:
    cmp al, 0xFF
    je end_while_key
    inc al
    jmp while_key
end_while_key:
    pop edi
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
    

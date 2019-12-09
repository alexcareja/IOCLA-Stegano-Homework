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

section .bss
    task:       resd 1
    img:        resd 1
    img_width:  resd 1
    img_height: resd 1
    lsb_string: resd 1
    
section .rodata
        a db ".-", 0
        b db "-...", 0
        c db "-.-.", 0
        d db "-..", 0
        e db ".", 0
        f db "..-.", 0
        g db "--.", 0
        h db "....", 0
        i db "..", 0
        j db ".---", 0
        k db "-.-", 0
        l db ".-..", 0
        m db "--", 0
        n db "-.", 0
        o db "---", 0
        p db ".--.", 0
        q db "--.-", 0
        r db ".-.", 0
        s db "...", 0
        t db "-", 0
        u db "..-", 0
        v db "...-", 0
        w db ".--", 0
        x db "-..-", 0
        y db "-.--", 0
        z db "--..", 0
        one db ".----", 0
        two db "..---", 0
        three db "...--", 0
        four db "....-", 0
        five db ".....", 0
        six db "-....", 0
        seven db "--...", 0
        eight db "---..", 0
        nine db "----.", 0
        zero db "-----", 0
        comma db "--..--", 0

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
    ;print the message
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
    ;print key and row
    NEWLINE
    PRINT_DEC 1, al
    NEWLINE
    PRINT_DEC 4, ecx
    jmp done
    
solve_task2:
    mov eax, [img]
    push eax
    ;get old_key and row
    call bruteforce_singlebyte_xor
    add esp, 4
    mov edi, [img]
    push ecx
    mov ecx, 0
    ;decrypt image
while_line2:
        cmp ecx, [img_height]
        je end_while_line2
        mov edx, 0
while_column2:
            cmp edx, [img_width]
            je end_while_column2
            xor byte[edi], al
            movzx esi, byte[edi]
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
            movzx esi, byte[edi]
            xor byte[edi], al
            add edi, 4
            inc edx
            jmp while_column2_1
end_while_column2_1:
        inc ecx
        jmp while_line2_1
end_while_line2_1:
    ;print result
    push dword [img_height]
    push dword [img_width]
    push dword [img]
    call print_image
    add esp, 12
    jmp done
    
solve_task3:
    mov ebx, [ebp + 12]
    push DWORD[ebx + 16]
    ;get index
    call atoi
    add esp, 4
    ;get message
    mov edx, [ebp + 12]
    mov ebx, [edx + 12]
    mov edi, [img]
    ;iterate string
while_char_to_write:
    mov cl, byte [ebx]
    ;switch character
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
    je write_one 
    cmp cl, '2'
    je write_two
    cmp cl, '3'
    je write_three
    cmp cl, '4'
    je write_four
    cmp cl, '5'
    je write_five
    cmp cl, '6'
    je write_six
    cmp cl, '7'
    je write_seven
    cmp cl, '8'
    je write_eight
    cmp cl, '9'
    je write_nine
    cmp cl, '0'
    je write_zero
    cmp cl, ','
    je write_comma
    ;if none of the above, then leave loop
    jmp end_while_char_to_write
after_writing:
    ;adding a space after every letter
    mov byte [edi + eax * 4], ' '
    ;increment both iterators for string and img
    inc eax
    inc ebx
    jmp while_char_to_write
end_while_char_to_write:
    ;overwrite last space with the null terminator
    dec eax
    mov byte [edi + eax * 4], 0
    ;print result
    push dword [img_height]
    push dword [img_width]
    push dword [img]
    call print_image
    add esp, 12
    jmp done
    
solve_task4:
    mov ebx, [ebp + 12]
    push DWORD[ebx + 16]
    ;get index
    call atoi
    add esp, 4
    ;get message
    mov edx, [ebp + 12]
    mov ebx, [edx + 12]
    push eax
    push ebx
    push dword [img]
    call lsb_encode
    add esp, 12
    ;print result
    push dword [img_height]
    push dword [img_width]
    push dword [img]
    call print_image
    add esp, 12
    jmp done
    
solve_task5:
    mov ebx, [ebp + 12]
    push DWORD[ebx + 12]
    ;get index
    call atoi
    add esp, 4
    ;get to index
    mov esi, [img]
    mov ebx, 4
    mul ebx
    add esi, eax
    sub esi, 4
    ;while not found '\0'
while_bytes_to_decrypt:
    call decrypt_byte
    cmp al, 0   ;if \0 is found then break
    je end_while_bytes_to_decrypt
    PRINT_CHAR al
    jmp while_bytes_to_decrypt
end_while_bytes_to_decrypt:
    jmp done
    
solve_task6:
    mov esi, [img]
    mov ecx, 1
while_line_in_img:
    mov eax, [img_width]
    mul ecx
    push ecx
    mov ecx, 4
    mul ecx
    pop ecx
    mov esi, [img]
    add esi, eax
    add esi, 4
    mov eax, [img_height]
    dec eax
    cmp ecx, eax
    je after_while_line_in_img
    mov edx, 2
while_column_in_img:
    mov al, byte [esi]
    movzx ax, al
    push edx
    mov edx, [img_width]
    mov bl, byte [esi + edx * 4]
    movzx bx, bl
    add ax, bx
    neg edx
    mov bl, byte [esi + edx * 4]
    movzx bx, bl
    add ax, bx
    mov bl, byte [esi - 4]
    movzx bx, bl
    add ax, bx
    mov bl, byte [esi + 4]
    movzx bx, bl
    add ax, bx
    mov bl, 5
    div bl
    ;PRINT_UDEC 1, al
    ;PRINT_STRING " "
    add esi, 4
    pop edx
    inc edx
    push eax
    cmp edx, [img_width]
    jl while_column_in_img
    ;NEWLINE
    inc ecx
    jmp while_line_in_img
after_while_line_in_img:

    ;write results from stack to img
    mov ecx, [img_height]
    sub ecx, 2
while_line_in_img_2:
    mov eax, [img_width]
    mul ecx
    push ecx
    mov ecx, 4
    mul ecx
    pop ecx
    mov esi, [img]
    add esi, eax    ;get to current line
    mov ebx, [img_width]
    mov eax, 4
    mul ebx
    add esi, eax    ;get to the first pixel from next line
    sub esi, 8      ;get to second last pixel from current line
    cmp ecx, 0
    je after_while_line_in_img_2
    mov edx, 2
while_column_in_img_2:
    pop eax
    mov byte [esi], al
    ;PRINT_UDEC 1, al
    sub esi, 4
    inc edx
    mov ebx, [img_width]
    cmp edx, ebx
    jl while_column_in_img_2
    ;NEWLINE
    dec ecx
    jmp while_line_in_img_2
after_while_line_in_img_2:
    ;print result
    push dword [img_height]
    push dword [img_width]
    push dword [img]
    call print_image
    add esp, 12
    jmp done

bruteforce_singlebyte_xor:
    push ebp
    mov ebp, esp
    mov edi, [ebp + 8]
    push edi
    xor eax, eax
    mov al, 1
    ;iterate through all possible keys until finding "revient"
while_key:
    pop edi
    push edi
    mov ecx, 0
    ;iterate through all pixels of the image
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
    ;check if next letters after 'r' are 'evient'
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
    
write_A:
    push a
    call encrypt_character
    add esp, 4
    jmp after_writing
    
write_B:
    push b
    call encrypt_character
    add esp, 4
    jmp after_writing
    
write_C:
    push c
    call encrypt_character
    add esp, 4
    jmp after_writing
    
write_D:
    push d
    call encrypt_character
    add esp, 4
    jmp after_writing
    
write_E:
    push e
    call encrypt_character
    add esp, 4
    jmp after_writing
    
write_F:
    push f
    call encrypt_character
    add esp, 4
    jmp after_writing
    
write_G:
    push g
    call encrypt_character
    add esp, 4
    jmp after_writing
    
write_H:
    push h
    call encrypt_character
    add esp, 4
    jmp after_writing
    
write_I:
    push i
    call encrypt_character
    add esp, 4
    jmp after_writing
    
write_J:
    push j
    call encrypt_character
    add esp, 4
    jmp after_writing
    
write_K:
    push k
    call encrypt_character
    add esp, 4
    jmp after_writing
    
write_L:
    push l
    call encrypt_character
    add esp, 4
    jmp after_writing
    
write_M:
    push m
    call encrypt_character
    add esp, 4
    jmp after_writing
    
write_N:
    push n
    call encrypt_character
    add esp, 4
    jmp after_writing
    
write_O:
    push o
    call encrypt_character
    add esp, 4
    jmp after_writing
    
write_P:
    push p
    call encrypt_character
    add esp, 4
    jmp after_writing
    
write_Q:
    push q
    call encrypt_character
    add esp, 4
    jmp after_writing
    
write_R:
    push r
    call encrypt_character
    add esp, 4
    jmp after_writing
    
write_S:
    push s
    call encrypt_character
    add esp, 4
    jmp after_writing
    
write_T:
    push t
    call encrypt_character
    add esp, 4
    jmp after_writing
    
write_U:
    push u
    call encrypt_character
    add esp, 4
    jmp after_writing
    
write_V:
    push v
    call encrypt_character
    add esp, 4
    jmp after_writing
    
write_W:
    push w
    call encrypt_character
    add esp, 4
    jmp after_writing
    
write_X:
    push x
    call encrypt_character
    add esp, 4
    jmp after_writing
    
write_Y:
    push y
    call encrypt_character
    add esp, 4
    jmp after_writing
    
write_Z:
    push z
    call encrypt_character
    add esp, 4
    jmp after_writing
    
write_zero:
    push zero
    call encrypt_character
    add esp, 4
    jmp after_writing
    
write_one:
    push one
    call encrypt_character
    add esp, 4
    jmp after_writing
    
write_two:
    push two
    call encrypt_character
    add esp, 4
    jmp after_writing
    
write_three:
    push three
    call encrypt_character
    add esp, 4
    jmp after_writing
    
write_four:
    push four
    call encrypt_character
    add esp, 4
    jmp after_writing
    
write_five:
    push five
    call encrypt_character
    add esp, 4
    jmp after_writing
    
write_six:
    push six
    call encrypt_character
    add esp, 4
    jmp after_writing
    
write_seven:
    push seven
    call encrypt_character
    add esp, 4
    jmp after_writing
    
write_eight:
    push eight
    call encrypt_character
    add esp, 4
    jmp after_writing
    
write_nine:
    push nine
    call encrypt_character
    add esp, 4
    jmp after_writing
    
write_comma:
    push comma
    call encrypt_character
    add esp, 4
    jmp after_writing
    
encrypt_character:
    push ebp
    mov ebp, esp
    mov esi, [ebp + 8]
    ;write morse the code given as parameter to the image
while_encrypt:
    mov dl, byte[esi]
    cmp dl, 0
    je leave_encrypt_character
    mov byte [edi + eax * 4], dl
    inc eax
    inc esi
    jmp while_encrypt
leave_encrypt_character:
    leave
    ret
    
lsb_encode:
    push ebp
    mov ebp, esp
    ;get img
    mov edi, [ebp + 8]
    ;get message
    mov esi, [ebp + 12]
    ;get index
    mov ecx, [ebp + 16]
    ;get edi to index
    mov eax, 4
    mul ecx
    add edi, eax
    sub edi, 4
    ;write each character to the image
while_chars_in_esi:
    ;get byte value of current char
    mov al, byte[esi]
    ;write current char in LSB encryption
    call write_byte
    ;if current byte was \0 then leave loop
    cmp byte [esi], 0
    je end_while_chars_in_esi
    inc esi
    jmp while_chars_in_esi
end_while_chars_in_esi:
    leave
    ret
    
    ;encrypts one byte as 8 bytes in the immage
write_byte:
    push ebp
    mov ebp, esp
    mov cl, 0
    push eax
while_cl_not_8:
    pop eax
    push eax
    cmp cl, 8
    je end_while_cl_not_8
    ;get the current bye in lsb position
    mov bl, byte[esi]
    mov dl, al
    shl dl, cl
    shr dl, 7
    ;get img pixel
    mov al, byte[edi]
    cmp dl, 0
    jg dl_one
    ;dl is 0
    mov dl, 0xFE
    and al, dl
    jmp after_dl_one
dl_one:
    ;dl is 1
    mov dl, 1
    or al, dl
after_dl_one:
    ;move result in img
    mov byte [edi], al
    add edi, 4
    inc cl
    jmp while_cl_not_8
end_while_cl_not_8:
    leave
    ret
    
    ;decrypts eight bytes into one byte (result in al)
decrypt_byte:
    push ebp
    mov ebp, esp
    mov cl, 0
    xor al, al
    ;for each byte get the lsb and add it to al
while_not_8_bits:
    ;shift al left to make space for the next bit
    shl al, 1
    mov dl, byte[esi]
    add esi, 4
    ;get only the lsb
    shl dl, 7
    shr dl, 7
    ;add lsb to al
    add al, dl
    inc cl
    cmp cl, 8
    jl while_not_8_bits
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
    

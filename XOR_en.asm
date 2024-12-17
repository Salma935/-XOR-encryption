.model small
.stack 100h

.data
    msg1 db 'Enter the text to encrypt: $ '    ; Prompt message
    msg2 db 'Encrypted text: $'              ; Encrypted text message
    buffer db 100, ?, 100 dup('$')           ; Input buffer: 100 max, 100 for output
    key db 1                                 ; XOR key

.code
main:
    ; Setup data segment
    mov ax, @data
    mov ds, ax

    ; Print "Enter the text to encrypt"
    mov ah, 09h
    lea dx, msg1
    int 21h

    ; Read input using function 0Ah
    lea dx, buffer
    mov ah, 0Ah
    int 21h

    ; Encrypt input using XOR key
    lea si, buffer + 2      ; Start of input text
    lea di, buffer + 2      ; Encrypted text stored in same buffer
    mov cl, buffer[1]       ; Length of the input text

encrypt_loop:
    mov al, [si]            ; Load character
    cmp al, 0Dh             ; Check for carriage return
    je done_encrypt         ; Exit loop if carriage return
    xor al, [key]           ; XOR character with key
    mov [di], al            ; Store encrypted character
    inc si                  ; Move to next character
    inc di
    loop encrypt_loop

done_encrypt:
    ; Add '$' terminator after encrypted text
    mov byte ptr [di], '$'

    ; Print "Encrypted text"
    mov ah, 09h
    lea dx, msg2
    int 21h

    ; Print encrypted text
    lea dx, buffer + 2
    mov ah, 09h
    int 21h

    ; Exit program
    mov ah, 4Ch
    int 21h
end main


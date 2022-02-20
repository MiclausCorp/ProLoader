;;
;;  hex.S
;;  Print Hexadecimal Values from Memory
;;
;;  Created by Miclaus Darius on 17/10/2020.
;;

;; Usage
;mov dx, [0x7c00 + 510]
;call .PRINT_HEX

; Print Hex Address to screen.
PRINT_HEX:
    push cx
    push di
    push bx

    mov si, HEX_PATTERN		    ; Load HEX_PATTERN memory location to si
    mov cl, 12
    mov di, 2

.HEX_LOOP:
    mov bx, dx			        ; copy dx to bx to preserve original hex value
    shr bx, cl			        ; Shift value in bx 12 bits (3 bytes) right
    and bx, 0x000f              ; mask first 3 digits
    mov bx, [bx + HEX_TABLE]	; load ascii character from HEX_TABLE into bx
    mov [HEX_PATTERN + di], bl	; insert byte bl into correct spot in HEX_PATTERN
    sub cl, 4                   ; change bits shifted in next iteration
    inc di                      ; add 1 to insertion location in HEX_PATTERN
  
    cmp di, 6                   ; since HEX_PATTERN.length = 5:
    je .exit                    ; exit the loop if di = 6

jmp .HEX_LOOP

.exit:
    call .HEX_INTERNAL_printf     ; print HEX_PATTERN which is now populated

    pop bx
    pop di
    pop cx
ret

.HEX_INTERNAL_printf:
    pusha
    .HEX_INTERNAL_str_loop:
        mov al, [si]
        cmp al, 0
        jne .HEX_INTERNAL_char
        popa
    ret

    .HEX_INTERNAL_char: 
        mov ah, 0x0e
        int 0x10
        add si, 1
        jne .HEX_INTERNAL_str_loop

;* Data *;
HEX_PATTERN: db '0x****', 0x0a, 0x0d, 0
HEX_TABLE: db '0123456789abcdef'
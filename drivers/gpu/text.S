;;
;;  text.S
;;  Graphics driver for outputting text
;;
;;  Created by Miclaus Darius on 18/10/2020.
;;

[bits 16]

PRINT:
    pusha
    str_loop:
        mov al, [si]
        cmp al, 0
        jne print_char
        popa
    ret

    print_char: 
        mov ah, 0x0e
        int 0x10
        add si, 1
        jmp str_loop

CLEAR:
    pusha
        mov ah, 0x00
        mov al, 0x03 
        int 0x10
        popa
    ret

DISABLE_CURSOR:
	pushf
	push eax
	push edx
 
	mov dx, 0x3D4
	mov al, 0xA	; low cursor shape register
	out dx, al
 
	inc dx
	mov al, 0x20	; bits 6-7 unused, bit 5 disables the cursor, bits 0-4 control the cursor shape
	out dx, al

	pop edx
	pop eax
	popf
ret
;;
;;  vga.S
;;  Visual Graphics Adapter Device Driver
;;
;;  Created by Miclaus Darius on 18/10/2020.
;;

[bits 64]

; Write to VGA Memory
PRINT64:
    VID_MEM equ 0xb8000
    mov edi, VID_MEM
    ; mov rax, 0x1f741f731f651f54
    mov [VID_MEM], rax

    ; Usage example: mov rax, 0x1f741f731f651f54
ret

; Fill VGA Memory
FILLSCREEN64:
    VID_MEM equ 0xb8000
    mov edi, VID_MEM
    mov ecx, 500
    ; Usage: mov rax, %VGA HEX CODE%
    ; Usage example: mov rax, 0x1f201f201f201f20
rep stosq
ret

; Fill Portion of VGA Memory
FILLPORTION64:
    VID_MEM equ 0xb8000
    mov edi, VID_MEM
    ;mov ecx, 500
    ; Usage: mov ecx, %Times%
    ; mov rax, %VGA HEX CODE%
rep stosq
ret

CURSOR:
VGA.Width equ 80
 
; Set Cursor Coordonates
.SET_CURSOR_COORDONATES64:
	; input bx = x, ax = y
	; modifies ax, bx, dx
	mov dl, VGA.Width
	mul dl
	add bx, ax

; Set Cursor Offset
.SET_CURSOR_OFFSET64:
	; input bx = cursor offset
	; modifies al, dx
	mov dx, 0x03D4
	mov al, 0x0F
	out dx, al
 
	inc dl
	mov al, bl
	out dx, al
 
	dec dl
	mov al, 0x0E
	out dx, al
 
	inc dl
	mov al, bh
	out dx, al
	ret
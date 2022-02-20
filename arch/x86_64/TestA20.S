;;
;;  testA20.S
;;  Test the A20 Line
;;
;;  Created by Miclaus Darius on 17/10/2020.
;;

[bits 16]
%include "drivers/memory/hex.S"

; This is the process used to figure out the offset for the magic
; number given the segment is 0xffff:
; 0xffff0 + offset = 0x107dfe
; offset = 0x107dfe - 0xffff0
; offset = 0x7e0e

TEST_A20:
   pusha

   mov ax, [0x7dfe]  ; 7dfe = 7c00+510 (memory location of magic number).
   
   push bx           ; create a reference to check for wrapping.
   mov bx, 0xffff
   mov es, bx        ; set es to zero.
   pop bx

   mov bx, 0x7e0e    ; set offset to 0x7e0e.

   mov dx, [es:bx]   ; print the contents located in the segment.

   cmp ax, dx        ; compare the segment to the reference
   je .CONTINUE      ; jump to .CONTINUE if ax = dx.

   popa              ; else popa
   mov ax, 1         ; set ax to 1 as a return value
   ret               ; and return.


; for this section, do the same as what was done above
; except shift the reference (and thus the offset) location
; one byte for confirmation
.CONTINUE:
   mov ax, [0x7dff]

   push bx
   mov bx, 0xffff
   mov es, bx
   pop bx

   mov bx, 0x7e0f
   mov dx, [es:bx]

   cmp ax, dx
   je .EXIT        ; EXIT if ax = dx

   popa
   mov ax, 1       ; else return
   ret

.EXIT:
   popa            ; popa
   xor ax, ax      ; set ax to 0 as return value
   ret             ; and return

;* Data *;
NO_A20 db "Error 2: No A20 Line for CPU"
A20_ENABLED: db 'A20 Line Enabled.', 0x0a, 0x0d, 0
;VID_MEM equ 0xb8000
;mov edi, VID_MEM
;mov rax, 0x1f201f201f201f20
;mov ecx, 500
;rep stosq

;mov rax, 0x1f741f731f651f54
;mov [VID_MEM], rax

; Set up Kernel Pre-load environment.
SETUP_KPRELOAD_ENVIRONMENT:
    push rax
    mov rax, 0x1f201f201f201f20
    mov ecx, 500
    call FILLSCREEN64
    pop rax

    mov rax, 0x1f741f731f651f54  ; Search on google something like "Text to Hex". Notice it has to be reversed and include 1f before every char due to endianess.
    mov [VID_MEM], rax
    call PRINT64
    pop rax

    call CURSOR
    hlt
    
  %include "drivers/gpu/vga.S"
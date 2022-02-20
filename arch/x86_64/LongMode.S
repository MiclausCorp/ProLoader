;;
;;  LongMode.S
;;  Checking Long Mode for 64 bit
;;
;;  Created by Miclaus Darius on 18/10/2020.
;;

[bits 16]

; Check if Long Mode is supported ;
CHECK_LONG_MODE:
    pusha
    pushfd
    pop eax
    mov ecx, eax

    xor eax, 1 << 21    ; Flipping the cpu ID

    push eax            ; Check if LM is supported
    popfd

    pushfd
    pop eax

    xor eax, ecx
    jz .DONE
    
    mov eax, 0x80000000 ; Check for comatibility
    cpuid
    cmp eax, 0x80000001
    jb .DONE

    mov eax, 0x80000001 ; Check if we can use extended memory
    cpuid
    test edx, 1 << 29
    jz .DONE
    mov si, YES_LM
    call PRINT
    popa
ret

.DONE: 
    popa
    mov si, NO_LM
    call PRINT
    jmp $


;* Data *;
NO_LM: db 'Error 3: No long mode support.', 0x0a, 0x0d, 0
YES_LM: db 'Long Mode supported.', 0x0a, 0x0d, 0
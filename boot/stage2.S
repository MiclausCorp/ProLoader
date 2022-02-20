;;
;;  stage2.S
;;  ProLoader Second Stage Loader
;;
;;  Created by Miclaus Darius on 17/10/2020.
;;

;* ProLoader 2nd Stage *;
BOOT_STAGE_2:
    call ENABLE_A20       ; Checking and Enabling the A20 Line.
    call CHECK_LONG_MODE  ; Check if we can go into 64-bit mode.

    call CLEAR            ; clear screen and reset cursor, easier to do in 16-bit mode.
    call SETUP_PAGING     ; Setup Memory Paging. Will automatically jump to 64-bit mode.

    jmp $                 ; Halt Execution if we didn't get to Long Mode.


;* Include Directive *;
%include "drivers/memory/paging.S"       ; Memory Paging
%include "arch/x86_64/EnableA20.S"       ; A20 Line Bus Manager
%include "arch/x86_64/LongMode.S"        ; 64-bit Long Mode Manager

;; 64-bit Long Mode Code ;;
LM_BOOTSTRAP:
    [bits 64]                      ; 64-bit Mode

    jmp SETUP_KPRELOAD_ENVIRONMENT ; Now let's jump and start loading Kernel Preload environment
    %include "environment/kPreLoadEnvironment.S"    ; Include ProShell placeholder environment

    jmp $                          ; Halt execution
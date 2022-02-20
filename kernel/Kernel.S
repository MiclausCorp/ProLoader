;;
;;  kernel.S
;;  Main Loader Kernel mock
;;
;;  Created by Miclaus Darius on 18/10/2020.
;;

%DEFINE OS_VER '1.0'

[bits 64]
PRINT64:
    call PRINT64
ret

%include "drivers/gpu/text.S"
%include "drivers/gpu/vga.S"
%include "drivers/memory/hex.S"
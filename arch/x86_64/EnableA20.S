;;
;;  EnableA20.S
;;  Enabling the A20 Line
;;
;;  Created by Miclaus Darius on 17/10/2020.
;;

[bits 16]
%include "arch/x86_64/TestA20.S"
%include "drivers/gpu/text.S"

; Enable the A20 bus line ;
ENABLE_A20:
  pusha
  
  ; BIOS Method of enabling the A20 line
  mov ax, 0x2401 
  int 0x15

  call TEST_A20     ; test to see if BIOS method worked
  cmp ax, 1
  je .DONE         ;if it did, jump to .DONE

  ; Keyboard Method of enabling the A20 line
  sti

  call WAIT_CONTROLLER        ; wait for controller to accept command
  mov al, 0xad      ; 0xad is the disable keyboard command
  out 0x64, al      ; send the command to port 0x64 (command port)

  call WAIT_CONTROLLER
  mov al, 0xd0      ; 0xd0 is the command that allows us to read from the controller
  out 0x64, al

  call WAIT_DATA        ; wait for controller data to be ready
  in al, 0x60       ; store data from port 0x60 (data port) in al
  push ax           ; push to the stack for later

  call WAIT_CONTROLLER
  mov al, 0xd1      ; 0xd1 command tells the controller we want to write data to it
  out 0x64, al

  call WAIT_CONTROLLER
  pop ax            ; pop data from stack
  or al, 2          ; mask bit #2
  out 0x60, al      ; send to controller through data port

  call WAIT_CONTROLLER
  mov al, 0xae      ; 0xae enabled the keyboard
  out 0x64, al

  call WAIT_CONTROLLER

  sti

  call TEST_A20
  cmp ax, 1
  je .DONE

  ; Fast A20 Method of enabling the A20 line
  in al, 0x92       ; read data through port 0x92 (chipset)
  or al, 2          ; mask bit 2
  out 0x92, al      ; send data back to chipset

  call TEST_A20
  cmp al, 1
  je .DONE

  ; Failed to load A20 Bus. Hang.
  mov si, NO_A20
  call PRINT
  jmp $

.DONE:
  mov si, A20_ENABLED
  call PRINT
  popa
  ret

WAIT_CONTROLLER:      ; wait for controller to accept commands
  in al, 0x64         ; get status from command port
  test al, 2          ; is bit2 of al = 1?
                      ; 1 = busy, 0 = ready
  jnz WAIT_CONTROLLER ; if it is (jump if not equal to zero), try again
ret

WAIT_DATA:      ; wait for controller to have data to read
  in al, 0x64   ; get status from command port
  test al, 1    ; is bit1 of al = 1?
                ; 0 = empty, 1 = full
  jz WAIT_DATA  ; if data is empty try again (jump if zero)
ret

DISABLE_A20:
    mov ax, 0x2400
    int 0x15
ret
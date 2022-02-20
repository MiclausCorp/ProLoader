;;
;;  entry.S
;;  ProLoader First Stage Loader
;;
;;  Created by Miclaus Darius on 17/10/2020.
;;

[ORG 0x7c00]
[bits 16]

OEMLabel		db "PROLOADER"	    ; Disk label
VolumeLabel		db "PROLOADER     " ; Volume Label: any 11 chars

jmp short INIT
nop

; Pre-INITialization code.
INIT:
    cli                ; Clear Intrerupts
    jmp 0x0000:ZeroSeg ; Flush Segments set by weird Bios'es

; Flush BIOS Segments.
ZeroSeg:
    xor ax, ax; mov ax, 0
    mov ss, ax
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov sp, INIT
    cld
sti

; Initialize disk  
push ax
xor ax, ax
int 0x13
pop ax

; Clear Screeen
call CLEAR_SCREEN

; Print Input Strings
mov si, INFO_STRING
call WRITE

; Print Start from HDD Strings
mov si, START_HD
call WRITE

; Print Start from USB Strings
mov si, START_USB
call WRITE

; Move cursor to Last Position
mov bl, 0h 
mov cl, 0h

; Start waiting for input.
SCAN:
    mov ah, 02h
    mov dl, bl
    mov dh, cl
    mov ah, 00h
    int 16h

    ; user pressed "1"
    cmp al, '1'
    je READ_DISK_HDD

    ; user pressed "2" 
    cmp al, '2'
    je READ_DISK_USB
    
    ; Nothing pressed
    jmp SCAN

jmp $

; Read 2nd sector from HDD
READ_DISK_HDD:
    pusha
    mov ah, 0x02
    mov dl, 0x80 ;0x0 for USBs and Floppys
    mov ch, 0
    mov dh, 0
    mov al, 2 ; If we have an error in later stages, we increase this
    mov cl, 2

    push bx
    mov bx, 0
    mov es, bx
    pop bx
    mov bx, 0x7c00 + 512
    
    int 0x13

    jc DISK_ERR
    popa
    call BOOT_STAGE_2
ret

; Read 2nd sector from Floppys / USBs
READ_DISK_USB:
    pusha
    mov ah, 0x02
    mov dl, 0x0 ;0x80 for HDDs
    mov ch, 0
    mov dh, 0
    mov al, 2 ; If we have an error in later stages, we increase this
    mov cl, 2

    push bx
    mov bx, 0
    mov es, bx
    pop bx
    mov bx, 0x7c00 + 512
    
    int 0x13

    jc DISK_ERR
    popa
    call BOOT_STAGE_2
ret

; Print Disk Error
DISK_ERR:
    mov si, DISK_ERR_MSG
    call WRITE
    jmp $

; Low Level PRINT
WRITE:
    pusha
    SLOOP:
        mov al, [si]
        cmp al, 0
        jne WRITE_CHAR
        popa
    ret

WRITE_CHAR: 
        mov ah, 0x0e
        int 0x10
        add si, 1
        jmp SLOOP

; Low level clear screen
CLEAR_SCREEN:
    pusha
        mov ah, 0x00
        mov al, 0x03  ; text mode 80x25 16 colours
        int 0x10
        popa
    ret

; ** Text Data **
DISK_ERR_MSG db "Error 1: Cannot Read 2nd Sector", 0x0a, 0x0d, 0
INFO_STRING db 'Choose a Startup Option:', 13, 10, 0
START_HD db '1) Start in HDD Mode', 13, 10, 0
START_USB db '2) Start in USB/Floppy Mode', 13, 10, 0

; Padding and key
times 510-($-$$) db 0
dw 0xaa55

; 2nd stage loader
%include "boot/stage2.S"
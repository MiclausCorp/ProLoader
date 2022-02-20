;;
;;  paging.S
;;  Paging Address Extension in Memory
;;
;;  Created by Miclaus Darius on 18/10/2020.
;;

%include "drivers/memory/gdt.S"

SETUP_PAGING:
  ; clearing table
  cli

  mov edi, 0x1000
  mov cr3, edi
  xor eax, eax
  mov ecx, 4096
  rep stosd
  mov edi, 0x1000

  ;PML4T -> 0x1000
  ;PDPT -> 0x2000
  ;PDT -> 0x3000
  ;PT -> 0x4000

  mov dword [edi], 0x2003
  add edi, 0x1000
  mov dword [edi], 0x3003
  add edi, 0x1000
  mov dword [edi], 0x4003
  add edi, 0x1000

  mov dword ebx, 3
  mov ecx, 512

.SET_ENTRY:
  mov dword [edi], ebx
  add ebx, 0x1000
  add edi, 8
  loop .SET_ENTRY

  mov eax, cr4
  or eax, 1 << 5
  mov cr4, eax

  mov ecx, 0xc0000080
  rdmsr
  or eax, 1 << 8
  wrmsr

  mov eax, cr0
  or eax, 1 << 31
  or eax, 1 << 0
  mov cr0, eax

  lgdt [GDT.Pointer]          ; Load the GDT
  jmp GDT.Code:LM_BOOTSTRAP   ; Jump to Long Mode Bootstrapper
ret

  

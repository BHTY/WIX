struc SYS_VECTOR 
  .dispatch:       resd    1 
  .n_args:         resd    1
endstruc

struc CONTEXT
    .edi:           resd 1
    .esi:           resd 1
    .ebp:           resd 1
    .esp:           resd 1
    .ebx:           resd 1
    .edx:           resd 1
    .ecx:           resd 1
    .eax:           resd 1
    .eflags:        resd 1
endstruc

extern syscall_table

; __cdecl int syscall_trap(int_state_t* state)
global syscall_trap
syscall_trap:
    push ebp
    mov ebp, esp
    mov eax, [ebp+0x8] ; EAX = state
    mov edx, [eax+CONTEXT.eax] ; EDX = state->eax

    mov ecx, [syscall_table + edx * 8 + SYS_VECTOR.n_args]
    mov ebx, [syscall_table + edx * 8 + SYS_VECTOR.dispatch]

    cmp ecx, 6
    je .six_args
    cmp ecx, 5
    je .five_args
    cmp ecx, 4
    je .four_args
    cmp ecx, 3
    je .three_args
    cmp ecx, 2
    je .two_args
    cmp ecx, 1
    je .one_arg
.no_args:
    call ebx
    pop ebp
    ret
.six_args:
    push dword  [eax + CONTEXT.ebp]
    push  dword [eax + CONTEXT.edi]
    push  dword [eax + CONTEXT.esi]
    push dword  [eax + CONTEXT.edx]
    push dword  [eax + CONTEXT.ecx]
    push dword  [eax + CONTEXT.ebx]
    call ebx
    add esp, 0x18
    pop ebp
    ret
.five_args:
    push dword  [eax + CONTEXT.edi]
    push  dword [eax + CONTEXT.esi]
    push dword  [eax + CONTEXT.edx]
    push dword  [eax + CONTEXT.ecx]
    push dword  [eax + CONTEXT.ebx]
    call ebx
    add esp, 0x14
    pop ebp
    ret
.four_args:
    push dword  [eax + CONTEXT.esi]
    push dword  [eax + CONTEXT.edx]
    push dword  [eax + CONTEXT.ecx]
    push dword  [eax + CONTEXT.ebx]
    call ebx
    add esp, 0x10
    pop ebp
    ret
.three_args:
    push dword [eax + CONTEXT.edx]
    push dword [eax + CONTEXT.ecx]
    push dword [eax + CONTEXT.ebx]
    call ebx
    add esp, 0x0C
    pop ebp
    ret
.two_args:
    push dword [eax + CONTEXT.ecx]
    push dword [eax + CONTEXT.ebx]
    call ebx
    add esp, 0x08
    pop ebp
    ret
.one_arg:
    push dword [eax + CONTEXT.ebx]
    call ebx
    add esp, 0x04
    pop ebp
    ret

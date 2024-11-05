struc TASK 
  .esp:        resd    1 
  .next:       resd    1 
  .prev:       resd    1 
endstruc

extern cur_task
global task_switch


; void task_switch(int_state_t*)
task_switch:
    mov edx, [esp+4]

    ; Save state of current thread
    push dword [edx+0x20] ; eflags
    push dword [edx+0x1C] ; eax
    push dword [edx+0x18] ; ecx
    push dword [edx+0x14] ; edx
    push dword [edx+0x10] ; ebx
    push ebp ; ebp
    push dword [edx+0x04] ; esi
    push dword [edx+0x00] ; edi

    mov edi, [cur_task]
    mov [edi+TASK.esp], esp

    ; Load state of next task
    mov esi, [edi+TASK.next]
    mov [cur_task], esi

    mov esp, [esi+TASK.esp]

    pop edi
    pop esi
    pop ebp
    pop ebx
    pop edx
    pop ecx
    pop eax
    popfd

    ret

extern jump_usermode

global thread_fun_1
thread_fun_1:
    push 0
    push thread_fun_1_3
    call jump_usermode

    mov ecx, 0x10101010
    mov al, 'P'
.fun_1_loop:
    mov [0xb8002], al
    jmp .fun_1_loop
    jmp $

thread_fun_1_3:
    jmp $

global thread_fun_2
thread_fun_2:
    inc byte [0xb8004]
    jmp thread_fun_2
    jmp $


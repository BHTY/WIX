extern cur_task
global task_switch

task_switch:
    ; Save state of current thread
    pushfd
    push ebx
    push esi
    push edi
    push ebp

    mov edi, [cur_task]
    mov [edi], esp

    ; Load state of next task
    mov esi, [edi+4]
    mov [cur_task], esi

    mov esp, [esi]

    pop ebp
    pop edi
    pop esi
    pop ebx
    popfd

    ret
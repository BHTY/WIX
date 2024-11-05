global jump_usermode
jump_usermode:
    ;int 0x80

    ;cli
	mov ax, (4 * 8) | 3 ; ring 3 data with bottom 2 bits set for ring 3
	mov ds, ax
	mov es, ax 
	mov fs, ax 
	mov gs, ax ; SS is handled by iret

    ;jmp $

	; set up the stack frame iret expects
	mov eax, esp
	push (4 * 8) | 3 ; data selector
	push eax ; current esp
	pushf ; eflags
	push (3 * 8) | 3 ; code selector (ring 3 code with bottom 2 bits set for ring 3)
	push test_user_function ; instruction address to return to
	iret

test_user_function:
    inc byte [0xb8000]
    mov eax, 0xDEADBEEF
    int 0x80
    ;not eax
    int 0x80
    mov eax, 0xCAFEBABE
    int 0x80
    jmp test_user_function
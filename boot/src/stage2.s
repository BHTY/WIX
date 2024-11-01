[org 0x7e00]
[bits 16]

push welcome_msg
call puts

cli
lgdt [GDT_Descriptor]
mov eax, cr0
or eax, 1
mov cr0, eax

jmp CODE_SEG:start_protected_mode

jmp $

CODE_SEG equ code_descriptor - GDT_Start
DATA_SEG equ data_descriptor - GDT_Start

GDT_Start:
	null_descriptor:
		dd 0
		dd 0
	code_descriptor:
		dw 0xffff
		dw 0
		db 0
		db 0x9a
		db 0xcf
		db 0
	data_descriptor:
		dw 0xffff
		dw 0
		db 0
		db 0x92
		db 0xcf
		db 0
	GDT_End:

GDT_Descriptor:
	dw GDT_End - GDT_Start - 1 ;size
	dd GDT_Start ;start

puts: 
    push bp
    mov bp, sp
    mov si, word [bp+4]

    puts_loop:
        mov al, byte [si]
        inc si
        cmp al, 0
        je puts_done
        mov ah, 0x0e
        int 0x10
        jmp puts_loop

    puts_done:
        pop bp
        ret 0x2

[bits 32]
start_protected_mode:
	mov ax, DATA_SEG
	mov ds, ax
	mov ss, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov ebp, 0x7C00
	mov esp, ebp

    mov byte [0xb8000], 'A'

    jmp $

welcome_msg: db "Welcome to stage 2!", 0
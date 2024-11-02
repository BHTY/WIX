[org 0x7e00]
[bits 16]

push welcome_msg
call puts

mov ah, 0x88
int 0x15
mov word [mem_size], ax

push ax
call print_int

push mb_msg
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

print_int:
    push bp
    mov bp, sp
    mov ax, word [bp+4]
    xor dx, dx
    mov cx, 0x1000
    mov bx, charset

    print_int_loop:
        div cx
        mov ah, 0x0e
        xlat
        int 0x10
        mov ax, dx
        xor dx, dx
        shr cx, 4
        cmp cx, 0
        jne print_int_loop

    pop bp
    ret 0x2

charset: db "0123456789ABCDEF"

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

    mov eax, 0x31007
    mov [0x30000], eax

    call fill_pt

    mov eax, 0x30000
    mov cr3, eax
    mov eax, cr0
    or eax, 0x80000001
    mov cr0, eax

    mov byte [0xb8000], 'B'

    jmp $

fill_pt:
    xor eax, eax

    fill_pt_loop:
        mov ebx, eax
        shl ebx, 12
        or ebx, 7
        mov [eax * 4 + 0x31000], ebx

        inc eax
        cmp eax, 256
        jne fill_pt_loop
    
    ret

welcome_msg: db "Welcome to stage 2!", 0x0a, 0x0d, 0
mb_msg: db " KB DETECTED", 0x0a, 0x0d, 0

kernel_sectors: dw 0
ramdisk_sectors: dw 0
mem_size: dw 0
[org 0x7e00]
[bits 16]

push bp
mov bp, sp

mov bx, word [bp+4] ; ramdisk_sectors
mov word [ramdisk_sectors], bx
mov bx, word [bp+6] ; kernel_sectors
mov word [kernel_sectors], bx

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

CODE_SEG equ kernel_code_descriptor - GDT_Start
DATA_SEG equ kernel_data_descriptor - GDT_Start

GDT_Start:
	null_descriptor:
		dd 0
		dd 0
	kernel_code_descriptor:
		dw 0xffff
		dw 0
		db 0
		db 0x9a
		db 0xcf
		db 0
	kernel_data_descriptor:
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

[bits 32]
start_protected_mode:
	mov ax, DATA_SEG
	mov ds, ax
	mov ss, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov ebp, 0xA0000;0x7C00
	mov esp, ebp

    mov byte [0xb8000], 'A'

    mov dword [0x80000], 0x81007
    mov dword [0x80800], 0x82007

    call fill_pt

    call map_kernel

    ; enable paging
    mov eax, 0x80000
    mov cr3, eax
    mov eax, cr0
    or eax, 0x80000001
    mov cr0, eax

    mov byte [0xb8000], 'B'

    movsx eax, word [mem_size]
    push eax
    push test_str
    call printf

    push kernel_sectors
    call 0x10000

    jmp $

map_kernel:
    xor eax, eax

    map_kernel_loop:
        mov ebx, eax
        shl ebx, 12
        add ebx, 0x10000
        or ebx, 7
        mov [eax * 4 + 0x82000], ebx

        inc eax
        cmp eax, 16
        jne map_kernel_loop

    ret

fill_pt:
    xor eax, eax

    fill_pt_loop:
        mov ebx, eax
        shl ebx, 12
        or ebx, 7
        mov [eax * 4 + 0x81000], ebx

        inc eax
        cmp eax, 256
        jne fill_pt_loop
    
    ret

test_str: db "Hello from Protected Mode! %x KB Memory", 0x0a, 0

print_dec:
print_hex:
    push ebp
    mov ebp, esp
    mov eax, dword [ebp+0x8]
    xor edx, edx
    mov ecx, 0x10000000
    mov ebx, charset

    print_hex_loop:
        div ecx
        xlat
        push edx
        push eax
        call putc
        pop edx
        mov eax, edx
        xor edx, edx
        shr ecx, 4
        cmp ecx, 0
        jne print_hex_loop

    pop ebp
    ret 0x4

printf: ; cdecl
    push ebp
    mov ebp, esp
    mov ecx, 1

    printf_loop:
        mov eax, dword [ebp+0x8]
        mov al, byte [eax]
        inc dword [ebp+0x8]
        cmp al, 0
        je printf_done
        cmp al, '%'
        je printf_format
        push eax
        call putc
        jmp printf_loop

        printf_format:
            mov eax, dword [ebp+0x8]
            mov al, byte [eax]
            push ecx
            push dword [ebp+0x8+ecx*4]

            cmp al, 'c'
            je printf_char
            cmp al, 's'
            je printf_str
            cmp al, 'x'
            je printf_hex
            push '%'
            call putc
            pop ecx
            jmp printf_loop

            printf_char:
                call putc
                jmp printf_format_done

            printf_str:
                call puts32
                jmp printf_format_done

            printf_hex:
                call print_hex
                jmp printf_format_done

            printf_format_done:
                pop ecx
                inc ecx
                inc dword [ebp+0x8]
        
        jmp printf_loop

    printf_done:
        pop ebp
        ret

%macro outb 2
    mov dx, %1
    mov al, %2
    out dx, al
%endmacro

set_cursor:
    outb 0x3d4, 14
    mov eax, dword [vp_pos]
    shr eax, 8
    outb 0x3d5, al
    outb 0x3d4, 15
    mov eax, dword [vp_pos]
    outb 0x3d5, al
    ret

scroll:
    mov ebx, 0
    scroll_loop:
        mov eax, ROWS*2
        mul ebx
        add eax, VIDEO_PTR

        mov edi, eax
        mov esi, edi
        add esi, ROWS*2
        
        mov ecx, ROWS / 2
        rep movsd
        inc ebx
        cmp ebx, ROWS
        jl scroll_loop

    mov eax, 0
    mov edi, VIDEO_PTR + (COLUMNS-1)*ROWS*2
    rep stosd
    ret

puts32:
    push ebp
    mov ebp, esp

    puts32_loop:
        mov esi, dword [ebp+0x8]
        mov al, byte [esi]
        cmp al, 0
        je puts32_done
        push eax
        call putc
        inc dword [ebp+0x8]
        jmp puts32_loop

    puts32_done:
    pop ebp
    ret 0x4

putc:
    push ebp
    mov ebp, esp

    mov dx, SERIAL_PORT+5
   
    wait_transmit_empty:
        in al, dx
        test al, 0x20
        je wait_transmit_empty

    mov al, byte [ebp+0x8]
    mov dx, SERIAL_PORT
    out dx, al

    pop ebp
    ret 0x4

putc_vga:
    push ebp
    mov ebp, esp

    mov al, byte [ebp+0x8]

    cmp al, 0xa
    je newline

    ; place character into video buffer
    mov esi, dword [vp_pos]
    mov byte [VIDEO_PTR+esi*2], al
    mov al, byte [current_attr]
    mov byte [VIDEO_PTR+esi*2+1], al
    inc dword [vp_pos]
    jmp after_newline

newline:
    xor edx, edx
    mov eax, dword [vp_pos]
    mov ebx, ROWS
    div ebx
    sub dword [vp_pos], edx
    add dword [vp_pos], ROWS

after_newline:
    cmp dword [vp_pos], SCREEN_SIZE
    jl end_putc
    sub dword [vp_pos], ROWS
    call scroll

end_putc:
    call set_cursor

    pop ebp
    ret 0x4

welcome_msg: db "Welcome to stage 2! I love Nicole!", 0x0a, 0x0d, 0
mb_msg: db " KB DETECTED", 0x0a, 0x0d, 0

charset: db "0123456789ABCDEF"

kernel_sectors: dw 0xBEEF
ramdisk_sectors: dw 0xDEAD
mem_size: dw 0xBEEF
dw 0
printf_addr: dd printf

SERIAL_PORT equ 0x3F8

ROWS equ 80
COLUMNS equ 25
SCREEN_SIZE equ ROWS*COLUMNS
VIDEO_PTR equ 0xB8000
vp_pos: dd 0
current_attr: db 0x17

[org 0x7c00]

xor ax, ax
mov ds, ax
mov ss, ax

mov [disk_num], dl

push 0x1234
call print_int

jmp $

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
        ret

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
    ret

loadsector_lba:
    ret

get_size:
    ret

; Scans the disk (starting from sector 1 to find the file) with the name pointed to by si
; Return values
; AX = Sector #
; BX = # of sectors
find_file: 
    ret

disk_num: db 0
kernel_name: db "kernel.bin", 0
core_name: db "core.tar", 0
stage2_name: db "stage2.bin", 0
charset: db "0123456789ABCDEF"

times 510-($-$$) db 0
db 0x55, 0xaa


; WIX Bootloader Stage 1
; by Will Klees
; with the lovely emotional support of Nicole <3 :)

[org 0x7c00]
[bits 16]

mov ax, cs
mov ds, ax
mov ss, ax
xor ax, ax

; read drive geometry
mov [disk_num], dl
mov ah, 0x08
int 0x13 ; Dh = # of heads - 1, CL & 0x3F = sectors per track
inc dh
mov [num_heads], dh
and cl, 0x3f
mov [sectors_per_track], cl

push welcome_msg
call puts

; load stage2.bin
mov si, stage2_name
call find_file

push bx
push ax
push ax
call print_int
pop ax
pop bx

push 0x0000
push STAGE2_SEGMENT
push bx
push ax
call loadsector_lba

; load the kernel image

; load the ramdisk

; push kernel_sectors & core_sectors
jmp (STAGE2_SEGMENT << 4)

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


; Reads a sector from the disk in CHS form
; BP+4 = # of sectors to read
; BP+6 = Cylinder # and Sector #
; BP+8 = Head #
; BP+A = Segment to load into
; BP+C = Offset to load into
loadsector:
    push bp
    mov bp, sp

    mov al, byte [bp+0x4] ; # of sectors
    mov cx, word [bp+0x6] ; cylinder # in ch, sector # in cl
    mov dh, byte [bp+0x8] ; head #
    mov bx, word [bp+0xa] ; segment portion of address to load into
    mov es, bx
    mov bx, word [bp+0xc] ; offset portion of address to load into
    mov ah, 2 ; read sectors operation
    mov dl, byte [disk_num]
    int 0x13

    pop bp
    ret 0xa

; Takes an LBA address off the stack, converts it to CHS, then loads it
; BP+4 = Linear Block Address
; BP+6 = # of sectors to read
; BP+8 = Segment to load into
; BP+A = Offset to load into
loadsector_lba:
    push bp
    mov bp, sp

    mov ax, word [bp+0x4]
    xor dx, dx
    div word [sectors_per_track] ; quotient(AX) = temp value, rem(DX)=sector-1
    mov bx, dx ; moving sector #-1 into bx
    inc bx

    div word [num_heads] ;quotient(AX) = cylinder #, rem(DX) = head #

    mov cl, bl ; sector #
    mov ch, al ; cylinder #

    push word [bp+0xa] ; push offset to load into
    push word [bp+0x8] ; push segment to load into
    push dx ; push head # onto the stack
    push cx ; push cylinder # & sector #
    push word [bp+0x6] ; push # of sectors to read

    call loadsector

    pop bp
    ret 0x8

; This function reads the currently-loaded disk fragment from TEMP_SEGMENT:0
; If called correctly, it's the header of a USTAR file
; Returns size (in sectors) in BX
; The data is located at ES:007C and is 12 bytes long
get_size:
    push TEMP_SEGMENT
    pop es
    mov cl, 12
	mov di, 0x7C
	xor bx, bx
	xor dx, dx

	get_size_loop:
		shl bx, 3
		mov dl, BYTE [es:di]
		sub dl, 48
		add bx, dx
		inc di
		dec cl
		cmp cl, 0
		jne get_size_loop

	get_size_done:
		mov cx, bx
		and cx, 0x1FF
		shr bx, 9
		cmp cx, 0
		je get_size_exit
	get_size_add_one:
		inc bx

	get_size_exit:
		ret

; Scans the disk (starting from sector 1 to find the file) to seek for the file with the name pointed to by si
; Return values
; AX = Sector #
; BX = # of sectors
find_file: 
    mov ax, 0x01

    find_file_loop:
        ; read a sector
        push ax ; preserve current sector
        push 0x0000
        push TEMP_SEGMENT
        push 0x01 ; only reading 1 sector
        push ax ; block #
        call loadsector_lba

        pop ax ; get the current sector back

        ; determine file size
        call get_size

        ; compare the filename to what we're seeking for
        jmp find_file_exit

        add ax, bx
        jmp find_file_loop
    
    find_file_exit:
        inc ax
        ret

    ret

kernel_sectors: dw 0
core_sectors: dw 0

disk_num: db 0
sectors_per_track: dw 0
num_heads: dw 0

kernel_name: db "kernel.bin", 0
core_name: db "ramdisk.tar", 0
stage2_name: db "stage2.bin", 0

welcome_msg: db "Stage 1 located Stage 2 at ", 0

charset: db "0123456789ABCDEF"
number: dw 0x1234

times 510-($-$$) db 0
db 0x55, 0xaa

KERNEL_SEGMENT equ 0x1000
STAGE2_SEGMENT equ 0x07E0
RAMDISK_SEGMENT equ 0x2000
TEMP_SEGMENT equ 0x07E0
	.file	"init.c"
	.text
.Ltext0:
	.cfi_sections	.debug_frame
	.file 0 "/home/will/WIX/kernel" "src/init/init.c"
	.globl	interrupt_tick
	.section	.bss
	.align 4
	.type	interrupt_tick, @object
	.size	interrupt_tick, 4
interrupt_tick:
	.zero	4
	.globl	cur_task
	.align 4
	.type	cur_task, @object
	.size	cur_task, 4
cur_task:
	.zero	4
	.globl	base_task
	.align 4
	.type	base_task, @object
	.size	base_task, 20
base_task:
	.zero	20
	.section	.rodata
	.align 4
.LC0:
	.string	"\nEAX: %x ECX: %x EBX: %x EDX: %x\nEBP: %x ESP: %x ESI: %x EDI: %x\n"
	.text
	.globl	dump_regs
	.type	dump_regs, @function
dump_regs:
.LFB0:
	.file 1 "src/init/init.c"
	.loc 1 43 35
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	subl	$28, %esp
	.cfi_offset 7, -12
	.cfi_offset 6, -16
	.cfi_offset 3, -20
	.loc 1 44 5
	movl	dbg_printf, %edi
	movl	8(%ebp), %eax
	movl	(%eax), %ecx
	movl	8(%ebp), %eax
	movl	4(%eax), %esi
	movl	8(%ebp), %eax
	movl	12(%eax), %eax
	movl	%eax, -28(%ebp)
	movl	8(%ebp), %eax
	movl	8(%eax), %edx
	movl	%edx, -32(%ebp)
	movl	8(%ebp), %eax
	movl	20(%eax), %ebx
	movl	%ebx, -36(%ebp)
	movl	8(%ebp), %eax
	movl	16(%eax), %ebx
	movl	8(%ebp), %eax
	movl	24(%eax), %edx
	movl	8(%ebp), %eax
	movl	28(%eax), %eax
	subl	$12, %esp
	pushl	%ecx
	pushl	%esi
	pushl	-28(%ebp)
	pushl	-32(%ebp)
	pushl	-36(%ebp)
	pushl	%ebx
	pushl	%edx
	pushl	%eax
	pushl	$.LC0
	call	*%edi
.LVL0:
	addl	$48, %esp
	.loc 1 45 1
	nop
	leal	-12(%ebp), %esp
	popl	%ebx
	.cfi_restore 3
	popl	%esi
	.cfi_restore 6
	popl	%edi
	.cfi_restore 7
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE0:
	.size	dump_regs, .-dump_regs
	.globl	pit_isr
	.type	pit_isr, @function
pit_isr:
.LFB1:
	.loc 1 48 37
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$8, %esp
	.loc 1 52 19
	movl	interrupt_tick, %eax
	incl	%eax
	movl	%eax, interrupt_tick
	.loc 1 53 5
	subl	$12, %esp
	pushl	$0
	call	pic_send_eoi
	addl	$16, %esp
	.loc 1 55 5
	subl	$12, %esp
	pushl	8(%ebp)
	call	task_switch
	addl	$16, %esp
	.loc 1 57 1
	nop
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE1:
	.size	pit_isr, .-pit_isr
	.globl	syscall_handler
	.type	syscall_handler, @function
syscall_handler:
.LFB2:
	.loc 1 59 45
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$8, %esp
	.loc 1 62 13
	movl	8(%ebp), %eax
	movl	28(%eax), %eax
	.loc 1 62 7
	cmpl	$1, %eax
	jne	.L4
.LBB2:
	.loc 1 63 9
	movl	8(%ebp), %eax
	movl	16(%eax), %eax
	subl	$12, %esp
	pushl	%eax
	call	print
	addl	$16, %esp
.L4:
.LBE2:
	.loc 1 67 12
	movl	$0, %eax
	.loc 1 68 1
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE2:
	.size	syscall_handler, .-syscall_handler
	.globl	init_tasking
	.type	init_tasking, @function
init_tasking:
.LFB3:
	.loc 1 70 20
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	.loc 1 71 14
	movl	$base_task, cur_task
	.loc 1 72 20
	movl	cur_task, %eax
	movl	%eax, base_task+4
	.loc 1 73 20
	movl	$-559038737, base_task+12
	.loc 1 74 1
	nop
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE3:
	.size	init_tasking, .-init_tasking
	.section	.rodata
.LC1:
	.string	"Thread exit!\n"
	.text
	.globl	thread_exit
	.type	thread_exit, @function
thread_exit:
.LFB4:
	.loc 1 76 19
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$8, %esp
	.loc 1 77 5
	call	disable_interrupts
	.loc 1 78 5
	movl	dbg_printf, %eax
	subl	$12, %esp
	pushl	$.LC1
	call	*%eax
.LVL1:
	addl	$16, %esp
.L8:
	.loc 1 79 10 discriminator 1
	jmp	.L8
	.cfi_endproc
.LFE4:
	.size	thread_exit, .-thread_exit
	.globl	create_thread
	.type	create_thread, @function
create_thread:
.LFB5:
	.loc 1 98 78
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$24, %esp
	.loc 1 99 23
	subl	$12, %esp
	pushl	$4096
	call	heap_alloc
	addl	$16, %esp
	.loc 1 99 40
	addl	$4096, %eax
	.loc 1 99 15
	movl	%eax, -12(%ebp)
	.loc 1 101 10
	subl	$4, -12(%ebp)
	.loc 1 101 21
	movl	16(%ebp), %edx
	movl	-12(%ebp), %eax
	movl	%edx, (%eax)
	.loc 1 102 10
	subl	$4, -12(%ebp)
	.loc 1 102 21
	movl	$thread_exit, %edx
	movl	-12(%ebp), %eax
	movl	%edx, (%eax)
	.loc 1 103 10
	subl	$4, -12(%ebp)
	.loc 1 103 21
	movl	12(%ebp), %edx
	movl	-12(%ebp), %eax
	movl	%edx, (%eax)
	.loc 1 104 10
	subl	$4, -12(%ebp)
	.loc 1 104 21
	movl	-12(%ebp), %eax
	movl	$514, (%eax)
	.loc 1 105 10
	subl	$4, -12(%ebp)
	.loc 1 105 21
	movl	-12(%ebp), %eax
	movl	$0, (%eax)
	.loc 1 106 10
	subl	$4, -12(%ebp)
	.loc 1 106 21
	movl	-12(%ebp), %eax
	movl	$0, (%eax)
	.loc 1 107 10
	subl	$4, -12(%ebp)
	.loc 1 107 21
	movl	-12(%ebp), %eax
	movl	$0, (%eax)
	.loc 1 108 10
	subl	$4, -12(%ebp)
	.loc 1 108 21
	movl	-12(%ebp), %eax
	movl	$0, (%eax)
	.loc 1 109 10
	subl	$4, -12(%ebp)
	.loc 1 109 21
	movl	-12(%ebp), %eax
	movl	$0, (%eax)
	.loc 1 110 10
	subl	$4, -12(%ebp)
	.loc 1 110 21
	movl	-12(%ebp), %eax
	movl	$0, (%eax)
	.loc 1 111 10
	subl	$4, -12(%ebp)
	.loc 1 111 21
	movl	-12(%ebp), %eax
	movl	$0, (%eax)
	.loc 1 113 15
	movl	-12(%ebp), %edx
	movl	8(%ebp), %eax
	movl	%edx, (%eax)
	.loc 1 115 8
	cmpl	$0, 20(%ebp)
	je	.L11
	.loc 1 116 22
	subl	$12, %esp
	pushl	$4096
	call	heap_alloc
	addl	$16, %esp
	.loc 1 116 39
	addl	$4096, %eax
	movl	%eax, %edx
	.loc 1 116 20
	movl	8(%ebp), %eax
	movl	%edx, 12(%eax)
.L11:
	.loc 1 118 1
	nop
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE5:
	.size	create_thread, .-create_thread
	.section	.rodata
.LC2:
	.string	"About to enable interrupts\n"
	.text
	.globl	spawn_thread
	.type	spawn_thread, @function
spawn_thread:
.LFB6:
	.loc 1 120 66
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$24, %esp
	.loc 1 121 5
	call	disable_interrupts
	.loc 1 122 28
	movl	cur_task, %eax
	.loc 1 122 13
	movl	4(%eax), %eax
	movl	%eax, -12(%ebp)
	.loc 1 123 22
	subl	$12, %esp
	pushl	$20
	call	heap_alloc
	addl	$16, %esp
	movl	%eax, %edx
	.loc 1 123 13
	movl	cur_task, %eax
	.loc 1 123 20
	movl	%edx, 4(%eax)
	.loc 1 124 13
	movl	cur_task, %eax
	movl	4(%eax), %eax
	.loc 1 124 26
	movl	cur_task, %edx
	movl	%edx, 8(%eax)
	.loc 1 125 13
	movl	cur_task, %eax
	movl	4(%eax), %eax
	.loc 1 125 26
	movl	-12(%ebp), %edx
	movl	%edx, 4(%eax)
	.loc 1 126 26
	movl	cur_task, %eax
	movl	4(%eax), %edx
	.loc 1 126 16
	movl	-12(%ebp), %eax
	movl	%edx, 8(%eax)
	.loc 1 128 17
	movl	cur_task, %eax
	movl	8(%eax), %eax
	.loc 1 128 7
	testl	%eax, %eax
	jne	.L13
	.loc 1 128 33 discriminator 1
	movl	cur_task, %eax
	.loc 1 128 40 discriminator 1
	movl	-12(%ebp), %edx
	movl	%edx, 8(%eax)
.L13:
	.loc 1 130 27
	movl	cur_task, %eax
	movl	4(%eax), %eax
	.loc 1 130 5
	pushl	16(%ebp)
	pushl	12(%ebp)
	pushl	8(%ebp)
	pushl	%eax
	call	create_thread
	addl	$16, %esp
	.loc 1 132 5
	movl	dbg_printf, %eax
	subl	$12, %esp
	pushl	$.LC2
	call	*%eax
.LVL2:
	addl	$16, %esp
	.loc 1 134 5
	call	enable_interrupts
	.loc 1 136 20
	movl	cur_task, %eax
	movl	4(%eax), %eax
	.loc 1 137 1
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE6:
	.size	spawn_thread, .-spawn_thread
	.globl	print
	.type	print, @function
print:
.LFB7:
	.loc 1 144 22
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$8, %esp
	.loc 1 146 5
	movl	dbg_printf, %eax
	subl	$12, %esp
	pushl	8(%ebp)
	call	*%eax
.LVL3:
	addl	$16, %esp
	.loc 1 147 1
	nop
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE7:
	.size	print, .-print
	.section	.rodata
	.align 4
.LC3:
	.string	"\033[33m[\033[H\033[JWelcome to WIX!\nPress any key to cause a crash.\n"
.LC4:
	.string	"src/init/init.c"
.LC5:
	.string	"0!=0"
.LC6:
	.string	"\r%s line %d"
	.text
	.globl	_start
	.type	_start, @function
_start:
.LFB8:
	.loc 1 149 45
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$56, %esp
	.loc 1 151 9
	movl	$0, -12(%ebp)
	.loc 1 152 5
	call	pmm_init
	.loc 1 154 24
	movl	8(%ebp), %eax
	movl	8(%eax), %eax
	.loc 1 154 16
	movl	%eax, dbg_printf
	.loc 1 156 5
	subl	$12, %esp
	pushl	$1048576
	call	sbrk
	addl	$16, %esp
	.loc 1 157 5
	call	heap_init
	.loc 1 158 5
	call	init_tasking
	.loc 1 159 5
	subl	$8, %esp
	pushl	$120
	pushl	$112
	call	pic_remap
	addl	$16, %esp
	.loc 1 160 5
	call	idt_init
	.loc 1 161 5
	subl	$8, %esp
	pushl	$pit_isr
	pushl	$112
	call	set_isr
	addl	$16, %esp
	.loc 1 162 5
	subl	$8, %esp
	pushl	$syscall_handler
	pushl	$128
	call	set_isr
	addl	$16, %esp
	.loc 1 164 5
	call	gdt_init
	.loc 1 166 5
	subl	$8, %esp
	pushl	$0
	pushl	$196608
	call	unmap_page
	addl	$16, %esp
	.loc 1 168 5
	subl	$8, %esp
	pushl	$52
	pushl	$67
	call	io_write_8
	addl	$16, %esp
	.loc 1 171 2
	subl	$8, %esp
	pushl	$223
	pushl	$64
	call	io_write_8
	addl	$16, %esp
	.loc 1 172 2
	subl	$8, %esp
	pushl	$4
	pushl	$64
	call	io_write_8
	addl	$16, %esp
	.loc 1 176 5
	call	tty_init
	.loc 1 182 5
	subl	$4, %esp
	pushl	$1
	pushl	$0
	pushl	$thread_fun_1
	call	spawn_thread
	addl	$16, %esp
	.loc 1 183 5
	subl	$4, %esp
	pushl	$1
	pushl	$0
	pushl	$thread_fun_2
	call	spawn_thread
	addl	$16, %esp
	.loc 1 189 11
	movl	$.LC3, -16(%ebp)
	.loc 1 191 5
	subl	$12, %esp
	pushl	-16(%ebp)
	call	strlen
	addl	$16, %esp
	subl	$8, %esp
	pushl	%eax
	pushl	-16(%ebp)
	call	tty_write
	addl	$16, %esp
	.loc 1 193 5
	pushl	$193
	pushl	$.LC4
	pushl	$.LC5
	pushl	$0
	call	libk_assert
	addl	$16, %esp
.L17:
	.loc 1 197 9 discriminator 1
	pushl	$197
	pushl	$.LC4
	pushl	$.LC6
	leal	-56(%ebp), %eax
	pushl	%eax
	call	sprintf
	addl	$16, %esp
	.loc 1 198 9 discriminator 1
	subl	$12, %esp
	leal	-56(%ebp), %eax
	pushl	%eax
	call	strlen
	addl	$16, %esp
	subl	$8, %esp
	pushl	%eax
	leal	-56(%ebp), %eax
	pushl	%eax
	call	tty_write
	addl	$16, %esp
	.loc 1 197 9 discriminator 1
	jmp	.L17
	.cfi_endproc
.LFE8:
	.size	_start, .-_start
.Letext0:
	.file 2 "/usr/local/i386elfgcc/lib/gcc/i386-elf/12.2.0/include/stdint-gcc.h"
	.file 3 "include/init/idt.h"
	.file 4 "include/mm/vmm.h"
	.file 5 "include/libk/assert.h"
	.file 6 "include/libk/stdio.h"
	.file 7 "include/init/pic.h"
	.file 8 "include/init/gdt.h"
	.file 9 "include/mm/pmm.h"
	.section	.debug_info,"",@progbits
.Ldebug_info0:
	.long	0x719
	.value	0x5
	.byte	0x1
	.byte	0x4
	.long	.Ldebug_abbrev0
	.uleb128 0x18
	.long	.LASF84
	.byte	0x1d
	.long	.LASF0
	.long	.LASF1
	.long	.Ltext0
	.long	.Letext0-.Ltext0
	.long	.Ldebug_line0
	.uleb128 0x4
	.byte	0x1
	.byte	0x6
	.long	.LASF2
	.uleb128 0x4
	.byte	0x2
	.byte	0x5
	.long	.LASF3
	.uleb128 0x4
	.byte	0x4
	.byte	0x5
	.long	.LASF4
	.uleb128 0x4
	.byte	0x8
	.byte	0x5
	.long	.LASF5
	.uleb128 0x5
	.long	.LASF7
	.byte	0x2
	.byte	0x2e
	.byte	0x18
	.long	0x4e
	.uleb128 0x4
	.byte	0x1
	.byte	0x8
	.long	.LASF6
	.uleb128 0x5
	.long	.LASF8
	.byte	0x2
	.byte	0x31
	.byte	0x19
	.long	0x61
	.uleb128 0x4
	.byte	0x2
	.byte	0x7
	.long	.LASF9
	.uleb128 0x5
	.long	.LASF10
	.byte	0x2
	.byte	0x34
	.byte	0x19
	.long	0x74
	.uleb128 0x4
	.byte	0x4
	.byte	0x7
	.long	.LASF11
	.uleb128 0x4
	.byte	0x8
	.byte	0x7
	.long	.LASF12
	.uleb128 0x19
	.byte	0x4
	.byte	0x5
	.string	"int"
	.uleb128 0x4
	.byte	0x4
	.byte	0x7
	.long	.LASF13
	.uleb128 0x5
	.long	.LASF14
	.byte	0x2
	.byte	0x56
	.byte	0x1a
	.long	0x74
	.uleb128 0xe
	.long	.LASF22
	.byte	0x24
	.byte	0x3
	.byte	0x14
	.long	0x11e
	.uleb128 0x7
	.string	"edi"
	.byte	0x3
	.byte	0x15
	.byte	0xe
	.long	0x68
	.byte	0
	.uleb128 0x7
	.string	"esi"
	.byte	0x3
	.byte	0x15
	.byte	0x13
	.long	0x68
	.byte	0x4
	.uleb128 0x7
	.string	"ebp"
	.byte	0x3
	.byte	0x15
	.byte	0x18
	.long	0x68
	.byte	0x8
	.uleb128 0x7
	.string	"esp"
	.byte	0x3
	.byte	0x15
	.byte	0x1d
	.long	0x68
	.byte	0xc
	.uleb128 0x7
	.string	"ebx"
	.byte	0x3
	.byte	0x15
	.byte	0x22
	.long	0x68
	.byte	0x10
	.uleb128 0x7
	.string	"edx"
	.byte	0x3
	.byte	0x15
	.byte	0x27
	.long	0x68
	.byte	0x14
	.uleb128 0x7
	.string	"ecx"
	.byte	0x3
	.byte	0x15
	.byte	0x2c
	.long	0x68
	.byte	0x18
	.uleb128 0x7
	.string	"eax"
	.byte	0x3
	.byte	0x15
	.byte	0x31
	.long	0x68
	.byte	0x1c
	.uleb128 0x8
	.long	.LASF15
	.byte	0x3
	.byte	0x15
	.byte	0x36
	.long	0x68
	.byte	0x20
	.byte	0
	.uleb128 0x5
	.long	.LASF16
	.byte	0x3
	.byte	0x16
	.byte	0x3
	.long	0x9c
	.uleb128 0x1a
	.byte	0x4
	.uleb128 0x5
	.long	.LASF17
	.byte	0x3
	.byte	0x1a
	.byte	0x14
	.long	0x138
	.uleb128 0x6
	.long	0x13d
	.uleb128 0x14
	.long	0x68
	.long	0x14c
	.uleb128 0x2
	.long	0x14c
	.byte	0
	.uleb128 0x6
	.long	0x11e
	.uleb128 0x4
	.byte	0xc
	.byte	0x4
	.long	.LASF18
	.uleb128 0x4
	.byte	0x10
	.byte	0x4
	.long	.LASF19
	.uleb128 0x5
	.long	.LASF20
	.byte	0x4
	.byte	0x6
	.byte	0x13
	.long	0x90
	.uleb128 0x5
	.long	.LASF21
	.byte	0x4
	.byte	0x7
	.byte	0x13
	.long	0x90
	.uleb128 0x1b
	.long	.LASF23
	.value	0x1000
	.byte	0x4
	.byte	0x9
	.byte	0x10
	.long	0x193
	.uleb128 0x8
	.long	.LASF24
	.byte	0x4
	.byte	0xa
	.byte	0xd
	.long	0x193
	.byte	0
	.byte	0
	.uleb128 0x15
	.long	0x15f
	.long	0x1a4
	.uleb128 0x1c
	.long	0x74
	.value	0x3ff
	.byte	0
	.uleb128 0x5
	.long	.LASF25
	.byte	0x4
	.byte	0xb
	.byte	0x3
	.long	0x177
	.uleb128 0x4
	.byte	0x1
	.byte	0x6
	.long	.LASF26
	.uleb128 0x1d
	.long	0x1b0
	.uleb128 0xf
	.long	.LASF39
	.byte	0x10
	.byte	0x5
	.long	0x82
	.uleb128 0x5
	.byte	0x3
	.long	interrupt_tick
	.uleb128 0xe
	.long	.LASF27
	.byte	0xc
	.byte	0x1
	.byte	0x12
	.long	0x20e
	.uleb128 0x8
	.long	.LASF28
	.byte	0x1
	.byte	0x13
	.byte	0xe
	.long	0x55
	.byte	0
	.uleb128 0x8
	.long	.LASF29
	.byte	0x1
	.byte	0x14
	.byte	0xe
	.long	0x55
	.byte	0x2
	.uleb128 0x8
	.long	.LASF30
	.byte	0x1
	.byte	0x15
	.byte	0xe
	.long	0x55
	.byte	0x4
	.uleb128 0x8
	.long	.LASF31
	.byte	0x1
	.byte	0x16
	.byte	0xc
	.long	0x21f
	.byte	0x8
	.byte	0
	.uleb128 0x1e
	.long	0x21a
	.uleb128 0x2
	.long	0x21a
	.uleb128 0x1
	.byte	0
	.uleb128 0x6
	.long	0x1b7
	.uleb128 0x6
	.long	0x20e
	.uleb128 0x5
	.long	.LASF32
	.byte	0x1
	.byte	0x17
	.byte	0x3
	.long	0x1cd
	.uleb128 0xe
	.long	.LASF33
	.byte	0x14
	.byte	0x1
	.byte	0x19
	.long	0x27e
	.uleb128 0x7
	.string	"esp"
	.byte	0x1
	.byte	0x1a
	.byte	0xe
	.long	0x68
	.byte	0
	.uleb128 0x8
	.long	.LASF34
	.byte	0x1
	.byte	0x1b
	.byte	0x12
	.long	0x27e
	.byte	0x4
	.uleb128 0x8
	.long	.LASF35
	.byte	0x1
	.byte	0x1c
	.byte	0x12
	.long	0x27e
	.byte	0x8
	.uleb128 0x8
	.long	.LASF36
	.byte	0x1
	.byte	0x1d
	.byte	0xe
	.long	0x68
	.byte	0xc
	.uleb128 0x7
	.string	"cr3"
	.byte	0x1
	.byte	0x1e
	.byte	0xe
	.long	0x68
	.byte	0x10
	.byte	0
	.uleb128 0x6
	.long	0x230
	.uleb128 0x5
	.long	.LASF37
	.byte	0x1
	.byte	0x1f
	.byte	0x3
	.long	0x230
	.uleb128 0x5
	.long	.LASF38
	.byte	0x1
	.byte	0x21
	.byte	0xb
	.long	0x29b
	.uleb128 0x6
	.long	0x2a0
	.uleb128 0x14
	.long	0x82
	.long	0x2af
	.uleb128 0x2
	.long	0x12a
	.byte	0
	.uleb128 0xf
	.long	.LASF40
	.byte	0x23
	.byte	0x9
	.long	0x2c0
	.uleb128 0x5
	.byte	0x3
	.long	cur_task
	.uleb128 0x6
	.long	0x283
	.uleb128 0xf
	.long	.LASF41
	.byte	0x24
	.byte	0x8
	.long	0x283
	.uleb128 0x5
	.byte	0x3
	.long	base_task
	.uleb128 0x1f
	.long	.LASF42
	.byte	0x1
	.byte	0x26
	.byte	0xf
	.long	0x21f
	.uleb128 0x16
	.long	.LASF51
	.byte	0x6
	.byte	0x6
	.byte	0x5
	.long	0x82
	.long	0x2fe
	.uleb128 0x2
	.long	0x2fe
	.uleb128 0x2
	.long	0x21a
	.uleb128 0x1
	.byte	0
	.uleb128 0x6
	.long	0x1b0
	.uleb128 0xa
	.long	.LASF43
	.byte	0x5
	.byte	0x4
	.long	0x323
	.uleb128 0x2
	.long	0x82
	.uleb128 0x2
	.long	0x21a
	.uleb128 0x2
	.long	0x21a
	.uleb128 0x2
	.long	0x82
	.byte	0
	.uleb128 0x3
	.long	.LASF44
	.byte	0xbf
	.byte	0x5
	.long	0x82
	.long	0x334
	.uleb128 0x1
	.byte	0
	.uleb128 0x3
	.long	.LASF45
	.byte	0xbf
	.byte	0x15
	.long	0x82
	.long	0x345
	.uleb128 0x1
	.byte	0
	.uleb128 0xa
	.long	.LASF46
	.byte	0x1
	.byte	0x60
	.long	0x356
	.uleb128 0x2
	.long	0x12a
	.byte	0
	.uleb128 0xa
	.long	.LASF47
	.byte	0x1
	.byte	0x5f
	.long	0x367
	.uleb128 0x2
	.long	0x12a
	.byte	0
	.uleb128 0x3
	.long	.LASF48
	.byte	0xb0
	.byte	0x5
	.long	0x82
	.long	0x378
	.uleb128 0x1
	.byte	0
	.uleb128 0x3
	.long	.LASF49
	.byte	0xa8
	.byte	0x5
	.long	0x82
	.long	0x389
	.uleb128 0x1
	.byte	0
	.uleb128 0xa
	.long	.LASF50
	.byte	0x4
	.byte	0x12
	.long	0x39f
	.uleb128 0x2
	.long	0x39f
	.uleb128 0x2
	.long	0x16b
	.byte	0
	.uleb128 0x6
	.long	0x1a4
	.uleb128 0xb
	.long	.LASF56
	.byte	0x8
	.byte	0x3a
	.long	0x3b1
	.uleb128 0x1
	.byte	0
	.uleb128 0x16
	.long	.LASF52
	.byte	0x3
	.byte	0x1c
	.byte	0xa
	.long	0x12c
	.long	0x3cc
	.uleb128 0x2
	.long	0x82
	.uleb128 0x2
	.long	0x12c
	.byte	0
	.uleb128 0x20
	.long	.LASF85
	.byte	0x3
	.byte	0x20
	.byte	0x6
	.uleb128 0xa
	.long	.LASF53
	.byte	0x7
	.byte	0x1a
	.long	0x3ea
	.uleb128 0x2
	.long	0x42
	.uleb128 0x2
	.long	0x42
	.byte	0
	.uleb128 0x3
	.long	.LASF54
	.byte	0x9d
	.byte	0x5
	.long	0x82
	.long	0x3fb
	.uleb128 0x1
	.byte	0
	.uleb128 0x3
	.long	.LASF55
	.byte	0x9c
	.byte	0x5
	.long	0x82
	.long	0x40c
	.uleb128 0x1
	.byte	0
	.uleb128 0xb
	.long	.LASF57
	.byte	0x9
	.byte	0x8
	.long	0x419
	.uleb128 0x1
	.byte	0
	.uleb128 0xb
	.long	.LASF58
	.byte	0x3
	.byte	0x22
	.long	0x426
	.uleb128 0x1
	.byte	0
	.uleb128 0x3
	.long	.LASF59
	.byte	0x63
	.byte	0x17
	.long	0x82
	.long	0x437
	.uleb128 0x1
	.byte	0
	.uleb128 0xb
	.long	.LASF60
	.byte	0x3
	.byte	0x23
	.long	0x444
	.uleb128 0x1
	.byte	0
	.uleb128 0xa
	.long	.LASF61
	.byte	0x1
	.byte	0x27
	.long	0x455
	.uleb128 0x2
	.long	0x14c
	.byte	0
	.uleb128 0xa
	.long	.LASF62
	.byte	0x7
	.byte	0x19
	.long	0x466
	.uleb128 0x2
	.long	0x42
	.byte	0
	.uleb128 0x10
	.long	.LASF70
	.byte	0x95
	.long	.LFB8
	.long	.LFE8-.LFB8
	.uleb128 0x1
	.byte	0x9c
	.long	0x56e
	.uleb128 0x9
	.long	.LASF72
	.byte	0x95
	.byte	0x26
	.long	0x56e
	.uleb128 0x2
	.byte	0x91
	.sleb128 0
	.uleb128 0x17
	.string	"buf"
	.byte	0x96
	.byte	0xa
	.long	0x573
	.uleb128 0x2
	.byte	0x91
	.sleb128 -64
	.uleb128 0x17
	.string	"n"
	.byte	0x97
	.byte	0x9
	.long	0x82
	.uleb128 0x2
	.byte	0x91
	.sleb128 -20
	.uleb128 0x3
	.long	.LASF55
	.byte	0x9c
	.byte	0x5
	.long	0x82
	.long	0x4b3
	.uleb128 0x1
	.byte	0
	.uleb128 0x3
	.long	.LASF54
	.byte	0x9d
	.byte	0x5
	.long	0x82
	.long	0x4c4
	.uleb128 0x1
	.byte	0
	.uleb128 0x3
	.long	.LASF49
	.byte	0xa8
	.byte	0x5
	.long	0x82
	.long	0x4d5
	.uleb128 0x1
	.byte	0
	.uleb128 0x3
	.long	.LASF48
	.byte	0xb0
	.byte	0x5
	.long	0x82
	.long	0x4e6
	.uleb128 0x1
	.byte	0
	.uleb128 0x11
	.long	.LASF63
	.byte	0xbd
	.byte	0xb
	.long	0x2fe
	.uleb128 0x2
	.byte	0x91
	.sleb128 -24
	.uleb128 0x3
	.long	.LASF44
	.byte	0xbf
	.byte	0x5
	.long	0x82
	.long	0x505
	.uleb128 0x1
	.byte	0
	.uleb128 0x3
	.long	.LASF45
	.byte	0xbf
	.byte	0x15
	.long	0x82
	.long	0x516
	.uleb128 0x1
	.byte	0
	.uleb128 0xc
	.long	.LASF64
	.byte	0xd0
	.long	0x2fe
	.uleb128 0x3
	.long	.LASF59
	.byte	0x63
	.byte	0x17
	.long	0x82
	.long	0x531
	.uleb128 0x1
	.byte	0
	.uleb128 0xc
	.long	.LASF65
	.byte	0xd1
	.long	0x2fe
	.uleb128 0xc
	.long	.LASF66
	.byte	0xd2
	.long	0x2fe
	.uleb128 0xc
	.long	.LASF67
	.byte	0xd4
	.long	0x2fe
	.uleb128 0x3
	.long	.LASF68
	.byte	0xd5
	.byte	0x5
	.long	0x82
	.long	0x560
	.uleb128 0x1
	.byte	0
	.uleb128 0xd
	.long	.LASF69
	.byte	0xd6
	.byte	0x5
	.long	0x82
	.uleb128 0x1
	.byte	0
	.byte	0
	.uleb128 0x6
	.long	0x224
	.uleb128 0x15
	.long	0x1b0
	.long	0x583
	.uleb128 0x21
	.long	0x74
	.byte	0x27
	.byte	0
	.uleb128 0x10
	.long	.LASF71
	.byte	0x90
	.long	.LFB7
	.long	.LFE7-.LFB7
	.uleb128 0x1
	.byte	0x9c
	.long	0x5a6
	.uleb128 0x12
	.string	"str"
	.byte	0x90
	.byte	0x12
	.long	0x2fe
	.uleb128 0x2
	.byte	0x91
	.sleb128 0
	.byte	0
	.uleb128 0x13
	.long	.LASF80
	.byte	0x78
	.byte	0x9
	.long	0x2c0
	.long	.LFB6
	.long	.LFE6-.LFB6
	.uleb128 0x1
	.byte	0x9c
	.long	0x604
	.uleb128 0x12
	.string	"fn"
	.byte	0x78
	.byte	0x24
	.long	0x28f
	.uleb128 0x2
	.byte	0x91
	.sleb128 0
	.uleb128 0x9
	.long	.LASF73
	.byte	0x78
	.byte	0x2e
	.long	0x12a
	.uleb128 0x2
	.byte	0x91
	.sleb128 4
	.uleb128 0x9
	.long	.LASF74
	.byte	0x78
	.byte	0x39
	.long	0x82
	.uleb128 0x2
	.byte	0x91
	.sleb128 8
	.uleb128 0x11
	.long	.LASF75
	.byte	0x7a
	.byte	0xd
	.long	0x2c0
	.uleb128 0x2
	.byte	0x91
	.sleb128 -20
	.uleb128 0xd
	.long	.LASF59
	.byte	0x63
	.byte	0x17
	.long	0x82
	.uleb128 0x1
	.byte	0
	.byte	0
	.uleb128 0x10
	.long	.LASF76
	.byte	0x62
	.long	.LFB5
	.long	.LFE5-.LFB5
	.uleb128 0x1
	.byte	0x9c
	.long	0x66b
	.uleb128 0x9
	.long	.LASF33
	.byte	0x62
	.byte	0x1c
	.long	0x2c0
	.uleb128 0x2
	.byte	0x91
	.sleb128 0
	.uleb128 0x12
	.string	"fn"
	.byte	0x62
	.byte	0x30
	.long	0x28f
	.uleb128 0x2
	.byte	0x91
	.sleb128 4
	.uleb128 0x9
	.long	.LASF73
	.byte	0x62
	.byte	0x3a
	.long	0x12a
	.uleb128 0x2
	.byte	0x91
	.sleb128 8
	.uleb128 0x9
	.long	.LASF74
	.byte	0x62
	.byte	0x45
	.long	0x82
	.uleb128 0x2
	.byte	0x91
	.sleb128 12
	.uleb128 0x11
	.long	.LASF77
	.byte	0x63
	.byte	0xf
	.long	0x66b
	.uleb128 0x2
	.byte	0x91
	.sleb128 -20
	.uleb128 0xd
	.long	.LASF59
	.byte	0x63
	.byte	0x17
	.long	0x82
	.uleb128 0x1
	.byte	0
	.byte	0
	.uleb128 0x6
	.long	0x68
	.uleb128 0x22
	.long	.LASF78
	.byte	0x1
	.byte	0x4c
	.byte	0x6
	.long	.LFB4
	.long	.LFE4-.LFB4
	.uleb128 0x1
	.byte	0x9c
	.uleb128 0x23
	.long	.LASF79
	.byte	0x1
	.byte	0x46
	.byte	0x6
	.long	.LFB3
	.long	.LFE3-.LFB3
	.uleb128 0x1
	.byte	0x9c
	.uleb128 0x13
	.long	.LASF81
	.byte	0x3b
	.byte	0xa
	.long	0x68
	.long	.LFB2
	.long	.LFE2-.LFB2
	.uleb128 0x1
	.byte	0x9c
	.long	0x6d3
	.uleb128 0x9
	.long	.LASF82
	.byte	0x3b
	.byte	0x27
	.long	0x14c
	.uleb128 0x2
	.byte	0x91
	.sleb128 0
	.uleb128 0x24
	.long	.LBB2
	.long	.LBE2-.LBB2
	.uleb128 0xd
	.long	.LASF71
	.byte	0x3f
	.byte	0x9
	.long	0x82
	.uleb128 0x1
	.byte	0
	.byte	0
	.byte	0
	.uleb128 0x13
	.long	.LASF83
	.byte	0x30
	.byte	0xa
	.long	0x68
	.long	.LFB1
	.long	.LFE1-.LFB1
	.uleb128 0x1
	.byte	0x9c
	.long	0x6fb
	.uleb128 0x9
	.long	.LASF82
	.byte	0x30
	.byte	0x1f
	.long	0x14c
	.uleb128 0x2
	.byte	0x91
	.sleb128 0
	.byte	0
	.uleb128 0x25
	.long	.LASF86
	.byte	0x1
	.byte	0x2b
	.byte	0x6
	.long	.LFB0
	.long	.LFE0-.LFB0
	.uleb128 0x1
	.byte	0x9c
	.uleb128 0x9
	.long	.LASF82
	.byte	0x2b
	.byte	0x1d
	.long	0x14c
	.uleb128 0x2
	.byte	0x91
	.sleb128 0
	.byte	0
	.byte	0
	.section	.debug_abbrev,"",@progbits
.Ldebug_abbrev0:
	.uleb128 0x1
	.uleb128 0x18
	.byte	0
	.byte	0
	.byte	0
	.uleb128 0x2
	.uleb128 0x5
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x3
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 1
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x3c
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x4
	.uleb128 0x24
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3e
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0xe
	.byte	0
	.byte	0
	.uleb128 0x5
	.uleb128 0x16
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x6
	.uleb128 0xf
	.byte	0
	.uleb128 0xb
	.uleb128 0x21
	.sleb128 4
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x7
	.uleb128 0xd
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x38
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x8
	.uleb128 0xd
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x38
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x9
	.uleb128 0x5
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 1
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0xa
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0x21
	.sleb128 6
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x3c
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xb
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0x21
	.sleb128 6
	.uleb128 0x3c
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xc
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 1
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0x21
	.sleb128 11
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xd
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 1
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x3c
	.uleb128 0x19
	.byte	0
	.byte	0
	.uleb128 0xe
	.uleb128 0x13
	.byte	0x1
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0x21
	.sleb128 16
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xf
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 1
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x10
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 1
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0x21
	.sleb128 6
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x6
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x7c
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x11
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 1
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x12
	.uleb128 0x5
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 1
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x13
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 1
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x6
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x7c
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x14
	.uleb128 0x15
	.byte	0x1
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x15
	.uleb128 0x1
	.byte	0x1
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x16
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x3c
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x17
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 1
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x18
	.uleb128 0x11
	.byte	0x1
	.uleb128 0x25
	.uleb128 0xe
	.uleb128 0x13
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0x1f
	.uleb128 0x1b
	.uleb128 0x1f
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x6
	.uleb128 0x10
	.uleb128 0x17
	.byte	0
	.byte	0
	.uleb128 0x19
	.uleb128 0x24
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3e
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0x8
	.byte	0
	.byte	0
	.uleb128 0x1a
	.uleb128 0xf
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x1b
	.uleb128 0x13
	.byte	0x1
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0xb
	.uleb128 0x5
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x1c
	.uleb128 0x21
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2f
	.uleb128 0x5
	.byte	0
	.byte	0
	.uleb128 0x1d
	.uleb128 0x26
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x1e
	.uleb128 0x15
	.byte	0x1
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x1f
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3c
	.uleb128 0x19
	.byte	0
	.byte	0
	.uleb128 0x20
	.uleb128 0x2e
	.byte	0
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x3c
	.uleb128 0x19
	.byte	0
	.byte	0
	.uleb128 0x21
	.uleb128 0x21
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2f
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x22
	.uleb128 0x2e
	.byte	0
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x6
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x7c
	.uleb128 0x19
	.byte	0
	.byte	0
	.uleb128 0x23
	.uleb128 0x2e
	.byte	0
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x6
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x7a
	.uleb128 0x19
	.byte	0
	.byte	0
	.uleb128 0x24
	.uleb128 0xb
	.byte	0x1
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x6
	.byte	0
	.byte	0
	.uleb128 0x25
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x6
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x7c
	.uleb128 0x19
	.byte	0
	.byte	0
	.byte	0
	.section	.debug_aranges,"",@progbits
	.long	0x1c
	.value	0x2
	.long	.Ldebug_info0
	.byte	0x4
	.byte	0
	.value	0
	.value	0
	.long	.Ltext0
	.long	.Letext0-.Ltext0
	.long	0
	.long	0
	.section	.debug_line,"",@progbits
.Ldebug_line0:
	.section	.debug_str,"MS",@progbits,1
.LASF50:
	.string	"unmap_page"
.LASF80:
	.string	"spawn_thread"
.LASF52:
	.string	"set_isr"
.LASF24:
	.string	"entries"
.LASF78:
	.string	"thread_exit"
.LASF34:
	.string	"next"
.LASF60:
	.string	"disable_interrupts"
.LASF75:
	.string	"temp"
.LASF3:
	.string	"short int"
.LASF49:
	.string	"io_write_8"
.LASF15:
	.string	"eflags"
.LASF30:
	.string	"mem_size"
.LASF70:
	.string	"_start"
.LASF33:
	.string	"task"
.LASF44:
	.string	"tty_write"
.LASF63:
	.string	"str1"
.LASF36:
	.string	"esp0"
.LASF7:
	.string	"uint8_t"
.LASF14:
	.string	"uintptr_t"
.LASF74:
	.string	"user_esp"
.LASF62:
	.string	"pic_send_eoi"
.LASF37:
	.string	"task_t"
.LASF58:
	.string	"enable_interrupts"
.LASF21:
	.string	"vaddr_t"
.LASF48:
	.string	"tty_init"
.LASF81:
	.string	"syscall_handler"
.LASF5:
	.string	"long long int"
.LASF28:
	.string	"kernel_sectors"
.LASF57:
	.string	"pmm_init"
.LASF4:
	.string	"long int"
.LASF31:
	.string	"printf"
.LASF86:
	.string	"dump_regs"
.LASF68:
	.string	"heap_free"
.LASF72:
	.string	"params"
.LASF46:
	.string	"thread_fun_2"
.LASF18:
	.string	"long double"
.LASF6:
	.string	"unsigned char"
.LASF55:
	.string	"sbrk"
.LASF39:
	.string	"interrupt_tick"
.LASF51:
	.string	"sprintf"
.LASF2:
	.string	"signed char"
.LASF12:
	.string	"long long unsigned int"
.LASF71:
	.string	"print"
.LASF10:
	.string	"uint32_t"
.LASF13:
	.string	"unsigned int"
.LASF8:
	.string	"uint16_t"
.LASF77:
	.string	"stack"
.LASF69:
	.string	"heap_print"
.LASF32:
	.string	"kernel_startup_params_t"
.LASF73:
	.string	"param"
.LASF9:
	.string	"short unsigned int"
.LASF59:
	.string	"heap_alloc"
.LASF26:
	.string	"char"
.LASF45:
	.string	"strlen"
.LASF40:
	.string	"cur_task"
.LASF79:
	.string	"init_tasking"
.LASF54:
	.string	"heap_init"
.LASF20:
	.string	"paddr_t"
.LASF64:
	.string	"ptr1"
.LASF11:
	.string	"long unsigned int"
.LASF65:
	.string	"ptr2"
.LASF22:
	.string	"_int_state"
.LASF29:
	.string	"ramdisk_sectors"
.LASF82:
	.string	"state"
.LASF38:
	.string	"thread_func_t"
.LASF16:
	.string	"int_state_t"
.LASF56:
	.string	"gdt_init"
.LASF27:
	.string	"kernel_startup_params"
.LASF17:
	.string	"isr_func"
.LASF83:
	.string	"pit_isr"
.LASF85:
	.string	"idt_init"
.LASF19:
	.string	"_Float128"
.LASF76:
	.string	"create_thread"
.LASF43:
	.string	"libk_assert"
.LASF66:
	.string	"ptr3"
.LASF67:
	.string	"ptr4"
.LASF23:
	.string	"pgdir"
.LASF42:
	.string	"dbg_printf"
.LASF61:
	.string	"task_switch"
.LASF35:
	.string	"prev"
.LASF53:
	.string	"pic_remap"
.LASF41:
	.string	"base_task"
.LASF84:
	.string	"GNU C17 12.2.0 -m32 -mtune=i386 -march=i386 -g -ffreestanding"
.LASF47:
	.string	"thread_fun_1"
.LASF25:
	.string	"pgdir_t"
	.section	.debug_line_str,"MS",@progbits,1
.LASF1:
	.string	"/home/will/WIX/kernel"
.LASF0:
	.string	"src/init/init.c"
	.ident	"GCC: (GNU) 12.2.0"

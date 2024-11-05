	.file	"init.c"
	.text
.Ltext0:
	.cfi_sections	.debug_frame
	.file 0 "/home/will/WIX/kernel" "src/init/init.c"
	.globl	cur_task
	.section	.bss
	.align 4
	.type	cur_task, @object
	.size	cur_task, 4
cur_task:
	.zero	4
	.globl	base_task
	.align 4
	.type	base_task, @object
	.size	base_task, 16
base_task:
	.zero	16
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
	.loc 1 39 35
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
	.loc 1 40 5
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
	.loc 1 41 1
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
	.loc 1 44 37
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$8, %esp
	.loc 1 48 5
	subl	$12, %esp
	pushl	$0
	call	pic_send_eoi
	addl	$16, %esp
	.loc 1 50 5
	subl	$12, %esp
	pushl	8(%ebp)
	call	task_switch
	addl	$16, %esp
	.loc 1 52 1
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
	.loc 1 54 45
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	.loc 1 56 12
	movl	$195948557, %eax
	.loc 1 57 1
	popl	%ebp
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
	.loc 1 59 20
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	.loc 1 60 14
	movl	$base_task, cur_task
	.loc 1 61 20
	movl	cur_task, %eax
	movl	%eax, base_task+4
	.loc 1 62 1
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
	.loc 1 64 19
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$8, %esp
	.loc 1 65 5
	call	disable_interrupts
	.loc 1 66 5
	movl	dbg_printf, %eax
	subl	$12, %esp
	pushl	$.LC1
	call	*%eax
.LVL1:
	addl	$16, %esp
.L7:
	.loc 1 67 10 discriminator 1
	jmp	.L7
	.cfi_endproc
.LFE4:
	.size	thread_exit, .-thread_exit
	.section	.rodata
.LC2:
	.string	"A"
	.text
	.globl	thread_fun_1
	.type	thread_fun_1, @function
thread_fun_1:
.LFB5:
	.loc 1 70 31
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$8, %esp
.L9:
	.loc 1 72 9 discriminator 1
	movl	dbg_printf, %eax
	subl	$12, %esp
	pushl	$.LC2
	call	*%eax
.LVL2:
	addl	$16, %esp
	jmp	.L9
	.cfi_endproc
.LFE5:
	.size	thread_fun_1, .-thread_fun_1
	.section	.rodata
.LC3:
	.string	"B"
	.text
	.globl	thread_fun_2
	.type	thread_fun_2, @function
thread_fun_2:
.LFB6:
	.loc 1 77 31
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$8, %esp
.L11:
	.loc 1 79 9 discriminator 1
	movl	dbg_printf, %eax
	subl	$12, %esp
	pushl	$.LC3
	call	*%eax
.LVL3:
	addl	$16, %esp
	jmp	.L11
	.cfi_endproc
.LFE6:
	.size	thread_fun_2, .-thread_fun_2
	.globl	create_thread
	.type	create_thread, @function
create_thread:
.LFB7:
	.loc 1 86 64
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$24, %esp
	.loc 1 87 23
	subl	$12, %esp
	pushl	$4096
	call	heap_alloc
	addl	$16, %esp
	.loc 1 87 40
	addl	$4096, %eax
	.loc 1 87 15
	movl	%eax, -12(%ebp)
	.loc 1 89 10
	subl	$4, -12(%ebp)
	.loc 1 89 21
	movl	16(%ebp), %edx
	movl	-12(%ebp), %eax
	movl	%edx, (%eax)
	.loc 1 90 10
	subl	$4, -12(%ebp)
	.loc 1 90 21
	movl	$thread_exit, %edx
	movl	-12(%ebp), %eax
	movl	%edx, (%eax)
	.loc 1 91 10
	subl	$4, -12(%ebp)
	.loc 1 91 21
	movl	12(%ebp), %edx
	movl	-12(%ebp), %eax
	movl	%edx, (%eax)
	.loc 1 92 10
	subl	$4, -12(%ebp)
	.loc 1 92 21
	movl	-12(%ebp), %eax
	movl	$514, (%eax)
	.loc 1 93 10
	subl	$4, -12(%ebp)
	.loc 1 93 21
	movl	-12(%ebp), %eax
	movl	$0, (%eax)
	.loc 1 94 10
	subl	$4, -12(%ebp)
	.loc 1 94 21
	movl	-12(%ebp), %eax
	movl	$0, (%eax)
	.loc 1 95 10
	subl	$4, -12(%ebp)
	.loc 1 95 21
	movl	-12(%ebp), %eax
	movl	$0, (%eax)
	.loc 1 96 10
	subl	$4, -12(%ebp)
	.loc 1 96 21
	movl	-12(%ebp), %eax
	movl	$0, (%eax)
	.loc 1 97 10
	subl	$4, -12(%ebp)
	.loc 1 97 21
	movl	-12(%ebp), %eax
	movl	$0, (%eax)
	.loc 1 98 10
	subl	$4, -12(%ebp)
	.loc 1 98 21
	movl	-12(%ebp), %eax
	movl	$0, (%eax)
	.loc 1 99 10
	subl	$4, -12(%ebp)
	.loc 1 99 21
	movl	-12(%ebp), %eax
	movl	$0, (%eax)
	.loc 1 101 15
	movl	-12(%ebp), %edx
	movl	8(%ebp), %eax
	movl	%edx, (%eax)
	.loc 1 102 1
	nop
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE7:
	.size	create_thread, .-create_thread
	.section	.rodata
.LC4:
	.string	"About to enable interrupts\n"
	.text
	.globl	spawn_thread
	.type	spawn_thread, @function
spawn_thread:
.LFB8:
	.loc 1 104 52
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$24, %esp
	.loc 1 105 5
	call	disable_interrupts
	.loc 1 106 28
	movl	cur_task, %eax
	.loc 1 106 13
	movl	4(%eax), %eax
	movl	%eax, -12(%ebp)
	.loc 1 107 22
	subl	$12, %esp
	pushl	$16
	call	heap_alloc
	addl	$16, %esp
	movl	%eax, %edx
	.loc 1 107 13
	movl	cur_task, %eax
	.loc 1 107 20
	movl	%edx, 4(%eax)
	.loc 1 108 13
	movl	cur_task, %eax
	movl	4(%eax), %eax
	.loc 1 108 26
	movl	cur_task, %edx
	movl	%edx, 8(%eax)
	.loc 1 109 13
	movl	cur_task, %eax
	movl	4(%eax), %eax
	.loc 1 109 26
	movl	-12(%ebp), %edx
	movl	%edx, 4(%eax)
	.loc 1 110 26
	movl	cur_task, %eax
	movl	4(%eax), %edx
	.loc 1 110 16
	movl	-12(%ebp), %eax
	movl	%edx, 8(%eax)
	.loc 1 112 17
	movl	cur_task, %eax
	movl	8(%eax), %eax
	.loc 1 112 7
	testl	%eax, %eax
	jne	.L14
	.loc 1 112 33 discriminator 1
	movl	cur_task, %eax
	.loc 1 112 40 discriminator 1
	movl	-12(%ebp), %edx
	movl	%edx, 8(%eax)
.L14:
	.loc 1 114 27
	movl	cur_task, %eax
	movl	4(%eax), %eax
	.loc 1 114 5
	subl	$4, %esp
	pushl	12(%ebp)
	pushl	8(%ebp)
	pushl	%eax
	call	create_thread
	addl	$16, %esp
	.loc 1 116 5
	movl	dbg_printf, %eax
	subl	$12, %esp
	pushl	$.LC4
	call	*%eax
.LVL4:
	addl	$16, %esp
	.loc 1 118 5
	call	enable_interrupts
	.loc 1 120 20
	movl	cur_task, %eax
	movl	4(%eax), %eax
	.loc 1 121 1
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE8:
	.size	spawn_thread, .-spawn_thread
	.globl	print
	.type	print, @function
print:
.LFB9:
	.loc 1 128 22
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$8, %esp
	.loc 1 129 5
	subl	$12, %esp
	pushl	8(%ebp)
	call	strlen
	addl	$16, %esp
	subl	$8, %esp
	pushl	%eax
	pushl	8(%ebp)
	call	tty_write
	addl	$16, %esp
	.loc 1 130 1
	nop
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE9:
	.size	print, .-print
	.section	.rodata
.LC5:
	.string	"Hello %d\n"
	.text
	.globl	_start
	.type	_start, @function
_start:
.LFB10:
	.loc 1 132 45
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$56, %esp
	.loc 1 134 9
	movl	$0, -12(%ebp)
	.loc 1 135 5
	call	pmm_init
	.loc 1 137 24
	movl	8(%ebp), %eax
	movl	8(%eax), %eax
	.loc 1 137 16
	movl	%eax, dbg_printf
	.loc 1 139 5
	subl	$12, %esp
	pushl	$1048576
	call	sbrk
	addl	$16, %esp
	.loc 1 140 5
	call	heap_init
	.loc 1 141 5
	call	init_tasking
	.loc 1 142 5
	subl	$8, %esp
	pushl	$120
	pushl	$112
	call	pic_remap
	addl	$16, %esp
	.loc 1 143 5
	call	idt_init
	.loc 1 144 5
	subl	$8, %esp
	pushl	$pit_isr
	pushl	$112
	call	set_isr
	addl	$16, %esp
	.loc 1 145 5
	subl	$8, %esp
	pushl	$syscall_handler
	pushl	$128
	call	set_isr
	addl	$16, %esp
	.loc 1 147 5
	call	gdt_init
	.loc 1 149 5
	subl	$4, %esp
	pushl	$2097152
	pushl	$753664
	pushl	$196608
	call	map_page
	addl	$16, %esp
	.loc 1 151 5
	subl	$8, %esp
	pushl	$52
	pushl	$67
	call	io_write_8
	addl	$16, %esp
	.loc 1 154 2
	subl	$8, %esp
	pushl	$223
	pushl	$64
	call	io_write_8
	addl	$16, %esp
	.loc 1 155 2
	subl	$8, %esp
	pushl	$4
	pushl	$64
	call	io_write_8
	addl	$16, %esp
	.loc 1 159 5
	call	tty_init
	.loc 1 165 5
	subl	$8, %esp
	pushl	$0
	pushl	$thread_fun_1
	call	spawn_thread
	addl	$16, %esp
	.loc 1 166 5
	subl	$8, %esp
	pushl	$0
	pushl	$thread_fun_2
	call	spawn_thread
	addl	$16, %esp
.L18:
.LBB2:
	.loc 1 173 9 discriminator 1
	movl	-12(%ebp), %eax
	leal	1(%eax), %edx
	movl	%edx, -12(%ebp)
	subl	$4, %esp
	pushl	%eax
	pushl	$.LC5
	leal	-52(%ebp), %eax
	pushl	%eax
	call	sprintf
	addl	$16, %esp
	.loc 1 174 9 discriminator 1
	subl	$12, %esp
	leal	-52(%ebp), %eax
	pushl	%eax
	call	strlen
	addl	$16, %esp
	subl	$8, %esp
	pushl	%eax
	leal	-52(%ebp), %eax
	pushl	%eax
	call	tty_write
	addl	$16, %esp
.LBE2:
	.loc 1 172 13 discriminator 1
	jmp	.L18
	.cfi_endproc
.LFE10:
	.size	_start, .-_start
.Letext0:
	.file 2 "/usr/local/i386elfgcc/lib/gcc/i386-elf/12.2.0/include/stdint-gcc.h"
	.file 3 "include/init/idt.h"
	.file 4 "include/mm/vmm.h"
	.file 5 "include/libk/stdio.h"
	.file 6 "include/init/pic.h"
	.file 7 "include/init/gdt.h"
	.file 8 "include/mm/pmm.h"
	.section	.debug_info,"",@progbits
.Ldebug_info0:
	.long	0x6ec
	.value	0x5
	.byte	0x1
	.byte	0x4
	.long	.Ldebug_abbrev0
	.uleb128 0x18
	.long	.LASF80
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
	.uleb128 0xf
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
	.uleb128 0x11
	.long	0x68
	.long	0x14c
	.uleb128 0x3
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
	.uleb128 0x12
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
	.long	.LASF27
	.byte	0xc
	.byte	0x1
	.byte	0xf
	.long	0x1fd
	.uleb128 0x8
	.long	.LASF28
	.byte	0x1
	.byte	0x10
	.byte	0xe
	.long	0x55
	.byte	0
	.uleb128 0x8
	.long	.LASF29
	.byte	0x1
	.byte	0x11
	.byte	0xe
	.long	0x55
	.byte	0x2
	.uleb128 0x8
	.long	.LASF30
	.byte	0x1
	.byte	0x12
	.byte	0xe
	.long	0x55
	.byte	0x4
	.uleb128 0x8
	.long	.LASF31
	.byte	0x1
	.byte	0x13
	.byte	0xc
	.long	0x20e
	.byte	0x8
	.byte	0
	.uleb128 0x1e
	.long	0x209
	.uleb128 0x3
	.long	0x209
	.uleb128 0x1
	.byte	0
	.uleb128 0x6
	.long	0x1b7
	.uleb128 0x6
	.long	0x1fd
	.uleb128 0x5
	.long	.LASF32
	.byte	0x1
	.byte	0x14
	.byte	0x3
	.long	0x1bc
	.uleb128 0xf
	.long	.LASF33
	.byte	0x10
	.byte	0x1
	.byte	0x16
	.long	0x260
	.uleb128 0x7
	.string	"esp"
	.byte	0x1
	.byte	0x17
	.byte	0xe
	.long	0x68
	.byte	0
	.uleb128 0x8
	.long	.LASF34
	.byte	0x1
	.byte	0x18
	.byte	0x12
	.long	0x260
	.byte	0x4
	.uleb128 0x8
	.long	.LASF35
	.byte	0x1
	.byte	0x19
	.byte	0x12
	.long	0x260
	.byte	0x8
	.uleb128 0x8
	.long	.LASF36
	.byte	0x1
	.byte	0x1a
	.byte	0xe
	.long	0x68
	.byte	0xc
	.byte	0
	.uleb128 0x6
	.long	0x21f
	.uleb128 0x5
	.long	.LASF37
	.byte	0x1
	.byte	0x1b
	.byte	0x3
	.long	0x21f
	.uleb128 0x5
	.long	.LASF38
	.byte	0x1
	.byte	0x1d
	.byte	0xb
	.long	0x27d
	.uleb128 0x6
	.long	0x282
	.uleb128 0x11
	.long	0x82
	.long	0x291
	.uleb128 0x3
	.long	0x12a
	.byte	0
	.uleb128 0x13
	.long	.LASF39
	.byte	0x1f
	.byte	0x9
	.long	0x2a2
	.uleb128 0x5
	.byte	0x3
	.long	cur_task
	.uleb128 0x6
	.long	0x265
	.uleb128 0x13
	.long	.LASF40
	.byte	0x20
	.byte	0x8
	.long	0x265
	.uleb128 0x5
	.byte	0x3
	.long	base_task
	.uleb128 0x1f
	.long	.LASF41
	.byte	0x1
	.byte	0x22
	.byte	0xf
	.long	0x20e
	.uleb128 0x14
	.long	.LASF45
	.byte	0x5
	.byte	0x6
	.byte	0x5
	.long	0x82
	.long	0x2e0
	.uleb128 0x3
	.long	0x2e0
	.uleb128 0x3
	.long	0x209
	.uleb128 0x1
	.byte	0
	.uleb128 0x6
	.long	0x1b0
	.uleb128 0x2
	.long	.LASF42
	.byte	0x9f
	.byte	0x5
	.long	0x82
	.long	0x2f6
	.uleb128 0x1
	.byte	0
	.uleb128 0x2
	.long	.LASF43
	.byte	0x97
	.byte	0x5
	.long	0x82
	.long	0x307
	.uleb128 0x1
	.byte	0
	.uleb128 0xb
	.long	.LASF44
	.byte	0x4
	.byte	0x11
	.long	0x322
	.uleb128 0x3
	.long	0x322
	.uleb128 0x3
	.long	0x15f
	.uleb128 0x3
	.long	0x16b
	.byte	0
	.uleb128 0x6
	.long	0x1a4
	.uleb128 0xc
	.long	.LASF50
	.byte	0x7
	.byte	0x3a
	.long	0x334
	.uleb128 0x1
	.byte	0
	.uleb128 0x14
	.long	.LASF46
	.byte	0x3
	.byte	0x1c
	.byte	0xa
	.long	0x12c
	.long	0x34f
	.uleb128 0x3
	.long	0x82
	.uleb128 0x3
	.long	0x12c
	.byte	0
	.uleb128 0x20
	.long	.LASF81
	.byte	0x3
	.byte	0x20
	.byte	0x6
	.uleb128 0xb
	.long	.LASF47
	.byte	0x6
	.byte	0x1a
	.long	0x36d
	.uleb128 0x3
	.long	0x42
	.uleb128 0x3
	.long	0x42
	.byte	0
	.uleb128 0x2
	.long	.LASF48
	.byte	0x8c
	.byte	0x5
	.long	0x82
	.long	0x37e
	.uleb128 0x1
	.byte	0
	.uleb128 0x2
	.long	.LASF49
	.byte	0x8b
	.byte	0x5
	.long	0x82
	.long	0x38f
	.uleb128 0x1
	.byte	0
	.uleb128 0xc
	.long	.LASF51
	.byte	0x8
	.byte	0x8
	.long	0x39c
	.uleb128 0x1
	.byte	0
	.uleb128 0x2
	.long	.LASF52
	.byte	0x81
	.byte	0x5
	.long	0x82
	.long	0x3ad
	.uleb128 0x1
	.byte	0
	.uleb128 0x2
	.long	.LASF53
	.byte	0x81
	.byte	0x14
	.long	0x82
	.long	0x3be
	.uleb128 0x1
	.byte	0
	.uleb128 0xc
	.long	.LASF54
	.byte	0x3
	.byte	0x22
	.long	0x3cb
	.uleb128 0x1
	.byte	0
	.uleb128 0x2
	.long	.LASF55
	.byte	0x57
	.byte	0x17
	.long	0x82
	.long	0x3dc
	.uleb128 0x1
	.byte	0
	.uleb128 0xc
	.long	.LASF56
	.byte	0x3
	.byte	0x23
	.long	0x3e9
	.uleb128 0x1
	.byte	0
	.uleb128 0xb
	.long	.LASF57
	.byte	0x1
	.byte	0x23
	.long	0x3fa
	.uleb128 0x3
	.long	0x14c
	.byte	0
	.uleb128 0xb
	.long	.LASF58
	.byte	0x6
	.byte	0x19
	.long	0x40b
	.uleb128 0x3
	.long	0x42
	.byte	0
	.uleb128 0xa
	.long	.LASF65
	.byte	0x84
	.long	.LFB10
	.long	.LFE10-.LFB10
	.uleb128 0x1
	.byte	0x9c
	.long	0x50f
	.uleb128 0x9
	.long	.LASF67
	.byte	0x84
	.byte	0x26
	.long	0x50f
	.uleb128 0x2
	.byte	0x91
	.sleb128 0
	.uleb128 0x15
	.string	"buf"
	.byte	0x85
	.byte	0xa
	.long	0x514
	.uleb128 0x2
	.byte	0x91
	.sleb128 -60
	.uleb128 0x15
	.string	"n"
	.byte	0x86
	.byte	0x9
	.long	0x82
	.uleb128 0x2
	.byte	0x91
	.sleb128 -20
	.uleb128 0x2
	.long	.LASF49
	.byte	0x8b
	.byte	0x5
	.long	0x82
	.long	0x458
	.uleb128 0x1
	.byte	0
	.uleb128 0x2
	.long	.LASF48
	.byte	0x8c
	.byte	0x5
	.long	0x82
	.long	0x469
	.uleb128 0x1
	.byte	0
	.uleb128 0x2
	.long	.LASF43
	.byte	0x97
	.byte	0x5
	.long	0x82
	.long	0x47a
	.uleb128 0x1
	.byte	0
	.uleb128 0x2
	.long	.LASF42
	.byte	0x9f
	.byte	0x5
	.long	0x82
	.long	0x48b
	.uleb128 0x1
	.byte	0
	.uleb128 0xd
	.long	.LASF59
	.byte	0xb6
	.long	0x2e0
	.uleb128 0x2
	.long	.LASF55
	.byte	0x57
	.byte	0x17
	.long	0x82
	.long	0x4a6
	.uleb128 0x1
	.byte	0
	.uleb128 0xd
	.long	.LASF60
	.byte	0xb7
	.long	0x2e0
	.uleb128 0xd
	.long	.LASF61
	.byte	0xb8
	.long	0x2e0
	.uleb128 0xd
	.long	.LASF62
	.byte	0xba
	.long	0x2e0
	.uleb128 0x2
	.long	.LASF63
	.byte	0xbb
	.byte	0x5
	.long	0x82
	.long	0x4d5
	.uleb128 0x1
	.byte	0
	.uleb128 0x2
	.long	.LASF64
	.byte	0xbc
	.byte	0x5
	.long	0x82
	.long	0x4e6
	.uleb128 0x1
	.byte	0
	.uleb128 0x21
	.long	.LBB2
	.long	.LBE2-.LBB2
	.uleb128 0x2
	.long	.LASF52
	.byte	0x81
	.byte	0x5
	.long	0x82
	.long	0x500
	.uleb128 0x1
	.byte	0
	.uleb128 0xe
	.long	.LASF53
	.byte	0x81
	.byte	0x14
	.long	0x82
	.uleb128 0x1
	.byte	0
	.byte	0
	.byte	0
	.uleb128 0x6
	.long	0x213
	.uleb128 0x12
	.long	0x1b0
	.long	0x524
	.uleb128 0x22
	.long	0x74
	.byte	0x27
	.byte	0
	.uleb128 0xa
	.long	.LASF66
	.byte	0x80
	.long	.LFB9
	.long	.LFE9-.LFB9
	.uleb128 0x1
	.byte	0x9c
	.long	0x565
	.uleb128 0x10
	.string	"str"
	.byte	0x80
	.byte	0x12
	.long	0x2e0
	.uleb128 0x2
	.byte	0x91
	.sleb128 0
	.uleb128 0x2
	.long	.LASF52
	.byte	0x81
	.byte	0x5
	.long	0x82
	.long	0x557
	.uleb128 0x1
	.byte	0
	.uleb128 0xe
	.long	.LASF53
	.byte	0x81
	.byte	0x14
	.long	0x82
	.uleb128 0x1
	.byte	0
	.byte	0
	.uleb128 0x16
	.long	.LASF76
	.byte	0x68
	.byte	0x9
	.long	0x2a2
	.long	.LFB8
	.long	.LFE8-.LFB8
	.uleb128 0x1
	.byte	0x9c
	.long	0x5b5
	.uleb128 0x10
	.string	"fn"
	.byte	0x68
	.byte	0x24
	.long	0x271
	.uleb128 0x2
	.byte	0x91
	.sleb128 0
	.uleb128 0x9
	.long	.LASF68
	.byte	0x68
	.byte	0x2e
	.long	0x12a
	.uleb128 0x2
	.byte	0x91
	.sleb128 4
	.uleb128 0x17
	.long	.LASF69
	.byte	0x6a
	.byte	0xd
	.long	0x2a2
	.uleb128 0x2
	.byte	0x91
	.sleb128 -20
	.uleb128 0xe
	.long	.LASF55
	.byte	0x57
	.byte	0x17
	.long	0x82
	.uleb128 0x1
	.byte	0
	.byte	0
	.uleb128 0xa
	.long	.LASF70
	.byte	0x56
	.long	.LFB7
	.long	.LFE7-.LFB7
	.uleb128 0x1
	.byte	0x9c
	.long	0x60e
	.uleb128 0x9
	.long	.LASF33
	.byte	0x56
	.byte	0x1c
	.long	0x2a2
	.uleb128 0x2
	.byte	0x91
	.sleb128 0
	.uleb128 0x10
	.string	"fn"
	.byte	0x56
	.byte	0x30
	.long	0x271
	.uleb128 0x2
	.byte	0x91
	.sleb128 4
	.uleb128 0x9
	.long	.LASF68
	.byte	0x56
	.byte	0x3a
	.long	0x12a
	.uleb128 0x2
	.byte	0x91
	.sleb128 8
	.uleb128 0x17
	.long	.LASF71
	.byte	0x57
	.byte	0xf
	.long	0x60e
	.uleb128 0x2
	.byte	0x91
	.sleb128 -20
	.uleb128 0xe
	.long	.LASF55
	.byte	0x57
	.byte	0x17
	.long	0x82
	.uleb128 0x1
	.byte	0
	.byte	0
	.uleb128 0x6
	.long	0x68
	.uleb128 0xa
	.long	.LASF72
	.byte	0x4d
	.long	.LFB6
	.long	.LFE6-.LFB6
	.uleb128 0x1
	.byte	0x9c
	.long	0x636
	.uleb128 0x9
	.long	.LASF68
	.byte	0x4d
	.byte	0x19
	.long	0x12a
	.uleb128 0x2
	.byte	0x91
	.sleb128 0
	.byte	0
	.uleb128 0xa
	.long	.LASF73
	.byte	0x46
	.long	.LFB5
	.long	.LFE5-.LFB5
	.uleb128 0x1
	.byte	0x9c
	.long	0x659
	.uleb128 0x9
	.long	.LASF68
	.byte	0x46
	.byte	0x19
	.long	0x12a
	.uleb128 0x2
	.byte	0x91
	.sleb128 0
	.byte	0
	.uleb128 0x23
	.long	.LASF74
	.byte	0x1
	.byte	0x40
	.byte	0x6
	.long	.LFB4
	.long	.LFE4-.LFB4
	.uleb128 0x1
	.byte	0x9c
	.uleb128 0x24
	.long	.LASF75
	.byte	0x1
	.byte	0x3b
	.byte	0x6
	.long	.LFB3
	.long	.LFE3-.LFB3
	.uleb128 0x1
	.byte	0x9c
	.uleb128 0x25
	.long	.LASF77
	.byte	0x1
	.byte	0x36
	.byte	0xa
	.long	0x68
	.long	.LFB2
	.long	.LFE2-.LFB2
	.uleb128 0x1
	.byte	0x9c
	.long	0x6a6
	.uleb128 0x9
	.long	.LASF78
	.byte	0x36
	.byte	0x27
	.long	0x14c
	.uleb128 0x2
	.byte	0x91
	.sleb128 0
	.byte	0
	.uleb128 0x16
	.long	.LASF79
	.byte	0x2c
	.byte	0xa
	.long	0x68
	.long	.LFB1
	.long	.LFE1-.LFB1
	.uleb128 0x1
	.byte	0x9c
	.long	0x6ce
	.uleb128 0x9
	.long	.LASF78
	.byte	0x2c
	.byte	0x1f
	.long	0x14c
	.uleb128 0x2
	.byte	0x91
	.sleb128 0
	.byte	0
	.uleb128 0x26
	.long	.LASF82
	.byte	0x1
	.byte	0x27
	.byte	0x6
	.long	.LFB0
	.long	.LFE0-.LFB0
	.uleb128 0x1
	.byte	0x9c
	.uleb128 0x9
	.long	.LASF78
	.byte	0x27
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
	.uleb128 0x3
	.uleb128 0x5
	.byte	0
	.uleb128 0x49
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
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x3c
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xc
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
	.uleb128 0xd
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
	.uleb128 0xe
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
	.uleb128 0xf
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
	.uleb128 0x10
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
	.uleb128 0x11
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
	.uleb128 0x12
	.uleb128 0x1
	.byte	0x1
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x13
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
	.uleb128 0x14
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
	.uleb128 0x15
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
	.uleb128 0x16
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
	.uleb128 0x17
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
	.uleb128 0xb
	.byte	0x1
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x6
	.byte	0
	.byte	0
	.uleb128 0x22
	.uleb128 0x21
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2f
	.uleb128 0xb
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
	.uleb128 0x7c
	.uleb128 0x19
	.byte	0
	.byte	0
	.uleb128 0x24
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
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x6
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x7a
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x26
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
.LASF76:
	.string	"spawn_thread"
.LASF44:
	.string	"map_page"
.LASF46:
	.string	"set_isr"
.LASF24:
	.string	"entries"
.LASF74:
	.string	"thread_exit"
.LASF34:
	.string	"next"
.LASF56:
	.string	"disable_interrupts"
.LASF69:
	.string	"temp"
.LASF3:
	.string	"short int"
.LASF43:
	.string	"io_write_8"
.LASF15:
	.string	"eflags"
.LASF30:
	.string	"mem_size"
.LASF65:
	.string	"_start"
.LASF33:
	.string	"task"
.LASF52:
	.string	"tty_write"
.LASF36:
	.string	"esp0"
.LASF7:
	.string	"uint8_t"
.LASF14:
	.string	"uintptr_t"
.LASF58:
	.string	"pic_send_eoi"
.LASF37:
	.string	"task_t"
.LASF54:
	.string	"enable_interrupts"
.LASF21:
	.string	"vaddr_t"
.LASF42:
	.string	"tty_init"
.LASF77:
	.string	"syscall_handler"
.LASF5:
	.string	"long long int"
.LASF28:
	.string	"kernel_sectors"
.LASF51:
	.string	"pmm_init"
.LASF4:
	.string	"long int"
.LASF31:
	.string	"printf"
.LASF82:
	.string	"dump_regs"
.LASF63:
	.string	"heap_free"
.LASF67:
	.string	"params"
.LASF72:
	.string	"thread_fun_2"
.LASF18:
	.string	"long double"
.LASF6:
	.string	"unsigned char"
.LASF49:
	.string	"sbrk"
.LASF45:
	.string	"sprintf"
.LASF2:
	.string	"signed char"
.LASF12:
	.string	"long long unsigned int"
.LASF66:
	.string	"print"
.LASF10:
	.string	"uint32_t"
.LASF13:
	.string	"unsigned int"
.LASF8:
	.string	"uint16_t"
.LASF71:
	.string	"stack"
.LASF64:
	.string	"heap_print"
.LASF32:
	.string	"kernel_startup_params_t"
.LASF68:
	.string	"param"
.LASF9:
	.string	"short unsigned int"
.LASF55:
	.string	"heap_alloc"
.LASF26:
	.string	"char"
.LASF53:
	.string	"strlen"
.LASF39:
	.string	"cur_task"
.LASF75:
	.string	"init_tasking"
.LASF48:
	.string	"heap_init"
.LASF20:
	.string	"paddr_t"
.LASF11:
	.string	"long unsigned int"
.LASF60:
	.string	"ptr2"
.LASF22:
	.string	"_int_state"
.LASF29:
	.string	"ramdisk_sectors"
.LASF78:
	.string	"state"
.LASF38:
	.string	"thread_func_t"
.LASF16:
	.string	"int_state_t"
.LASF50:
	.string	"gdt_init"
.LASF27:
	.string	"kernel_startup_params"
.LASF17:
	.string	"isr_func"
.LASF79:
	.string	"pit_isr"
.LASF81:
	.string	"idt_init"
.LASF19:
	.string	"_Float128"
.LASF70:
	.string	"create_thread"
.LASF59:
	.string	"ptr1"
.LASF61:
	.string	"ptr3"
.LASF62:
	.string	"ptr4"
.LASF23:
	.string	"pgdir"
.LASF41:
	.string	"dbg_printf"
.LASF57:
	.string	"task_switch"
.LASF35:
	.string	"prev"
.LASF47:
	.string	"pic_remap"
.LASF40:
	.string	"base_task"
.LASF80:
	.string	"GNU C17 12.2.0 -m32 -mtune=i386 -march=i386 -g -ffreestanding"
.LASF73:
	.string	"thread_fun_1"
.LASF25:
	.string	"pgdir_t"
	.section	.debug_line_str,"MS",@progbits,1
.LASF1:
	.string	"/home/will/WIX/kernel"
.LASF0:
	.string	"src/init/init.c"
	.ident	"GCC: (GNU) 12.2.0"

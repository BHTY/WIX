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
	.size	base_task, 12
base_task:
	.zero	12
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
	.loc 1 38 35
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
	.loc 1 39 5
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
	.loc 1 40 1
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
	.loc 1 43 37
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$8, %esp
	.loc 1 47 5
	subl	$12, %esp
	pushl	$0
	call	pic_send_eoi
	addl	$16, %esp
	.loc 1 49 5
	subl	$12, %esp
	pushl	8(%ebp)
	call	task_switch
	addl	$16, %esp
	.loc 1 51 1
	nop
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE1:
	.size	pit_isr, .-pit_isr
	.section	.rodata
.LC1:
	.string	"System call %x\n"
	.text
	.globl	syscall_handler
	.type	syscall_handler, @function
syscall_handler:
.LFB2:
	.loc 1 53 45
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$8, %esp
	.loc 1 54 5
	movl	dbg_printf, %eax
	movl	8(%ebp), %edx
	movl	28(%edx), %edx
	subl	$8, %esp
	pushl	%edx
	pushl	$.LC1
	call	*%eax
.LVL1:
	addl	$16, %esp
	.loc 1 55 12
	movl	$195948557, %eax
	.loc 1 56 1
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
	.loc 1 58 20
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	.loc 1 59 14
	movl	$base_task, cur_task
	.loc 1 60 20
	movl	cur_task, %eax
	movl	%eax, base_task+4
	.loc 1 61 1
	nop
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE3:
	.size	init_tasking, .-init_tasking
	.section	.rodata
.LC2:
	.string	"Thread exit!\n"
	.text
	.globl	thread_exit
	.type	thread_exit, @function
thread_exit:
.LFB4:
	.loc 1 63 19
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$8, %esp
	.loc 1 64 5
	call	disable_interrupts
	.loc 1 65 5
	movl	dbg_printf, %eax
	subl	$12, %esp
	pushl	$.LC2
	call	*%eax
.LVL2:
	addl	$16, %esp
.L7:
	.loc 1 66 10 discriminator 1
	jmp	.L7
	.cfi_endproc
.LFE4:
	.size	thread_exit, .-thread_exit
	.globl	create_thread
	.type	create_thread, @function
create_thread:
.LFB5:
	.loc 1 85 64
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$24, %esp
	.loc 1 86 23
	subl	$12, %esp
	pushl	$4096
	call	heap_alloc
	addl	$16, %esp
	.loc 1 86 40
	addl	$4096, %eax
	.loc 1 86 15
	movl	%eax, -12(%ebp)
	.loc 1 88 10
	subl	$4, -12(%ebp)
	.loc 1 88 21
	movl	16(%ebp), %edx
	movl	-12(%ebp), %eax
	movl	%edx, (%eax)
	.loc 1 89 10
	subl	$4, -12(%ebp)
	.loc 1 89 21
	movl	$thread_exit, %edx
	movl	-12(%ebp), %eax
	movl	%edx, (%eax)
	.loc 1 90 10
	subl	$4, -12(%ebp)
	.loc 1 90 21
	movl	12(%ebp), %edx
	movl	-12(%ebp), %eax
	movl	%edx, (%eax)
	.loc 1 91 10
	subl	$4, -12(%ebp)
	.loc 1 91 21
	movl	-12(%ebp), %eax
	movl	$514, (%eax)
	.loc 1 92 10
	subl	$4, -12(%ebp)
	.loc 1 92 21
	movl	-12(%ebp), %eax
	movl	$0, (%eax)
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
	.loc 1 100 15
	movl	-12(%ebp), %edx
	movl	8(%ebp), %eax
	movl	%edx, (%eax)
	.loc 1 101 1
	nop
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE5:
	.size	create_thread, .-create_thread
	.section	.rodata
.LC3:
	.string	"About to enable interrupts\n"
	.text
	.globl	spawn_thread
	.type	spawn_thread, @function
spawn_thread:
.LFB6:
	.loc 1 103 52
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$24, %esp
	.loc 1 104 5
	call	disable_interrupts
	.loc 1 105 28
	movl	cur_task, %eax
	.loc 1 105 13
	movl	4(%eax), %eax
	movl	%eax, -12(%ebp)
	.loc 1 106 22
	subl	$12, %esp
	pushl	$12
	call	heap_alloc
	addl	$16, %esp
	movl	%eax, %edx
	.loc 1 106 13
	movl	cur_task, %eax
	.loc 1 106 20
	movl	%edx, 4(%eax)
	.loc 1 107 13
	movl	cur_task, %eax
	movl	4(%eax), %eax
	.loc 1 107 26
	movl	cur_task, %edx
	movl	%edx, 8(%eax)
	.loc 1 108 13
	movl	cur_task, %eax
	movl	4(%eax), %eax
	.loc 1 108 26
	movl	-12(%ebp), %edx
	movl	%edx, 4(%eax)
	.loc 1 109 26
	movl	cur_task, %eax
	movl	4(%eax), %edx
	.loc 1 109 16
	movl	-12(%ebp), %eax
	movl	%edx, 8(%eax)
	.loc 1 111 17
	movl	cur_task, %eax
	movl	8(%eax), %eax
	.loc 1 111 7
	testl	%eax, %eax
	jne	.L10
	.loc 1 111 33 discriminator 1
	movl	cur_task, %eax
	.loc 1 111 40 discriminator 1
	movl	-12(%ebp), %edx
	movl	%edx, 8(%eax)
.L10:
	.loc 1 113 27
	movl	cur_task, %eax
	movl	4(%eax), %eax
	.loc 1 113 5
	subl	$4, %esp
	pushl	12(%ebp)
	pushl	8(%ebp)
	pushl	%eax
	call	create_thread
	addl	$16, %esp
	.loc 1 115 5
	movl	dbg_printf, %eax
	subl	$12, %esp
	pushl	$.LC3
	call	*%eax
.LVL3:
	addl	$16, %esp
	.loc 1 117 5
	call	enable_interrupts
	.loc 1 119 20
	movl	cur_task, %eax
	movl	4(%eax), %eax
	.loc 1 120 1
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE6:
	.size	spawn_thread, .-spawn_thread
	.globl	_start
	.type	_start, @function
_start:
.LFB7:
	.loc 1 125 45
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$56, %esp
	.loc 1 127 5
	call	pmm_init
	.loc 1 129 24
	movl	8(%ebp), %eax
	movl	8(%eax), %eax
	.loc 1 129 16
	movl	%eax, dbg_printf
	.loc 1 131 5
	subl	$12, %esp
	pushl	$1048576
	call	sbrk
	addl	$16, %esp
	.loc 1 132 5
	call	heap_init
	.loc 1 133 5
	call	init_tasking
	.loc 1 134 5
	subl	$8, %esp
	pushl	$120
	pushl	$112
	call	pic_remap
	addl	$16, %esp
	.loc 1 135 5
	call	idt_init
	.loc 1 136 5
	subl	$8, %esp
	pushl	$pit_isr
	pushl	$112
	call	set_isr
	addl	$16, %esp
	.loc 1 137 5
	subl	$8, %esp
	pushl	$syscall_handler
	pushl	$128
	call	set_isr
	addl	$16, %esp
	.loc 1 139 5
	call	gdt_init
	.loc 1 141 5
	subl	$4, %esp
	pushl	$2097152
	pushl	$753664
	pushl	$196608
	call	map_page
	addl	$16, %esp
	.loc 1 143 5
	subl	$8, %esp
	pushl	$52
	pushl	$67
	call	io_write_8
	addl	$16, %esp
	.loc 1 146 2
	subl	$8, %esp
	pushl	$223
	pushl	$64
	call	io_write_8
	addl	$16, %esp
	.loc 1 147 2
	subl	$8, %esp
	pushl	$4
	pushl	$64
	call	io_write_8
	addl	$16, %esp
	.loc 1 149 5
	subl	$8, %esp
	pushl	$0
	pushl	$thread_fun_1
	call	spawn_thread
	addl	$16, %esp
	.loc 1 150 5
	subl	$8, %esp
	pushl	$0
	pushl	$thread_fun_2
	call	spawn_thread
	addl	$16, %esp
	.loc 1 154 5
	movl	$test_user_function, %eax
	subl	$8, %esp
	pushl	$61455
	pushl	%eax
	call	jump_usermode
	addl	$16, %esp
.L13:
	.loc 1 156 10 discriminator 1
	jmp	.L13
	.cfi_endproc
.LFE7:
	.size	_start, .-_start
.Letext0:
	.file 2 "/usr/local/i386elfgcc/lib/gcc/i386-elf/12.2.0/include/stdint-gcc.h"
	.file 3 "include/init/idt.h"
	.file 4 "include/mm/vmm.h"
	.file 5 "include/init/gdt.h"
	.file 6 "include/init/pic.h"
	.file 7 "include/mm/pmm.h"
	.section	.debug_info,"",@progbits
.Ldebug_info0:
	.long	0x605
	.value	0x5
	.byte	0x1
	.byte	0x4
	.long	.Ldebug_abbrev0
	.uleb128 0x16
	.long	.LASF75
	.byte	0x1d
	.long	.LASF0
	.long	.LASF1
	.long	.Ltext0
	.long	.Letext0-.Ltext0
	.long	.Ldebug_line0
	.uleb128 0x3
	.byte	0x1
	.byte	0x6
	.long	.LASF2
	.uleb128 0x3
	.byte	0x2
	.byte	0x5
	.long	.LASF3
	.uleb128 0x3
	.byte	0x4
	.byte	0x5
	.long	.LASF4
	.uleb128 0x3
	.byte	0x8
	.byte	0x5
	.long	.LASF5
	.uleb128 0x4
	.long	.LASF7
	.byte	0x2
	.byte	0x2e
	.byte	0x18
	.long	0x4e
	.uleb128 0x3
	.byte	0x1
	.byte	0x8
	.long	.LASF6
	.uleb128 0x4
	.long	.LASF8
	.byte	0x2
	.byte	0x31
	.byte	0x19
	.long	0x61
	.uleb128 0x3
	.byte	0x2
	.byte	0x7
	.long	.LASF9
	.uleb128 0x4
	.long	.LASF10
	.byte	0x2
	.byte	0x34
	.byte	0x19
	.long	0x74
	.uleb128 0x3
	.byte	0x4
	.byte	0x7
	.long	.LASF11
	.uleb128 0x3
	.byte	0x8
	.byte	0x7
	.long	.LASF12
	.uleb128 0x17
	.byte	0x4
	.byte	0x5
	.string	"int"
	.uleb128 0x3
	.byte	0x4
	.byte	0x7
	.long	.LASF13
	.uleb128 0x4
	.long	.LASF14
	.byte	0x2
	.byte	0x56
	.byte	0x1a
	.long	0x74
	.uleb128 0xd
	.long	.LASF22
	.byte	0x24
	.byte	0x3
	.byte	0x14
	.long	0x11e
	.uleb128 0x6
	.string	"edi"
	.byte	0x3
	.byte	0x15
	.byte	0xe
	.long	0x68
	.byte	0
	.uleb128 0x6
	.string	"esi"
	.byte	0x3
	.byte	0x15
	.byte	0x13
	.long	0x68
	.byte	0x4
	.uleb128 0x6
	.string	"ebp"
	.byte	0x3
	.byte	0x15
	.byte	0x18
	.long	0x68
	.byte	0x8
	.uleb128 0x6
	.string	"esp"
	.byte	0x3
	.byte	0x15
	.byte	0x1d
	.long	0x68
	.byte	0xc
	.uleb128 0x6
	.string	"ebx"
	.byte	0x3
	.byte	0x15
	.byte	0x22
	.long	0x68
	.byte	0x10
	.uleb128 0x6
	.string	"edx"
	.byte	0x3
	.byte	0x15
	.byte	0x27
	.long	0x68
	.byte	0x14
	.uleb128 0x6
	.string	"ecx"
	.byte	0x3
	.byte	0x15
	.byte	0x2c
	.long	0x68
	.byte	0x18
	.uleb128 0x6
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
	.uleb128 0x4
	.long	.LASF16
	.byte	0x3
	.byte	0x16
	.byte	0x3
	.long	0x9c
	.uleb128 0x18
	.byte	0x4
	.uleb128 0x4
	.long	.LASF17
	.byte	0x3
	.byte	0x1a
	.byte	0x14
	.long	0x138
	.uleb128 0x5
	.long	0x13d
	.uleb128 0x10
	.long	0x68
	.long	0x14c
	.uleb128 0x2
	.long	0x14c
	.byte	0
	.uleb128 0x5
	.long	0x11e
	.uleb128 0x3
	.byte	0xc
	.byte	0x4
	.long	.LASF18
	.uleb128 0x3
	.byte	0x10
	.byte	0x4
	.long	.LASF19
	.uleb128 0x4
	.long	.LASF20
	.byte	0x4
	.byte	0x6
	.byte	0x13
	.long	0x90
	.uleb128 0x4
	.long	.LASF21
	.byte	0x4
	.byte	0x7
	.byte	0x13
	.long	0x90
	.uleb128 0x19
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
	.uleb128 0x11
	.long	0x15f
	.long	0x1a4
	.uleb128 0x1a
	.long	0x74
	.value	0x3ff
	.byte	0
	.uleb128 0x4
	.long	.LASF25
	.byte	0x4
	.byte	0xb
	.byte	0x3
	.long	0x177
	.uleb128 0x3
	.byte	0x1
	.byte	0x6
	.long	.LASF26
	.uleb128 0x1b
	.long	0x1b0
	.uleb128 0xd
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
	.uleb128 0x1c
	.long	0x209
	.uleb128 0x2
	.long	0x209
	.uleb128 0x1
	.byte	0
	.uleb128 0x5
	.long	0x1b7
	.uleb128 0x5
	.long	0x1fd
	.uleb128 0x4
	.long	.LASF32
	.byte	0x1
	.byte	0x14
	.byte	0x3
	.long	0x1bc
	.uleb128 0xd
	.long	.LASF33
	.byte	0xc
	.byte	0x1
	.byte	0x16
	.long	0x253
	.uleb128 0x6
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
	.long	0x253
	.byte	0x4
	.uleb128 0x8
	.long	.LASF35
	.byte	0x1
	.byte	0x19
	.byte	0x12
	.long	0x253
	.byte	0x8
	.byte	0
	.uleb128 0x5
	.long	0x21f
	.uleb128 0x4
	.long	.LASF36
	.byte	0x1
	.byte	0x1a
	.byte	0x3
	.long	0x21f
	.uleb128 0x4
	.long	.LASF37
	.byte	0x1
	.byte	0x1c
	.byte	0xb
	.long	0x270
	.uleb128 0x5
	.long	0x275
	.uleb128 0x10
	.long	0x82
	.long	0x284
	.uleb128 0x2
	.long	0x12a
	.byte	0
	.uleb128 0x12
	.long	.LASF38
	.byte	0x1e
	.byte	0x9
	.long	0x295
	.uleb128 0x5
	.byte	0x3
	.long	cur_task
	.uleb128 0x5
	.long	0x258
	.uleb128 0x12
	.long	.LASF39
	.byte	0x1f
	.byte	0x8
	.long	0x258
	.uleb128 0x5
	.byte	0x3
	.long	base_task
	.uleb128 0x1d
	.long	.LASF40
	.byte	0x1
	.byte	0x21
	.byte	0xf
	.long	0x20e
	.uleb128 0x9
	.long	.LASF41
	.byte	0x1
	.byte	0x7a
	.long	0x2cd
	.uleb128 0x2
	.long	0x68
	.uleb128 0x2
	.long	0x68
	.byte	0
	.uleb128 0xb
	.long	.LASF46
	.byte	0x1
	.byte	0x7b
	.long	0x2da
	.uleb128 0x1
	.byte	0
	.uleb128 0x9
	.long	.LASF42
	.byte	0x1
	.byte	0x53
	.long	0x2eb
	.uleb128 0x2
	.long	0x12a
	.byte	0
	.uleb128 0x9
	.long	.LASF43
	.byte	0x1
	.byte	0x52
	.long	0x2fc
	.uleb128 0x2
	.long	0x12a
	.byte	0
	.uleb128 0x7
	.long	.LASF44
	.byte	0x8f
	.byte	0x5
	.long	0x82
	.long	0x30d
	.uleb128 0x1
	.byte	0
	.uleb128 0x9
	.long	.LASF45
	.byte	0x4
	.byte	0x11
	.long	0x328
	.uleb128 0x2
	.long	0x328
	.uleb128 0x2
	.long	0x15f
	.uleb128 0x2
	.long	0x16b
	.byte	0
	.uleb128 0x5
	.long	0x1a4
	.uleb128 0xb
	.long	.LASF47
	.byte	0x5
	.byte	0x3a
	.long	0x33a
	.uleb128 0x1
	.byte	0
	.uleb128 0x1e
	.long	.LASF76
	.byte	0x3
	.byte	0x1c
	.byte	0xa
	.long	0x12c
	.long	0x355
	.uleb128 0x2
	.long	0x82
	.uleb128 0x2
	.long	0x12c
	.byte	0
	.uleb128 0x1f
	.long	.LASF77
	.byte	0x3
	.byte	0x20
	.byte	0x6
	.uleb128 0x9
	.long	.LASF48
	.byte	0x6
	.byte	0x1a
	.long	0x373
	.uleb128 0x2
	.long	0x42
	.uleb128 0x2
	.long	0x42
	.byte	0
	.uleb128 0x7
	.long	.LASF49
	.byte	0x84
	.byte	0x5
	.long	0x82
	.long	0x384
	.uleb128 0x1
	.byte	0
	.uleb128 0x7
	.long	.LASF50
	.byte	0x83
	.byte	0x5
	.long	0x82
	.long	0x395
	.uleb128 0x1
	.byte	0
	.uleb128 0xb
	.long	.LASF51
	.byte	0x7
	.byte	0x8
	.long	0x3a2
	.uleb128 0x1
	.byte	0
	.uleb128 0xb
	.long	.LASF52
	.byte	0x3
	.byte	0x22
	.long	0x3af
	.uleb128 0x1
	.byte	0
	.uleb128 0x7
	.long	.LASF53
	.byte	0x56
	.byte	0x17
	.long	0x82
	.long	0x3c0
	.uleb128 0x1
	.byte	0
	.uleb128 0xb
	.long	.LASF54
	.byte	0x3
	.byte	0x23
	.long	0x3cd
	.uleb128 0x1
	.byte	0
	.uleb128 0x9
	.long	.LASF55
	.byte	0x1
	.byte	0x22
	.long	0x3de
	.uleb128 0x2
	.long	0x14c
	.byte	0
	.uleb128 0x9
	.long	.LASF56
	.byte	0x6
	.byte	0x19
	.long	0x3ef
	.uleb128 0x2
	.long	0x42
	.byte	0
	.uleb128 0x13
	.long	.LASF66
	.byte	0x7d
	.long	.LFB7
	.long	.LFE7-.LFB7
	.uleb128 0x1
	.byte	0x9c
	.long	0x4ab
	.uleb128 0xa
	.long	.LASF63
	.byte	0x7d
	.byte	0x26
	.long	0x4ab
	.uleb128 0x2
	.byte	0x91
	.sleb128 0
	.uleb128 0x20
	.string	"buf"
	.byte	0x1
	.byte	0x7e
	.byte	0xa
	.long	0x4b0
	.uleb128 0x2
	.byte	0x91
	.sleb128 -56
	.uleb128 0x7
	.long	.LASF50
	.byte	0x83
	.byte	0x5
	.long	0x82
	.long	0x431
	.uleb128 0x1
	.byte	0
	.uleb128 0x7
	.long	.LASF49
	.byte	0x84
	.byte	0x5
	.long	0x82
	.long	0x442
	.uleb128 0x1
	.byte	0
	.uleb128 0x7
	.long	.LASF44
	.byte	0x8f
	.byte	0x5
	.long	0x82
	.long	0x453
	.uleb128 0x1
	.byte	0
	.uleb128 0xc
	.long	.LASF57
	.byte	0xa5
	.long	0x4c0
	.uleb128 0x7
	.long	.LASF53
	.byte	0x56
	.byte	0x17
	.long	0x82
	.long	0x46e
	.uleb128 0x1
	.byte	0
	.uleb128 0xc
	.long	.LASF58
	.byte	0xa6
	.long	0x4c0
	.uleb128 0xc
	.long	.LASF59
	.byte	0xa7
	.long	0x4c0
	.uleb128 0xc
	.long	.LASF60
	.byte	0xa9
	.long	0x4c0
	.uleb128 0x7
	.long	.LASF61
	.byte	0xaa
	.byte	0x5
	.long	0x82
	.long	0x49d
	.uleb128 0x1
	.byte	0
	.uleb128 0xe
	.long	.LASF62
	.byte	0xab
	.byte	0x5
	.long	0x82
	.uleb128 0x1
	.byte	0
	.byte	0
	.uleb128 0x5
	.long	0x213
	.uleb128 0x11
	.long	0x1b0
	.long	0x4c0
	.uleb128 0x21
	.long	0x74
	.byte	0x27
	.byte	0
	.uleb128 0x5
	.long	0x1b0
	.uleb128 0xf
	.long	.LASF71
	.byte	0x67
	.byte	0x9
	.long	0x295
	.long	.LFB6
	.long	.LFE6-.LFB6
	.uleb128 0x1
	.byte	0x9c
	.long	0x515
	.uleb128 0x14
	.string	"fn"
	.byte	0x67
	.byte	0x24
	.long	0x264
	.uleb128 0x2
	.byte	0x91
	.sleb128 0
	.uleb128 0xa
	.long	.LASF64
	.byte	0x67
	.byte	0x2e
	.long	0x12a
	.uleb128 0x2
	.byte	0x91
	.sleb128 4
	.uleb128 0x15
	.long	.LASF65
	.byte	0x69
	.byte	0xd
	.long	0x295
	.uleb128 0x2
	.byte	0x91
	.sleb128 -20
	.uleb128 0xe
	.long	.LASF53
	.byte	0x56
	.byte	0x17
	.long	0x82
	.uleb128 0x1
	.byte	0
	.byte	0
	.uleb128 0x13
	.long	.LASF67
	.byte	0x55
	.long	.LFB5
	.long	.LFE5-.LFB5
	.uleb128 0x1
	.byte	0x9c
	.long	0x56e
	.uleb128 0xa
	.long	.LASF33
	.byte	0x55
	.byte	0x1c
	.long	0x295
	.uleb128 0x2
	.byte	0x91
	.sleb128 0
	.uleb128 0x14
	.string	"fn"
	.byte	0x55
	.byte	0x30
	.long	0x264
	.uleb128 0x2
	.byte	0x91
	.sleb128 4
	.uleb128 0xa
	.long	.LASF64
	.byte	0x55
	.byte	0x3a
	.long	0x12a
	.uleb128 0x2
	.byte	0x91
	.sleb128 8
	.uleb128 0x15
	.long	.LASF68
	.byte	0x56
	.byte	0xf
	.long	0x56e
	.uleb128 0x2
	.byte	0x91
	.sleb128 -20
	.uleb128 0xe
	.long	.LASF53
	.byte	0x56
	.byte	0x17
	.long	0x82
	.uleb128 0x1
	.byte	0
	.byte	0
	.uleb128 0x5
	.long	0x68
	.uleb128 0x22
	.long	.LASF69
	.byte	0x1
	.byte	0x3f
	.byte	0x6
	.long	.LFB4
	.long	.LFE4-.LFB4
	.uleb128 0x1
	.byte	0x9c
	.uleb128 0x23
	.long	.LASF70
	.byte	0x1
	.byte	0x3a
	.byte	0x6
	.long	.LFB3
	.long	.LFE3-.LFB3
	.uleb128 0x1
	.byte	0x9c
	.uleb128 0xf
	.long	.LASF72
	.byte	0x35
	.byte	0xa
	.long	0x68
	.long	.LFB2
	.long	.LFE2-.LFB2
	.uleb128 0x1
	.byte	0x9c
	.long	0x5bf
	.uleb128 0xa
	.long	.LASF73
	.byte	0x35
	.byte	0x27
	.long	0x14c
	.uleb128 0x2
	.byte	0x91
	.sleb128 0
	.byte	0
	.uleb128 0xf
	.long	.LASF74
	.byte	0x2b
	.byte	0xa
	.long	0x68
	.long	.LFB1
	.long	.LFE1-.LFB1
	.uleb128 0x1
	.byte	0x9c
	.long	0x5e7
	.uleb128 0xa
	.long	.LASF73
	.byte	0x2b
	.byte	0x1f
	.long	0x14c
	.uleb128 0x2
	.byte	0x91
	.sleb128 0
	.byte	0
	.uleb128 0x24
	.long	.LASF78
	.byte	0x1
	.byte	0x26
	.byte	0x6
	.long	.LFB0
	.long	.LFE0-.LFB0
	.uleb128 0x1
	.byte	0x9c
	.uleb128 0xa
	.long	.LASF73
	.byte	0x26
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
	.uleb128 0x4
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
	.uleb128 0x5
	.uleb128 0xf
	.byte	0
	.uleb128 0xb
	.uleb128 0x21
	.sleb128 4
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x6
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
	.uleb128 0x7
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
	.uleb128 0xa
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
	.uleb128 0x10
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
	.uleb128 0x11
	.uleb128 0x1
	.byte	0x1
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x12
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
	.uleb128 0x14
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
	.uleb128 0x15
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
	.uleb128 0x16
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
	.uleb128 0x17
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
	.uleb128 0x18
	.uleb128 0xf
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x19
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
	.uleb128 0x1a
	.uleb128 0x21
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2f
	.uleb128 0x5
	.byte	0
	.byte	0
	.uleb128 0x1b
	.uleb128 0x26
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x1c
	.uleb128 0x15
	.byte	0x1
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x1d
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
	.uleb128 0x1e
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
	.uleb128 0x1f
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
	.uleb128 0x20
	.uleb128 0x34
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
	.uleb128 0x2
	.uleb128 0x18
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
.LASF71:
	.string	"spawn_thread"
.LASF45:
	.string	"map_page"
.LASF76:
	.string	"set_isr"
.LASF24:
	.string	"entries"
.LASF69:
	.string	"thread_exit"
.LASF34:
	.string	"next"
.LASF54:
	.string	"disable_interrupts"
.LASF65:
	.string	"temp"
.LASF3:
	.string	"short int"
.LASF44:
	.string	"io_write_8"
.LASF15:
	.string	"eflags"
.LASF30:
	.string	"mem_size"
.LASF66:
	.string	"_start"
.LASF33:
	.string	"task"
.LASF41:
	.string	"jump_usermode"
.LASF7:
	.string	"uint8_t"
.LASF14:
	.string	"uintptr_t"
.LASF56:
	.string	"pic_send_eoi"
.LASF36:
	.string	"task_t"
.LASF52:
	.string	"enable_interrupts"
.LASF21:
	.string	"vaddr_t"
.LASF72:
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
.LASF78:
	.string	"dump_regs"
.LASF61:
	.string	"heap_free"
.LASF63:
	.string	"params"
.LASF42:
	.string	"thread_fun_2"
.LASF18:
	.string	"long double"
.LASF6:
	.string	"unsigned char"
.LASF50:
	.string	"sbrk"
.LASF2:
	.string	"signed char"
.LASF12:
	.string	"long long unsigned int"
.LASF10:
	.string	"uint32_t"
.LASF13:
	.string	"unsigned int"
.LASF8:
	.string	"uint16_t"
.LASF68:
	.string	"stack"
.LASF62:
	.string	"heap_print"
.LASF46:
	.string	"test_user_function"
.LASF32:
	.string	"kernel_startup_params_t"
.LASF64:
	.string	"param"
.LASF9:
	.string	"short unsigned int"
.LASF53:
	.string	"heap_alloc"
.LASF26:
	.string	"char"
.LASF38:
	.string	"cur_task"
.LASF70:
	.string	"init_tasking"
.LASF49:
	.string	"heap_init"
.LASF20:
	.string	"paddr_t"
.LASF11:
	.string	"long unsigned int"
.LASF58:
	.string	"ptr2"
.LASF22:
	.string	"_int_state"
.LASF29:
	.string	"ramdisk_sectors"
.LASF73:
	.string	"state"
.LASF37:
	.string	"thread_func_t"
.LASF16:
	.string	"int_state_t"
.LASF47:
	.string	"gdt_init"
.LASF27:
	.string	"kernel_startup_params"
.LASF17:
	.string	"isr_func"
.LASF74:
	.string	"pit_isr"
.LASF77:
	.string	"idt_init"
.LASF19:
	.string	"_Float128"
.LASF67:
	.string	"create_thread"
.LASF57:
	.string	"ptr1"
.LASF59:
	.string	"ptr3"
.LASF60:
	.string	"ptr4"
.LASF23:
	.string	"pgdir"
.LASF40:
	.string	"dbg_printf"
.LASF55:
	.string	"task_switch"
.LASF35:
	.string	"prev"
.LASF48:
	.string	"pic_remap"
.LASF39:
	.string	"base_task"
.LASF75:
	.string	"GNU C17 12.2.0 -m32 -mtune=i386 -march=i386 -g -ffreestanding"
.LASF43:
	.string	"thread_fun_1"
.LASF25:
	.string	"pgdir_t"
	.section	.debug_line_str,"MS",@progbits,1
.LASF1:
	.string	"/home/will/WIX/kernel"
.LASF0:
	.string	"src/init/init.c"
	.ident	"GCC: (GNU) 12.2.0"

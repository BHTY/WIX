	.file	"init.c"
	.intel_syntax noprefix
	.text
.Ltext0:
	.cfi_sections	.debug_frame
	.file 0 "/home/will/WIX/kernel/src/init" "init.c"
	.section	.rodata
.LC0:
	.string	"01:23:06"
.LC1:
	.string	"Nov  3 2024"
	.align 4
.LC2:
	.string	"\nWelcome to the WIX kernel!\nBuilt %s %s\nMemory size: %xKB\n"
.LC3:
	.string	"Allocated page at 0x%x\n"
	.align 4
.LC4:
	.string	"Failed to allocate after allocating %x %x pages\n"
	.text
	.globl	_start
	.type	_start, @function
_start:
.LFB0:
	.file 1 "init.c"
	.loc 1 13 45
	.cfi_startproc
	push	ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	mov	ebp, esp
	.cfi_def_cfa_register 5
	sub	esp, 24
	.loc 1 14 9
	mov	DWORD PTR [ebp-12], 0
	.loc 1 17 5
	call	pmm_init
	.loc 1 19 11
	mov	eax, DWORD PTR [ebp+8]
	mov	edx, DWORD PTR [eax+8]
	.loc 1 19 112
	mov	eax, DWORD PTR [ebp+8]
	mov	eax, DWORD PTR [eax+4]
	.loc 1 19 5
	movzx	eax, ax
	push	eax
	push	OFFSET FLAT:.LC0
	push	OFFSET FLAT:.LC1
	push	OFFSET FLAT:.LC2
	call	edx
.LVL0:
	add	esp, 16
	.loc 1 28 10
	jmp	.L2
.L3:
	.loc 1 29 15
	mov	eax, DWORD PTR [ebp+8]
	mov	eax, DWORD PTR [eax+8]
	.loc 1 29 9
	mov	edx, DWORD PTR [ebp-16]
	sal	edx, 12
	sub	esp, 8
	push	edx
	push	OFFSET FLAT:.LC3
	call	eax
.LVL1:
	add	esp, 16
	.loc 1 30 14
	inc	DWORD PTR [ebp-12]
.L2:
	.loc 1 28 18
	call	commit_page
	mov	DWORD PTR [ebp-16], eax
	.loc 1 28 33
	cmp	DWORD PTR [ebp-16], -1
	jne	.L3
	.loc 1 33 11
	mov	eax, DWORD PTR [ebp+8]
	mov	eax, DWORD PTR [eax+8]
	.loc 1 33 5
	sub	esp, 4
	push	DWORD PTR [ebp-12]
	push	DWORD PTR [ebp-12]
	push	OFFSET FLAT:.LC4
	call	eax
.LVL2:
	add	esp, 16
.L4:
	.loc 1 34 10 discriminator 1
	jmp	.L4
	.cfi_endproc
.LFE0:
	.size	_start, .-_start
.Letext0:
	.file 2 "/usr/local/i386elfgcc/lib/gcc/i386-elf/12.2.0/include/stdint-gcc.h"
	.section	.debug_info,"",@progbits
.Ldebug_info0:
	.long	0x156
	.value	0x5
	.byte	0x1
	.byte	0x4
	.long	.Ldebug_abbrev0
	.uleb128 0x6
	.long	.LASF20
	.byte	0x1d
	.long	.LASF0
	.long	.LASF1
	.long	.Ltext0
	.long	.Letext0-.Ltext0
	.long	.Ldebug_line0
	.uleb128 0x1
	.byte	0x1
	.byte	0x6
	.long	.LASF2
	.uleb128 0x1
	.byte	0x2
	.byte	0x5
	.long	.LASF3
	.uleb128 0x1
	.byte	0x4
	.byte	0x5
	.long	.LASF4
	.uleb128 0x1
	.byte	0x8
	.byte	0x5
	.long	.LASF5
	.uleb128 0x1
	.byte	0x1
	.byte	0x8
	.long	.LASF6
	.uleb128 0x3
	.long	.LASF8
	.byte	0x2
	.byte	0x31
	.byte	0x19
	.long	0x55
	.uleb128 0x1
	.byte	0x2
	.byte	0x7
	.long	.LASF7
	.uleb128 0x3
	.long	.LASF9
	.byte	0x2
	.byte	0x34
	.byte	0x19
	.long	0x68
	.uleb128 0x1
	.byte	0x4
	.byte	0x7
	.long	.LASF10
	.uleb128 0x1
	.byte	0x8
	.byte	0x7
	.long	.LASF11
	.uleb128 0x7
	.byte	0x4
	.byte	0x5
	.string	"int"
	.uleb128 0x1
	.byte	0x4
	.byte	0x7
	.long	.LASF12
	.uleb128 0x8
	.long	.LASF21
	.byte	0xc
	.byte	0x1
	.byte	0x3
	.byte	0x10
	.long	0xc2
	.uleb128 0x2
	.long	.LASF13
	.byte	0x4
	.byte	0xe
	.long	0x49
	.byte	0
	.uleb128 0x2
	.long	.LASF14
	.byte	0x5
	.byte	0xe
	.long	0x49
	.byte	0x2
	.uleb128 0x2
	.long	.LASF15
	.byte	0x6
	.byte	0xe
	.long	0x49
	.byte	0x4
	.uleb128 0x2
	.long	.LASF16
	.byte	0x7
	.byte	0xc
	.long	0xdf
	.byte	0x8
	.byte	0
	.uleb128 0x9
	.long	0xce
	.uleb128 0xa
	.long	0xce
	.uleb128 0x4
	.byte	0
	.uleb128 0x5
	.long	0xda
	.uleb128 0x1
	.byte	0x1
	.byte	0x6
	.long	.LASF17
	.uleb128 0xb
	.long	0xd3
	.uleb128 0x5
	.long	0xc2
	.uleb128 0x3
	.long	.LASF18
	.byte	0x1
	.byte	0x8
	.byte	0x3
	.long	0x84
	.uleb128 0xc
	.long	.LASF22
	.byte	0x1
	.byte	0xb
	.byte	0xa
	.long	0x5c
	.long	0x102
	.uleb128 0x4
	.byte	0
	.uleb128 0xd
	.long	.LASF23
	.byte	0x1
	.byte	0xa
	.byte	0x6
	.long	0x110
	.uleb128 0x4
	.byte	0
	.uleb128 0xe
	.long	.LASF24
	.byte	0x1
	.byte	0xd
	.byte	0x6
	.long	.LFB0
	.long	.LFE0-.LFB0
	.uleb128 0x1
	.byte	0x9c
	.long	0x154
	.uleb128 0xf
	.long	.LASF25
	.byte	0x1
	.byte	0xd
	.byte	0x26
	.long	0x154
	.uleb128 0x2
	.byte	0x91
	.sleb128 0
	.uleb128 0x10
	.long	.LASF19
	.byte	0x1
	.byte	0xe
	.byte	0x9
	.long	0x76
	.uleb128 0x2
	.byte	0x91
	.sleb128 -20
	.uleb128 0x11
	.string	"pfn"
	.byte	0x1
	.byte	0xf
	.byte	0xe
	.long	0x5c
	.uleb128 0x2
	.byte	0x91
	.sleb128 -24
	.byte	0
	.uleb128 0x5
	.long	0xe4
	.byte	0
	.section	.debug_abbrev,"",@progbits
.Ldebug_abbrev0:
	.uleb128 0x1
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
	.uleb128 0x2
	.uleb128 0xd
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
	.uleb128 0x38
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x3
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
	.uleb128 0x4
	.uleb128 0x18
	.byte	0
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
	.uleb128 0x7
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
	.uleb128 0x8
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
	.uleb128 0xb
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x9
	.uleb128 0x15
	.byte	0x1
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xa
	.uleb128 0x5
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xb
	.uleb128 0x26
	.byte	0
	.uleb128 0x49
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
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x3c
	.uleb128 0x19
	.uleb128 0x1
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
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x3c
	.uleb128 0x19
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
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xf
	.uleb128 0x5
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
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x10
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
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x11
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
.LASF21:
	.string	"kernel_startup_params"
.LASF23:
	.string	"pmm_init"
.LASF20:
	.string	"GNU C17 12.2.0 -masm=intel -m32 -mtune=i386 -march=i386 -g -fno-asynchronous-unwind-tables -ffreestanding"
.LASF10:
	.string	"long unsigned int"
.LASF7:
	.string	"short unsigned int"
.LASF6:
	.string	"unsigned char"
.LASF25:
	.string	"params"
.LASF15:
	.string	"mem_size"
.LASF24:
	.string	"_start"
.LASF12:
	.string	"unsigned int"
.LASF11:
	.string	"long long unsigned int"
.LASF22:
	.string	"commit_page"
.LASF14:
	.string	"ramdisk_sectors"
.LASF13:
	.string	"kernel_sectors"
.LASF5:
	.string	"long long int"
.LASF17:
	.string	"char"
.LASF16:
	.string	"printf"
.LASF3:
	.string	"short int"
.LASF8:
	.string	"uint16_t"
.LASF9:
	.string	"uint32_t"
.LASF4:
	.string	"long int"
.LASF19:
	.string	"pages"
.LASF2:
	.string	"signed char"
.LASF18:
	.string	"kernel_startup_params_t"
	.section	.debug_line_str,"MS",@progbits,1
.LASF1:
	.string	"/home/will/WIX/kernel/src/init"
.LASF0:
	.string	"init.c"
	.ident	"GCC: (GNU) 12.2.0"

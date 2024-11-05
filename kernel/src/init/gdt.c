/* 
    Copyright (C) 2024 WIX Kernel
    Authored by Will Klees
    gdt.c - Kernel support for the Global Descriptor Table
*/

#include <stdint.h>
#include <string.h>
#include <init/gdt.h>

gdt_descriptor_t gdtr;
gdt_entry_t gdt[6]; // one null segment, two ring 0 segments, two ring 3 segments, TSS
tss_entry_t tss_entry;

void install_tss(gdt_entry_t *g) {
	// Compute the base and limit of the TSS for use in the GDT entry.
	uint32_t base = (uint32_t) &tss_entry;
	uint32_t limit = sizeof tss_entry;

	// Add a TSS descriptor to the GDT.
	g->limit_low = limit;
	g->base_low = base;
	g->accessed = 1; // With a system entry (`code_data_segment` = 0), 1 indicates TSS and 0 indicates LDT
	g->read_write = 0; // For a TSS, indicates busy (1) or not busy (0).
	g->conforming_expand_down = 0; // always 0 for TSS
	g->code = 1; // For a TSS, 1 indicates 32-bit (1) or 16-bit (0).
	g->code_data_segment=0; // indicates TSS/LDT (see also `accessed`)
	g->DPL = 0; // ring 0, see the comments below
	g->present = 1;
	g->limit_high = (limit & (0xf << 16)) >> 16; // isolate top nibble
	g->available = 0; // 0 for a TSS
	g->long_mode = 0;
	g->big = 0; // should leave zero according to manuals.
	g->gran = 0; // limit is in bytes, not pages
	g->base_high = (base & (0xff << 24)) >> 24; //isolate top byte

	// Ensure the TSS is initially zero'd.
	memset(&tss_entry, 0, sizeof tss_entry);

	tss_entry.ss0  = 0x10;  // Set the kernel stack segment.
	tss_entry.esp0 = 0x7C00; // Set the kernel stack pointer.
	//note that CS is loaded from the IDT entry and should be the regular kernel code segment
}

void set_kernel_stack(uint32_t stack) { // Used when an interrupt occurs
	tss_entry.esp0 = stack;
}

void init_flat_selectors(){
    gdt_entry_t* ring0_code = &gdt[1];
    gdt_entry_t* ring0_data = &gdt[2];
    gdt_entry_t* ring3_code = &gdt[3];
    gdt_entry_t* ring3_data = &gdt[4];

    ring3_code->limit_low = 0xFFFF;
    ring3_code->base_low = 0;
    ring3_code->accessed = 0;
    ring3_code->read_write = 1; // since this is a code segment, specifies that the segment is readable
    ring3_code->conforming_expand_down = 0; // does not matter for ring 3 as no lower privilege level exists
    ring3_code->code = 1;
    ring3_code->code_data_segment = 1;
    ring3_code->DPL = 3; // ring 3
    ring3_code->present = 1;
    ring3_code->limit_high = 0xF;
    ring3_code->available = 1;
    ring3_code->long_mode = 0;
    ring3_code->big = 1; // it's 32 bits
    ring3_code->gran = 1; // 4KB page addressing
    ring3_code->base_high = 0;

    *ring3_data = *ring3_code; // contents are similar so save time by copying
    ring3_data->code = 0; // not code but data

    *ring0_code = *ring3_code;
    ring0_code->DPL = 0;

    *ring0_data = *ring0_code; // contents are similar so save time by copying
    ring0_data->code = 0; // not code but data
}

/* Sets up flat selectors for Ring 0/3 code/data & TSS */
void gdt_init(){
    gdtr.base = (uint32_t)gdt;
    gdtr.limit = (sizeof(gdt_entry_t) * 6) - 1;

    init_flat_selectors();
    
    install_tss(&gdt[5]);
    __asm__ volatile ("lgdtl %0" :: "m" (gdtr));
    flush_tss();
}


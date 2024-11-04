/* 
    Copyright (C) 2024 WIX Kernel
    Authored by Will Klees
    idt.c - Kernel support for interrupts
*/

#include <stdint.h>
#include <string.h>
#include <init/idt.h>
#include <init/io.h>
#include <init/pic.h>

__attribute__((aligned(0x10))) static idt_entry_t idt[256];

static idtr_t idtr;

void (*dbg_printf)(const char*, ...) = 0;

isr_func isr_table[256] = {0};

isr_func set_isr(int index, isr_func new_func){
    isr_func old_func = isr_table[index];
    isr_table[index] = new_func;
    return old_func;
}

/* Base interrupt handler */
__attribute__((noreturn)) uint32_t interrupt_handler(int code, int_state_t state){
    if (isr_table[code]){
        isr_table[code](&state);
    } else{
        dbg_printf("UNHANDLED INTERRUPT %x SYSTEM HALTED!\n", code);
        while(1);
    }
}

/* Base exception handler */
__attribute__((noreturn)) uint32_t exception_handler(int code, uint32_t error_code){
    dbg_printf("Unrecoverable Exception %x Code %x at %x:%x\n", code, error_code, *(uint32_t*)(&error_code + 2), *(uint32_t*)(&error_code + 1));
    while(1);
}

void idt_set_descriptor(uint8_t vector, void* isr, uint8_t flags) {
    idt_entry_t* descriptor = &idt[vector];
 
    descriptor->isr_low        = (uint32_t)isr & 0xFFFF;
    descriptor->kernel_cs      = 0x08; // this value can be whatever offset your kernel code selector is in your GDT
    descriptor->flags          = flags;
    descriptor->isr_high       = (uint32_t)isr >> 16;
    descriptor->reserved       = 0;
}

void idt_init() {
	idtr.base = (uintptr_t)&idt[0];
    idtr.limit = (uint16_t)sizeof(idt_entry_t) * IDT_MAX_DESCRIPTORS - 1;
 
    for (uint8_t vector = 0; vector < 255; vector++) {
        idt_set_descriptor(vector, isr_stub_table[vector], 0x8E);
        //vectors[vector] = 1;
    }
 
    __asm__ volatile ("lidt %0" : : "m"(idtr)); // load the new IDT
    enable_interrupts();
}

void enable_interrupts(){
    __asm__ volatile ("sti"); // set the interrupt flag
}

void disable_interrupts(){
    __asm__ volatile ("cli"); // clear the interrupt flag
}
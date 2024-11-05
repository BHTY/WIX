#pragma once

#include <stdint.h>

#define IDT_MAX_DESCRIPTORS 256

typedef struct{
	uint16_t isr_low;
	uint16_t kernel_cs;
	uint8_t reserved;
	uint8_t flags;
	uint16_t isr_high;
} __attribute__((packed)) idt_entry_t;

typedef struct{
	uint16_t limit;
	uint32_t base;
} __attribute__((packed)) idtr_t;

typedef struct _int_state{
    uint32_t edi, esi, ebp, esp, ebx, edx, ecx, eax, eflags;
} int_state_t;

extern void* isr_stub_table[];

typedef uint32_t (*isr_func)(int_state_t*);

isr_func set_isr(int index, isr_func new_func);
__attribute__((noreturn)) uint32_t exception_handler(int code, int_state_t state, uint32_t error_code);
__attribute__((noreturn)) uint32_t interrupt_handler(int code, int_state_t state);
void idt_set_descriptor(uint8_t vector, void* isr, uint8_t flags);
void idt_init(void);
void idt_enable();
void enable_interrupts();
void disable_interrupts();

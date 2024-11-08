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
#include <tty/tty.h>
#include <stdio.h>

__attribute__((aligned(0x10))) static idt_entry_t idt[256];

static idtr_t idtr;

void (*dbg_printf)(const char*, ...) = 0;

isr_func isr_table[256] = {0};

isr_func set_isr(int index, isr_func new_func){
    isr_func old_func = isr_table[index];
    isr_table[index] = new_func;
    return old_func;
}

void trace(int_state_t* state){
    uint32_t EBP = state->ebp;
    int i = 5;

    while(EBP && i){
        if(*(uint32_t*)(EBP+4)){
            dbg_printf("%x\n", *(uint32_t*)(EBP+4));
        } else{
            break;
        }
        EBP = *(uint32_t*)EBP;
        i--;
    }
}

void crash_dump(char* buf, int_state_t* state){
    sprintf(buf, "EAX: 0x%08X  ECX: 0x%08X  EDX: 0x%08X  EBX: 0x%08X\nEBP: 0x%08X  ESP: 0x%08X  ESI: 0x%08X  EDI: 0x%08X\n\n", state->eax, state->ecx, state->edx, state->ebx, state->ebp, state->esp, state->esi, state->edi);
    tty_write(buf, strlen(buf));
    
    //stack dump
    for(int i = 0; i < 32; i += 4){
        sprintf(buf, "[ESP+0x%02X] = 0x%08X\n", i, *(uint32_t*)(state->esp + i));
        tty_write(buf, strlen(buf));
    }
}

void bug_check(int_state_t* state, int code, uint32_t error_code, uint16_t cs, uint32_t eip){
    char buf[256];
    int print_instructions = 1;

    disable_interrupts();

    tty_write("\x1B[41m\x1B[37m\x1B[2J\x1B[H", strlen("\x1B[41m\x1B[37m\x1B[2J\x1B[H")); // fill screen with red and set cursor

    sprintf(buf, "UNRECOVERABLE EXCEPTION 0x%x CODE %x\n", code, error_code);
    tty_write(buf, strlen(buf));

    sprintf(buf, "FAULTING ADDRESS: %04x:%08x\n", cs, eip);
    tty_write(buf, strlen(buf));

    switch(code){
        case 0x0E:{
            uint32_t vaddr;
            __asm__ volatile("movl %cr2, %eax");
            __asm__ volatile ("movl %%eax, %0" : "=a" (vaddr));

            sprintf(buf, "PAGE FAULT ACCESSING 0x%08x\n", vaddr);
            tty_write(buf, strlen(buf));

            if(vaddr == eip) print_instructions = 0;

            break;
        }
        case 0x20:{
            sprintf(buf, "UNHANDLED INTERRUPT 0x%02x\n", error_code);
            tty_write(buf, strlen(buf));
            break;
        }
        default: break;
    }

    tty_write("\n", 1);
    crash_dump(buf, state);

    if(print_instructions){
        sprintf(buf, "\n%08x: ", eip);
        tty_write(buf, strlen(buf));

        disasm_opcode(buf, eip, eip, 1, 1, 0, 0, 0);

        tty_write(buf, strlen(buf));
    }
    
    while(1);
}

/* Base interrupt handler */
__attribute__((noreturn)) uint32_t interrupt_handler(int code, int_state_t state){
    if (isr_table[code]){
        uint32_t ret_val = isr_table[code](&state);
        return ret_val;
    } else{
        //dbg_printf("UNHANDLED INTERRUPT %x SYSTEM HALTED!\nEAX=%x\n", code, state.eax);
        //*(unsigned int*)(0x300000) = 0;
        //dbg_printf("fuck you\n");
        //while(1);
        bug_check(&state, 0x20, code, *(((uint32_t*)((&state + 1)))+1), *(uint32_t*)(&state + 1));
    }
}

__attribute__((noreturn)) uint32_t exception_handler(int code, int_state_t state, uint32_t error_code){
    bug_check(&state, code, error_code, *(uint32_t*)(&error_code + 2), *(uint32_t*)(&error_code + 1));
}

/* Base exception handler */
__attribute__((noreturn)) uint32_t old_exception_handler(int code, uint32_t error_code){

    dbg_printf("Unrecoverable Exception %x Code %x at %x:%x\n", code, error_code, *(uint32_t*)(&error_code + 2), *(uint32_t*)(&error_code + 1));
    
    if(code == 0x0E){
        uint32_t vaddr;
        __asm__ volatile("movl %cr2, %eax");
        __asm__ volatile ("movl %%eax, %0" : "=a" (vaddr));
        dbg_printf("Page fault accessing %x\n", vaddr);
    }

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
        idt_set_descriptor(vector, isr_stub_table[vector], 0xEE); //0x8E
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
/* 
    Copyright (C) 2024 WIX Kernel
    Authored by Will Klees
    init.c - Kernel initialization
*/

#include <stdint.h>
#include <init/idt.h>
#include <init/pic.h>
#include <mm/pmm.h>
#include <mm/vmm.h>
#include <stdio.h>

typedef struct kernel_startup_params {
    uint16_t kernel_sectors;
    uint16_t ramdisk_sectors;
    uint16_t mem_size;
    void (*printf)(const char*, ...);
} kernel_startup_params_t;

typedef struct task{
    uint32_t esp;
    struct task* next;
    struct task* prev;
} task_t;

typedef (*thread_func_t)(void*);

task_t* cur_task;
task_t base_task;

extern void (*dbg_printf)(const char*, ...);
void task_switch();

void test_int();

uint32_t pit_isr(int_state_t* state){
    dbg_printf("Hello! ESP=%x [%x]\n", state->esp, *(uint32_t*)state->esp);
    task_switch();
    pic_send_eoi(0);
    return 0;
}

void init_tasking(){
    cur_task = &base_task;
    base_task.next = cur_task;
}

void _start(kernel_startup_params_t* params){
    char buf[40];
    pmm_init();

    dbg_printf = params->printf;

    init_tasking();
    pic_remap(0x70, 0x78);
    idt_init();
    set_isr(0x70, pit_isr);

    map_page(0x30000, 0xB8000, 0x100000);

    params->printf("\nWelcome to the WIX kernel!\nBuilt %s %s\n", __DATE__, __TIME__);
    sprintf(buf, "%d KB Extended Memory\n", params->mem_size);
    params->printf(buf);

    sbrk(0x100);

    while(1){
        (*(unsigned char*)(0x100000))++;
    }
}
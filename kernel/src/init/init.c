/* 
    Copyright (C) 2024 WIX Kernel
    Authored by Will Klees
    init.c - Kernel initialization
*/

#include <string.h>
#include <stdint.h>
#include <init/idt.h>
#include <init/pic.h>
#include <init/gdt.h>
#include <init/io.h>
#include <tty/tty.h>
#include <mm/pmm.h>
#include <mm/vmm.h>
#include <mm/heap.h>
#include <mm/brk.h>
#include <stdio.h>
#include <assert.h>

int interrupt_tick = 0;

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
    uint32_t esp0;
    uint32_t cr3;
} task_t;

typedef uint32_t (*thread_func_t)(void*);

task_t* cur_task;
task_t base_task;

extern void (*dbg_printf)(const char*, ...);
void task_switch(int_state_t* state);

void test_int();

void print(char* str){
    dbg_printf(str);
}

void dump_regs(int_state_t* state){
    dbg_printf("\nEAX: %x ECX: %x EBX: %x EDX: %x\nEBP: %x ESP: %x ESI: %x EDI: %x\n", state->eax, state->ecx, state->ebx, state->edx, state->ebp, state->esp, state->esi, state->edi);
}

uint32_t pit_isr(int_state_t* state){
    interrupt_tick++;
    pic_send_eoi(0);
    task_switch(state);
}

uint32_t syscall_handler(int_state_t* state){
    if(state->eax == 0x01) print((char*)(state->ebx));

    return 0;
}

void init_tasking(){
    cur_task = &base_task;
    base_task.next = cur_task;
    base_task.esp0 = 0xDEADBEEF;
}

void thread_exit(){
    disable_interrupts();
    dbg_printf("Thread exit!\n");
    while(1);
}

uint32_t thread_fun_1(void* param);
uint32_t thread_fun_2(void* param);

void create_thread(task_t* task, thread_func_t fn, void* param, int user_esp){
    uint32_t* stack = heap_alloc(4096) + 4096;

    stack--; *stack = (uint32_t)param;
    stack--; *stack = (uint32_t)thread_exit;
    stack--; *stack = (uint32_t)fn;
    stack--; *stack = 0x202; //eflags
    stack--; *stack = 0;
    stack--; *stack = 0;
    stack--; *stack = 0;
    stack--; *stack = 0;
    stack--; *stack = 0;
    stack--; *stack = 0;
    stack--; *stack = 0;

    task->esp = (uint32_t)stack;

    if (user_esp){
        task->esp0 = (uint32_t)heap_alloc(4096) + 4096;
    }
}

task_t* spawn_thread(thread_func_t fn, void* param, int user_esp){
    disable_interrupts();
    task_t* temp = cur_task->next;
    cur_task->next = heap_alloc(sizeof(task_t));
    cur_task->next->prev = cur_task;
    cur_task->next->next = temp;
    temp->prev = cur_task->next;

    if(!cur_task->prev) cur_task->prev = temp;

    create_thread(cur_task->next, fn, param, user_esp);

    dbg_printf("About to enable interrupts\n");

    enable_interrupts();

    return cur_task->next;
}

void _start(kernel_startup_params_t* params){
    char buf[40];
    int n = 0;
    pmm_init();

    dbg_printf = params->printf;

    sbrk(0x100000);
    heap_init();
    init_tasking();
    pic_remap(0x70, 0x78);
    idt_init();
    set_isr(0x70, pit_isr);
    set_isr(0x80, syscall_handler);
    
    gdt_init();

    unmap_page((void*)0x30000, 0x0);

    io_write_8(0x43, 52);
	io_write_8(0x40, 0xdf);
	io_write_8(0x40, 0x4);

    tty_init();

    spawn_thread(thread_fun_1, 0, 1);
    spawn_thread(thread_fun_2, 0, 1);

    char* str1 = "\x1B[33m[\x1B[H\x1B[JWelcome to WIX!\nPress any key to cause a crash.\n";

    tty_write(str1, strlen(str1));

    while(1){ // Happy kernel mode task!!!
        sprintf(buf, "\x0DTime: %d", interrupt_tick);
        tty_write(buf, strlen(buf));
    }

    params->printf("Welcome to the WIX kernel!\nBuilt %s %s\n", __DATE__, __TIME__);
    sprintf(buf, "%d KB Extended Memory\n", params->mem_size);
    params->printf(buf);

}
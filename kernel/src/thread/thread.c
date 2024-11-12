/* 
    Copyright (C) 2024 WIX Kernel
    Authored by Will Klees
    thread.c - Multithreading scheduler
*/

#include <thread/thread.h>
#include <init/io.h>
#include <init/pic.h>
#include <init/idt.h>
#include <mm/pmm.h>
#include <mm/vmm.h>
#include <mm/heap.h>

volatile uint32_t interrupt_tick = 0;

task_t* cur_task;
task_t base_task;

extern void (*dbg_printf)(const char*, ...);

void dump_regs(int_state_t* state){
    dbg_printf("\nEAX: %x ECX: %x EBX: %x EDX: %x\nEBP: %x ESP: %x ESI: %x EDI: %x\n", state->eax, state->ecx, state->ebx, state->edx, state->ebp, state->esp, state->esi, state->edi);
}

uint32_t pit_isr(int_state_t* state){
    interrupt_tick++;
    pic_send_eoi(0);
    task_switch(state);
}

void init_tasking(){
    interrupt_tick = 0;
    cur_task = &base_task;
    base_task.next = cur_task;
    base_task.esp0 = 0xDEADBEEF;
    __asm__ volatile("movl %cr3, %eax");
    __asm__ volatile ("movl %%eax, %0" : "=a" (base_task.cr3));
    set_isr(0x70, pit_isr);

    // set pit reload frequency
    io_write_8(0x43, 52);
	io_write_8(0x40, 0xdf);
	io_write_8(0x40, 0x4);
}

void thread_exit(){
    disable_interrupts();
    dbg_printf("Thread exit!\n");
    // TODO: cleanup the thread
    while(1);
}

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

    task->esp0 = (uint32_t)stack;
    task->cr3 = (pgdir_t*)0x30000;

    if (user_esp){
        task->esp3 = (uint32_t)heap_alloc(4096) + 4096;
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

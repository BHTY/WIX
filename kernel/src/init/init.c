/* 
    Copyright (C) 2024 WIX Kernel
    Authored by Will Klees
    init.c - Kernel initialization
*/

#include <stdint.h>
#include <init/idt.h>
#include <init/pic.h>
#include <init/gdt.h>
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
    //dbg_printf("Hello! ESP=%x [%x]\n", state->esp, *(uint32_t*)state->esp);
    pic_send_eoi(0);
    task_switch();
    return 0;
}

void init_tasking(){
    cur_task = &base_task;
    base_task.next = cur_task;
}

void thread_exit(){
    disable_interrupts();
    dbg_printf("Thread exit!\n");
    while(1);
}

void thread_fun_1(void* param){
    while (1){
        dbg_printf("A");
        //task_switch();
    }
}

void thread_fun_2(void* param){
    while (1){
        dbg_printf("B");
    }
}

void create_thread(task_t* task, thread_func_t fn, void* param){
    uint32_t* stack = heap_alloc(4096) + 4096;

    stack--; *stack = param;
    stack--; *stack = thread_exit;
    stack--; *stack = fn;
    stack--; *stack = 0x202; //eflags
    stack--; *stack = 0;
    stack--; *stack = 0;
    stack--; *stack = 0;
    stack--; *stack = 0;

    task->esp = stack;
}

task_t* spawn_thread(thread_func_t fn, void* param){
    disable_interrupts();
    task_t* temp = cur_task->next;
    cur_task->next = heap_alloc(sizeof(task_t));
    cur_task->next->prev = cur_task;
    cur_task->next->next = temp;
    temp->prev = cur_task->next;

    if(!cur_task->prev) cur_task->prev = temp;

    create_thread(cur_task->next, fn, param);

    dbg_printf("About to enable interrupts\n");

    enable_interrupts();

    return cur_task->next;
}
 
void jump_usermode();

void _start(kernel_startup_params_t* params){
    char buf[40];
    pmm_init();

    dbg_printf = params->printf;

    sbrk(0x100000);
    heap_init();
    init_tasking();
    pic_remap(0x70, 0x78);
    idt_init();
    set_isr(0x70, pit_isr);

    gdt_init();

    map_page(0x30000, 0xB8000, 0x200000);

    io_write_8(0x43, 52);
	//outp(0x40, 0x95);
	//outp(0x40, 0x42);
	io_write_8(0x40, 0xdf);
	io_write_8(0x40, 0x4);

    spawn_thread(thread_fun_1, 0);
    spawn_thread(thread_fun_2, 0);

    dbg_printf("Okay...\n");

    jump_usermode();

    while(1){
        
    }

    params->printf("Welcome to the WIX kernel!\nBuilt %s %s\n", __DATE__, __TIME__);
    sprintf(buf, "%d KB Extended Memory\n", params->mem_size);
    params->printf(buf);

    //heap_init();
    char* ptr1 = heap_alloc(1024);
    char* ptr2 = heap_alloc(1024);
    char* ptr3 = heap_alloc(1024);
    //heap_free(ptr2);
    char* ptr4 = heap_alloc(1024);
    heap_free(ptr3);
    heap_print();

    //sbrk(0x100);

    while(1){
        (*(unsigned char*)(0x200000))++;
    }
}
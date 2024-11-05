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
} task_t;

typedef (*thread_func_t)(void*);

task_t* cur_task;
task_t base_task;

extern void (*dbg_printf)(const char*, ...);
void task_switch(int_state_t* state);

void test_int();

void dump_regs(int_state_t* state){
    dbg_printf("\nEAX: %x ECX: %x EBX: %x EDX: %x\nEBP: %x ESP: %x ESI: %x EDI: %x\n", state->eax, state->ecx, state->ebx, state->edx, state->ebp, state->esp, state->esi, state->edi);
}

// override in asm!?!?!?!?!?!?!?!?!?!?!?!?!?!?!?!
uint32_t pit_isr(int_state_t* state){
    // push regs
    //dbg_printf("\nContext switch: ");
    //dump_regs(state);
    interrupt_tick++;
    pic_send_eoi(0);
    //dbg_printf("EOI sent\n");
    task_switch(state);
    //return 0x30;
}

uint32_t syscall_handler(int_state_t* state){
    //dbg_printf("System call %x\n", state->eax);

    if(state->eax == 0x01){
        print(state->ebx);
    }

    //while(1);
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

/*void thread_fun_1(void* param){
    while (1){
        dbg_printf("A");
        //task_switch();
    }
}*/

/*void thread_fun_2(void* param){
    while (1){
        dbg_printf("B");
    }
}*/

void thread_fun_1(void* param);
void thread_fun_2(void* param);

void create_thread(task_t* task, thread_func_t fn, void* param, int user_esp){
    uint32_t* stack = heap_alloc(4096) + 4096;

    stack--; *stack = param;
    stack--; *stack = thread_exit;
    stack--; *stack = fn;
    stack--; *stack = 0x202; //eflags
    stack--; *stack = 0;
    stack--; *stack = 0;
    stack--; *stack = 0;
    stack--; *stack = 0;
    stack--; *stack = 0;
    stack--; *stack = 0;
    stack--; *stack = 0;

    task->esp = stack;

    if (user_esp){
        task->esp0 = heap_alloc(4096) + 4096;
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
 
void jump_usermode(uint32_t, uint32_t);
void test_user_function();

void bootvid_fill(uint16_t start, uint16_t end);

void print(char* str){
    //tty_write(str, strlen(str));
    dbg_printf(str);
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

    unmap_page(0x30000, 0x0);

    io_write_8(0x43, 52);
	//outp(0x40, 0x95);
	//outp(0x40, 0x42);
	io_write_8(0x40, 0xdf);
	io_write_8(0x40, 0x4);

    //dbg_printf("\x1B[41m\x1B[2J\x1B[HFATAL ERROR\n");

    tty_init();
    //tty_write("\x1B[41m\x1B[2JHi\x1B[H", 14);
    //bootvid_fill(0, 2000);

    //*(uint8_t*)(0x300000) = 0;

    spawn_thread(thread_fun_1, 0, 1);
    spawn_thread(thread_fun_2, 0, 1);

    //dbg_printf("Okay...\n");

    //jump_usermode(test_user_function, 0xF00F);

    char* str1 = "\x1B[33m[\x1B[H\x1B[JWelcome to WIX!\nPress any key to cause a crash.\n";

    tty_write(str1, strlen(str1));

    while(1){
        sprintf(buf, "\x0DTime: %d", interrupt_tick);
        tty_write(buf, strlen(buf));
        //tty_write("I'm a happy kernel mode task!\n", strlen("I'm a happy kernel mode task!\n"));
        //print("I'm a happy kernel mode task!\n");
    }

    while(1){
        sprintf(buf, "Hello %d\n", n++);
        tty_write(buf, strlen(buf));
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
        //(*(unsigned char*)(0x200000))++;
    }
}
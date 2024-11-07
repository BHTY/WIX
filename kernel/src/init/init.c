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
#include <thread/thread.h>

typedef struct kernel_startup_params {
    uint16_t kernel_sectors;
    uint16_t ramdisk_sectors;
    uint16_t mem_size;
    void (*printf)(const char*, ...);
} kernel_startup_params_t;

extern void (*dbg_printf)(const char*, ...);

void print(char* str){
    dbg_printf(str);
}

uint32_t syscall_handler(int_state_t* state){
    if(state->eax == 0x01) print((char*)(state->ebx));

    return 0;
}

uint32_t thread_fun_1(void* param);
uint32_t thread_fun_2(void* param);

uint32_t thread_fun_3(void* param){
    while(1){
        (*(uint8_t*)(0xB8000))++;
    }
}

void _start(kernel_startup_params_t* params){
    char buf[40];

    dbg_printf = params->printf;
    
    pmm_init();
    heap_init(0x100000);
    init_tasking();
    pic_remap(0x70, 0x78);
    idt_init();
    gdt_init();
    set_isr(0x80, syscall_handler);
    
    uint16_t int10_seg = *(uint16_t*)(0x42);
    uint16_t int10_off = *(uint16_t*)(0x40);
    dbg_printf("INT 10H entry point = %x:%x\n", int10_seg, int10_off);

    unmap_page(cur_task->cr3, 0x0);

    // set pit reload frequency
    io_write_8(0x43, 52);
	io_write_8(0x40, 0xdf);
	io_write_8(0x40, 0x4);

    tty_init();

    spawn_thread(thread_fun_1, 0, 1);
    spawn_thread(thread_fun_2, 0, 1);

    char* str1 = "\x1B[33m[\x1B[H\x1B[JWelcome to WIX!\nPress any key to cause a crash.\n"; //I LOVE NICOLE!

    tty_write(str1, strlen(str1));

    while(1){ // Happy kernel mode task!!!
        sprintf(buf, "\x0DTime: %d", interrupt_tick);
        tty_write(buf, strlen(buf));
    }
}
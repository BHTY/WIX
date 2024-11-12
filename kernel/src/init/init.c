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
#include <basedrv/ramdisk.h>
#include <ios/blockdev.h>
#include <ios/buf.h>
#include <ios/inode.h>
#include <basedrv/fs/ustar.h>

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

void fs_test(kernel_startup_params_t* params, const char* filename){
    char buffer[512];
    int n_ramdisk = install_ramdisk((uint8_t*)0x40000, params->ramdisk_sectors);
    tar_mount(n_ramdisk);
    inode_t* ip = tar_open(filename);

    if (ip){
        int n = readi(ip, buffer, 0, 20);
        dbg_printf("Read %x bytes from %s\n", n, filename);
        dbg_printf("%s", buffer);
    }
}

extern struct {
    size_t nbits;
    size_t arr_size;
    uint32_t arr[120];
} pageframe_bitmap;

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

    unmap_page(cur_task->cr3, 0x0);

    tty_init();

    binit();

    fs_test(params, "test.txt");

    spawn_thread(thread_fun_1, 0, 1);
    spawn_thread(thread_fun_2, 0, 1);

    char* str1 = "\x1B[33m[\x1B[H\x1B[JWelcome to WIX!\nPress any key to cause a crash.\n"; //I LOVE NICOLE!

    tty_write(str1, strlen(str1));

    while(1){ // Happy kernel mode task!!!
        sprintf(buf, "\x0DTime: %d", interrupt_tick);
        tty_write(buf, strlen(buf));
    }
}
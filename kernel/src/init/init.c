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
#include <mm/slab.h>
#include <syscall/syscall.h>
#include <basedrv/serial.h>
#include <stdarg.h>
#include <init/init.h>

kernel_startup_params_t startup_params;

int printk(const char* format, ...){
    char str[1024];
    va_list args;
    int size;

    va_start(args, format);
    size = vsprintf(str, format, args);
    va_end(args);

    com_write(COM1, str, size);

    return size;
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
    int n_ramdisk = install_ramdisk((uint8_t*)0x50000, params->ramdisk_sectors);
    tar_mount(n_ramdisk);
    inode_t* ip = tar_open(filename);

    if (ip){
        int n = readi(ip, buffer, 0, 20);
        printk("Read %x bytes from %s\n", n, filename);
        printk("%s", buffer);
    }
}

void _start(kernel_startup_params_t* params){
    char buf[40];

    /* Copy startup parameters */
    startup_params = *params;

    /* Initialize the physical memory manager */
    pmm_init();
    printk("PMM: \x1B[32mOK\x1B[0m\n");

    /* Initialize the virtual memory manager */
    vmm_init();
    printk("VMM: \x1B[32mOK\x1B[0m\n");

    /* Initialize the kernel heap */
    heap_init(0x100000);

    /* Set up multitasking */
    pic_remap(0x70, 0x78);
    idt_init();
    gdt_init();
    init_tasking();
    set_isr(0x80, syscall_trap);

    unmap_page(cur_task->cr3, 0x0);

    /* Initialize basic devices */
    tty_init();
    binit();
    fs_test(params, "test.txt");

    printk("%x\n", commit_pages(513));
    
    /* Testing! */
    spawn_thread(thread_fun_1, 0, 1);
    spawn_thread(thread_fun_2, 0, 1);

    char* str1 = "\x1B[33m[\x1B[H\x1B[JWelcome to WIX!\nPress any key to cause a crash.\n"; //I LOVE NICOLE!

    tty_write(str1, strlen(str1));

    while(1){ // Happy kernel mode task!!!
        sprintf(buf, "\x0DTime: %d", interrupt_tick);
        tty_write(buf, strlen(buf));
    }
}
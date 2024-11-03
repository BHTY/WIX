/* 
    Copyright (C) 2024 WIX Kernel
    Authored by Will Klees
    init.c - Kernel initialization
*/

#include <stdint.h>

typedef struct kernel_startup_params {
    uint16_t kernel_sectors;
    uint16_t ramdisk_sectors;
    uint16_t mem_size;
    void (*printf)(const char*, ...);
} kernel_startup_params_t;

void pmm_init();
uint32_t commit_page();
int sprintf(char* str, const char* format, ...);

void _start(kernel_startup_params_t* params){
    char buf[40];
    pmm_init();

    params->printf("\nWelcome to the WIX kernel!\nBuilt %s %s\n", __DATE__, __TIME__);
    sprintf(buf, "%d KB Extended Memory\n", params->mem_size);
    params->printf(buf);

    while(1){
        (*(unsigned char*)(0xB8000))++;
    }
}
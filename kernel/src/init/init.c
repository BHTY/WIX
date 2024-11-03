#include <stdint.h>

typedef struct kernel_startup_params {
    uint16_t kernel_sectors;
    uint16_t ramdisk_sectors;
    uint16_t mem_size;
    void (*printf)(const char*, ...);
} kernel_startup_params_t;

void pmm_init();
uint32_t commit_page();

void _start(kernel_startup_params_t* params){
    int pages = 0;
    uint32_t pfn;

    pmm_init();

    params->printf("\nWelcome to the WIX kernel!\nBuilt %s %s\nMemory size: %xKB\n", __DATE__, __TIME__, params->mem_size);

    
    /*for(int i = 0; i < 32; i++){
        pfn = commit_page();
        params->printf("Allocated page at 0x%x (%x)\n", pfn << 12, i);
    }*/
    

    while((pfn = commit_page()) != 0xFFFFFFFF){
        params->printf("Allocated page at 0x%x\n", pfn << 12);
        pages++;
    }

    params->printf("Failed to allocate after allocating %x %x pages\n", pages, pages);
    while(1);
}
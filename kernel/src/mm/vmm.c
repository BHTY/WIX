/* 
    Copyright (C) 2024 WIX Kernel
    Authored by Will Klees
    vmm.c - Virtual memory manager
*/

#include <mm/pmm.h>
#include <mm/vmm.h>
#include <mm/slab.h>
#include <string.h>
#include <assert.h>

#define NREGIONS 512

vmregion_t cache_data[NREGIONS];

struct{
    slab_cache_t slab;
    uint32_t flags[NREGIONS/32];
} vm_region_cache;

vmregion_t* kernel_address_space;

/* Initializes the virtual memory manager */
void vmm_init(){
    // Initialize the slab cache
    memset(vm_region_cache.flags, 0, sizeof(vm_region_cache.flags));
    vm_region_cache.slab.element_size = sizeof(vmregion_t);
    vm_region_cache.slab.data = cache_data;
    vm_region_cache.slab.bitmap.nbits = NREGIONS;
    vm_region_cache.slab.bitmap.arr_size = NREGIONS/32;

    // Initialize the kernel's memory manager
    kernel_address_space = slab_alloc(&(vm_region_cache.slab));
    kernel_address_space->prev = NULL;
    kernel_address_space->next = slab_alloc(&(vm_region_cache.slab));
    kernel_address_space->base = 0x80000000;
    kernel_address_space->size = 0x80000;
    kernel_address_space->state = 0;

    /* Initialize the kernel hyperspace */
    kernel_address_space->next->prev = kernel_address_space;
    kernel_address_space->next->next = NULL;
    kernel_address_space->next->base = 0xFFE00000;
    kernel_address_space->next->size = 0x00000200;
    kernel_address_space->next->state = 2;

    /*
    paddr_t base = commit_pages(0x200);

    for(int i = 0; i < 0x200; i++){
        map_page();
    }*/
}

/* Maps the given physical address to the given virtual address in the specified address space */
void map_page(pgdir_t* page_dir, paddr_t paddr, vaddr_t vaddr, uint32_t access){
    uintptr_t pd_entry = vaddr >> 22; // index into page directory
    uintptr_t pt_entry = (vaddr >> 12) & 0x3FF; // index into page table

    if (page_dir->entries[pd_entry] == 0){ // the virtual address is not backed by any existing page table
        page_dir->entries[pd_entry] = (commit_pages(1)) | access;
    }

    pgtable_t* page_table = (pgtable_t*)(page_dir->entries[pd_entry] & 0xFFFFF000);
    page_table->entries[pt_entry] = paddr | 7;

    //dbg_printf("[VMM] Mapped physical address %x to linear address %x\n", paddr, vaddr);
}

void unmap_page(pgdir_t* page_dir, vaddr_t vaddr){
    uintptr_t pd_entry = vaddr >> 22; // index into page directory
    uintptr_t pt_entry = (vaddr >> 12) & 0x3FF; // index into page table

    if(page_dir->entries[pd_entry] != 0){
        pgtable_t* page_table = (pgtable_t*)(page_dir->entries[pd_entry] & 0xFFFFF000);
        page_table->entries[pt_entry] = 0x0;
        //dbg_printf("[VMM] Unmapped linear address %x\n", vaddr);
    }
}

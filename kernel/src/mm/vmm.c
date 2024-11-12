/* 
    Copyright (C) 2024 WIX Kernel
    Authored by Will Klees
    vmm.c - Virtual memory manager
*/

#include <mm/pmm.h>
#include <mm/vmm.h>

extern void (*dbg_printf)(const char*, ...);

/* Maps the given physical address to the given virtual address in the specified address space */
void map_page(pgdir_t* page_dir, paddr_t paddr, vaddr_t vaddr){
    uintptr_t pd_entry = vaddr >> 22; // index into page directory
    uintptr_t pt_entry = (vaddr >> 12) & 0x3FF; // index into page table

    if (page_dir->entries[pd_entry] == 0){ // the virtual address is not backed by any existing page table
        page_dir->entries[pd_entry] = (commit_pages(1)) | 7;
    }

    pgtable_t* page_table = (pgtable_t*)(page_dir->entries[pd_entry] & 0xFFFFF000);
    page_table->entries[pt_entry] = paddr | 7;

    dbg_printf("[VMM] Mapped physical address %x to linear address %x\n", paddr, vaddr);
}

void unmap_page(pgdir_t* page_dir, vaddr_t vaddr){
    uintptr_t pd_entry = vaddr >> 22; // index into page directory
    uintptr_t pt_entry = (vaddr >> 12) & 0x3FF; // index into page table

    if(page_dir->entries[pd_entry] != 0){
        pgtable_t* page_table = (pgtable_t*)(page_dir->entries[pd_entry] & 0xFFFFF000);
        page_table->entries[pt_entry] = 0x0;
        dbg_printf("[VMM] Unmapped linear address %x\n", vaddr);
    }
}

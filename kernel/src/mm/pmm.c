/* 
    Copyright (C) 2024 WIX Kernel
    Authored by Will Klees
    pmm.c - Page Frame Manager
*/

#include <stdint.h>
#include <string.h>
#include <mm/pmm.h>
#include <mm/bitarray.h>

extern void (*dbg_printf)(const char*, ...);

struct {
    size_t nbits;
    size_t arr_size;
    uint32_t arr[120];
} pageframe_bitmap;

/* Initializes the physical memory manager and pageframe bitmap */
void pmm_init(){
    pageframe_bitmap.nbits = 3840;
    pageframe_bitmap.arr_size = 120;
    memset(pageframe_bitmap.arr, 0, sizeof(uint32_t) * pageframe_bitmap.arr_size);
}

/* Commit contiguous pages of physical memory */
paddr_t commit_pages(size_t n){
    pfn_t index = bitarray_find_free_region((struct bitarray*)&pageframe_bitmap, n);

    if (index != -1){
        bitarray_set((struct bitarray*)&pageframe_bitmap, index, n);
        return (index << 12) + 0x100000;
    }

    return -1;
}

/* Decommit pages of physical memory */
void decommit_pages(paddr_t paddr, size_t n){
    pfn_t index = (paddr - 0x100000) >> 12;
    bitarray_clear((struct bitarray*)&pageframe_bitmap, index, n);
}

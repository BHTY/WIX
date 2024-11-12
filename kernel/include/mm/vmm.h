#pragma once

#include <stddef.h>
#include <stdint.h>

typedef uintptr_t paddr_t;
typedef uintptr_t vaddr_t;

typedef struct pgdir {
    paddr_t entries[1024];
} pgdir_t;

typedef struct pgtable {
    paddr_t entries[1024];
} pgtable_t;

typedef struct vmregion { // allocated from slab cache
    struct vmregion *prev, *next;
    vaddr_t base;
    size_t size; // in pages
    int state; // 0 = free, 1 = reserved, 2 = committed
} vmregion_t;

void vmm_init();
void map_page(pgdir_t* page_dir, paddr_t paddr, vaddr_t vaddr, uint32_t access);
void unmap_page(pgdir_t* page_dir, vaddr_t vaddr);
vaddr_t vm_reserve(vaddr_t start, size_t size, uint32_t access);
int vm_commit(vaddr_t base, size_t size);
int vm_decommit(vaddr_t base, size_t size);
int vm_release(vaddr_t base, size_t size);

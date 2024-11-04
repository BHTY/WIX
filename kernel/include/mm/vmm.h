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

void map_page(pgdir_t* page_dir, paddr_t paddr, vaddr_t vaddr);

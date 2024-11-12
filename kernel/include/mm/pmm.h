#pragma once

#include <stddef.h>
#include <stdint.h>
#include <mm/vmm.h>

typedef uintptr_t pfn_t;

void pmm_init();
//pfn_t commit_page();
//void decommit_page(pfn_t pfn);

paddr_t commit_pages(size_t n);
void decommit_pages(paddr_t paddr, size_t n);

#pragma once

#include <stddef.h>
#include <stdint.h>

typedef uintptr_t pfn_t;

void pmm_init();
pfn_t commit_page();
void decommit_page(pfn_t pfn);

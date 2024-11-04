#pragma once

#include <stddef.h>

void heap_print();
void heap_init();
void* heap_alloc(size_t sz);
void heap_free(void* ptr);
void* heap_realloc(void* ptr, size_t new_sz);

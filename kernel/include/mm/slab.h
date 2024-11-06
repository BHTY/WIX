#pragma once

#include <stdint.h>
#include <stddef.h>

typedef struct slab_cache {
    uint32_t elements;
    size_t element_size;
    void* data;
    uint32_t bitmap[0];
} slab_cache_t;

slab_cache_t* slab_create(uint32_t elements, size_t element_size, void* data);
void* slab_alloc(slab_cache_t* slab);
void slab_release(slab_cache_t* slab, void* data);
void slab_destroy(slab_cache_t* slab);

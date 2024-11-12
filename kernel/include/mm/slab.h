#pragma once

#include <stdint.h>
#include <stddef.h>
#include <mm/bitarray.h>

typedef struct slab_cache {
    size_t element_size;
    void* data;
    struct bitarray bitmap;
} slab_cache_t;

void* slab_alloc(slab_cache_t* slab);
void slab_release(slab_cache_t* slab, void* data);

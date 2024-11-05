#pragma once

#include <stdint.h>
#include <stddef.h>

typedef struct slab {
    uint32_t elements;
    size_t element_size;
    void* data;
    uint32_t bitmap[0];
} slab_t;

slab_t* slab_create(uint32_t elements, size_t element_size, void* data);
void* slab_alloc(slab_t* slab);
void slab_release(slab_t* slab, void* data);
void slab_destroy(slab_t* slab);

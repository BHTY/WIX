/* 
    Copyright (C) 2024 WIX Kernel
    Authored by Will Klees
    slab.c - Slab Allocator
*/

#include <mm/slab.h>
#include <mm/bitarray.h>

/* Allocate a new element from the slab cache, returning NULL if none are present */
void* slab_alloc(slab_cache_t* slab){
    uint32_t index = bitarray_find_free_region(&(slab->bitmap), 1);
    if (index == -1) return NULL;
    bitarray_set(&(slab->bitmap), index, 1);
    return (void*)((uintptr_t)slab->data + index * slab->element_size);
}

/* Free an element back into the pool to be reallocated later */
void slab_release(slab_cache_t* slab, void* data){
    uint32_t index = ((uintptr_t)data - (uintptr_t)(slab->data)) / slab->element_size;

    if (index < slab->bitmap.nbits) { // within range of the # of elements
        bitarray_clear(&(slab->bitmap), index, 1);
    }
}

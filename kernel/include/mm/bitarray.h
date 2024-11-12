#pragma once

#include <stdint.h>
#include <stddef.h>

struct bitarray{
    size_t nbits;
    size_t arr_size;
    uint32_t arr[0];
};

/* Sets nbits in the bitarray starting from pos */
void bitarray_set(struct bitarray*, size_t pos, size_t nbits);

/* Clears nbits in the bitarray starting from pos */
void bitarray_clear(struct bitarray*, size_t pos, size_t nbits);

/* Finds the index of the first free region of sufficient size (or -1 if not found) */
uint32_t bitarray_find_free_region(struct bitarray*, size_t size);

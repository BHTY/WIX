#include <stdint.h>
#include <mm/bitarray.h>
#include <stdio.h>

/* Clears bits from src starting from pos */
uint32_t bit_clear(uint32_t src, size_t bits, size_t pos){
    uint32_t mask = (((uint64_t)1 << bits) - 1) << pos;
    return src & ~mask;
}

/* Sets bits from src starting from pos */
uint32_t bit_set(uint32_t src, size_t bits, size_t pos){
    uint32_t mask = (((uint64_t)1 << bits) - 1) << pos;
    return src | mask;
}

/* Sets nbits in the bitarray starting from pos */
void bitarray_set(struct bitarray* bitmap, size_t pos, size_t nbits){
    if ((pos + nbits) > bitmap->nbits) nbits = bitmap->nbits - pos;
    
    uint32_t array_index = pos / 32;
    uint32_t bit_index = pos % 32;
    uint32_t bits_set_here = ((32 - bit_index) > nbits) ? nbits : (32 - bit_index);

    bitmap->arr[array_index] = bit_set(bitmap->arr[array_index], bits_set_here, bit_index);

    nbits -= bits_set_here;

    array_index++;

    while (nbits >= 32){
        bitmap->arr[array_index++] = 0xFFFFFFFF;
        nbits -= 32;
    }

    if (nbits){
        bitmap->arr[array_index] = bit_set(bitmap->arr[array_index], nbits, 0);
    }
}

/* Clears nbits in the bitarray starting from pos */
void bitarray_clear(struct bitarray* bitmap, size_t pos, size_t nbits){
    if ((pos + nbits) > bitmap->nbits) nbits = bitmap->nbits - pos;
    
    uint32_t array_index = pos / 32;
    uint32_t bit_index = pos % 32;
    uint32_t bits_set_here = ((32 - bit_index) > nbits) ? nbits : (32 - bit_index);

    bitmap->arr[array_index] = bit_clear(bitmap->arr[array_index], bits_set_here, bit_index);

    nbits -= bits_set_here;

    array_index++;

    while (nbits >= 32){
        bitmap->arr[array_index++] = 0x00000000;
        nbits -= 32;
    }

    if (nbits){
        bitmap->arr[array_index] = bit_clear(bitmap->arr[array_index], nbits, 0);
    }
}

/* Bit-scan reverse: returns the position of the last set bit */
uint32_t bsr(uint32_t dword){
    uint32_t index = 31;

    while(!(dword & 0x80000000) && index){
        dword <<= 1;
        index--;
    }

    return index;
}

/* Bit scan forward: returns the position of the first set bit */
uint32_t bsf(uint32_t dword){
    uint32_t index = 0;

    while(!(dword & 0x1) && index < 32){
        dword >>= 1;
        index++;
    }

    return index;
}

/* Find free bits from position n */
size_t find_free_bits(struct bitarray* bitmap, size_t n){
    uint32_t array_index = n / 32;
    uint32_t bit_index = n % 32;
    uint32_t last_set_bit = bsr(bitmap->arr[array_index]);
    uint32_t free_bits;

    if (bitmap->arr[array_index] == 0 || last_set_bit < bit_index) {
        free_bits = 32 - bit_index;
    } else {
        free_bits = 0;
        uint32_t test_value = bitmap->arr[array_index] >> bit_index;

        while (!(test_value & 0x1)) {
            test_value >>= 1;
            free_bits++;
        }

        return free_bits;
    }

    array_index++;

    while (bitmap->arr[array_index] == 0) {
        if (array_index == (bitmap->arr_size-1)) {
            free_bits += (bitmap->nbits & 31) ? (bitmap->nbits & 31) : 32;
            return free_bits;
        }

        free_bits += 32;
        array_index++;
    }

    free_bits += bsf(bitmap->arr[array_index]);

    return free_bits;

}

/* Find set bits from position n */
size_t find_set_bits(struct bitarray* bitmap, size_t n){
    uint32_t array_index = n / 32;
    uint32_t bit_index = n % 32;
    uint32_t last_set_bit = bsr(~bitmap->arr[array_index]);
    uint32_t free_bits;

    if (bitmap->arr[array_index] == 0xFFFFFFFF || last_set_bit < bit_index) {
        free_bits = 32 - bit_index;
    } else {
        free_bits = 0;
        uint32_t test_value = ~(bitmap->arr[array_index] >> bit_index);

        while (!(test_value & 0x1)) {
            test_value >>= 1;
            free_bits++;
        }

        return free_bits;
    }

    array_index++;

    while (bitmap->arr[array_index] == 0xFFFFFFFF) {
        if (array_index == (bitmap->arr_size-1)) {
            free_bits += (bitmap->nbits & 31) ? (bitmap->nbits & 31) : 32;
            return free_bits;
        }

        free_bits += 32;
        array_index++;
    }

    free_bits += bsf(~bitmap->arr[array_index]);

    return free_bits;

}

/* Find first free bit starting from pos, -1 if no more free bits */
uint32_t find_first_free_bit(struct bitarray* bitmap, size_t pos){
    // FIXME: Optimize
    return find_set_bits(bitmap, pos) + pos;
}

/* Finds the index of the first free region of sufficient size (or -1 if not found) */
uint32_t bitarray_find_free_region(struct bitarray* bitmap, size_t size){
    uint32_t index = 0;

    while (index < bitmap->nbits) {
        uint32_t free_region = find_free_bits(bitmap, index);

        if (free_region >= size) {
            return index;
        }

        index = find_first_free_bit(bitmap, index + free_region);
    }

    return -1;
}


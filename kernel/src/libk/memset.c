#include <stddef.h>
#include <stdint.h>

void *memset(void *dest, uint8_t val, size_t count)
{
    uint8_t *temp = (uint8_t*) dest;
    for(; count != 0; count--) *temp++ = val;
    return dest;
}
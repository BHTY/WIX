#include <stdint.h>
#include <stddef.h>

size_t strlen(const char* str){
    size_t sz = 0;

    while(*(str++)){
        sz++;
    }

    return sz;
}
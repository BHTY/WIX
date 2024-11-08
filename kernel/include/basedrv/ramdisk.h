#pragma once

#include <stddef.h>
#include <stdint.h>

typedef struct ramdisk_params{
    uint8_t* data;
    size_t blocks;
} ramdisk_params_t;

int install_ramdisk(uint8_t* data, size_t blocks);

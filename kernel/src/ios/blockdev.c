/* 
    Copyright (C) 2024 WIX Kernel
    Authored by Will Klees
    blockdev.c - Kernel I/O manager for block devices
*/

#include <ios/blockdev.h>

blockdev_t block_devs[MAX_BLOCKDEVS];
int n_block_devs = 0;

/* Installs/registers a new block device, returning -1 if impossible */
int add_block_dev(blockdev_t* bd){
    if (n_block_devs >= MAX_BLOCKDEVS)
        return -1;

    block_devs[n_block_devs] = *bd;

    return n_block_devs++;
}

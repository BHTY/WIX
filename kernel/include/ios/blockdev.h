#pragma once

#include <stdint.h>
#include <stddef.h>

#define MAX_BLOCKDEVS 10

typedef uint32_t blknum_t;

typedef struct blockdev{
    int (*read)(struct blockdev*, uint8_t*, blknum_t);
    int (*write)(struct blockdev*, uint8_t*, blknum_t);
    void* data; // stored per driver
} blockdev_t;

extern blockdev_t block_devs[];
extern int n_block_devs;

int add_block_dev(blockdev_t* bd);

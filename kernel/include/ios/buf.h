#pragma once

#include <ios/blockdev.h>

#define BSIZE 512
#define NBUF 8

typedef struct buf {
    int flags;
    int devnum;
    blknum_t blknum;

    uint8_t data[BSIZE];
} buf_t;

buf_t* bread(uint16_t devnum, blknum_t blknum);
void bwrite(uint16_t devnum, blknum_t blknum, uint8_t* data);
void binit();

#define B_DIRTY 0x1

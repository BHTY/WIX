#pragma once

#include <stdint.h>
#include <stddef.h>
#include <ios/blockdev.h>

typedef struct inode {
    int type; // 0 for device file, 1 for disk file
    int refcnt; // reference count

    // device files only
    uint16_t major, minor;

    // disk files only
    uint32_t num; // for the use of the filesystem driver
    size_t size;
    int blkdev;
    blknum_t (*bmap)(struct inode*, blknum_t); // maps file blocks to disk blocks
} inode_t;

void creatid(inode_t* ip, uint16_t major, uint16_t minor);
void creatif(inode_t* ip, uint32_t num, size_t size, uint16_t blkdev, blknum_t (*bmap)(struct inode*, blknum_t));
int readi(inode_t* ip, uint8_t* dst, size_t off, size_t n);

#define I_DEVICE 0
#define I_FILE 1

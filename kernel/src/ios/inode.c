/* 
    Copyright (C) 2024 WIX Kernel
    Authored by Will Klees
    inode.c - Kernel I/O manager for inodes
*/

#include <ios/buf.h>
#include <ios/inode.h>
#include <init/panic.h>
#include <string.h>

#define min(a, b) ((a) < (b) ? (a) : (b))

/* Initialize an inode pointing to a device file */
void creatid(inode_t* ip, uint16_t major, uint16_t minor){
    ip->type = I_DEVICE;
    ip->major = major;
    ip->minor = minor;
}

/* Initialize an inode pointing to a disk file */
void creatif(inode_t* ip, uint32_t num, size_t size, uint16_t blkdev, blknum_t (*bmap)(struct inode*, blknum_t)){
    ip->type = I_FILE;
    ip->num = num;
    ip->size = size;
    ip->blkdev = blkdev;
    ip->bmap = bmap;
}

int readi(inode_t* ip, uint8_t* dst, size_t off, size_t n){
    buf_t* bp;
    uint32_t total, m;

    if (ip->type == I_DEVICE) {
        panic("Device files unsupported!\n");
    }

    if (off > ip->size || off + n < off) // reading past end of file
        return -1;
    if (off + n > ip->size) // off+n would go beyond the end of file, truncate to fit
        n = ip->size - off;

    for(total = 0; total < n; total += m, off += m, dst += m){
        bp = bread(ip->blkdev, ip->bmap(ip, off/BSIZE));
        m = min(n - total, BSIZE - off % BSIZE);
        memcpy(dst, bp->data + off%BSIZE, m);
    }

    return n;
}

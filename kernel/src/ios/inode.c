/* 
    Copyright (C) 2024 WIX Kernel
    Authored by Will Klees
    inode.c - Kernel I/O manager for inodes
*/

#include <ios/inode.h>

/* Initialize an inode pointing to a device file */
void creatid(inode_t* ip, uint16_t major, uint16_t minor){
    ip->type = I_DEVICE;
    ip->major = major;
    ip->minor = minor;
}

/* Initialize an inode pointing to a disk file */
void creatif(inode_t* ip, uint16_t num, size_t size, uint16_t blkdev, blknum_t (*bmap)(struct inode*, blknum_t)){
    ip->type = I_FILE;
    ip->num = num;
    ip->size = size;
    ip->blkdev = blkdev;
    ip->bmap = bmap;
}

int readi(inode_t* ip, uint8_t* dst, size_t off, size_t n){
    /*buf_t* bp;

    if (ip->type == I_DEVICE) {
        while(1);
    }

    if (off > ip->size || off + n < off) // reading past end of file
        return -1;
    if (off + n > ip->size) // off+n would go beyond the end of file, truncate to fit
        n = ip->size - off;
    
    */
}

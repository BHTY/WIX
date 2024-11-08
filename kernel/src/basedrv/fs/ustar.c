/* 
    Copyright (C) 2024 WIX Kernel
    Authored by Will Klees
    ustar.c - USTAR filesystem driver
*/

#include <mm/heap.h>
#include <ios/blockdev.h>
#include <ios/inode.h>
#include <ios/buf.h>
#include <basedrv/fs/ustar.h>
#include <string.h>

extern void (*dbg_printf)(const char*, ...);

uint16_t devnum;

int oct2bin(unsigned char *str, int size) {
    int n = 0;
    unsigned char *c = str;
    while (size-- > 0) {
        n *= 8;
        n += *c - '0';
        c++;
    }
    return n;
}

/* Maps the block number within a file to the disk block number */
blknum_t tar_bmap(inode_t* ip, blknum_t blknum){
    return ip->num + blknum;
}

/*  */
void tar_mount(int blkdev){
    devnum = blkdev;
}

/* */
inode_t* tar_open(const char* filename){
    blknum_t blknum = 0;
    buf_t* b = bread(devnum, blknum);
    tar_header_t* hdr = (tar_header_t*)b->data;

    while(!memcmp(hdr->ustar, "ustar", 5)){
        int filesize = oct2bin(hdr->file_size, 11);

        if (!strcmp(hdr->filename, filename)) {
            inode_t* ip = heap_alloc(sizeof(inode_t));
            creatif(ip, blknum + 1, filesize, devnum, tar_bmap);
            return ip;
        }

        blknum += (((filesize + 511) / 512) + 1);
        b = bread(devnum, blknum);
        hdr = (tar_header_t*)b->data;
    }

    return NULL;
}

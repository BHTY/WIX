/* 
    Copyright (C) 2024 WIX Kernel
    Authored by Will Klees
    buf.c - Kernel block cache
*/

#include <ios/blockdev.h>
#include <ios/buf.h>
#include <string.h>

extern void (*dbg_printf)(const char*, ...);

// buf_ptr+1 = LRU, buf_ptr = MRU, buf_ptr-1 = 2nd MRU
buf_t buffers[NBUF]; // circular LRU array
int buf_ptr;

/* Initialize the buffer cache */
void binit(){    
    buf_ptr = 0;

    // initialize the list of buffers
    for (int i = 0; i < NBUF; i++) {
        buffers[i].flags = 0;
        buffers[i].devnum = -1;
    }
}

/* Find the matching buffer in the cache, or return NULL if none is found */
buf_t* bget(uint16_t devnum, blknum_t blknum){
    for (int i = 0; i < NBUF; i++) {
        if(buffers[i].devnum == devnum && buffers[i].blknum == blknum){
            return &buffers[i];
        }
    }

    return NULL;
}

/* Flush the LRU buffer to disk and return it for new use */
buf_t* bflush(){
    buf_ptr = (buf_ptr + 1) % NBUF;
    buf_t* b = &buffers[buf_ptr];

    if (b->flags & B_DIRTY){ // flush to disk
        blockdev_t* bd = &block_devs[b->devnum];
        bd->write(bd, b->data, b->blknum); // handle failure
    }

    b->flags = 0;
    b->devnum = -1;

    return b;
}

/* Read a block from the buffer cache */
buf_t* bread(uint16_t devnum, blknum_t blknum){
    buf_t* b = bget(devnum, blknum);

    if (b == NULL) { // obtain the next buffer
        b = bflush();
        b->devnum = devnum;
        b->blknum = blknum;

        // read the block into memory
        blockdev_t* bd = &block_devs[devnum];
        bd->read(bd, b->data, blknum);
    }

    return b;
}

/* Write a block into the buffer cache */
void bwrite(uint16_t devnum, blknum_t blknum, uint8_t* data){
    buf_t* b = bget(devnum, blknum);

    if (b == NULL) { // obtain the next buffer
        b = bflush();
        b->devnum = devnum;
        b->blknum = blknum;
    }

    memcpy(b->data, data, BSIZE);
    b->flags |= B_DIRTY;
}

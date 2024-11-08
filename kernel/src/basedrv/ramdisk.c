/* 
    Copyright (C) 2024 WIX Kernel
    Authored by Will Klees
    ramdisk.c - Very simple block-oriented ramdisk driver
*/

#include <string.h>
#include <mm/heap.h>
#include <basedrv/ramdisk.h>
#include <ios/blockdev.h>
#include <ios/buf.h>

/* Reads from the ramdisk */
int ramdisk_read(blockdev_t* bd, uint8_t* buf, blknum_t blknum){
    ramdisk_params_t* params = bd->data;

    if (blknum >= params->blocks) return -1;

    memcpy(buf, params->data + blknum * BSIZE, BSIZE);

    return 0;
}

/* Writes to the ramdisk */
int ramdisk_write(blockdev_t* bd, uint8_t* buf, blknum_t blknum){
    ramdisk_params_t* params = bd->data;

    if (blknum >= params->blocks) return -1;

    memcpy(params->data + blknum * BSIZE, buf, BSIZE);

    return 0;
}

/* Installs a ramdisk device as a block device */
int install_ramdisk(uint8_t* data, size_t blocks){
    int devnum;
    blockdev_t bd;
    ramdisk_params_t* params = heap_alloc(sizeof(ramdisk_params_t));

    if (params == NULL) return -1;

    params->data = data;
    params->blocks = blocks;
    bd.data = params;
    bd.read = ramdisk_read;
    bd.write = ramdisk_write;

    devnum = add_block_dev(&bd);

    if (devnum == -1) heap_free(params);

    return devnum;
}

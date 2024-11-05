/* 
    Copyright (C) 2024 WIX Kernel
    Authored by Will Klees
    heap.c - Kernel heap functions
*/

#include <mm/heap.h>
#include <stddef.h>
#include <stdint.h>
#include <string.h>

extern void (*dbg_printf)(const char*, ...);

#define ALIGNMENT   4
#define align(x,a)	((((x) % (a)) == 0) ? (x) : ((x) + (a)) - (x) % (a))

size_t heap_size;
void *heap_start;

typedef struct mem_block{
	int used;
	size_t size;
	struct mem_block *prev;
	struct mem_block *next;
	uint8_t data[0];
} mem_block_t;

void print_heap_entry(mem_block_t* blk){
    dbg_printf("%s %x: %x bytes\n", blk->used ? "USED" : "FREE", blk->data, blk->size);
}

mem_block_t* heap_walk(mem_block_t* blk, void(*fn)(mem_block_t*)){
    fn(blk);
    return blk->next;
}

void heap_print(){
    mem_block_t *blk = heap_start;

    while(blk = heap_walk(blk, print_heap_entry));
}

void heap_init(){
    mem_block_t temp;
    heap_size = 0x100000;
    heap_start = (void*)0x100000;
	temp.used = 0;
	temp.size = heap_size - sizeof(mem_block_t);
	temp.prev = 0;
	temp.next = 0;
	memcpy(heap_start, &temp, sizeof(mem_block_t));
}

void* heap_alloc(size_t sz){
    mem_block_t *curBlock = (mem_block_t*)heap_start;
	mem_block_t *oldNext;
	mem_block_t *nextBlock;
	size_t oldSize;

	sz = align(sz, ALIGNMENT);

	while (1){

		if (!(curBlock->used)){ //free block found

			if (curBlock->size >= (16 + sz)){ //is block big enough?
				oldSize = curBlock->size;
				oldNext = curBlock->next;
				//format current block
				curBlock->used = 1;
				curBlock->size = sz;
				curBlock->next = (mem_block_t*)((size_t)curBlock + 16 + sz);
				nextBlock = curBlock->next;

				nextBlock->used = 0;
				nextBlock->prev = curBlock;

				if (oldNext == 0 || oldNext->used){ 
					nextBlock->next = oldNext;
					nextBlock->size = oldSize - (16 + sz);
				}
				else{ //oldnext is free, merge
					nextBlock->next = oldNext->next;
					nextBlock->size = oldSize - sz + oldNext->size;
				}

				break;
			}

		}

		curBlock = curBlock->next;

        if(!curBlock){
            return NULL;
        }
	}

	return curBlock->data;
}

void heap_free(void* ptr){
    mem_block_t* curBlock = (mem_block_t*)((size_t)ptr - 16);
	//printf("%p", curBlock);

	if (curBlock->prev && !(curBlock->prev->used)){ //if block behind this is free, merge
		curBlock->prev->next = curBlock->next;
		curBlock->prev->size += 16 + curBlock->size;
		curBlock = curBlock->prev;
	}

	//if next block is unused, merge with that as well
	if (curBlock->next && !(curBlock->next->used)){
		curBlock->size += 16 + curBlock->next->size;
		curBlock->next = curBlock->next->next;
	}

	//mark as free
	curBlock->used = 0;
}

void* heap_realloc(void* ptr, size_t new_sz){
    return NULL;
}

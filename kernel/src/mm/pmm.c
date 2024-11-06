#include <stdint.h>
#include <string.h>
#include <mm/pmm.h>

extern void (*dbg_printf)(const char*, ...);

uint32_t pageframe_bitmap[120] = {0};

void pmm_init(){
    memset(pageframe_bitmap, 0, sizeof(pageframe_bitmap));
}

int bitscan(uint32_t bitfield){ //find first zero
    int index = 0;

    while(bitfield){
        if(!(bitfield & 0x1)) break;
        bitfield >>= 1;

        index++;
    }

    return index;
}

pfn_t commit_page(){
    pfn_t pfn = -1 - 0x100;

    for(int i = 0; i < 120; i++){
        if(pageframe_bitmap[i] != 0xFFFFFFFF){
            int bit_index = bitscan(pageframe_bitmap[i]);
            pfn = bit_index + i * 32;
            pageframe_bitmap[i] |= 1 << bit_index;
            break;
        }
        /*if(!pageframe_bitmap[i]){
            pfn = i;
            pageframe_bitmap[i] = 1;
            break;
        }*/
    }

    dbg_printf("[PMM] Allocated page at %x\n", (pfn + 0x100) << 12);

    return pfn + 0x100;
}

void decommit_page(pfn_t pfn){
    int array_index = (pfn - 0x100) >> 5;
    int bit_index = (pfn - 0x100) % 32;

    pageframe_bitmap[array_index] &= ~(1 << bit_index);
}

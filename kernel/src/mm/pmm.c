#include <stdint.h>
#include <string.h>

typedef uintptr_t paddr_t;
typedef uintptr_t vaddr_t;
typedef uintptr_t pfn_t;

typedef struct pgdir {
    paddr_t pde[1024];
} pgdir_t;

typedef struct pgtable {
    paddr_t pte[1024];
} pgtable_t;

uint32_t pageframe_bitmap[3840] = {0};

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

    for(int i = 0; i < 3840; i++){
        /*if(pageframe_bitmap[i] != 0xFFFFFFFF){
            int bit_index = bitscan(pageframe_bitmap[i]);
            pfn = bit_index + i * 32;
            pageframe_bitmap[i] |= 1 << bit_index;
            break;
        }*/
        if(!pageframe_bitmap[i]){
            pfn = i;
            pageframe_bitmap[i] = 1;
            break;
        }
    }

    return pfn + 0x100;
}

void free_page(pfn_t pfn){
    int array_index = (pfn - 0x100) >> 5;
    int bit_index = (pfn - 0x100) % 32;

    pageframe_bitmap[array_index] &= ~(1 << bit_index);
}
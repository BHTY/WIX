#include <mm/pmm.h>
#include <mm/vmm.h>

vaddr_t brk = 0x100000;
vaddr_t brk_end = 0x100000;

extern void (*dbg_printf)(const char*, ...);

void* sbrk(size_t increment){
    vaddr_t new_brk = brk + increment;

    while(new_brk > brk_end){
        paddr_t new_page = commit_page() << 12;
        map_page((void*)0x30000, new_page, brk_end);

        brk_end += 0x1000;
    }

    brk = new_brk;

    dbg_printf("Raised program break by %x bytes to %x\n", increment, brk);

    return (void*)brk;
}

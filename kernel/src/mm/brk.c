#include <mm/pmm.h>
#include <mm/vmm.h>

vaddr_t brk = 0x100000;
vaddr_t brk_end = 0x100000;

void* sbrk(size_t increment){
    vaddr_t old_brk = brk;
    vaddr_t new_brk = brk + increment;

    while(new_brk > brk_end){
        paddr_t new_page = commit_pages(1);
        map_page((void*)0x80000, new_page, brk_end, 0x107);

        brk_end += 0x1000;
    }

    brk = new_brk;

    //printk("Raised program break by %x bytes to %x\n", increment, brk);

    return (void*)old_brk;
}

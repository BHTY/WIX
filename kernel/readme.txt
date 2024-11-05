Todo List
1.) Fix... so many bugs (kheap)
2.) Thread cleanup
3.) Sleep queues / blocking / synch objects
    Mutex
    Critical Section
4.) Slab allocator (for threads and stuff)
5.) Multiple address spaces

Kernel debugger

Fixing user mode
- Syscalls
- Swapping kernel stacks

Loading additional processes

Superior timeslice scheduler

TTY/bootvid (ANSI?)

MEMORY MANAGEMENT
Applications dynamically allocate memory by requesting it from the system via the sbrk(int) system call, which raises the program break, extending the heap, and returning the new program break.

If new pages are required to ensure that the entire heap is accessible, new pages will be committed and mapped into the address space

The stack expands downwards as the heap goes upwards


User Mode Memory Map
----------
| Stack  |
|        |
|        |
|--------| Program Break
|  Heap  |
|  Data  |
|  Text  |
|--------| 0x00001000
| Unused |
---------- 0x00000000

Task Control Block
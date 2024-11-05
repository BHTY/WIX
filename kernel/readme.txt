Todo List

=== BUG FIXES ===
Kernel heap


=== MULTITHREADING ===
Improve the timeslice scheduler

Thread cleanup

Block List
Sleep queues for synchronization objects
Wait on a mutex / critical section

Multiple address spaces


=== SLAB ALLOCATOR ===
For threads and stuff


=== OTHER ===
- Kernel debugger
- Loading additional processes


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
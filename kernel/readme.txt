Todo List

=== CLEANUP ===

=== BUG FIXES ===
Kernel heap


=== MULTITHREADING ===
Add thread local storage (Win32-like mechanism; FS register points to TEB)

Improve the timeslice scheduler

Thread cleanup

Block List
Sleep queues for synchronization objects
Wait on a mutex / critical section
Block for a file (read from keyboard!!!)
    Waitable event objects are implemented quite simply. When you call WaitEvent(event) for an unsignalled event, the thread is immediately taken off
    of of the active thread queue and placed onto the sleep queue. At the same time, the event object itself has a linked queue of threads waiting on
    it. Once SignalEvent(event) is called, the first thread is popped off of the linked queue and woken up.

Multiple address spaces


=== SLAB ALLOCATOR ===
Slab allocator objects can be created to reserve a pool of a fixed number of fixed-size objects (i.e. threads)
When an object is deleted from the slab allocator, it is released to the pool


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


Applications
- Pong
- Hex editor
- Machine monitor
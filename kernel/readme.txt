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


=== I/O SUBSYSTEM & VIRTUAL FILESYSTEM ===
Mount the initrd (we can load executables from here)


=== OTHER ===
- Kernel debugger
- Loading additional processes


MEMORY MANAGEMENT
Applications dynamically allocate memory by requesting it from the system via the sbrk(int) system call, which raises the program break, extending the heap, and returning the new program break.

If new pages are required to ensure that the entire heap is accessible, new pages will be committed and mapped into the address space

The stack expands downwards as the heap goes upwards




CREATING A PROCESS
Create a new thread with a new virtual address space. Set its EIP to load_image and its argument to the path (or something?) of the image file
The new thread will then begin executing the kernel code load_image to map the executable into its memory space, and then will call 
jump_usermode(entry_point, param) to begin executing the image file in user mode.

Like files, threads are waitable objects that can be signalled. You can block for a thread's completion, and then when the thread completes, it signals
the waiting threads and gives them the thread exit/return code.



User Mode Memory Map
---------- 0x80000000
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
- Pong/Snake
- Hex editor
- Machine monitor

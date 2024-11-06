# Bug fixes
The kernel heap seems buggy...

# Multithreading
- Add thread-local-storage (Win32-like mechanism; FS register points to a TEB)
- Improve the time-slice scheduler
- Thread cleanup function
- Multiple address spaces

# Blocking
There needs to be some kind of list of "sleeping" processes. I.e. when a process needs to block, it is taken off of the main task list and put onto the sleep list. The main synchronization objects that one can wait on will be
- Mutex
- Critical Section
- File

Waitable event objects are implemented quite simply. When you call a function to wait on an unsignalled event (i.e. trying to acquire a lock, for instance), the thread is taken off of the active thread list and placed onto the linked sleep queue for that event object. Once the event is signalled, the next thread on the queue is "popped" off and woken up.

Like files, threads/processes are waitable objects that can be signalled. You can block for a thread's completion, and then when the thread completes, it signals the waiting threads and gives them the thread exit/return code.

# Slab Allocator
Allocating frequently-used objects such as Task Control Blocks from the kernel heap is inefficient and promotes memory fragmentation. To avoid this, a slab cache can be created to reserve a pool of fixed-size objects. Similar to the page frame manager, objects in the slab cache are tracked via a bitmap, one bit per position. When an object is allocated, the bit is set. When an object is freed, it's released back into the pool and the bit is cleared.

# I/O Subsystem & Virtual Filesystem
Mount the initrd (we can load executables from there!)

# Kernel Debugger
Some kind of kernel debugger will need to be written. It doesn't need to be too elaborate, just to let me poke around memory, and it needs to understand the OS's data structures. Ideally, I can treat the OS as one giant program and suspend it, or I can attach to and debug individual threads. The [minidbg](https://gitlab.com/bztsrc/minidbg) library may be of some assistance here. Any assertions should automatically break out into the debugger, which should probably be hosted over the COM port.

# Creating a Process
1. Create a new thread with a new virtual address space (obviously, mapping the kernel in)
2. Set its EIP to `start_thread_load_image_thunk` (a procedure entry point in the kernel) with its argument set to the path (or something) of the image file to be loaded 
3. The new thread begins executing in kernel mode from `start_thread_load_image_thunk` to map the executable into its memory space
4. It will call ``jump_usermode(image_entry_point, 0)`` to begin executing the image file in Ring 3

# Miscellaneous
tbd

# Application Programs
- Pong
- Snake
- Hex editor
- Machine language monitor
- User-mode i386 emulator (for debugging purposes)

# Memory Map (User Mode)
```
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
```
Applications dynamically allocate memory by requesting it from the system via the `void* sbrk(int)` system call, which raises the program break, extending the heap, and returning the new program break. If new pages are required to ensure that the entire heap is accessible, new pages will be committed and mapped into the address space. The stack expands downwards as the heap goes upwards. The kernel also has its own program break and heap.
The logic is that a "heap" exists between the end of the data segment and the program break. In other words, there's a "heap start" and a "heap end", and more pages can be mapped to extend the heap end, which is increased by `sbrk`.
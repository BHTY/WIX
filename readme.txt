Todo List
1. Beef up the Virtual Memory Manager
2. Rewrite the heap manager
3. Rewrite the scheduler (with TLS, spinlocks, sleeping)
5. Write the IOS/VFS
6. Processes (executable loader & system calls)

User-mode executables will be built as Win32 Microsoft-format PE/COFF images. To build them using the Microsoft C/C++ Compiler and Linker, specify /NODEFAULTLIB on the command line to avoid linking in any of the default Microsoft libraries. Instead, link with WIX.LIB, the import library for WIX.DLL which in turn provides the system call interface to the kernel.
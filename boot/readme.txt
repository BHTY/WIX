STAGE 1 (boot sector)
Mounts the boot disk's filesystem using int13 and loads the following files from disk
- STAGE2.BIN (0x7E00)
- KERNEL.BIN (0x1000)
- CORE.TAR (0x8000)
Jumps to 0x7E00.

STAGE 2
---16-bit Real Mode---
The processor sets up a flat GDT and switches into 32-bit protected mode.

---32-bit Protected Mode---
Sets up page tables (identity-mapping the lower 1MB and mapping in the kernel), and then jumps to the kernel's entry point.

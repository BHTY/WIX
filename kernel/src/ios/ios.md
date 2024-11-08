**Note**: Everything in this document is extremely preliminary and subject to change. The design of this filesystem is VERY limited and makes no provisions for VFS, caching, symlinks, arbitrary mountpoints, or any of the nice things that exist in properly-designed operating systems. This is designed to be just enough to get the ball rolling with a semi-UNIX-like interface for managing files.

## What is a file?
Before worrying about how we manage files, it's important to define what a file is. For the purposes of this document, the generic term "file" refers to any object referred to by a file descriptor, that supports the standard file API calls. The primary types we're concerned with here are
- Disk files (i.e. blocks of data indexed by name on some formatted volume)
- Pipes
- Devices (both character-oriented devices such as TTYs and block-oriented devices such as disks)
There is also a distinction between files that are stream-oriented (i.e. where you read/write byte-by-byte) versus seekable (e.g. on disk)

## Overview
User-mode processes perform operations on files by passing a **file descriptor**, which is an integer that is an index into a per-process data structure maintained by the kernel: the **File Descriptor Table** (FDT). The FDT is merely a layer of indirection containing indices into a global kernel data structure: the **Open File Table** (OFT). It is the entries in the OFT which contain the core information about how file-related calls are routed, including
- A reference count (equal to the number of file descriptors pointing to this file)
- The access mode for the file
- The current file offset
- The type of file
- A pointer to either an inode object (for disk & device files) or a pipe object

A pipe structure contains the following elements: a buffer, the index of the last byte read, and the index of the last byte written. If the file is a pipe, then TBD

An inode data structure contains the following information:
- Inode type (disk file vs device file)
- Reference count (how many OFT entries are referring to this inode)
- Major and minor device numbers (for device files)
- File size, block device number and block mapping function (for disk files)

If the file is an inode, then check if it's referencing a disk file or a device file. If it's referencing a device file, obtain the relevant function for the relevant major device number and call it, passing in any parameters, plus the minor device number. 

If it's referencing a disk file, first check if the current file offset plus the number of bytes to be read exceed the file size. If so, decrease the number of bytes accordingly to make it fit. Then, begin loading in blocks from the disk, calling the block mapping function (contained within the filesystem driver) to map the given inode and offset to a block number.

Some possible errors include if any device numbers are invalid, or if the file offset is greater than the file size.

Some file calls cannot be executed immediately. In that case, they will either block, or if the file is opened in non-blocking mode, return immediately with an error code indicating that the call *would* have blocked.

## Sequence of Events


## Core System Calls
- open
- close
- read
- write
- seek
- tell
- dup
- ioctl
A few system calls to deal with polling whether a device has data available may also be in order.

Stuff for dealing with iterating over files in a directory, changing the current directory, etc.

## Current Implementation Plans
The bootloader loads a TAR file from the boot disk, which is the initial ramdisk. During kernel initialization, it will:
1. Register the ramdisk block device (passing it the memory address where the initrd was loaded and the number of sectors), which returns an integer representing the block device number
2. Initialize the USTAR filesystem driver, passing it the block device number and the number of blocks

The whole I/O system won't exist yet, instead one will interact with files via inodes directly.

Lots of locks for multithreading
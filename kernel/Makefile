BUILDDIR		:= build
SRCDIR := src

CC					:= $(CCBASE)-gcc
ASM					:= nasm
LD					:= $(CCBASE)-ld

all:
	$(CC) $(CFLAGS) $(SRCDIR)/init.c -o $(BUILDDIR)/init.o
	$(LD) -o $(BUILDDIR)/kernel.bin -Ttext 0x80000000 $(BUILDDIR)/init.o --oformat binary
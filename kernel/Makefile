BUILDDIR		:= build
SRCDIR := src
OUTPUT := kernel.bin
ADDRESS := 0x10000

CC					:= $(CCBASE)-gcc
ASM					:= nasm
LD					:= $(CCBASE)-ld
CFILES			:= $(shell find $(SRCDIR) -type f -name "*.c")
SFILES			:= $(shell find $(SRCDIR) -type f -name "*.s")

OBJFILES		:= $(patsubst $(SRCDIR)/%.c,$(BUILDDIR)/%.o,$(CFILES)) $(patsubst $(SRCDIR)/%.s,$(BUILDDIR)/%.o,$(SFILES))


$(BUILDDIR)/%.o: $(SRCDIR)/%.c
		$(CC) $(CFLAGS) $< -o $@
		echo hi
$(BUILDDIR)/%.o: $(SRCDIR)/%.s
		$(ASM) $< -f elf -o $@

all:  $(OBJFILES)
	$(LD) -o $(BUILDDIR)/$(OUTPUT) -Ttext $(ADDRESS) $(BUILDDIR)/init/startup.o `find $(BUILDDIR) -type f -name *.o ! -name 'startup.o'` --oformat binary
all:
	$(eval CCBASE ?= i386-elf)
	$(eval ASM ?= nasm)
	$(eval CFLAGS ?= -ffreestanding -m32 -g -c)
	$(eval ASMFLAGS ?= -f elf)
	cd boot; make
	cd kernel; make CCBASE="$(CCBASE)" CFLAGS="$(CFLAGS)" ASMFLAGS="$(ASMFLAGS)" ASM="$(ASM)"
	cd disk; make

clean:
		rm -f -- $(shell find boot disk kernel -type f -name "*.o" -or -name "*.a" -or -name "*.bin")
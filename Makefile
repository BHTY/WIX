all:
	$(eval CCBASE ?= i386-elf)
	$(eval CFLAGS ?= -ffreestanding -m32 -g -c)
	cd boot; make
	cd kernel; make CCBASE="$(CCBASE)" CFLAGS="$(CFLAGS)"
	cd disk; make

clean:
		rm -f -- $(shell find boot disk -type f -name "*.o" -or -name "*.a" -or -name "*.bin")
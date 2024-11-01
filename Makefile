all:
	cd boot; make
	cd disk; make

clean:
		rm -f -- $(shell find boot disk -type f -name "*.o" -or -name "*.a" -or -name "*.bin")
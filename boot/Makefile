BUILDDIR		:= build
 
all:
		nasm -f bin -o build/stage1.bin src/stage1.s
		nasm -f bin -o build/stage2.bin src/stage2.s

clean:
		rm $(BUILDDIR)/*.bin
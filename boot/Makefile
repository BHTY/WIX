BUILDDIR		:= build
 
all:
		nasm -f bin -o build/stage1.bin src/stage1.s -l build/stage1.lst
		nasm -f bin -o build/stage2.bin src/stage2.s -l build/stage2.lst

clean:
		rm $(BUILDDIR)/*.bin
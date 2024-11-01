BUILDDIR		:= build
 
all:
		cp ../boot/build/stage2.bin fs/
		tar -C fs -cvf build/fs.tar stage2.bin
		cat ../boot/build/stage1.bin build/fs.tar > build/disk.bin

clean:
		rm $(BUILDDIR)/*.bin $(BUILDDIR)/*.tar
BUILDDIR		:= build
 
all:
		cp ../boot/build/stage2.bin fs/
		cp ../kernel/build/kernel.bin fs/
		tar -C initrd -cvf fs/initrd hello.txt test.txt
		tar -C fs -cvf build/fs.tar stage2.bin kernel.bin initrd
		cat ../boot/build/stage1.bin build/fs.tar > build/disk.bin

clean:
		rm $(BUILDDIR)/*.bin $(BUILDDIR)/*.tar
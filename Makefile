main.bin:
	./o++ b -p build.txt

clean:
	rm build/boot/bootStage1.bin

run:
	./o++ l -i build/boot/bootStage1.bin

kill:
	killall qemu-system-x86_64

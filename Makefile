all:
	wcc -S parallel_task.c
	wasm parallel_task.s

	wcc -S serial_task.c
	wasm serial_task.s

	wasm kernel_q3.s
	wlink -o kernel_q3.srec kernel_q3.o serial_task.o

	wasm kernel_q4.s
	wlink -o kernel_q4.srec kernel_q4.o serial_task.o

	wasm kernel_q5.s
	wlink -o kernel_q5.srec kernel_q5.o serial_task.o parallel_task.o

	wasm kernel_q6.s
	wlink -o kernel_q6.srec kernel_q6.o serial_task.o parallel_task.o mtk/gameSelect.o mtk/breakout.o mtk/rocks.o

	wasm kernel_q7.s
	wlink -o kernel_q7.srec kernel_q7.o serial_task.o parallel_task.o mtk/gameSelect.o mtk/breakout.o mtk/rocks.o

	cp kernel_q3.srec /home/alin2299/Downloads
	cp kernel_q4.srec /home/alin2299/Downloads
	cp kernel_q5.srec /home/alin2299/Downloads
	cp kernel_q6.srec /home/alin2299/Downloads
	cp kernel_q7.srec /home/alin2299/Downloads

clean:
	rm parallel_task.s parallel_task.o
	rm serial_task.s serial_task.o
	rm kernel_q3.o kernel_q3.srec
	rm kernel_q4.o kernel_q4.srec
	rm kernel_q5.o kernel_q5.srec
	rm kernel_q6.o kernel_q6.srec
	rm kernel_q7.o kernel_q7.srec

	rm /home/alin2299/Downloads/kernel_q3.srec
	rm /home/alin2299/Downloads/kernel_q4.srec
	rm /home/alin2299/Downloads/kernel_q5.srec
	rm /home/alin2299/Downloads/kernel_q6.srec
	rm /home/alin2299/Downloads/kernel_q7.srec
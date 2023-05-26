all:
	wcc -S parallel_task.c
	wasm parallel_task.s
	wlink -o parallel_task.srec parallel_task.o
	
clean:
	rm parallel_task.s parallel_task.o parallel_task.srec
	
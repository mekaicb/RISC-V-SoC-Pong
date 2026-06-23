riscv64-unknown-elf-gcc -march=rv32i -mabi=ilp32 -nostdlib -c pong.c -o pong.o
riscv64-unknown-elf-ld -m elf32lriscv -T linker2.ld pong.o -o pong.elf
riscv64-unknown-elf-objcopy -O verilog pong.elf pong.hex
python3 makehex.py
cp pong.hex ../CPU/synthesis


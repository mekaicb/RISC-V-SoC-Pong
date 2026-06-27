riscv64-unknown-elf-gcc -march=rv32i -mabi=ilp32 -nostdlib -c pong.c -o pong.o
riscv64-unknown-elf-ld -m elf32lriscv -T link.ld pong.o /usr/lib/gcc/riscv64-unknown-elf/13.2.0/rv32i/ilp32/libgcc.a -o pong.elf
riscv64-unknown-elf-objcopy -O verilog pong.elf pong.hex
python3 makehex.py
cp pong.hex ../CPU/synthesis


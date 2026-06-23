ENTRY(_start)

MEMORY {
    ROM (rx)  : ORIGIN = 0x00000000, LENGTH = 5K
    RAM (rwx) : ORIGIN = 0x00024400, LENGTH = 15K
}

SECTIONS {
    .text : {
        KEEP(*(.text.init))   /* _start lands at 0x0 */
        *(.text*)
    } > ROM

    .rodata : { *(.rodata*) } > ROM

    .data : {
        __data_start = .;
        *(.data*)
        __data_end = .;
    } > RAM AT> ROM
    __data_load = LOADADDR(.data);

    .bss : {
        __bss_start = .;
        *(.bss*) *(COMMON)
        __bss_end = .;
    } > RAM

    __stack_top = ORIGIN(RAM) + LENGTH(RAM);
}

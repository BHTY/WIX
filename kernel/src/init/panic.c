#include <assert.h>
#include <stdio.h>
#include <string.h>
#include <tty/tty.h>
#include <init/idt.h>

void panic(const char* format, ...){
    char str[1024];
    va_list args;
    int size;

    va_start(args, format);
    size = vsprintf(str, format, args);
    va_end(args);

    disable_interrupts();
    tty_write(str, strlen(str));
    while(1);
}

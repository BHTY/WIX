#include <assert.h>
#include <stdio.h>
#include <string.h>
#include <tty/tty.h>
#include <init/idt.h>

extern void (*dbg_printf)(const char*, ...);

void libk_assert(int condition, const char* cond_str, const char* filename, int line){
    char buf[128];

    if(!condition){
        disable_interrupts();
        sprintf(buf, "\n\x1B[41m\x1B[HAssertion failed: %s, file %s, line %d\n", cond_str, filename, line);
        tty_write(buf, strlen(buf));
        dbg_printf(buf);
        while(1);
    }
}
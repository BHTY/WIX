/* 
    Copyright (C) 2024 WIX Kernel
    Authored by Will Klees
    bootvid.c - Basic VGA terminal
*/

#include <stdint.h>
#include <string.h>
#include <tty/bootvid.h>
#include <init/io.h>

uint8_t *text_buffer;
uint8_t text_attr = 0x00;
uint16_t bootvid_cursor;

void scroll(){
    for(int i = 0; i < COLS - 1; i++){
        memcpy(text_buffer + ROWS*i*2, text_buffer + ROWS*(i+1)*2, ROWS * 2);    
    }

    //kmemset(TEXT_BUFFER + (LINES-1)*CHARS_PER_LINE*2, 0, CHARS_PER_LINE * 2);
}

void sync_cursor(){
    io_write_8(0x3D4, 14);
    io_write_8(0x3D5, bootvid_cursor >> 8);
    io_write_8(0x3D4, 15);
    io_write_8(0x3D5, bootvid_cursor);
}

void bootvid_init(){
    text_buffer = (uint8_t*)0xB8000;
    bootvid_fg(0x0F);
    bootvid_bg(0x00);
    bootvid_fill(0, ROWS*COLS);
    bootvid_gotoxy(0, 0);
}

void bootvid_putc(char ch){
    if (ch == 0x0A){
        bootvid_cursor = ROWS + (bootvid_cursor - (bootvid_cursor % ROWS));
    } else {
        *(text_buffer + bootvid_cursor * 2) = ch;
        *(text_buffer + bootvid_cursor * 2 + 1) = text_attr;
        bootvid_cursor++;
    }

    if (bootvid_cursor >= ROWS * COLS){
        scroll();
        bootvid_cursor -= ROWS;
    }

    sync_cursor();
}

void bootvid_fg(char fg){
    text_attr = (text_attr & 0xF0) | (fg & 0xF);
}

void bootvid_bg(char bg){
    text_attr = (text_attr & 0xF) | ((bg & 0xF) << 4);
}

uint16_t bootvid_getx(){
    return bootvid_cursor % ROWS;
}

uint16_t bootvid_gety(){
    return bootvid_cursor / ROWS;
}

int bootvid_gotoxy(uint16_t x, uint16_t y){
    if(x < ROWS && y < COLS){
        bootvid_cursor = ROWS * y + x;
        sync_cursor();
        return 1;
    }

    return 0;
}

void bootvid_fill(uint16_t start, uint16_t end){
    uint16_t value = text_attr << 8;
    int i;
    uint16_t* buf = text_buffer;

    for(i = start; i < end; i++){
        buf[i] = value;
    }
}

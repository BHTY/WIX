#pragma once

#include <stdint.h>

#define ROWS 80
#define COLS 25

void bootvid_init();
void bootvid_putc(char ch);
void bootvid_fg(char fg);
void bootvid_bg(char bg);
uint16_t bootvid_getx();
uint16_t bootvid_gety();
int bootvid_gotoxy(uint16_t x, uint16_t y);
void bootvid_fill(uint16_t start, uint16_t end);

extern uint16_t bootvid_cursor;

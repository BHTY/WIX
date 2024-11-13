#pragma once

#include <stddef.h>

#define COM1 0x3F8

int com_write(int minor, const char* buf, size_t count);
int com_read(int minor, char* buf, size_t count);
int com_ioctl(int minor, int op, void* data);

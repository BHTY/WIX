#pragma once

#include <stdint.h>

uint8_t io_read_8(uint32_t port);
void io_write_8(uint32_t port, uint8_t data);
uint16_t io_read_16(uint32_t port);
void io_write_16(uint32_t port, uint16_t data);
uint32_t io_read_32(uint32_t port);
void io_write_32(uint32_t port, uint32_t data);
void io_wait();

#include <init/io.h>
#include <basedrv/serial.h>

int is_transmit_empty(int minor){
    return io_read_8(minor + 5) & 0x20;
}

int is_received_ready(int minor){
    return io_read_8(minor + 5) & 0x1;
}

void write_serial(int minor, char c){
    while (is_transmit_empty(minor) == 0);
    io_write_8(minor, c);
}

char read_serial(int minor){
    while (is_received_ready(minor) == 0);
    return io_read_8(minor);
}

int com_write(int minor, const char* buf, size_t count){
    int bytes = 0;
    
    while(count--){
        write_serial(minor, buf[bytes++]);
    }

    return bytes;
}

int com_read(int minor, char* buf, size_t count){
    int bytes = 0;

    while(count--){
        *(buf++) = read_serial(minor);
        bytes++;
    }

    return bytes;
}

int com_ioctl(int minor, int op, void* data){
    // set frequency, block vs nonblock mode

    io_write_8(minor + 1, 0x00); // disable interrupts
    io_write_8(minor + 3, 0x80); // enable DLAB (set baud rate divisor)
    io_write_8(minor + 0, 0x03); // set divisor to 3 (lo byte) 38400 baud
    io_write_8(minor + 1, 0x00); //                  (hi byte)
    io_write_8(minor + 3, 0x03); // 8N1
    io_write_8(minor + 2, 0xC7); // Enable FIFo, clear, 14 byte threshold
    io_write_8(minor + 4, 0x0B); // IRQs enabled, RTS/DSR set
    io_write_8(minor + 4, 0x1E); // Set in loopback mode for testing

    io_write_8(minor + 4, 0x0F); // Set in normal operation mode (IRQs enabled)
}

/* 
    Copyright (C) 2024 WIX Kernel
    Authored by Will Klees
    pic.c - Kernel support for Intel 8259 PIC
*/

#include <init/pic.h>
#include <init/io.h>
#include <init/idt.h>

/* Sends the EOI signal for an IRQ to the PIC */
void pic_send_eoi(uint8_t irq){
    if(irq >= 8)
		io_write_8(PIC2_COMMAND, PIC_EOI);
	
	io_write_8(PIC1_COMMAND, PIC_EOI);
}

/* Remaps the interrupt vector offsets for the master PIC to offset1 and the slave PIC to offset2 */
void pic_remap(uint8_t offset1, uint8_t offset2)
{
	uint8_t a1, a2;
	
	a1 = io_read_8(PIC1_DATA);                        // save masks
	a2 = io_read_8(PIC2_DATA);
	
	io_write_8(PIC1_COMMAND, ICW1_INIT | ICW1_ICW4);  // starts the initialization sequence (in cascade mode)
	io_wait();
	io_write_8(PIC2_COMMAND, ICW1_INIT | ICW1_ICW4);
	io_wait();
	io_write_8(PIC1_DATA, offset1);                 // ICW2: Master PIC vector offset
	io_wait();
	io_write_8(PIC2_DATA, offset2);                 // ICW2: Slave PIC vector offset
	io_wait();
	io_write_8(PIC1_DATA, 4);                       // ICW3: tell Master PIC that there is a slave PIC at IRQ2 (0000 0100)
	io_wait();
	io_write_8(PIC2_DATA, 2);                       // ICW3: tell Slave PIC its cascade identity (0000 0010)
	io_wait();
	
	io_write_8(PIC1_DATA, ICW4_8086);               // ICW4: have the PICs use 8086 mode (and not 8080 mode)
	io_wait();
	io_write_8(PIC2_DATA, ICW4_8086);
	io_wait();
	
	io_write_8(PIC1_DATA, a1);   // restore saved masks.
	io_write_8(PIC2_DATA, a2);
}

void pic_mask_irq(uint8_t irq) {
    uint16_t port;
    uint8_t value;

    if(irq < 8) {
        port = PIC1_DATA;
    } else {
        port = PIC2_DATA;
        irq -= 8;
    }
    value = io_read_8(port) | (1 << irq);
    io_write_8(port, value);        
}

void pic_unmask_irq(uint8_t irq) {
    uint16_t port;
    uint8_t value;

    if(irq < 8) {
        port = PIC1_DATA;
    } else {
        port = PIC2_DATA;
        irq -= 8;
    }
    value = io_read_8(port) & ~(1 << irq);
    io_write_8(port, value);        
}

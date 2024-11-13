#include <syscall/syscall.h>
#include <init/init.h>

int sys_print(char* str){
    printk(str);
    return 0;
}

system_service_vector_t syscall_table[128] = {
    {0, 0},                                         // System Call Vector 0x00: NULL
    {sys_print, 1},                                 // System Call Vector 0x01: sys_print
};

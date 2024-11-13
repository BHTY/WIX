#pragma once

#include <init/idt.h>

typedef struct system_service_vector{
    int (*dispatch)();
    int n_args;
} system_service_vector_t;

extern system_service_vector_t syscall_table[128];

int syscall_trap(int_state_t* state);

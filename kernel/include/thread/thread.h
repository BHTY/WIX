#pragma once

#include <mm/vmm.h>
#include <stdint.h>
#include <stddef.h>
#include <init/idt.h>

typedef uint32_t tid_t;
typedef uint32_t (*thread_func_t)(void*);

typedef struct task{
    uint32_t esp;
    struct task* next;
    struct task* prev;
    uint32_t esp0;
    pgdir_t* cr3;
} task_t;

extern task_t* cur_task;
extern uint32_t interrupt_tick;

void task_switch(int_state_t* state);
void init_tasking();
task_t* spawn_thread(thread_func_t fn, void* param, int user_esp);
void jump_usermode(void* fn, void* param);

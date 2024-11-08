#pragma once

#include <stdint.h>

typedef struct i386_instruction{ // debug info
    char* name;
    int flags;
    int dest;
    int src1;
    int src2;
    int dbg_info;
} i386_instruction_t;

typedef struct disasm_state{
    int size;

    int reg_or_mem;
    uint8_t modrm;
    uint8_t mod, reg, rm;
    char rm_str[80];
} disasm_state_t;

uint32_t disasm_opcode(char* str, uint8_t* data, uint32_t eip, int op_sz, int addr_sz, int sgmt_override, int which_segment, int which_table);

extern i386_instruction_t opcode_table_1[256];
extern i386_instruction_t opcode_table_2[256];
extern i386_instruction_t opcode_table_group80[];
extern i386_instruction_t opcode_table_group81[];
extern i386_instruction_t opcode_table_group83[];
extern i386_instruction_t opcode_table_groupC0[];
extern i386_instruction_t opcode_table_groupC1[];
extern i386_instruction_t opcode_table_groupD0[];
extern i386_instruction_t opcode_table_groupD1[];
extern i386_instruction_t opcode_table_groupD2[];
extern i386_instruction_t opcode_table_groupD3[];
extern i386_instruction_t opcode_table_groupF6[];
extern i386_instruction_t opcode_table_groupF7[];
extern i386_instruction_t opcode_table_groupFE[];
extern i386_instruction_t opcode_table_groupFF[];
extern i386_instruction_t opcode_table_group0F00[];
extern i386_instruction_t opcode_table_group0F01[];
extern i386_instruction_t* opcode_tables[];

/* Instruction flags */
#define MODRM 1
#define TWO_BYTE 2
#define SEG_ES 3
#define SEG_CS 4
#define SEG_SS 5
#define SEG_DS 6
#define SEG_FS 7
#define SEG_GS 8
#define OP_SIZE 9
#define ADDR_SIZE 10
#define VAR_NAME 11
#define PREFIX 12
#define GROUP80 13
#define GROUP81 14
#define GROUP83 15
#define GROUPC0 16 
#define GROUPC1 17
#define GROUPD0 18 
#define GROUPD1 19
#define GROUPD2 20 
#define GROUPD3 21
#define GROUPF6 22 
#define GROUPF7 23
#define GROUPFE 24 
#define GROUPFF 25
#define GROUP0F00 26 
#define GROUP0F01 27

/* Parameter Types */
#define PARAM_RM8 1
#define PARAM_REG8 2
#define PARAM_RM 3
#define PARAM_REG 4

#define PARAM_AL 5
#define PARAM_CL 6
#define PARAM_DL 7
#define PARAM_BL 8
#define PARAM_AH 9
#define PARAM_CH 10
#define PARAM_DH 11
#define PARAM_BH 12

#define PARAM_EAX 13
#define PARAM_ECX 14
#define PARAM_EDX 15
#define PARAM_EBX 16
#define PARAM_ESP 17
#define PARAM_EBP 18
#define PARAM_ESI 19
#define PARAM_EDI 20

#define PARAM_UI8 21
#define PARAM_I8 22
#define PARAM_IMM 23

#define PARAM_REG16 24
#define PARAM_SEGOVER 25
#define PARAM_REL8 26
#define PARAM_REL 27
#define PARAM_ADDR 28
#define PARAM_DX 29
#define PARAM_RM16 30
#define PARAM_SREG 31
#define PARAM_UI16 32
#define PARAM_OFFSET 33
#define PARAM_1 34
#define PARAM_RM32 35
#define PARAM_CREG 36
#define PARAM_DREG 37

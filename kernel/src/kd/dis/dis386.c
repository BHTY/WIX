#include <kd/dis/dis386.h>
#include <kd/dis/names.h>
#include <kd/common.h>
#include <stdio.h>
#include <string.h>
#include <assert.h>

void pdisp8(char* dest_str, int8_t num){
    if (num >= 0){
        sprintf(dest_str, "+0x%02X", num);
    } else{
        sprintf(dest_str, "-0x%02X", -num);
    }
}

void pdisp16(char* dest_str, int16_t num){
    if (num >= 0){
        sprintf(dest_str, "+0x%04X", num);
    } else{
        sprintf(dest_str, "-0x%04X", -num);
    }
}

void pdisp32(char* dest_str, int32_t num){
    if (num >= 0){
        sprintf(dest_str, "+0x%08X", num);
    } else{
        sprintf(dest_str, "-0x%08X", -num);
    }
}

uint32_t decode_rm_16(uint8_t* data, int op_sz, disasm_state_t* state){
    int sz = 0;
    char disp_str[16];
    uint16_t disp;

    state->rm_str[0] = 0;

    switch(state->mod){
        case 0:
            state->reg_or_mem = 1;
            break;
        case 1: // + disp8
            disp = *data;
            pdisp8(disp_str, disp);
            sz++;
            state->reg_or_mem = 1;
            break;
        case 2: // + disp16
            disp = *(uint16_t*)(data);
            pdisp16(disp_str, disp);
            sz += 2;
            state->reg_or_mem = 1;
            break;
        case 3: // Register
            state->reg_or_mem = 0;
            return sz;
    }

    switch(state->rm){
        case 6:
            if (state->mod == 0){
                sprintf(state->rm_str, "0x%04X", *(uint16_t*)(data));
                sz+=2;
                break;
            }
        default:
            strcat(state->rm_str, rm16_strs[state->rm]);
            if(state->mod == 1 || state->mod == 2) strcat(state->rm_str, disp_str);
            break;
    }

    return sz;
}

uint32_t decode_sib(uint8_t* data, disasm_state_t* state){
    char index[16];
    uint32_t sz = 1;
    uint8_t sib = *(data++);

    if (BASE(sib) == 5 && state->mod == 0){
        sprintf(index, "0x%08X", *(uint32_t*)data);
        strcat(state->rm_str, index);
        sz += 4;
    } else{
        strcat(state->rm_str, regs_32[BASE(sib)]);
    }

    if (INDEX(sib) != 4){
        if (SCALE(sib) == 0){
            sprintf(index, "+%s", regs_32[INDEX(sib)]);
        } else{
            sprintf(index, "+%s*%d", regs_32[INDEX(sib)], 1 << SCALE(sib));
        }
        strcat(state->rm_str, index);
    }

    return sz;
}

uint32_t decode_rm_32(uint8_t* data, int op_sz, disasm_state_t* state){
    char disp_str[16];
    uint32_t sz = 0;
    state->rm_str[0] = 0;

    if(state->mod == 3){
        state->reg_or_mem = 0;
        return sz;
    }

    state->reg_or_mem = 1;

    switch(state->rm){
        case 4:{
            uint32_t sib_size = decode_sib(data, state);
            data += sib_size;
            sz += sib_size;
            break;
        }
        case 5:
            if(state->mod == 0){ // disp32
                sprintf(state->rm_str, "0x%08X", *(uint32_t*)(data));
                sz += 4;
                break;
            }
        default:
            strcat(state->rm_str, regs_32[state->rm]);
            break;
    }

    if (state->mod == 1){
        pdisp8(disp_str, *(data));
        sz += 1;
        strcat(state->rm_str, disp_str);
    } else if (state->mod == 2){
        pdisp32(disp_str, *(uint32_t*)(data));
        sz += 4;
        strcat(state->rm_str, disp_str);
    }

    return sz;
}

void add_mem_prefix(char* str, int size, int sgmt_override, int which_segment){
    char* size_prefixes[] = {"BYTE", "WORD", "DWORD", 0};

    if(size_prefixes[size]){
        sprintf(str, "%s %s ", str, size_prefixes[size]);
    }else{
        strcat(str, " ");
    }

    if(sgmt_override){
        sprintf(str, "%s%s:", str, seg_regs[which_segment]);
    }

    strcat(str, "[");
}

void add_rm(char* str, int size, int sgmt_override, int which_segment, disasm_state_t* state){
    const char** reg_names[] = {regs_8, regs_16, regs_32};

    if(!state->reg_or_mem){ // register only
        sprintf(str, "%s %s", str, reg_names[size][state->rm]);
    } else { // memory
        add_mem_prefix(str, size, sgmt_override, which_segment);
        sprintf(str, "%s%s]", str, state->rm_str);
    }
}

uint32_t add_param(int type, char* str, uint8_t* data, int op_sz, int addr_sz, int sgmt_override, int which_segment, uint32_t eip, disasm_state_t* state){
    int sz = 0;
    char buf[80];
    
    switch(type){
        case PARAM_OFFSET:
            add_mem_prefix(str, 3, sgmt_override, which_segment);
            if(addr_sz == 1){
                uint32_t offset = *(uint32_t*)data;
                sz+=4;
                sprintf(str, "%s0x%08X", str, offset);
            } else{
                uint16_t offset = *(uint16_t*)data;
                sz+=2;
                sprintf(str, "%s0x%04X", str, offset);
            }
            strcat(str, "]");
            break;
        case PARAM_RM8:
            add_rm(str, 0, sgmt_override, which_segment, state);
            break;
        case PARAM_REG8:
            sprintf(str, "%s %s", str, regs_8[state->reg]);
            break;
        case PARAM_RM:
            add_rm(str, op_sz + 1, sgmt_override, which_segment, state);
            break;
        case PARAM_REG:
            sprintf(str, "%s %s", str, op_sz ? regs_32[state->reg] : regs_16[state->reg]);
            break;
        case PARAM_SREG:
            sprintf(str, "%s %s", str, seg_regs[state->reg]);
            break;
        case PARAM_CREG:
            sprintf(str, "%s CR%d", str, state->reg);
            break;
        case PARAM_DREG:
            sprintf(str, "%s DR%d", str, state->reg);
            break;
        case PARAM_REG16:
            sprintf(str, "%s %s", str, regs_16[state->reg]);
            break;
        case PARAM_RM16:
            add_rm(str, 1, sgmt_override, which_segment, state);
            break;
        case PARAM_RM32:
            add_rm(str, 2, sgmt_override, which_segment, state);
            break;
        case PARAM_AL:
        case PARAM_CL:
        case PARAM_DL:
        case PARAM_BL:
        case PARAM_AH:
        case PARAM_CH:
        case PARAM_DH:
        case PARAM_BH:
            sprintf(str, "%s %s", str, regs_8[type - PARAM_AL]);
            break;
        case PARAM_EAX:
        case PARAM_ECX:
        case PARAM_EDX:
        case PARAM_EBX:
        case PARAM_ESP:
        case PARAM_EBP:
        case PARAM_ESI:
        case PARAM_EDI:
            sprintf(str, "%s %s", str, op_sz ? regs_32[type - PARAM_EAX] : regs_16[type - PARAM_EAX]);
            break;
        case PARAM_DX:
            strcat(str, " DX");
            break;
        case PARAM_SEGOVER:
            if(sgmt_override) sprintf(str, "%s %s", str, seg_regs[which_segment]);
            break;
        case PARAM_I8:
            pdisp8(buf, *data);
            sprintf(str, "%s %s", str, buf);
            sz++;
            break;
        case PARAM_UI8:
            sprintf(str, "%s 0x%02X", str, *data);
            sz++;
            break;
        case PARAM_UI16:
            sprintf(str, "%s 0x%04X", str, *(uint16_t*)data);
            sz+=2;
            break;
        case PARAM_IMM:
            if (op_sz == 1){
                sprintf(str, "%s 0x%08X", str, *(uint32_t*)data);
                sz += 4;
            } else{
                sprintf(str, "%s 0x%04X", str, *(uint16_t*)data);
                sz += 2;
            }
            break;
        case PARAM_1:
            strcat(str, " 1");
            break;
        case PARAM_ADDR:
            if(op_sz == 1){
                sprintf(str, "%s 0x%04X:0x%08X", str, *(uint16_t*)(data+4), *(uint32_t*)(data));
                sz += 6;
            } else {
                sprintf(str, "%s 0x%04X:0x%04X", str, *(uint16_t*)(data+2), *(uint16_t*)(data));
                sz += 4;
            }
            break;
        case PARAM_REL8:{
            int8_t offset = *data;
            uint32_t result;
            sz++;
            result = eip + state->size + sz + offset;

            if(op_sz == 1){
                sprintf(str, "%s 0x%08X", str, result);
            } else{
                sprintf(str, "%s 0x%04X", str, result);
            }
            break;
        }
        case PARAM_REL:
            if (op_sz == 1){
                int32_t offset = *(int32_t*)data;
                sz += 4;
                sprintf(str, "%s 0x%08X", str, eip + state->size + sz + offset);
            } else{
                int16_t offset = *(int16_t*)data;
                sz += 2;
                sprintf(str, "%s 0x%04X", str, eip + state->size + sz + offset);
            }
            break;
        default:
            //fprintf(stderr, "Invalid parameter type %d\n", type);
            assert(0);
            break;
    }

    state->size += sz;
    return sz;
}

uint32_t disasm_opcode(char* str, uint8_t* data, uint32_t eip, int op_sz, int addr_sz, int sgmt_override, int which_segment, int which_table){
    uint8_t opcode = *(data++);
    i386_instruction_t* inst = which_table ? &opcode_table_2[opcode] : &opcode_table_1[opcode];
    disasm_state_t state;
    int modrm_size;
    char* mnemonic = inst->name;

    state.size = 1;

    switch(inst->flags){
        case PREFIX:{
            uint32_t sz;
            str += sprintf(str, "%s ", mnemonic);
            sz = disasm_opcode(str, data, eip + 1, op_sz, addr_sz, sgmt_override, which_segment, which_table);
            return sz + 1;
        }
        case MODRM:
            state.modrm = *(data++); state.size++;
            state.mod = MOD(state.modrm);
            state.reg = REG(state.modrm);
            state.rm = RM(state.modrm);

            modrm_size = addr_sz ? decode_rm_32(data, op_sz, &state) : decode_rm_16(data, op_sz, &state);
            state.size += modrm_size;
            data += modrm_size;
            break;
        case SEG_ES:
        case SEG_CS:
        case SEG_SS:
        case SEG_DS:
        case SEG_FS:
        case SEG_GS:
            return disasm_opcode(str, data, eip + 1, op_sz, addr_sz, 1, inst->flags - SEG_ES, which_table) + 1;
        case OP_SIZE:
            return disasm_opcode(str, data, eip + 1, !op_sz, addr_sz, sgmt_override, which_segment, which_table) + 1;
        case ADDR_SIZE:
            return disasm_opcode(str, data, eip + 1, op_sz, !addr_sz, sgmt_override, which_segment, which_table) + 1;
        case VAR_NAME:
            if(op_sz) mnemonic += strlen(mnemonic) + 1;
            break;
        case TWO_BYTE:
            return disasm_opcode(str, data, eip + 1, op_sz, addr_sz, sgmt_override, which_segment, 1) + 1;
        case GROUP80:
        case GROUP81:
        case GROUP83:
        case GROUPC0:
        case GROUPC1:
        case GROUPD0:
        case GROUPD1:
        case GROUPD2:
        case GROUPD3:
        case GROUPF6:
        case GROUPF7:
        case GROUPFE:
        case GROUPFF:
        case GROUP0F00:
        case GROUP0F01:
            state.modrm = *(data++); state.size++;
            state.mod = MOD(state.modrm);
            state.reg = REG(state.modrm);
            state.rm = RM(state.modrm);

            modrm_size = addr_sz ? decode_rm_32(data, op_sz, &state) : decode_rm_16(data, op_sz, &state);
            state.size += modrm_size;
            data += modrm_size;

            inst = &opcode_tables[inst->flags - GROUP80][state.reg];
            mnemonic = inst->name;
            break;
        case 0:
            break;
        default:
            //fprintf(stderr, "Unknown flag %d\n", inst->flags);
            assert(0);
            break;
    }

    if(mnemonic == NULL){
        sprintf(str, "DB 0x%02X", opcode);
        return state.size;
    }

    // print instruction
    sprintf(str, "%s", mnemonic);

    if (inst->dest){
        data += add_param(inst->dest, str, data, op_sz, addr_sz, sgmt_override, which_segment, eip, &state);
    }

    if(inst->src1){
        sprintf(str, "%s,", str);
        data += add_param(inst->src1, str, data, op_sz, addr_sz, sgmt_override, which_segment, eip, &state);
    }

    if(inst->src2){
        sprintf(str, "%s,", str);
        data += add_param(inst->src2, str, data, op_sz, addr_sz, sgmt_override, which_segment, eip, &state);
    }

    return state.size;
}

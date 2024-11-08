#include <kd/dis/names.h>

const char* rm16_strs[] = {"BX+SI", "BX+DI", "BP+SI", "BP+DI", "SI", "DI", "BP", "BX"};

const char* regs_8[] = { "AL", "CL", "DL", "BL", "AH", "CH", "DH", "BH" };
const char* regs_16[] = { "AX", "CX", "DX", "BX", "SP", "BP", "SI", "DI" };
const char* regs_32[] = { "EAX", "ECX", "EDX", "EBX", "ESP", "EBP", "ESI", "EDI" };
const char* seg_regs[] = { "ES", "CS", "SS", "DS", "FS", "GS" };

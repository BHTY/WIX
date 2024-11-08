#pragma once
#include <stdint.h>

#define MOD(MODRM) (((MODRM) & 0xc0) >> 6)
#define REG(MODRM) (((MODRM) & 0x38) >> 3)
#define RM(MODRM) ((MODRM) & 0x7)

#define SCALE(SIB)	((SIB) >> 6)
#define INDEX(SIB)	(((SIB) & 0x38) >> 3)
#define BASE(SIB)	((SIB) & 0x7)

//Constant Segment Registers
#define ES 0
#define CS 1
#define SS 2
#define DS 3
#define FS 4
#define GS 5

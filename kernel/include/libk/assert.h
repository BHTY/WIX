#pragma once
#define assert(cond)    libk_assert(cond, #cond, __FILE__, __LINE__)

void libk_assert(int condition, const char* cond_str, const char* filename, int line);

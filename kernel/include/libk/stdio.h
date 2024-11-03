#pragma once

#include <stdarg.h>

int vsprintf(char *str, const char *format, va_list arg);           
int sprintf(char *str, const char *format, ...);                    

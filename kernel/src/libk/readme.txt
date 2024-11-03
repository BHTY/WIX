libk implements a minimal C runtime library for the kernel's use, implementing the following functions:

    string.h
int memcmp(const void *str1, const void *str2, size_t n);
void *memcpy(void *dest, const void *src, size_t n);
void *memmove(void *dest, const void *src, size_t n);
void *memset(void *str, int c, size_t n);
char *strcat(char *dest, const char *src);
char *strchr(const char *str, int c);
int strcmp(const char *str1, const char *str2);
char *strcpy(char *dest, const char *src);
size_t strlen(const char *str);

    stdlib.h
int atoi(const char *str);

    stdio.h
int vsprintf(char *str, const char *format, va_list arg);
int sprintf(char *str, const char *format, ...);

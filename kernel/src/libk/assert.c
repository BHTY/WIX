#include <assert.h>
#include <init/panic.h>

void libk_assert(int condition, const char* cond_str, const char* filename, int line){
    char buf[128];

    if(!condition){
        panic("\n\x1B[41m\x1B[HAssertion failed: %s, file %s, line %d\n", cond_str, filename, line);
    }
}

#include <cassert>

#if DEBUG
#   define LOG_DEBUG(format, ...) printf("DEBUG: " format "\n", ##__VA_ARGS__)
//#   define DEBUG_ASM_LINES() LOG_DEBUG("lines.size()=%d, addr:%0x16x\n",lines.size(), &asm_lines)
#   define DEBUG_ASM_LINES()
#   define ASSERT(condition) assert(condition)
#else
#   define LOG_DEBUG(format, ...)
#   define DEBUG_ASM_LINES()
#   define ASSERT(condition)
#endif
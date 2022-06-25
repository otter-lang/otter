#ifndef _TESTS__TEST_HPP
#define _TESTS__TEST_HPP

#include <otter/runtime/include.hpp>

/*
	namespace main
*/
extern void_t puts(const byte_t *str);
extern void_t *malloc(uword_t size);
extern void_t *realloc(void_t *memory, uword_t size);
extern void_t free(void_t *memory);
extern const int_t *const main_cp2ci();
extern int main_main();

#endif
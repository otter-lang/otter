#ifndef _TESTS__TEST_HPP
#define _TESTS__TEST_HPP

#include <otter/runtime/include.hpp>

/*
	namespace: global
*/
extern void_t puts(const byte_t *__str);
extern void_t *malloc(uword_t __size);
extern void_t *realloc(void_t *__memory, uword_t __size);
extern void_t free(void_t *__memory);
extern const void_t global_cp2ci();

/*
	namespace: math
*/
extern long_t math_addi(long_t __a, long_t __b);
extern double_t math_addf(double_t __a, double_t __b);

/*
	namespace: main
*/
extern int main_main();

#endif
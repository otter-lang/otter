#ifndef _TESTS__TEST_HPP
#define _TESTS__TEST_HPP

#include <otter/runtime/include.hpp>

/*
	namespace global
*/
extern void_t puts(const byte_t *str);
extern void_t *malloc(uword_t size);
extern void_t *realloc(void_t *memory, uword_t size);
extern void_t free(void_t *memory);
extern const int_t *const global_cp2ci();

/*
	namespace math
*/
extern long_t math_addi(long_t a, long_t b);
extern double_t math_addf(double_t a, double_t b);

/*
	namespace main
*/
extern int main_main();

#endif
#ifndef _TESTS__TEST_HPP
#define _TESTS__TEST_HPP

#include <otter/runtime/include.hpp>

/*
	namespace: global
*/

extern "C" int_t puts(const char_t *global_puts_str);
extern void_t global_writeln(const char_t *global_writeln_content);

/*
	namespace: main
*/

extern int main_main(void);

#endif
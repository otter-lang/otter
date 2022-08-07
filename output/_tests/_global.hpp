#ifndef _TESTS__GLOBAL_HPP
#define _TESTS__GLOBAL_HPP

#include <otter/runtime/include.hpp>

extern "C" int_t puts(const char_t *global_puts_content);
extern void_t global_writeln(const char_t *global_writeln_content);

#endif
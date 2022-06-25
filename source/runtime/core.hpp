#ifndef OTTER_RUNTIME_CORE_HPP
#define OTTER_RUNTIME_CORE_HPP

#include <cstdint>

using void_t   = void;
using bool_t   = bool;

struct string_t;

using ubyte_t  = unsigned char;
using ushort_t = unsigned short;
using uint_t   = unsigned int;
using ulong_t  = unsigned long long;
using uword_t  = unsigned long long;

using byte_t  = char;
using short_t = short;
using int_t   = int;
using long_t  = long long;
using word_t  = long long;

using single_t = float;
using double_t = double;

#define null nullptr;

extern int_t main_main();

int main()
{
    return main_main();
}

#endif
// there's actually a 'namespace global;' here,
// but we can't see! o.o 

namespace main;

// Tell the compiler we're using an extern C function.
extern function puts(str: *const char): int;

// Entry point function.
function main(): int
{
    puts("hello!");
    return 0;
}
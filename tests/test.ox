// there's actually a 'namespace global;' here,
// but we can't see! o.o 

// Tell the compiler we're using an extern C function.
extern function puts(str: *const char): int;

function writeln(content: *const char)
{
    puts(content);
}

// Entry point namespace.
namespace main;

// Entry point function.
function main(): int
{
    writeln("hi");
    return 0;
}
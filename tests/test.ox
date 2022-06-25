namespace main;

// Console functions.
extern function puts(str: *const char): void;

// Memory allocation functions.
extern function malloc(size: uword): *void;
extern function realloc(memory: *void, size: uword): *void;
extern function free(memory: *void): void;

// A function that returns a constant pointer of a constant integer.
function cp2ci(): const *const int
{
    return null;
}

// Entry point function.
function main(): int
{
    return 123;
}
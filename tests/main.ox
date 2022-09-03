// std.c
module std.c;

extern int puts(const char *message);

extern void *fopen (const char *path, const char *flags);
extern int   fclose(void *file);

extern int fwrite(const void *content, uword count, uword length, void *file);

// std.console
module std.console;

import std.c;

void writeln(string content)
{
    puts(content);
}

// std.file
module std.file;

import std.c;

void file_write(string path, const char *content)
{
    void *file = fopen(path, "wb");
                 fwrite(content, 1, 3, file);
                 fclose(file);
}

// main
module main;

import std.console;

// Entry point.
void main()
{
    writeln("Hello, World!");
}
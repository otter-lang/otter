// std.c
extern int puts(const char *message);

extern void *fopen (const char *path, const char *flags);
extern int   fclose(void *file);

extern int fwrite(const void *content, uword count, uword length, void *file);

// std.console
void writeln(string content)
{
    puts(content);
}

// std.file
void file_write(string path, const char *content)
{
    void *file = fopen(path, "wb");
                 fwrite(content, 1, 3, file);
                 fclose(file);
}

// Entry point.
void main()
{
    file_write("A.md", "lol");
    writeln("Hello, World!");
}
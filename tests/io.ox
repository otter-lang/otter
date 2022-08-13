// C function for printing content with
// line at end to the console.
extern int puts(const char *content);

// Write content with line at end to the console.
void writeln(const char *content)
{
    // Let's use C puts for now.
    puts(content);
}